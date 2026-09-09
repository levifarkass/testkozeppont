-- ELLE Yoga Weekend — referral-alapú jegysorsolás
-- Futtasd le ezt egyben a Supabase projekt SQL Editorában (Supabase dashboard > SQL Editor > New query).
-- Csak egyszer kell lefuttatni, egy új Supabase projektben.

create extension if not exists pgcrypto;

create table if not exists elle_giveaway_entries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null unique,
  referral_code text not null unique,
  referred_by text references elle_giveaway_entries(referral_code),
  created_at timestamptz not null default now()
);

alter table elle_giveaway_entries enable row level security;
-- Szándékosan nincs public policy: minden hozzáférés a lenti SECURITY DEFINER
-- függvényeken keresztül megy, azok megkerülik az RLS-t (a táblát a migrációt
-- futtató szerepkör birtokolja). Közvetlen select/insert a táblán kívülről nem megy.

revoke all on elle_giveaway_entries from anon, authenticated;

-- Egyedi, félreérthetetlen kódot generál (kihagyva a 0/O, 1/I/L karaktereket)
create or replace function elle_generate_code() returns text
language plpgsql as $$
declare
  chars text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  code text;
  exists_already boolean;
begin
  loop
    code := '';
    for i in 1..6 loop
      code := code || substr(chars, floor(random() * length(chars) + 1)::int, 1);
    end loop;
    select exists(select 1 from elle_giveaway_entries where referral_code = code) into exists_already;
    exit when not exists_already;
  end loop;
  return code;
end;
$$;

-- Feliratkozás / visszatérő feliratkozó lekérése. Ha az email már regisztrált,
-- nem hoz létre új sort, hanem visszaadja a meglévő kódját (ez a "elvesztettem
-- a linkem" eset kezelése is egyben).
create or replace function register_entry(p_name text, p_email text, p_ref text default null)
returns table(referral_code text, ticket_count int, already_registered boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_email text := lower(trim(p_email));
  v_ref text := nullif(upper(trim(coalesce(p_ref, ''))), '');
  v_existing elle_giveaway_entries%rowtype;
  v_new_code text;
  v_ref_valid text;
begin
  if v_email = '' or p_name is null or trim(p_name) = '' then
    raise exception 'Név és email kötelező.';
  end if;

  select * into v_existing from elle_giveaway_entries where email = v_email;
  if found then
    return query
      select v_existing.referral_code,
             (1 + (select count(*)::int from elle_giveaway_entries where referred_by = v_existing.referral_code)),
             true;
    return;
  end if;

  -- csak érvényes, létező kódra hivatkozhat; ha nem létezik, simán null lesz (nem hasal el a regisztráció)
  select ref.referral_code into v_ref_valid from elle_giveaway_entries ref where ref.referral_code = v_ref;

  v_new_code := elle_generate_code();

  insert into elle_giveaway_entries (name, email, referral_code, referred_by)
  values (trim(p_name), v_email, v_new_code, v_ref_valid);

  return query select v_new_code, 1, false;
end;
$$;

-- Egy meglévő kód aktuális jegyszámának lekérése (visszatérő látogatónak, localStorage alapján)
create or replace function get_stats(p_code text)
returns table(ticket_count int, referred_count int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text := upper(trim(p_code));
  v_referred int;
begin
  select count(*)::int into v_referred from elle_giveaway_entries where referred_by = v_code;
  return query select (1 + v_referred), v_referred;
end;
$$;

grant execute on function register_entry(text, text, text) to anon, authenticated;
grant execute on function get_stats(text) to anon, authenticated;

-- Admin lista: csak a te bejelentkezett Supabase Auth felhasználód láthatja.
-- CSERÉLD LE a saját admin emailedre, mielőtt lefuttatod!
create or replace function admin_list_entries()
returns table(
  name text,
  email text,
  referral_code text,
  referred_by text,
  ticket_count int,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if coalesce(auth.jwt() ->> 'email', '') <> 'CSERELD_LE_A_SAJAT_EMAILEDRE@example.com' then
    raise exception 'Nincs jogosultságod.';
  end if;

  return query
    select e.name, e.email, e.referral_code, e.referred_by,
           (1 + (select count(*)::int from elle_giveaway_entries r where r.referred_by = e.referral_code)) as ticket_count,
           e.created_at
    from elle_giveaway_entries e
    order by e.created_at asc;
end;
$$;

grant execute on function admin_list_entries() to authenticated;
