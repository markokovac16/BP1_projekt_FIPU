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
8. Zaključak i preporuke za daljnji razvoj



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
Analiza vjernosti - na temelju duljine članstva i aktivnosti (privatni treninzi, grupni treninzi, rezervacije opreme) prepoznajemo najvjernije članove, kojima možemo ponuditi dodatne pogodnosti.

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
Također, omogućava vlasniku teretane da ima detaljne uvide u isplativosti određenih grupnih treninga, isplativosti privatnih trenera dugoročno, uvid u kašnjenja i izostale uplate i još mnoge stvari vezane uz financijsku stranu poslovanja.



## 3. Relacijski model

Relacijski model prikazuje sve tablice baze podataka s pripadajućim atributima, primarnim ključevima (PK) i stranim ključevima (FK). Svaka relacija sadrži popis atributa uz naznaku veza među tablicama.
Popis relacija:

1. clanarina(id, tip, cijena, trajanje, opis)
PK: id

2. clan(id, ime, prezime, email, telefon, datum_uclanjenja, id_clanarina, aktivan, datum_rodjenja, spol, adresa, grad)
PK: id
FK: id_clanarina → clanarina(id)

3. trener(id, ime, prezime, specijalizacija, email, telefon, datum_zaposlenja, godine_iskustva, aktivan)
PK: id

4. tip_treninga(id, naziv, osnovna_cijena, opis)
PK: id

5. privatni_trening(id, id_clana, id_trenera, id_tip_treninga, datum, vrijeme, trajanje, napomena, status, cijena)
PK: id
FK: id_clana → clan(id)
FK: id_trenera → trener(id)
FK: id_tip_treninga → tip_treninga(id)

6. grupni_trening(id, naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme, trajanje, cijena_po_terminu, aktivan, opis)
PK: id
FK: id_trenera → trener(id)

7. prisutnost(id, id_clana, id_grupnog_treninga, datum, prisutan)
PK: id
FK: id_clana → clan(id)
FK: id_grupnog_treninga → grupni_trening(id)

8. OPREMA
oprema(id, sifra, naziv, datum_nabave, stanje, vrijednost, proizvođač, model, garancija_do)
PK: id

9. REZERVACIJA_OPREME
rezervacija_opreme(id, id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka, status, napomena)
PK: id
FK: id_clana → clan(id)
FK: id_opreme → oprema(id)

10. OSOBLJE
osoblje(id, ime, prezime, uloga, email, telefon, datum_zaposlenja, placa, radno_vrijeme, aktivan)
PK: id

11. PLACANJE
placanje(id, id_clana, tip_placanja, referentni_id, iznos, datum_uplate, nacin_placanja, broj_racuna, popust, id_osoblje)
PK: id
FK: id_clana → clan(id)
FK: id_osoblje → osoblje(id)


## 3. ER dijagram
![Alt text](/erd.png)

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


## 5.EER dijagram (prošireni ER model)
![Alt text](/EER.png)

# 6. Tablice

Implementacija baze provedena je pomoću MySQL Workbench sustava. Baza nosi naziv **teretana**, a sastoji se od jedanest povezanih tablica. Svaka tablica sadrži definirane atribute s odgovarajućim tipovima podataka, primarnim i stranim ključevima.

U nastavku su prikazane sve tablice korištene u bazi, zajedno s definicijama atributa. Također su navedene SQL naredbe za kreiranje baze, unos početnih podataka (INSERT INTO) i definiranje odnosa među tablicama pomoću FOREIGN KEY veza.

## 6.1. TABLICA clanarina

Tablica **clanarina** služi za evidenciju vrsta članarina u teretani. Sadrži atribute: `id`, `tip`, `cijena`, `trajanje` i `opis`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT AUTO_INCREMENT`, jedinstveno identificira svaku članarinu
- **`tip`** - `VARCHAR(50) NOT NULL UNIQUE` označava naziv članarine (npr. "Osnovna", "Premium") i jedinstven je, pa se ne može ponavljati
- **`cijena`** - `DECIMAL(6,2) NOT NULL CHECK (cijena >= 0)` bilježi iznos u eurima, ne može biti negativan
- **`trajanje`** - `INT NOT NULL CHECK (trajanje > 0)` govori o duljini članarine u mjesecima, mora biti barem 1
- **`opis`** - `TEXT` može sadržavati dodatne napomene o pogodnostima ili uvjetima i može ostati prazan

## 6.2. TABLICA clan

Tablica **clan** pohranjuje osnovne podatke o članovima teretane. Sadrži atribute: `id`, `ime`, `prezime`, `email`, `telefon`, `datum_uclanjenja`, `id_clanarina`, `aktivan`, `datum_rodjenja`, `spol`, `adresa` i `grad`.

- **`id`** - primarni ključ (`INT AUTO_INCREMENT`) i jedinstveno identificira člana
- **`ime`** i **`prezime`** - `VARCHAR(50) NOT NULL` su obavezni za unos osobnih podataka
- **`email`** - `VARCHAR(100) NOT NULL UNIQUE` mora biti jedinstven i ne smije biti prazan
- **`telefon`** - `VARCHAR(20)` može ostati prazan ako se ne unese
- **`datum_uclanjenja`** - `DATE NOT NULL DEFAULT CURRENT_DATE` automatski pohranjuje datum učlanjenja
- **`id_clanarina`** - `INT` je strani ključ na `clanarina(id)`, označava vrstu članarine koju član odabere
- **`aktivan`** - `BOOLEAN DEFAULT TRUE` pokazuje je li članstvo aktivno
- **`datum_rodjenja`** - `DATE` i **`spol`** - `ENUM('M','Ž')` mogu ostati prazni
- **`adresa`** - `VARCHAR(200)` i **`grad`** - `VARCHAR(50) DEFAULT 'Zagreb'` pohranjuju adresu prebivališta

## 6.3. TABLICA trener

Tablica **trener** služi za pohranu podataka o osobama koje provode individualne i grupne treninge u teretani. Sadrži atribute: `id`, `ime`, `prezime`, `specijalizacija`, `email` i `telefon`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT`, s opcijom `AUTO_INCREMENT`, čime se automatski generira identifikator za svakog trenera
- **`ime`** i **`prezime`** - `VARCHAR(50)` i obavezni su (`NOT NULL`) jer predstavljaju osnovne podatke trenera
- **`specijalizacija`** - označava područje stručnosti trenera (npr. "Rehabilitacija", "Kondicijska priprema") i definiran je kao `VARCHAR(100)`
- **`email`** - `VARCHAR(100)`, a **`telefon`** - `VARCHAR(20)`. Oba podatka služe za kontaktiranje trenera i mogu biti neobavezni, ovisno o dostupnosti podataka

## 6.4. TABLICA tip_treninga

Tablica **tip_treninga** služi za evidenciju različitih vrsta treninga koji se nude u teretani. Sadrži atribute: `id`, `naziv`, `osnovna_cijena` i `opis`.

- **`id`** - PRIMARY KEY, `INT`, automatski se povećava (`AUTO_INCREMENT`) i koristi se za jedinstvenu identifikaciju svakog tipa treninga
- **`naziv`** - `VARCHAR(50)`, `NOT NULL` i `UNIQUE` – definira naziv tipa treninga (npr. "Pilates", "Kondicija") i mora biti jedinstven
- **`osnovna_cijena`** - `DECIMAL(6,2)`, `NOT NULL`, i predstavlja početnu cijenu treninga u eurima – ne može biti negativna
- **`opis`** - `TEXT` i koristi se za dodatne informacije o vrsti treninga – nije obavezan

## 6.5. TABLICA privatni_trening

Tablica **privatni_trening** služi za evidenciju individualnih treninga između članova i trenera. Sadrži atribute: `id`, `id_clana`, `id_trenera`, `id_tip_treninga`, `datum`, `vrijeme`, `trajanje`, `napomena`, `status` i `cijena`.

- **`id`** - PRIMARY KEY, `INT`, automatski se povećava (`AUTO_INCREMENT`) i koristi se za jedinstvenu identifikaciju svakog privatnog treninga
- **`id_clana`** - strani ključ (FOREIGN KEY) koji označava člana koji sudjeluje na treningu – povezan je s `clan(id)`
- **`id_trenera`** - strani ključ koji označava trenera koji vodi trening – povezan je s `trener(id)`
- **`id_tip_treninga`** - strani ključ koji označava vrstu treninga – povezan je s `tip_treninga(id)`
- **`datum`** - `DATE` i definira kada se trening održava, dok **`vrijeme`** (`TIME`) označava točan početak
- **`trajanje`** - `INT` i predstavlja trajanje treninga u minutama (maksimalno 180 minuta)
- **`napomena`** - `TEXT` i služi za dodatne informacije, po potrebi
- **`status`** - `ENUM ('zakazan', 'održan', 'otkazan')` s početnom vrijednosti 'zakazan', i definira stanje treninga
- **`cijena`** - `DECIMAL(6,2)` i prikazuje konačan iznos koji član plaća za taj trening

## 6.6. TABLICA grupni_trening

Tablica **grupni_trening** evidentira grupne treninge koji se održavaju u redovitim terminima i vodi ih jedan trener. Sadrži atribute: `id`, `naziv`, `id_trenera`, `max_clanova`, `dan_u_tjednu`, `vrijeme`, `trajanje`, `cijena_po_terminu`, `aktivan` i `opis`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT` s `AUTO_INCREMENT` i koristi se za jedinstvenu identifikaciju svakog grupnog treninga
- **`naziv`** - opisuje vrstu grupnog treninga (npr. "Pilates", "HIIT") i definiran je kao `VARCHAR(100)`, obavezan za unos
- **`id_trenera`** - strani ključ koji označava trenera koji vodi trening – povezan je s `trener(id)`
- **`max_clanova`** - `INT` koji označava maksimalan broj članova na treningu, uz ograničenje da mora biti veći od 0 i najviše 30
- **`dan_u_tjednu`** - `ENUM` koji definira dan kada se trening održava (npr. "Ponedjeljak", "Srijeda")
- **`vrijeme`** - `TIME` i koristi se za zakazivanje točnog termina treninga, s početnom vrijednosti `18:00:00`
- **`trajanje`** - `INT` i predstavlja trajanje treninga u minutama, s početnom vrijednosti 60
- **`cijena_po_terminu`** - `DECIMAL(5,2)` i označava cijenu po jednom terminu, mora biti veća od 0
- **`aktivan`** - `BOOLEAN` koji označava je li trening trenutno aktivan (zadana vrijednost je `TRUE`)
- **`opis`** - `TEXT` i koristi se za dodatne informacije o treningu

## 6.7. TABLICA prisutnost_grupni

Tablica **prisutnost_grupni** služi za evidenciju članova koji su prisustvovali grupnim treninzima. Povezuje članove s određenim grupnim treninzima na određeni datum. Sadrži atribute: `id`, `id_clana`, `id_grupnog_treninga`, `datum` i `prisutan`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT` s `AUTO_INCREMENT`, i koristi se za jedinstvenu identifikaciju svakog zapisa prisutnosti
- **`id_clana`** - strani ključ koji označava člana koji je sudjelovao na treningu – povezan je s `clan(id)`
- **`id_grupnog_treninga`** - strani ključ koji označava grupni trening kojem je član prisustvovao – povezan je s `grupni_trening(id)`
- **`datum`** - tipa `DATE` i koristi se za označavanje točnog dana prisustva. Ovaj podatak je obavezan (`NOT NULL`), jer omogućuje razlikovanje višestrukih prisustava na istom treningu
- **`prisutan`** - `BOOLEAN` koji označava je li član bio prisutan ili ne, s početnom vrijednosti `TRUE`

## 6.8. TABLICA oprema

Tablica **oprema** koristi se za evidenciju sprava i uređaja dostupnih u teretani. Sadrži atribute: `id`, `sifra`, `naziv`, `datum_nabave`, `stanje`, `vrijednost`, `proizvodac`, `model` i `garancija_do`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT` i automatski se generira (`AUTO_INCREMENT`)
- **`sifra`** - `VARCHAR(20)`, mora biti jedinstvena (`UNIQUE`) i označava inventarnu oznaku opreme (npr. "SPR-001")
- **`naziv`** - `VARCHAR(100)` i opisuje vrstu opreme (npr. "Bench klupa")
- **`datum_nabave`** - tipa `DATE` i obavezan je za praćenje datuma nabave opreme
- **`stanje`** - `ENUM` s mogućim vrijednostima: 'ispravna', 'u servisu', 'potrebna zamjena dijela', 'neispravna', 'nova' i po defaultu je 'nova', te opisuje trenutno stanje opreme
- **`vrijednost`** - `DECIMAL(8,2)` i označava financijsku vrijednost opreme, s početnom vrijednošću 0.00
- **`proizvodac`** i **`model`** - `VARCHAR(50)` i služe za unos podataka o proizvođaču i modelu opreme
- **`garancija_do`** - `DATE` i bilježi do kada vrijedi garancija na opremu

## 6.9. TABLICA rezervacija_opreme

Tablica **rezervacija_opreme** vodi evidenciju rezervacija opreme koje su napravili članovi. Sadrži atribute: `id`, `id_clana`, `id_opreme`, `datum`, `vrijeme_pocetka`, `vrijeme_zavrsetka`, `status` i `napomena`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT` s `AUTO_INCREMENT`
- **`id_clana`** - strani ključ koji povezuje rezervaciju s članom – referencira `clan(id)`
- **`id_opreme`** - strani ključ koji označava rezerviranu spravu – povezan je s `oprema(id)`
- **`datum`** - `DATE` i označava dan rezervacije
- **`vrijeme_pocetka`** i **`vrijeme_zavrsetka`** - tipa `TIME` i određuju vremenski raspon rezervacije; `vrijeme_zavrsetka` mora biti kasnije od `vrijeme_pocetka`
- **`status`** - `ENUM` s vrijednostima 'aktivna', 'završena' i 'otkazana', s default vrijednošću 'aktivna'
- **`napomena`** - tekstualno polje za dodatne informacije o rezervaciji

## 6.10. TABLICA osoblje

Tablica **osoblje** pohranjuje podatke o zaposlenicima teretane, uključujući trenere, recepcioniste i tehničko osoblje. Sadrži atribute: `id`, `ime`, `prezime`, `uloga`, `email`, `telefon`, `datum_zaposlenja`, `radno_vrijeme` i `aktivan`.

- **`id`** - primarni ključ (PRIMARY KEY) tipa `INT` s `AUTO_INCREMENT` i jedinstveno identificira svakog zaposlenika
- **`ime`** i **`prezime`** - `VARCHAR(50)` i obavezni su za osnovnu identifikaciju
- **`uloga`** - `ENUM` koji definira funkciju zaposlenika (npr. 'Recepcionist', 'Voditelj', 'Čistačica', 'Održavanje', 'Administrator', 'Nutricionist')
- **`email`** (`VARCHAR(100)`) je jedinstven kontakt, dok **`telefon`** (`VARCHAR(20)`) služi kao dodatni kontakt
- **`datum_zaposlenja`** - `DATE` i po defaultu postavlja trenutni datum
- **`radno_vrijeme`** - `VARCHAR(50)` i označava radni raspored zaposlenika
- **`aktivan`** - `BOOLEAN` s default vrijednošću `TRUE` i označava je li zaposlenik trenutno aktivan

## 6.11. TABLICA placanje

Tablica **placanje** služi za praćenje uplata članova. Sadrži atribute: `id`, `id_clana`, `iznos`, `datum_uplate`, `nacin_placanja`, `broj_racuna`, `popust`, `id_osoblje` i `opis`.

- **`id`** - primarni ključ, `INT` tipa, s `AUTO_INCREMENT` postavkom. Koristi se za identifikaciju svake transakcije u sustavu
- **`id_clana`** - strani ključ koji se odnosi na člana koji je izvršio uplatu. Povezan je s tablicom `clan(id)` i osigurava integritet podataka
- **`iznos`** - `DECIMAL(6,2)` i prikazuje iznos uplate. Obavezan je za unos jer prikazuje stvarno stanje prihoda
- **`datum_uplate`** - označava datum kada je uplata izvršena i tipa je `DATE`. Obavezan je zbog kronološkog praćenja uplata
- **`nacin_placanja`** - `ENUM` s vrijednostima ('gotovina', 'kartica', 'transfer', 'PayPal', 'kripto'), zadana vrijednost je 'kartica'. Opisuje način plaćanja i koristan je za analizu financija
- **`broj_racuna`** - `VARCHAR(20)` i jedinstven je (`UNIQUE`). Koristi se za evidenciju broja računa, ako je primjenjivo
- **`popust`** - `DECIMAL(5,2)` i predstavlja postotak popusta od 0 do 100, s default vrijednošću 0.00
- **`id_osoblje`** - strani ključ koji označava zaposlenika koji je evidentirao uplatu i povezan je s tablicom `osoblje(id)`
- **`opis`** - tekstualno polje za dodatne napomene

Vanjski ključevi definirani su za `id_clana` i `id_osoblje`, s opcijama `ON DELETE RESTRICT` i `ON UPDATE CASCADE`.

## 7. Pogledi i upit

# 7.1. Pogledi - Martina Ilić
# Pregled članova
Ovaj pogled omogućuje brz uvid u trenutno aktivne članove, njihov status članarine i koliko su dugo članovi, što može biti korisno za analizu zadržavanja članova i upravljanje odnosima s korisnicima.
```sql
CREATE OR REPLACE VIEW pregled_clanova AS
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS puno_ime,
    c.email,
    c.telefon,
    cl.tip AS tip_clanarine,
    cl.cijena,
    cl.trajanje AS trajanje_dana,
    c.datum_uclanjenja,
    DATEDIFF(CURRENT_DATE, c.datum_uclanjenja) AS dana_od_uclanjenja
FROM clan c
INNER JOIN clanarina cl ON c.id_clanarina = cl.id
WHERE c.aktivan = TRUE
ORDER BY c.datum_uclanjenja DESC;
```

# Statistika članarina
Ovaj pogled prikazuje statistiku po vrstama članarina, uključujući broj aktivnih članova po tipu, očekivani prihod i udio članova po vrsti članarine.
Očekivani prihod je procjena temeljena na množenju broja aktivnih članova s punom cijenom članarine, bez uzimanja u obzir stvarnih uplata, datuma plaćanja ili eventualnih popusta. Rezultat služi kao gruba procjena potencijalnog prihoda u idealnim uvjetima.
```sql
CREATE OR REPLACE VIEW statistika_clanarina AS
SELECT 
    cl.tip,
    cl.cijena,
    cl.trajanje,
    COUNT(c.id) AS broj_clanova,
    COUNT(c.id) * cl.cijena AS ocekivani_prihod,
    ROUND(COUNT(c.id) * 100.0 / (SELECT COUNT(*) FROM clan WHERE aktivan = TRUE), 2) AS postotak_clanova,
    CASE 
        WHEN cl.trajanje >= 365 THEN 'Godišnja'
        WHEN cl.trajanje >= 30 THEN 'Mjesečna'
    END AS kategorija_trajanja
FROM clanarina cl
LEFT JOIN clan c ON cl.id = c.id_clanarina AND c.aktivan = TRUE
GROUP BY cl.id, cl.tip, cl.cijena, cl.trajanje
ORDER BY broj_clanova DESC;
```

#  Demografski pregled članova
Ovaj pogled pruža demografsku analizu aktivnih članova prema spolu, dobnim skupinama i tipu članarine.Pogled je koristan za bolje razumijevanje ciljnih skupina korisnika, što može pomoći pri kreiranju marketinških kampanja, prilagodbi ponude i donošenju poslovnih odluka temeljenih na strukturi članstva.
```sql
CREATE OR REPLACE VIEW demografski_pregled_clanova AS
SELECT 
    c.spol,
    CASE 
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 25 THEN '18-24'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 35 THEN '25-34'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 45 THEN '35-44'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 55 THEN '45-54'
        ELSE '55+'
    END AS dobna_skupina,
    cl.tip AS tip_clanarine,
    COUNT(*) AS broj_clanova
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
WHERE c.aktivan = TRUE AND c.datum_rodjenja IS NOT NULL
GROUP BY c.spol, dobna_skupina, cl.tip
ORDER BY c.spol, dobna_skupina;
```
# 7.2. Upiti (Martina Ilić)
 Upit 1. Članovi koji u zadnjih 30 dana nisu rezervirali opremu niti sudjelovali na treninzima, a imaju aktivno članstvo (c.aktivan = TRUE)
Ovaj upit prikazuje aktivne članove koji u posljednjih 30 dana nisu rezervirali opremu, nisu sudjelovali na privatnim treninzima niti na grupnim treninzima.

Korisnost:
Omogućuje identifikaciju članova koji ne koriste usluge teretane iako imaju aktivno članstvo.
Može poslužiti za ciljanu komunikaciju, slanje podsjetnika, promotivnih ponuda ili poziva na aktivnosti kako bi se povećala njihova angažiranost i zadržavanje članova.
```sql
SELECT 
    c.id,
    c.ime,
    c.prezime,
    c.email,
    c.datum_uclanjenja
FROM clan c
WHERE 
    c.aktivan = TRUE
    AND NOT EXISTS (
        SELECT 1
        FROM rezervacija_opreme ro
        WHERE ro.id_clana = c.id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM privatni_trening t
        WHERE t.id_clana = c.id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM prisutnost_grupni pg
        WHERE pg.id_clana = c.id
    )
ORDER BY 
    c.datum_uclanjenja ASC, 
    c.prezime, 
    c.ime;
```

Upit 2: Financijska analiza po dobnim skupinama i spolu
Opis:
Ovaj upit prikazuje statistički i financijski pregled aktivnih članova grupiranih po dobnim skupinama i spolu. Može se koristiti za prilagodbu cijena, promotivnih paketa ili usluga ciljanim skupinama. Korisno za strategijsko planiranje i financijske analize
```sql
SELECT 
    CASE 
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 25 THEN '18-24'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 35 THEN '25-34'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 45 THEN '35-44'
        WHEN YEAR(CURRENT_DATE) - YEAR(c.datum_rodjenja) < 55 THEN '45-54'
        ELSE '55+'
    END AS dobna_skupina,
    c.spol,
    COUNT(DISTINCT c.id) AS broj_clanova,
    AVG(cl.cijena) AS prosjecna_cijena_clanarine,
    SUM(p.iznos) AS ukupno_placeno,
    AVG(p.iznos) AS prosjecno_placeno_po_transakciji,
    COUNT(p.id) AS broj_transakcija
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN placanje p ON c.id = p.id_clana
WHERE c.datum_rodjenja IS NOT NULL AND c.aktivan = TRUE
GROUP BY dobna_skupina, c.spol
ORDER BY dobna_skupina, c.spol;
```

Upit 3: Mjesečni prihod od članarina
Opis:
Ovaj upit izračunava ukupni očekivani mjesečni prihod temeljen na aktivnim članovima koji imaju mjesečne članarine (isključujući godišnje).Pomaže u procjeni redovitog mjesečnog prihoda

Korisno za financijsko planiranje i kontrolu likvidnosti

Fokusira se samo na ponavljajuće mjesečne uplate, što je važno za operativne troškove i budžetiranje
```sql
SELECT 
    'MJESEČNI PRIHOD' as kategorija,
    SUM(d.broj_clanova * cl.cijena) AS ukupno_eur,
    COUNT(DISTINCT d.tip_clanarine) AS broj_tipova_clanarina,
    SUM(d.broj_clanova) AS ukupno_aktivnih_clanova
FROM demografski_pregled_clanova d
JOIN clanarina cl ON d.tip_clanarine = cl.tip
WHERE cl.tip NOT LIKE '%Godišnja%';
```


# 7.3 Pogled - Pregled trenera s statistikama - Karlo Perić

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

##  Pogled - Raspored budućih treninga - Karlo Perić

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

## Pogled - Analiza tipova treninga - Karlo Perić

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

##  Upit - Efikasnost trenera po tipovima treninga - Karlo Perić

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

## 7.9. Upit - ROI analiza tipova treninga (Karlo Perić)

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

``COUNT(ro.id)`` prebrojava sve rezervacije pojedine sprave od strane člana.

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

## 7.2. Pogledi - Marko Kovač

### Pregled uplata članarina
Ovaj pogled prikazuje status plaćanja članarina za trenutni mjesec, omogućujući praćenje koji su članovi platili na vrijeme, koji kasne s plaćanjem, te koliko dana kasne. Pogled je koristan za upravljanje financijama teretane i identifikaciju članova kojima treba poslati opomene za plaćanje.


```sql
CREATE OR REPLACE VIEW pregled_uplata_clanarina AS
SELECT 
   c.id,
   c.ime,
   c.prezime,
   c.email,
   c.telefon,
   cl.tip AS tip_clanarine,
   cl.cijena AS cijena_clanarine,
   
   -- Informacije o uplati
   p.datum_uplate,
   p.iznos AS uplatio_iznos,
   p.nacin_placanja,
   CONCAT(o.ime, ' ', o.prezime) AS primio_uplatu,
   
   -- Status plaćanja s napomenama
   CASE 
       WHEN p.datum_uplate IS NULL THEN 'POSLATI OPOMENU'
       WHEN DAY(p.datum_uplate) <= 10 THEN 'OK'
       WHEN DAY(p.datum_uplate) > 10 THEN 'KAŠNJENJE'
   END AS status_placanja,
   
   -- Logika računanja dana kašnjenja
   CASE 
       WHEN p.datum_uplate IS NULL THEN DATEDIFF(CURRENT_DATE, DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')))
       WHEN DAY(p.datum_uplate) > 10 THEN DAY(p.datum_uplate) - 10
       ELSE 0
   END AS dana_kasnjenja,
   
   c.aktivan AS clan_aktivan
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN placanje p ON c.id = p.id_clana 
   AND YEAR(p.datum_uplate) = YEAR(CURRENT_DATE) 
   AND MONTH(p.datum_uplate) = MONTH(CURRENT_DATE)
LEFT JOIN osoblje o ON p.id_osoblje = o.id
WHERE c.aktivan = TRUE
ORDER BY 
   CASE 
       WHEN p.datum_uplate IS NULL THEN 1
       WHEN DAY(p.datum_uplate) > 10 THEN 2
       ELSE 3
   END,
   dana_kasnjenja DESC,
   c.prezime, c.ime;
```
**OPIS:**
`CASE` izraz kategorizira status plaćanja prema datumu uplate (do 10. u mjesecu je OK, nakon toga kašnjenje).
`DATEDIFF` računa broj dana kašnjenja od 10. dana u mjesecu.
`LEFT JOIN` na `placanje` filtriran je po trenutnoj godini i mjesecu za praćenje mjesečnih uplata.
`ORDER BY` prioritizira prikaz prvo onih koji nisu platili, zatim onih koji kasne, pa tek one koji su platili na vrijeme.



### Pregled dodatnih troškova članova
Ovaj pogled izračunava dodatne troškove članova osim osnovne članarine, uključujući privatne treninge i dodatne grupne treninge ovisno o tipu članarine. Pogled je koristan za izračun ukupnog iznosa za naplatu za svaki mjesec i razumijevanje koliko članovi troše na dodatne usluge.


```sql
CREATE OR REPLACE VIEW dodatni_troskovi_clanova AS
SELECT 
    c.id,
    c.ime,
    c.prezime,
    cl.tip AS tip_clanarine,
    
    -- Privatni treninzi (svi se naplaćuju za ne-Premium članove)
    COUNT(pt.id) AS broj_privatnih_treninga,
    COALESCE(SUM(pt.cijena), 0) AS troskovi_privatni_treninzi,
    
    -- Dodatni grupni treninzi (samo za Osnovna i Student - Basic)
    COUNT(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN pr.id 
        ELSE NULL 
    END) AS broj_dodatnih_grupnih,
    
    COALESCE(SUM(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
        ELSE 0 
    END), 0) AS troskovi_grupni_treninzi,
    
    -- Ukupni dodatni troškovi
    COALESCE(SUM(pt.cijena), 0) + 
    COALESCE(SUM(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
        ELSE 0 
    END), 0) AS ukupno_dodatni_troskovi,

    -- Mjesečni iznos članarine (0 za Godišnju Standard)
    CASE 
        WHEN c.id_clanarina = 6 THEN 0.00
        ELSE cl.cijena
    END AS mjesecni_iznos_clanarine,
    
    -- Ukupno za naplatu ovaj mjesec
    CASE 
        WHEN c.id_clanarina = 6 THEN -- Godišnja Standard (ne naplaćuje se mjesečno)
            COALESCE(SUM(pt.cijena), 0) + 
            COALESCE(SUM(CASE 
                WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
                ELSE 0 
            END), 0)
        ELSE -- Mjesečne članarine
            cl.cijena + 
            COALESCE(SUM(pt.cijena), 0) + 
            COALESCE(SUM(CASE 
                WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
                ELSE 0 
            END), 0)
    END AS ukupno_za_naplatu_ovaj_mjesec,
    
    -- Označavanje godišnjih članarina
    CASE 
        WHEN c.id_clanarina = 6 THEN 'DA' 
        ELSE 'NE' 
    END AS godisnja_clanarina
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN privatni_trening pt ON c.id = pt.id_clana 
    AND pt.status = 'održan'
    AND YEAR(pt.datum) = YEAR(CURRENT_DATE) 
    AND MONTH(pt.datum) = MONTH(CURRENT_DATE)
LEFT JOIN prisutnost_grupni pr ON c.id = pr.id_clana 
    AND pr.prisutan = TRUE
    AND YEAR(pr.datum) = YEAR(CURRENT_DATE) 
    AND MONTH(pr.datum) = MONTH(CURRENT_DATE)
LEFT JOIN grupni_trening gt ON pr.id_grupnog_treninga = gt.id
WHERE c.aktivan = TRUE
    AND cl.id NOT IN (3, 7)  -- Isključuje Premium (mjesečni) i Godišnju Premium
GROUP BY c.id, c.ime, c.prezime, cl.tip, cl.cijena, c.id_clanarina, cl.id
ORDER BY ukupno_dodatni_troskovi DESC;
```
**OPIS:**
`COUNT` i `COALESCE` računaju broj i troškove privatnih treninga i grupnih treninga.
`CASE` izraz razlikuje godišnje članarine (id=6) od mjesečnih pri računanju ukupnog iznosa za naplatu.
Logika naplate grupnih treninga primjenjuje se samo na 'Osnovna' i 'Student - Basic' članarine.
`WHERE` klauzula isključuje Premium članarine (id 3 i 7) jer one imaju drugačiju strukturu naplate.


### Pregled uplata članarina
Ovaj pogled prikazuje statistike aktivnosti trenera za trenutni mjesec, uključujući broj održanih privatnih treninga, ukupan prihod, broj klijenata i prosječne cijene. Pogled je koristan za praćenje performansi trenera i donošenje odluka o nagrađivanju ili dodatnom treningu.


```sql
CREATE OR REPLACE VIEW aktivnost_trenera AS
SELECT 
    t.id,
    t.ime,
    t.prezime,
    t.specijalizacija,
    
    COUNT(pt.id) AS broj_privatnih_treninga,
    COALESCE(SUM(pt.cijena), 0) AS ukupni_prihod,
    COUNT(DISTINCT pt.id_clana) AS broj_klijenata,
    
    ROUND(AVG(pt.cijena), 2) AS prosjecna_cijena_treninga,
    ROUND(COALESCE(SUM(pt.cijena), 0) / NULLIF(COUNT(DISTINCT pt.id_clana), 0), 2) AS prihod_po_klijentu,
    
    MIN(pt.datum) AS prvi_trening_ovaj_mjesec,
    MAX(pt.datum) AS zadnji_trening_ovaj_mjesec,
    
    GROUP_CONCAT(DISTINCT tt.naziv ORDER BY tt.naziv SEPARATOR ', ') AS tipovi_treninga
FROM trener t
LEFT JOIN privatni_trening pt ON t.id = pt.id_trenera 
    AND pt.status = 'održan'
    AND YEAR(pt.datum) = YEAR(CURRENT_DATE) 
    AND MONTH(pt.datum) = MONTH(CURRENT_DATE)
LEFT JOIN tip_treninga tt ON pt.id_tip_treninga = tt.id
WHERE t.aktivan = TRUE
GROUP BY t.id, t.ime, t.prezime, t.specijalizacija
ORDER BY ukupni_prihod DESC;
```
**OPIS:**
`COUNT(DISTINCT pt.id_clana)` broji jedinstvene klijente po treneru.
`ROUND(AVG(pt.cijena), 2)` računa prosječnu cijenu treninga.
`NULLIF` sprječava dijeljenje s nulom pri računanju prihoda po klijentu.
`GROUP_CONCAT` spaja različite tipove treninga koje trener vodi u jedan string.
`MIN MAX` prikazuju vremenski raspon aktivnosti u mjesecu.


## 7 Upit – Ukupne transakcije po članu osoblja zaduženom za naplate

Prikazuje ukupne transakcije, prihod, broj klijenata i načine plaćanja po recepcionistima i voditeljima.

**TRAŽENO RJEŠENJE:**  
Ime, prezime, uloga, broj klijenata, ukupno transakcija, ukupni prihod, prihod po klijentu, najveća pojedinačna naplata, korišteni načini plaćanja.

**KOD:**  
```sql
SELECT 
    o.ime,
    o.prezime,
    o.uloga,
    COUNT(DISTINCT p.id_clana) AS broj_klijenata,
    COUNT(p.id) AS ukupno_transakcija,
    ROUND(SUM(p.iznos * (1 - p.popust/100)), 2) AS ukupni_prihod,
    ROUND(SUM(p.iznos * (1 - p.popust/100)) / COUNT(DISTINCT p.id_clana), 2) AS prihod_po_klijentu,
    ROUND(MAX(p.iznos * (1 - p.popust/100)), 2) AS najveca_pojedinacna_naplata,
    GROUP_CONCAT(DISTINCT p.nacin_placanja ORDER BY p.nacin_placanja) AS nacini_placanja_koje_koristi
FROM osoblje o
JOIN placanje p ON o.id = p.id_osoblje
WHERE o.uloga IN ('Recepcionist', 'Voditelj') AND o.aktivan = TRUE
GROUP BY o.id, o.ime, o.prezime, o.uloga
ORDER BY prihod_po_klijentu DESC;
```

**OPIS:**  
Grupira transakcije po zaposlenicima, računa ukupan i prosječni prihod, najveću pojedinačnu naplatu i prikuplja načine plaćanja.

-----------------------------  
## 8 Upit – Analiza plaćanja po načinu (Marko Kovač)

Analizira broj, prihod i udio transakcija po načinu plaćanja.

**TRAŽENO RJEŠENJE:**  
Način plaćanja, broj transakcija, ukupni prihod, prosječni iznos, broj različitih klijenata, postotak transakcija, postotak prihoda.

**KOD:**  
```sql
SELECT 
    p.nacin_placanja,
    COUNT(*) AS broj_transakcija,
    SUM(p.iznos - p.popust) AS ukupni_prihod,
    ROUND(AVG(p.iznos - p.popust), 2) AS prosjecni_iznos,
    COUNT(DISTINCT p.id_clana) AS broj_različitih_klijenata,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM placanje), 2) AS postotak_transakcija,
    ROUND(SUM(p.iznos - p.popust) * 100.0 / (SELECT SUM(iznos - popust) FROM placanje), 2) AS postotak_prihoda
FROM placanje p
WHERE p.nacin_placanja IS NOT NULL
GROUP BY p.nacin_placanja
ORDER BY ukupni_prihod DESC;
```

**OPIS:**  
Računa koliko je transakcija po načinu plaćanja, koliki je njihov prihod i udio u ukupnom volumenu.

-----------------------------  
## 9 Upit – Koji zaposlenici daju popuste i koliki je ukupni iznos popusta

Prikazuje pregled popusta koje su odobrili recepcionisti i voditelji.

**TRAŽENO RJEŠENJE:**  
Ime, prezime, uloga, broj odobrenih popusta, ukupno naplata, postotak s popustom, prosječni popust, ukupan iznos popusta, bruto iznos, neto iznos, prosječni postotak popusta.

**KOD:**  
```sql
SELECT 
    o.ime,
    o.prezime,
    o.uloga,
    COUNT(CASE WHEN p.popust > 0 THEN 1 END) AS broj_popusta_odobren,
    COUNT(p.id) AS ukupno_naplata,
    ROUND((COUNT(CASE WHEN p.popust > 0 THEN 1 END) * 100.0) / COUNT(p.id), 2) AS postotak_s_popustom,
    ROUND(AVG(CASE WHEN p.popust > 0 THEN p.popust END), 2) AS prosjecni_popust,
    ROUND(SUM(p.iznos * p.popust/100), 2) AS ukupan_iznos_popusta,
    ROUND(SUM(p.iznos), 2) AS ukupni_bruto_iznos,
    ROUND(SUM(p.iznos * (1 - p.popust/100)), 2) AS ukupni_neto_iznos,
    ROUND(AVG(p.popust), 2) AS prosjecni_postotak_popusta
FROM osoblje o
JOIN placanje p ON o.id = p.id_osoblje
WHERE o.uloga IN ('Recepcionist', 'Voditelj') AND o.aktivan = TRUE
GROUP BY o.id, o.ime, o.prezime, o.uloga
ORDER BY ukupan_iznos_popusta DESC;
```

**OPIS:**  
Analizira učestalost i iznose odobrenih popusta po zaposlenicima, te uspoređuje bruto i neto iznose.



## 8. Zaključak
U ovom projektu razvijen je detaljan model baze podataka koji omogućuje učinkovito upravljanje poslovanjem teretane. Obuhvaćeni su svi ključni aspekti – članstvo, članarine, treninzi, prisutnost, oprema, osoblje te financijske transakcije. Normalizacijom podataka i implementacijom stranih ključeva osigurana je konzistentnost i povezanost podataka, dok se fleksibilnim strukturama (npr. ENUM, tekstualna polja, napomene) omogućuje dodatna prilagodba stvarnim poslovnim potrebama.

Za daljnje poboljšanje sustava mogu se razmotriti sljedeće nadogradnje:

Dodavanje korisničkih računa i autentikacije za pristup sustavu (članovi i osoblje).

Praćenje analitike – izvještaji o broju dolazaka, najpopularnijim treninzima, prihodima po tipu članarine i sl.

Automatska obavijest članovima (e-mail ili SMS) o isteku članarine, zakazanim treninzima ili promjenama termina.

Integracija s online sustavima za plaćanje radi veće dostupnosti i praktičnosti.

Mobilna aplikacija ili web sučelje za članove kako bi mogli samostalno pregledavati treninge, rezervirati opremu i pratiti napredak.

U konačnici, ovaj sustav predstavlja temelj za cjelovito digitalno upravljanje teretanom, a njegovim daljnjim razvojem može se postići veća učinkovitost, bolja korisnička podrška i kvalitetnije poslovno odlučivanje.







