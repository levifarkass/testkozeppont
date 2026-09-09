# ELLE giveaway — élesítési lépések

A rendszer megvan a repóban, de amíg ezeket nem csinálod meg, nem működik élesben.

## 1. Supabase projekt létrehozása
1. https://supabase.com → ingyenes projekt létrehozása (pl. `testkozeppont-elle`).
2. Project Settings → API → másold ki a **Project URL**-t és az **anon public** kulcsot.

## 2. Adatbázis felállítása
1. Supabase dashboard → SQL Editor → New query.
2. Nyisd meg a `supabase/elle_giveaway_setup.sql` fájlt, illeszd be teljes egészében.
3. **Mielőtt lefuttatod:** az `admin_list_entries()` függvényben cseréld le a
   `CSERELD_LE_A_SAJAT_EMAILEDRE@example.com` placeholdert a saját, admin
   belépéshez használt emailedre.
4. Futtasd le (Run).

## 3. Admin bejelentkezés létrehozása
1. Supabase dashboard → Authentication → Users → Add user.
2. Add meg ugyanazt az emailt, amit a 2/3. pontban beírtál a SQL-be, és állíts be
   egy jelszót. Ezzel tudsz majd bejelentkezni az admin oldalon.

## 4. Kulcsok beillesztése a két HTML fájlba
- `elle_giveaway.html` és `elle_giveaway_admin.html` — mindkettőben cseréld le:
  - `IDE_A_SUPABASE_PROJEKT_URL` → a Project URL
  - `IDE_A_SUPABASE_ANON_KEY` → az anon public kulcs
- Az anon kulcs nyilvánosan látható lesz a HTML forrásban — ez szándékos és
  biztonságos, mert a tábla RLS-sel zárt, minden hozzáférés a Supabase
  függvényeken (`register_entry`, `get_stats`, `admin_list_entries`) megy
  keresztül, azok pedig ellenőrzik a jogosultságot.

## 5. Tesztelés élesítés előtt
1. Nyisd meg `elle_giveaway.html`-t böngészőben, regisztrálj egy teszt-emaillel.
2. Másold ki a kapott referral linket, nyisd meg inkognitó ablakban, regisztrálj
   egy másik teszt-emaillel — ellenőrizd, hogy az első teszt-email jegyszáma
   2-re nőtt (frissítéshez töltsd újra az oldalt vagy nézd az admin listát).
3. Nyisd meg `elle_giveaway_admin.html`-t, jelentkezz be, ellenőrizd, hogy
   látod mindkét teszt-regisztrációt és a jegyszámokat.
4. Próbáld ki a "Sorsolás" gombot és a CSV exportot.
5. Ha minden stimmel, minden Supabase táblasorból (SQL Editor: `delete from
   elle_giveaway_entries;`) törölheted a teszt-adatokat, mielőtt élesbe mész.

## 6. Nyitva maradt, Leviéknek eldöntendő kérdések
- **Viszony a meglévő `elle.html` funnelhez.** Ha a helyszíni QR ma az
  `elle.html`-re (gyakorlat-letöltés) mutat, döntsd el: a giveaway ezt
  helyettesíti, vagy a kettő párhuzamosan fut (pl. a giveaway az
  online/social kampány, az `elle.html` marad a helyszíni QR). Ha mindkettő
  megy egyszerre ugyanazon a csatornán, az hígítja a konverziót.
- **A 10 jegy forrása Flóránál nincs megerősítve** — ezt egyeztesd, mielőtt
  a landing oldal élesben ígéri.
- **Jogi/szövegezési kockázat.** Ingyenes (nem tétes) nyereményjáték
  Magyarországon alacsonyabb kockázatú, mint egy tétes sorsolás, de érdemes
  játékszabályzatot linkelni és kerülni a hivatalos "sorsolás" szó túl
  formális, kötelezettségvállalást sugalló használatát. A jelenlegi szöveg
  ("véletlenszerű, jegyekkel súlyozva") ezt már megpróbálja finoman kezelni,
  de ez nem jogi tanácsadás.

## Hogyan működik röviden
- Minden feliratkozó kap egy egyedi 6 karakteres kódot és 1 alap jegyet.
- A saját linkjén (`elle_giveaway.html?ref=KÓD`) keresztül regisztrált minden
  új ember +1 jegyet ad az ajánlónak.
- Duplikáció-védelem: az email egyedi a táblában — ha valaki kétszer
  próbálkozik, csak visszakapja a meglévő kódját, nem jön létre új sor.
- A sorsolás az admin oldalon fut, kliens oldalon, súlyozott, visszatevés
  nélküli mintavétellel (Efraimidis–Spirakis-algoritmus) — ez azt jelenti,
  hogy 5 jeggyel ötször nagyobb esélyed van nyerni, mint 1 jeggyel, de nem
  lehetsz kétszer nyertes.
