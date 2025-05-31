## Dokumentacija uz projekt “Sustav za upravljanje teretanom” 
*Akademska godina 2024./2025.*
Tim 16

- Marko Aleksić (1219029539)
- Martina Ilić (0303121636)
- Marko Kovač (0171269112)
- Vladan Krivokapić (0016162273)
- Karlo Perić (0130299100)





1. Uvod	
2. Opis poslovnog procesa	
3. Relacijski model	
4. ER dijagram
5. EER dijagram (prošireni ER model)
6. Implementacija baze (SQL kod)
7. Upiti i pogledi (VIEWs)
 7.1
8. Prikaz rezultata upita 
9. Zaključak i preporuke za daljnji razvoj



## 1.UVOD
Ovaj projekt obuhvaća izradu relacijske baze podataka namijenjene upravljanju poslovanjem teretane. Sustav omogućuje evidenciju članova, članarina, privatnih i grupnih treninga, prisutnosti, opreme, rezervacija i osoblja. Iako su u bazi evidentirani članovi koji su se učlanili i u prethodnim godinama, radi jednostavnosti prikaza i obrade podataka treninzi i aktivnosti prate se isključivo za tekući mjesec.

Baza podataka implementirana je u MySQL-u WorkBenchu, a sastoji se od više povezanih tablica, pogleda (VIEWs) i SQL upita koji omogućuju pregled i analizu podataka.

Projekt je razvijen kroz sljedeće korake:

- analiza zahtjeva i planiranje strukture baze

- izrada relacijskog modela i EER dijagrama

- implementacija baze podataka u MySQL-u

- izrada SQL upita i pogleda

U nastavku dokumentacije prikazan je relacijski model, struktura baze, te primjeri upita s rezultatima.

## 2.OPIS POSLOVNOG PROCESA
Poslovni proces teretane obuhvaća više povezanih aktivnosti koje omogućuju učinkovito upravljanje članovima, zaposlenicima, treninzima i opremom.

## 2.1 Članovi i članarina
Svi korisnici koji žele koristiti usluge teretane evidentiraju se u tablici clan. Za svakog člana bilježe se osnovni podaci (ime,prezime...). Obavezno se evidentira i datum učlanjenja, koji se automatski postavlja na trenutni datum (CURRENT_DATE) prilikom unosa.
Polje aktivan koristi se za označavanje je li član trenutno aktivan korisnik usluga teretane, što omogućuje jednostavno filtriranje korisnika u svakodnevnom radu i analizama.Tablica clanarina definira različite vrste članarina koje teretana nudi. 

U tablici clan, atribut id_clanarina služi kao vanjski ključ koji povezuje svakog člana s konkretnom vrstom članarine iz tablice clanarina. Time se omogućuje jasno praćenje koju vrstu članarine svaki član koristi te fleksibilnost u slučaju promjene članarine.

Veza između clan i clanarina postavljena je tako da:

ON DELETE SET NULL — ako se članarina obriše iz sustava, član ostaje evidentiran, ali bez aktivne članarine (podatak se poništava),
ON UPDATE CASCADE — ako se promijeni ID članarine, ta promjena se automatski propagira svim povezanim članovima.

Implementirana baza podataka omogućuje jednostavno upravljanje članovima i njihovim članarinama te pruža analitičke upite i poglede koji podupiru strateško odlučivanje. Kroz prikazane primjere, moguće je brzo identificirati aktivne članove, pratiti vrste članarina koje koriste te analizirati duljinu njihova članstva. Takav sustav omogućuje pravovremeno prepoznavanje članova kojima je potrebna dodatna motivacija ili kojima bi odgovarala ponuda za nadogradnju članarine.

Demografska analiza s financijskim podacima: kombinira spol i dobne skupine s prosječnom cijenom članarine, ukupnim i prosječnim uplatama te brojem transakcija, što otkriva koje skupine najviše doprinose prihodu i kako optimizirati ponudu.

Analiza vjernosti: na temelju duljine članstva i aktivnosti (privatni treninzi, grupni treninzi, rezervacije opreme) prepoznajemo najvjernije članove, kojima možemo ponuditi dodatne pogodnosti.

## 2.2 Treneri i treninzi
U sklopu poslovanja teretane, prate se podaci o trenerima, tipovima treninga te privatnim treninzima. Treneri su stručne osobe zaposlene u teretani, od kojih se evidentiraju njihovi osobni podaci, kontakt podaci, specijalizacije, kao i godine iskustva. Svaki trener može voditi više različitih treninga, a može imati i više privatnih termina sa članovima.

Tipovi treninga definiraju različite vrste aktivnosti koje teretana nudi – poput kondicijskog treninga, yoge, pilatesa, snage i slično. Svaki tip treninga ima vlastiti naziv, opis i osnovnu cijenu.

Privatni treninzi predstavljaju individualne termine između člana i trenera, s jasno definiranim datumom, vremenom, trajanjem i tipom treninga. Evidentira se i status termina (npr. zakazan, održan, otkazan), kao i cijena treninga – pri čemu neki treninzi mogu biti besplatni ako su uključeni u članarinu.

Ovaj poslovni proces omogućava:
- upravljanje resursima (trenerima),
- optimizaciju individualnog pristupa članovima,
- analizu popularnosti i profitabilnosti različitih tipova treninga,
- evidenciju povijesti rada trenera i angažmana članova.

## 2.3 Grupni treninzi i prisutnost članova
Grupni treninzi predstavljaju organizirane termine treninga koje vodi jedan trener, a na njima može sudjelovati više članova. Svaki grupni trening definiran je nazivom, terminom (dan i vrijeme), maksimalnim brojem članova, trajanjem i cijenom po terminu. Trener koji vodi trening jasno je naznačen u sustavu kako bi se olakšalo planiranje rasporeda i raspodjela rada.

Za svakog člana koji sudjeluje u grupnom treningu vodi se evidencija prisutnosti. Ova evidencija uključuje datum termina i informaciju je li član bio prisutan, što omogućuje praćenje sudjelovanja, izradu statistika i potencijalnu naplatu po dolasku.

Sustav na taj način omogućuje učinkovito upravljanje grupnim treninzima, praćenje broja sudionika te transparentno vođenje evidencije o dolascima, što je korisno i za trenere i za upravu teretane.

## 2.4 Oprema i rezervacije
U teretani se vodi detaljna evidencija o svakoj spravi i opremi koja je dostupna članovima i osoblju. Kada u teretanu stigne novi komad opreme, on se najprije evidentira u tablici oprema, gdje svaki zapis sadrži jedinstvenu šifru, naziv, datum nabave, nabavnu vrijednost, proizvođača, model i datum isteka garancije. Na taj način sustav postaje svjestan postojanja nove sprave i može pratiti njen životni ciklus.

Kada član ili trener želi koristiti određenu spravu, sustav u tablici rezervacija_opreme kreira novi zapis s poljima: ID člana, ID opreme, datum i vrijeme početka i završetka rezervacije te status “aktivna”. To sprječava dvostruke rezervacije istog uređaja u istom terminu. Nakon izvedenog treninga ili otkazivanja, status se ažurira na “završena” ili “otkazana”, čime postaje jasno tko je, kada i koliko dugo koristio opremu.

Podaci iz ovih dvije tablice služe za operativno upravljanje i strateško planiranje: osiguravaju pregled iskorištenosti pojedinih sprava, pomažu pri određivanju termina za redovno održavanje ili servis, te omogućuju generiranje izvještaja o popularnosti i učinkovitosti opreme. Ukoliko član prekorači rezervirano vrijeme ili upravo ošteti spravu, sustav može inicirati dodatne naplate povezane s tim rezervacijama, a ti se troškovi dalje prate u tablici plaćanje. Na osnovi svih prikupljenih informacija menadžment dobiva precizan uvid u rad teretane i može donositi odluke o novim nabavkama, otpisu zastarjele opreme ili marketinškim akcijama usmjerenima na neiskorištene sprave.

Članovima je omogućeno rezerviranje određene opreme za korištenje u točno određenom terminu. Rezervacija uključuje informacije o članu, vremenskom rasponu korištenja, statusu rezervacije (aktivna, završena, otkazana) te eventualnim napomenama. Ova funkcionalnost omogućuje bolje upravljanje raspoloživošću opreme i sprječava preklapanje korištenja istih resursa od strane više članova.

## 2.5 Osoblje i plaćanja
Za nesmetano svakodnevno funkcioniranje teretane, vodi se evidencija zaposlenika raznih uloga, uključujući recepcioniste, voditelje, čistačice, osoblje za održavanje, administratore i nutricioniste. Svaki zaposlenik ima definiran kontakt, datum zaposlenja, radno vrijeme te status aktivnosti. Na ovaj način omogućeno je jasno praćenje tko je odgovoran za koje zadatke unutar sustava.

Proces plaćanja članarina i drugih usluga također je centraliziran. Svaka uplata se povezuje s konkretnim članom i zaposlenikom koji je izvršio naplatu, što omogućuje veću transparentnost i kontrolu nad financijama. Uplaćeni iznosi bilježe se zajedno s datumom, načinom plaćanja (gotovina, kartica, bankovni transfer, PayPal ili kripto), mogućim popustom i dodatnim opisom.

Ovakva organizacija osigurava točnu financijsku evidenciju i odgovornost osoblja, dok članovima pruža više opcija prilikom plaćanja.





## 3. Relacijski model
Relacijski model prikazuje sve tablice baze podataka s pripadajućim atributima, primarnim ključevima (PK) i stranim ključevima (FK). Svaka relacija sadrži popis atributa uz naznaku veza među tablicama.
Popis relacija:
1. CLANARINA
clanarina(id, tip, cijena, trajanje, opis)
PK: id

2. CLAN
clan(id, ime, prezime, email, telefon, datum_uclanjenja, id_clanarina, aktivan, datum_rodjenja, spol, adresa, grad)
PK: id
FK: id_clanarina → clanarina(id)

3. TRENER
trener(id, ime, prezime, specijalizacija, email, telefon, datum_zaposlenja, godine_iskustva, aktivan)
PK: id

4. PRIVATNI_TRENING
privatni_trening(id, id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje, napomena, status, cijena)
PK: id
FK: id_clana → clan(id)
FK: id_trenera → trener(id)

5. GRUPNI_TRENING
grupni_trening(id, naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme, trajanje, cijena_po_terminu, aktivan, opis)
PK: id
FK: id_trenera → trener(id)

6. PRISUTNOST
prisutnost(id, id_clana, id_grupnog_treninga, datum, prisutan)
PK: id
FK: id_clana → clan(id)
FK: id_grupnog_treninga → grupni_trening(id)

7. OPREMA
oprema(id, sifra, naziv, datum_nabave, stanje, vrijednost, proizvođač, model, garancija_do)
PK: id

8. REZERVACIJA_OPREME
rezervacija_opreme(id, id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka, status, napomena)
PK: id
FK: id_clana → clan(id)
FK: id_opreme → oprema(id)

9. OSOBLJE
osoblje(id, ime, prezime, uloga, email, telefon, datum_zaposlenja, placa, radno_vrijeme, aktivan)
PK: id

10. PLACANJE
placanje(id, id_clana, tip_placanja, referentni_id, iznos, datum_uplate, nacin_placanja, broj_racuna, popust, id_osoblje)
PK: id
FK: id_clana → clan(id)
FK: id_osoblje → osoblje(id)



## 3. ER dijagram
Sljedeći ER dijagram detaljno i pregledno opisuje sve skupove entiteta, njihove atribute, kao i veze među njima. Dijagram jasno prikazuje logičku strukturu baze podataka za upravljanje teretanom.
Kardinalnosti označene na relacijama predstavljaju odnose među entitetima.

CLANARINA je dodijeljena CLANU
- Više članova može imati istu članarinu (tip) (ali član ima samo jednu aktivnu članarinu)
- kardinalnost: one to many

CLAN ostvaruje PLACANJE
- Jedan član može imati više uplata, dok je svako plaćanje vezano za jednog člana
- kardinalnost: one to many

PLACANJE se odnosi na CLANARINU
- svako plaćanje odnosi se na jednu članarinu, a isti tip članarine može biti povezan s više uplata
- kardinalnost: one to many

CLAN sudjeluje na PRIVATNI_TRENING
-jedan član može imati više individualnih treninga,a svaki privatni trening vezan je za jednog člana
- kardinalnost: one to many

TRENER vodi PRIVATNI_TRENING
- jedan trener može voditi više treninga, dok svaki privatni trening vodi jedan trener
- kardinalnost: one to many

TIP_TRENINGA ima PRIVATNI_TRENING
- jedan tip treninga može imati više privatnih treninga, ali svaki privatni trening pripada samo jednom tipu treninga
- kardinalnost: one to many

TRENER vodi GRUPNI_TRENING
- trener može voditi više grupnih treninga, ali svaki grupni trening vodi samo jedan trener)
- kardinalnost: one to many

CLAN ima PRISUTNOST na GRUPNI_TRENING
- jedan član može biti prisutan na više grupnih treninga, a svaki grupni trening može imati više članova
- kardinalnost: many to many
 (realizirano preko entiteta PRISUTNOST)

CLAN ima REZERVACIJU_OPREME
- jedan član može rezervirati više sprava, dok svaka rezervacija pripada točno jednom članu
- kardinalnost: one to many

REZERVACIJA_OPREME se odnosi na OPREMU
- jedna sprava može biti rezervirana više puta, dok se svaka rezervacija odnosi na jednu spravu
- kardinalnost: one to many


## 7.4 Pogled - Pregled trenera s statistikama

Trenutno rukovodstvo teretane želi imati cjelokupan pregled nad angažmanom svojih trenera kako bi mogli donositi odluke o nagradama, zaduženjima i budućim zapošljavanjima. Odjel analitike zatražio je pogled koji prikazuje broj treninga po treneru, trajanje, broj klijenata, prihod i ostale korisne informacije.

**TRAŽENO RJEŠENJE:**  
ID trenera, ime i prezime, specijalizacija, email, broj treninga, broj klijenata, trajanje, prihod i prosječna cijena održanih treninga.

**KOD:**
```sql
CREATE OR REPLACE VIEW treneri_statistika AS
SELECT 
    t.id,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    t.specijalizacija,
    t.godine_iskustva,
    t.email,
    COUNT(DISTINCT tr.id) AS ukupno_termina,
    COUNT(DISTINCT tr.id_clana) AS broj_razlicitih_klijenata,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END), 0) AS ukupno_minuta,
    COALESCE(AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena END), 0) AS prosjecna_cijena,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END), 0) AS ukupni_prihod
FROM trener t
LEFT JOIN privatni_trening tr ON t.id = tr.id_trenera
WHERE t.aktivan = TRUE
GROUP BY t.id, t.ime, t.prezime, t.specijalizacija, t.godine_iskustva, t.email
ORDER BY ukupni_prihod DESC;
```

**OPIS:**  
Ovim pogledom se objedinjuju podaci iz tablica trener i privatni_trening kako bi se dobila statistika za svakog trenera:
- Računa se broj različitih treninga, različitih klijenata i termina.
- `SUM` i `AVG` funkcijama se dobiva trajanje i prosječna cijena održanih treninga.
- `LEFT JOIN` omogućuje da se i treneri koji trenutno nemaju treninge i dalje prikažu u rezultatu.
- `COALESCE` zamjenjuje moguće `NULL` vrijednosti s nulom.

---

## 7.5. Pogled - Raspored budućih treninga

Voditelj dvorane traži pregled svih nadolazećih privatnih treninga kako bi mogao organizirati prostor i resurse (sprave, osoblje). Pregled treba uključivati članove, trenere, termin i napomene.

**TRAŽENO RJEŠENJE:**  
Popis zakazanih i održanih budućih privatnih treninga od današnjeg datuma nadalje, uz sve relevantne informacije.

**KOD:**
```sql
CREATE OR REPLACE VIEW raspored_buducih_treninga AS
SELECT 
    tr.datum,
    DAYNAME(tr.datum) AS dan_u_tjednu,
    tr.vrijeme,
    tt.naziv AS tip_treninga,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    c.telefon AS telefon_clana,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    tr.trajanje,
    tr.cijena,
    tr.status,
    tr.napomena
FROM privatni_trening tr
JOIN clan c ON tr.id_clana = c.id
JOIN trener t ON tr.id_trenera = t.id
JOIN tip_treninga tt ON tr.id_tip_treninga = tt.id
WHERE tr.datum >= CURRENT_DATE
  AND tr.status != 'otkazan'
ORDER BY tr.datum, tr.vrijeme;
```

**OPIS:**  
Upit koristi `JOIN` kako bi dohvatio ime i prezime člana, tip treninga, kontakt, trenera i dodatne informacije.
`DAYNAME` funkcija dodaje razumljiviji kontekst prikazu datuma. Treninzi koji su otkazani se izbacuju filtriranjem `tr.status != 'otkazan'`.

---

## 7.6. Pogled - Analiza tipova treninga

Odjel marketinga želi znati koji su tipovi treninga najpopularniji i najisplativiji kako bi prilagodili promocije i cijene.

**TRAŽENO RJEŠENJE:** 
Broj termina, klijenata, prihoda i efikasnosti naplate po tipu treninga.

**KOD:**
```sql
CREATE OR REPLACE VIEW analiza_tipova_treninga AS
SELECT 
    tt.id,
    tt.naziv,
    tt.osnovna_cijena,
    tt.opis,
    COUNT(tr.id) AS broj_treninga,
    SUM(CASE WHEN tr.status = 'održan' THEN 1 ELSE 0 END) AS broj_odrzanih,
    COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
    COUNT(DISTINCT tr.id_trenera) AS broj_trenera,
    ROUND(AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE NULL END), 2) AS prosjecna_naplata,
    SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) AS ukupni_prihod,
    CASE 
        WHEN tt.osnovna_cijena > 0 THEN ROUND(AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena END) * 100.0 / tt.osnovna_cijena, 2)
        ELSE NULL
    END AS postotak_naplate
FROM tip_treninga tt
LEFT JOIN privatni_trening tr ON tt.id = tr.id_tip_treninga
GROUP BY tt.id, tt.naziv, tt.osnovna_cijena, tt.opis
ORDER BY ukupni_prihod DESC;
```

**OPIS:**  
Za svaki tip treninga izračunava se broj održanih termina, klijenata, ukupni prihod i omjer stvarne naplate naspram početne cijene (`postotak_naplate`).
Korišten je `LEFT JOIN` kako bi se prikazali i oni tipovi koji trenutno nemaju termina.

---

## 7.7. Upit - Efikasnost trenera po tipovima treninga

Od menadžmenta je stigao zahtjev za procjenom rada trenera – koliko su angažirani, koliko klijenata imaju, koji su im prihodi, i koliko treninga je bilo otkazano. Upit daje efikasnost rada po tipu treninga.

**KOD:**
```sql
SELECT 
    t.id AS trener_id,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    t.specijalizacija,
    COUNT(DISTINCT pt.id) AS broj_treninga,
    COUNT(DISTINCT pt.id_clana) AS broj_klijenata,
    COALESCE(ROUND(AVG(CASE WHEN pt.status = 'održan' THEN pt.cijena END), 2), 0) AS prosjecna_cijena,
    COALESCE(SUM(CASE WHEN pt.status = 'održan' THEN pt.cijena ELSE 0 END), 0) AS prihod,
    COALESCE(SUM(CASE WHEN pt.status = 'održan' THEN pt.trajanje ELSE 0 END), 0) / 60.0 AS sati,
    COUNT(CASE WHEN pt.status = 'otkazan' THEN 1 END) AS broj_otkazanih,
    ROUND(
        CASE 
            WHEN COUNT(pt.id) > 0 THEN 
                COUNT(CASE WHEN pt.status = 'otkazan' THEN 1 END) * 100.0 / COUNT(pt.id)
            ELSE 0
        END, 2
    ) AS postotak_otkazanih
FROM trener t
LEFT JOIN privatni_trening pt ON pt.id_trenera = t.id
WHERE t.aktivan = TRUE
GROUP BY t.id, t.ime, t.prezime, t.specijalizacija
ORDER BY prihod DESC;
```

**OPIS:**  
Uz pomoć `COUNT`, `AVG`, `SUM` i `ROUND` izvlače podaci o učinkovitosti rada svakog trenera.
Ključan dio je izračun postotka otkazanih termina kroz `CASE` i `COUNT`.

---

## 7.8. Upit - Analiza opterećenosti trenera (Karlo Perić)

Potrebna je analiza koliko je koji trener radio u zadnjih tjedan i mjesec dana kako bi se odredila razina opterećenosti i planirala preraspodjela.

**KOD:**
```sql
WITH privatni AS (
    SELECT 
        tr.id_trenera,
        SUM(CASE WHEN tr.datum >= CURRENT_DATE - INTERVAL 7 DAY AND tr.status = 'održan' THEN tr.trajanje ELSE 0 END) AS minuta_tjedan,
        SUM(CASE WHEN tr.datum >= CURRENT_DATE - INTERVAL 30 DAY AND tr.status = 'održan' THEN tr.trajanje ELSE 0 END) AS minuta_mjesec
    FROM privatni_trening tr
    GROUP BY tr.id_trenera
),
grupni AS (
    SELECT 
        gt.id_trenera,
        SUM(CASE WHEN pg.datum >= CURRENT_DATE - INTERVAL 7 DAY AND pg.prisutan = TRUE THEN gt.trajanje ELSE 0 END) AS minuta_tjedan,
        SUM(CASE WHEN pg.datum >= CURRENT_DATE - INTERVAL 30 DAY AND pg.prisutan = TRUE THEN gt.trajanje ELSE 0 END) AS minuta_mjesec
    FROM prisutnost_grupni pg
    JOIN grupni_trening gt ON pg.id_grupnog_treninga = gt.id
    GROUP BY gt.id_trenera
),
kombinirano AS (
    SELECT 
        t.id,
        CONCAT(t.ime, ' ', t.prezime) AS trener,
        COALESCE(p.minuta_tjedan, 0) + COALESCE(g.minuta_tjedan, 0) AS ukupno_tjedan,
        COALESCE(p.minuta_mjesec, 0) + COALESCE(g.minuta_mjesec, 0) AS ukupno_mjesec
    FROM trener t
    LEFT JOIN privatni p ON t.id = p.id_trenera
    LEFT JOIN grupni g ON t.id = g.id_trenera
)
SELECT 
    id,
    trener,
    ROUND(ukupno_tjedan / 60.0, 2) AS sati_tjedno,
    ROUND(ukupno_mjesec / 60.0, 2) AS sati_mjesec,
    CASE 
        WHEN ukupno_tjedan >= 600 THEN 'Preopterećen'
        WHEN ukupno_tjedan >= 300 THEN 'Vrlo zauzet'
        WHEN ukupno_tjedan >= 120 THEN 'Umjereno aktivan'
        ELSE 'Niska aktivnost'
    END AS status_tjedan,
    CASE 
        WHEN ukupno_mjesec >= 2400 THEN 'Preopterećen'
        WHEN ukupno_mjesec >= 1200 THEN 'Vrlo zauzet'
        WHEN ukupno_mjesec >= 480 THEN 'Umjereno aktivan'
        ELSE 'Niska aktivnost'
    END AS status_mjesec
FROM kombinirano
ORDER BY sati_tjedno DESC;
```

**OPIS:**  
Koriste se tri CTE izraza (`WITH`) – za privatne, grupne i objedinjene treninge.
Zbrajaju se minute po treneru i na temelju rezultata klasificira ih se u kategorije opterećenosti (“Preopterećen”, “Niska aktivnost” itd.).

---

## 7.9. Upit - ROI analiza tipova treninga

Cilj je utvrditi koji tipovi treninga donose najviše prihoda u odnosu na svoj utrošeni radni sat i koliko je stvarna naplata u odnosu na definiranu cijenu.

**KOD:**
```sql
SELECT 
    tt.naziv AS tip_treninga,
    tt.osnovna_cijena,

    COUNT(tr.id) AS broj_treninga,
    COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
    COUNT(DISTINCT tr.id_trenera) AS broj_trenera,

    SUM(CASE WHEN tr.status = 'održan' THEN 1 ELSE 0 END) AS broj_odrzanih,

    COALESCE(ROUND(AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena END), 2), 0) AS prosjecna_naplata,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END), 0) AS ukupni_prihod,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END), 0) AS ukupno_minuta,

    COALESCE(ROUND(
        SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) / 
        NULLIF(SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END), 0) * 60, 2
    ), 0) AS prihod_po_satu,

    COALESCE(ROUND(
        AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena END) / 
        NULLIF(tt.osnovna_cijena, 0) * 100, 2
    ), 0) AS postotak_realizacije_cijene

FROM tip_treninga tt
LEFT JOIN privatni_trening tr ON tt.id = tr.id_tip_treninga
GROUP BY tt.id, tt.naziv, tt.osnovna_cijena
ORDER BY ukupni_prihod DESC;
```

**OPIS:**  
Analizira se broj termina, broj članova, naplata po satu i postotak realizacije cijene.
`ROUND` i `NULLIF` koriste se za sigurno računanje bez dijeljenja s nulom.
Idealno za usporedbu koliko se realno naplaćuje u odnosu na očekivano (osnovna cijena).

---

## 7.10 Pogled – Trenutno stanje i vrijednost opreme (Vladan Krivokapić)

Vodstvo teretane treba brz uvid u sve komade opreme i njihov rok jamstva kako bi planirali servise i zamjene.

**TRAŽENO RJEŠENJE:**  
ID opreme, šifra, naziv, proizvođač, model, stanje, vrijednost, datum nabave, datum isteka garancije, broj dana do isteka garancije.

**KOD:**
```sql
CREATE OR REPLACE VIEW stanje_opreme AS
SELECT 
    o.id,
    o.sifra,
    o.naziv,
    o.proizvodac,
    o.model,
    o.stanje,
    o.vrijednost,
    o.datum_nabave,
    o.garancija_do,
    DATEDIFF(o.garancija_do, CURRENT_DATE) AS dana_do_isteka_garancije
FROM oprema o
ORDER BY o.stanje DESC, o.vrijednost DESC;
```
**OPIS:**

Iz tablice ``oprema`` dohvaća sve ključne atribute.

Funkcija ``DATEDIFF`` izračunava broj dana do isteka garancije, omogućujući pravovremeno zakazivanje servisa.

Sortira prvo po stanje (najkritičnije sprave na vrhu), a potom po vrijednost (najskuplje sprave prve).

---------------------------------------------------
## 7.11 Pogled – Oprema po proizvođaču (Vladan Krivokapić)

Odjel analitike treba agregirane podatke o vrijednosti i stanju garancija za svaku robnu marku opreme kako bi mogao optimizirati nabavu i servis.

**TRAŽENO RJEŠENJE:**  
Proizvođač, broj stavki, ukupna vrijednost, prosjek dana do isteka garancije, broj isteklih garancija, broj garancija koje uskoro istječu.

**KOD**:
```sql
CREATE OR REPLACE VIEW oprema_po_proizvodacu AS
SELECT
    o.proizvodac,
    COUNT(*)                     AS broj_stavki,
    SUM(o.vrijednost)            AS ukupna_vrijednost,
    ROUND(AVG(DATEDIFF(o.garancija_do, CURRENT_DATE)), 1) AS prosjek_dana_do_isteka_garancije,
    SUM(CASE WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) < 0 THEN 1 ELSE 0 END) AS broj_isteklih_garancija,
    SUM(CASE WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) BETWEEN 0 AND 30 THEN 1 ELSE 0 END) AS broj_garancija_uskoro_istjece
FROM oprema o
GROUP BY o.proizvodac
ORDER BY ukupna_vrijednost DESC; 
```
**OPIS:**

Grupira opremu prema proizvođaču (``GROUP BY o.proizvodac``).

``COUNT(*)`` broji koliko komada opreme ima svaki proizvođač.

``SUM(o.vrijednost)`` daje ukupnu nabavnu vrijednost opreme po proizvođaču.

``AVG(DATEDIFF(...))`` računa prosjek dana do isteka garancije, zaokružen na jedno decimalno mjesto.

``SUM(CASE WHEN ... < 0)`` izračunava koliko je garancija već isteklo.

``SUM(CASE WHEN ... BETWEEN 0 AND 30)`` broji garancije koje istječu unutar idućih 30 dana.

Rezultati se sortiraju silazno po ukupna_vrijednost za prioritetno praćenje najvrjednijih proizvođača.

------------------------------------------------
## 7.12 Pogled – Broj rezervacija po opremi (Vladan Krivokapić)

Menadžment želi znati koje sprave su najpopularnije kako bi mogao prilagoditi raspored održavanja i eventualno proširiti ponudu.

**TRAŽENO RJEŠENJE:**  
Naziv opreme, broj svih rezervacija, broj različitih korisnika, datum zadnje rezervacije.

**KOD:**
```sql
CREATE OR REPLACE VIEW broj_rezervacija_po_opremi AS
SELECT 
    o.naziv AS oprema,
    COUNT(ro.id) AS broj_rezervacija,
    COUNT(DISTINCT ro.id_clana) AS broj_razlicitih_korisnika,
    MAX(ro.datum) AS zadnja_rezervacija
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
GROUP BY o.id
ORDER BY broj_rezervacija DESC;
```
**OPIS:**

``COUNT(ro.id)`` pokazuje koliko je puta svaka sprava rezervirana.

``COUNT(DISTINCT ro.id_clana)`` mjeri koliko je različitih članova koristilo spravu.

``MAX(ro.datum)`` daje datum zadnje upotrebe.

``LEFT JOIN`` osigurava da i nepopularne sprave budu vidljive s brojem rezervacija 0.

---------------------------
## 7.13 Pogled – Prosječno korištenje opreme po članu (Vladan Krivokapić)

Odjel analitike želi dobiti uvid u to koliko vremena pojedini članovi u prosjeku provode na svakoj spravi kako bi se razumjela korisnička aktivnost i optimizirao raspored.

**TRAŽENO RJEŠENJE:**  
Naziv opreme, ime i prezime člana, broj rezervacija, prosječno trajanje rezervacije u minutama.

**KOD:**
```sql
CREATE OR REPLACE VIEW prosjecno_koristenje_opreme AS
SELECT 
    o.naziv AS oprema,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    COUNT(ro.id) AS broj_rezervacija,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)), 1) AS prosjecno_trajanje_minuta
FROM rezervacija_opreme ro
JOIN oprema o ON ro.id_opreme = o.id
JOIN clan c ON ro.id_clana = c.id
WHERE ro.status IN ('završena', 'aktivna')
GROUP BY o.id, c.id
ORDER BY broj_rezervacija DESC, prosjecno_trajanje_minuta DESC;
```
**OPIS:**

``COUNT(ro.id)` prebrojava sve rezervacije pojedine sprave od strane člana.

``AVG(TIMESTAMPDIFF(...))`` računa prosječno trajanje svake rezervacije u minutama.

Filtrira se samo status ``aktivna`` i ``završena`` kako bi se izbjegle otkazane rezervacije.

Rezultati se sortiraju po broju rezervacija (silazno) i po duljini prosječnog trajanja.

-----------------------------------
## 7.14 Pogled – Top 5 sprava po trajanju (Vladan Krivokapić)

Cilj je identificirati sprave koje su kroz vrijeme najintenzivnije korištene kako bi se planiralo održavanje i eventualno proširenje inventara.

**TRAŽENO RJEŠENJE:**  
Naziv opreme, broj rezervacija, ukupno minuta korištenja, prosječno trajanje.

**KOD:**
```sql
CREATE OR REPLACE VIEW top_oprema_po_trajanju AS
SELECT 
    o.naziv AS oprema,
    COUNT(ro.id) AS broj_rezervacija,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_minuta,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)), 1) AS prosjecno_trajanje
FROM rezervacija_opreme ro
JOIN oprema o ON ro.id_opreme = o.id
WHERE ro.status IN ('završena', 'aktivna')
GROUP BY o.id
ORDER BY ukupno_minuta DESC
LIMIT 5;
```
**OPIS:**

``COUNT(ro.id)`` daje ukupan broj svih rezervacija za svaku spravu.

``SUM(TIMESTAMPDIFF(...))`` sabira minute korištenja po spravi, pokazujući ukupno opterećenje.

``AVG(TIMESTAMPDIFF(...))`` računa prosječno trajanje rezervacije, zaokruženo na jednu decimalu.

``LIMIT 5`` osigurava da se prikaže samo prvih pet najintenzivnijih sprava.

--------------------------------------
## 7.15 Pogled – Oprema bez rezervacija (Vladan Krivokapić)

Operativni tim želi identificirati komade opreme koji nikada nisu rezervirani kako bi mogao pokrenuti promocije ili preispitati njihove troškove.

**TRAŽENO RJEŠENJE:**  
ID opreme, šifra, naziv, stanje, vrijednost, datum nabave, proizvođač.

**KOD:**
```sql
CREATE OR REPLACE VIEW oprema_bez_rezervacije AS
SELECT 
    o.id,
    o.sifra,
    o.naziv,
    o.stanje,
    o.vrijednost,
    o.datum_nabave,
    o.proizvodac
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
WHERE ro.id IS NULL
ORDER BY o.vrijednost DESC;
```
**OPIS:**

``LEFT JOIN`` osigurava da se uključe sve sprave čak i one bez rezervacija.

``WHERE ro.id IS NULL`` filtrira samo sprave koje nisu rezervirane nijednom.

Sortira po vrijednost silazno kako bi se prvo vidjele najskuplje neiskorištene sprave.

---------------------------------------
## 7.16 Upit – Osnovni podaci opreme i detaljna statistika (Vladan Krivokapić)

Menadžment želi objedinjeni prikaz ključnih metrika korištenja svake sprave kako bi mogao pratiti učestalost rezervacija, recentne trendove i prioritete za servis.

**TRAŽENO RJEŠENJE:**  
ID opreme, šifra, naziv, proizvođač, stanje, ukupno rezervacija, završene rezervacije, rezervacije u zadnjih 7 dana, rezervacije u zadnjih 30 dana, omjer 30-dnevnih prema 90-dnevnim rezervacijama (u %), broj dana od zadnje rezervacije, razina korištenja (Visoka/​Srednja/​Niska).

**KOD:**
```sql
SELECT
    o.id,
    o.sifra,
    o.naziv,
    o.proizvodac,
    o.stanje,
    COUNT(ro.id) AS ukupno_rezervacija,
    SUM(CASE WHEN ro.status = 'završena' THEN 1 ELSE 0 END) AS zavrsene_rezervacije,
    SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) THEN 1 ELSE 0 END) AS rezervacije_posljednjih_7_dana,
    SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 1 ELSE 0 END) AS rezervacije_posljednjih_30_dana,
    ROUND(
        SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY) THEN 1 ELSE 0 END), 0)
        * 100, 1
    ) AS omjer_30_90_dana,
    DATEDIFF(CURRENT_DATE, MAX(ro.datum)) AS dana_od_zadnje_rezervacije,
    CASE
        WHEN SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 1 ELSE 0 END) >= 5 THEN 'Visoka'
        WHEN SUM(CASE WHEN ro.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 1 ELSE 0 END) >= 2 THEN 'Srednja'
        ELSE 'Niska'
    END AS razina_koristenja
FROM oprema o
LEFT JOIN rezervacija_opreme ro
    ON o.id = ro.id_opreme
GROUP BY o.id, o.sifra, o.naziv, o.proizvodac, o.stanje
ORDER BY rezervacije_posljednjih_30_dana DESC,
         dana_od_zadnje_rezervacije ASC;
```
**OPIS:**

``COUNT(ro.id)`` i ``SUM(CASE WHEN …)`` mjere ukupne i završene rezervacije, te aktivnosti u zadnjih 7 i 30 dana.

``ROUND(... omjer ...)`` računa postotak 30-dnevnih rezervacija u odnosu na 90-dnevni period.

``DATEDIFF`` pokazuje koliko je dana prošlo od zadnje rezervacije.

``CASE`` kategorizira razinu korištenja prema broju rezervacija u zadnjih 30 dana.

-----------------------------
## 7.17 Upit – Trend korištenja opreme (Vladan Krivokapić)

Analitički tim želi pratiti promjene u učestalosti rezervacija svake sprave uspoređujući prosjeke zadnja četiri i prethodna četiri tjedna kako bi uočili rastuće ili opadajuće trendove.

**TRAŽENO RJEŠENJE:**  
ID opreme, šifra, naziv, prosjek rezervacija u zadnja 4 tjedna, prosjek rezervacija u prethodna 4 tjedna, razlika, trend korištenja (`Rastući trend` / `Opadajući trend` / `Stabilno`).

**KOD:**
```sql
WITH tjedni AS (
    SELECT
        id_opreme,
        YEARWEEK(datum, 1) AS yw,
        COUNT(*)          AS broj_rezervacija
    FROM rezervacija_opreme
    GROUP BY id_opreme, yw
),
rangirani AS (
    SELECT
        t.*,
        ROW_NUMBER() OVER (PARTITION BY id_opreme ORDER BY yw DESC) AS rn
    FROM tjedni t
),
filtrirani AS (
    SELECT
        id_opreme,
        ROUND(AVG(CASE WHEN rn BETWEEN 1 AND 4 THEN broj_rezervacija END), 2) AS avg_zadnja_4_tjedna,
        ROUND(AVG(CASE WHEN rn BETWEEN 5 AND 8 THEN broj_rezervacija END), 2) AS avg_prethodna_4_tjedna
    FROM rangirani
    WHERE rn <= 8
    GROUP BY id_opreme
)
SELECT
    o.id,
    o.sifra,
    o.naziv,
    COALESCE(f.avg_zadnja_4_tjedna, 0)    AS avg_zadnja_4_tjedna,
    COALESCE(f.avg_prethodna_4_tjedna, 0) AS avg_prethodna_4_tjedna,
    ROUND(
      COALESCE(f.avg_zadnja_4_tjedna, 0)
      - COALESCE(f.avg_prethodna_4_tjedna, 0)
      , 2
    )                                    AS razlika,
    CASE
      WHEN f.avg_zadnja_4_tjedna > f.avg_prethodna_4_tjedna THEN 'Rastući trend'
      WHEN f.avg_zadnja_4_tjedna < f.avg_prethodna_4_tjedna THEN 'Opadajući trend'
      ELSE 'Stabilno'
    END                                   AS trend_koristenja
FROM oprema o
LEFT JOIN filtrirani f ON o.id = f.id_opreme
ORDER BY razlika DESC;
```
**OPIS:**

CTE tjedni prikuplja broj rezervacija po spravi i tjednu.

CTE rangirani rangira tjedne za svaku spravu od najnovijeg ``(rn=1) `` prema starijima.

CTE filtrirani izračunava prosjek rezervacija za zadnja 4  ``(rn 1–4)  ``i prethodna 4  ``(rn 5–8) `` tjedna.

Glavni SELECT spaja rezultate na tablicu oprema, računa razliku i klasificira trend.

Sortira sprave po najvećoj pozitivnoj ili negativnoj razlici za brzo uočavanje promjena.

-----------------------
## 7.18 Upit – Analiza rezervacija, trajanja i garancije opreme (Vladan Krivokapić)

Menadžment želi detaljnu statistiku svake sprave uključujući broj rezervacija, raznolikost dana korištenja, trend unazad 30 dana te status garancije kako bi mogao optimizirati servisne cikluse i planirati zamjene.

**TRAŽENO RJEŠENJE:**  
ID opreme, šifra, naziv, stanje, ukupno rezervacija, broj različitih dana rezervacija, prva i zadnja rezervacija, rezervacije u zadnjih 30 dana, postotak tih rezervacija u odnosu na ukupne, prosjek rezervacija po danu, broj dana od zadnje rezervacije, broj dana do isteka garancije, status garancije, kategorija korištenja.

**KOD:**
```sql
WITH res AS (
    SELECT
        id_opreme,
        COUNT(*) AS ukupno_rezervacija,
        COUNT(DISTINCT datum) AS broj_razlicitih_dana,
        MIN(datum) AS prva_rezervacija,
        MAX(datum) AS zadnja_rezervacija,
        SUM(CASE WHEN datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN 1 ELSE 0 END) AS rezervacije_zadnjih_30_dana
    FROM rezervacija_opreme
    GROUP BY id_opreme
)
SELECT
    o.id,
    o.sifra,
    o.naziv,
    o.stanje,
    COALESCE(r.ukupno_rezervacija, 0)           AS ukupno_rezervacija,
    COALESCE(r.broj_razlicitih_dana, 0)         AS broj_razlicitih_dana,
    r.prva_rezervacija,
    r.zadnja_rezervacija,
    COALESCE(r.rezervacije_zadnjih_30_dana, 0)  AS rezervacije_zadnjih_30_dana,
    ROUND(
      COALESCE(r.rezervacije_zadnjih_30_dana,0) * 100
      / NULLIF(COALESCE(r.ukupno_rezervacija,0),0)
      ,1
    )                                          AS postotak_rezervacija_30_od_ukupnih,
    ROUND(
      COALESCE(r.ukupno_rezervacija,0)
      / NULLIF(COALESCE(r.broj_razlicitih_dana,1),1)
      ,2
    )                                          AS prosjek_rezervacija_po_danu,
    DATEDIFF(CURRENT_DATE, COALESCE(r.zadnja_rezervacija, o.datum_nabave))
                                                AS dana_od_zadnje_rezervacije,
    DATEDIFF(o.garancija_do, CURRENT_DATE)      AS dana_do_isteka_garancije,
    CASE
      WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) < 0 THEN 'Jamstvo isteklo'
      WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) <= 30 THEN 'Jamstvo uskoro istječe'
      ELSE 'Garancija valjana'
    END                                         AS status_garancije,
    CASE
      WHEN COALESCE(r.rezervacije_zadnjih_30_dana,0) >= 10 THEN 'Visoka'
      WHEN COALESCE(r.rezervacije_zadnjih_30_dana,0) >= 5  THEN 'Srednja'
      ELSE 'Niska'
    END                                         AS kategorija_koristenja
FROM oprema o
LEFT JOIN res r ON o.id = r.id_opreme
ORDER BY
    rezervacije_zadnjih_30_dana DESC,
    dana_od_zadnje_rezervacije ASC;
```
**OPIS:**

CTE res prebrojava sve rezervacije po opremi, različite dane korištenja i računa prvu te zadnju rezervaciju, uključujući broj rezervacija u zadnjih 30 dana.

``COALESCE`` osigurava da se i oprema bez rezervacija prikaže s nulama umjesto ``NULL``.

``ROUND(... *100 / NULLIF(...))`` izračunava postotak rezervacija u zadnjih 30 dana u odnosu na ukupne rezervacije.

``ROUND(... / NULLIF(...))`` daje prosječan broj rezervacija po danu korištenja.

``DATEDIFF`` prikazuje koliko je dana prošlo od posljednje rezervacije i koliko dana preostaje do isteka garancije.

``CASE`` izrazi kategoriziraju status garancije i razinu korištenja ``(Visoka/Srednja/Niska)`` za brze odluke o servisu i zamjeni.

---




## Zaključak
U ovom projektu razvijen je detaljan model baze podataka koji omogućuje učinkovito upravljanje poslovanjem teretane. Obuhvaćeni su svi ključni aspekti – članstvo, članarine, treninzi, prisutnost, oprema, osoblje te financijske transakcije. Normalizacijom podataka i implementacijom stranih ključeva osigurana je konzistentnost i povezanost podataka, dok se fleksibilnim strukturama (npr. ENUM, tekstualna polja, napomene) omogućuje dodatna prilagodba stvarnim poslovnim potrebama.

Za daljnje poboljšanje sustava mogu se razmotriti sljedeće nadogradnje:

Dodavanje korisničkih računa i autentikacije za pristup sustavu (članovi i osoblje).

Praćenje analitike – izvještaji o broju dolazaka, najpopularnijim treninzima, prihodima po tipu članarine i sl.

Automatska obavijest članovima (e-mail ili SMS) o isteku članarine, zakazanim treninzima ili promjenama termina.

Integracija s online sustavima za plaćanje radi veće dostupnosti i praktičnosti.

Mobilna aplikacija ili web sučelje za članove kako bi mogli samostalno pregledavati treninge, rezervirati opremu i pratiti napredak.

U konačnici, ovaj sustav predstavlja temelj za cjelovito digitalno upravljanje teretanom, a njegovim daljnjim razvojem može se postići veća učinkovitost, bolja korisnička podrška i kvalitetnije poslovno odlučivanje.








