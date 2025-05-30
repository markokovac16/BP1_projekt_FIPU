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
Treneri su zaposlenici teretane koji vode individualne i grupne treninge. Za svakog trenera evidentiraju se osnovni podaci poput imena, kontakta, datuma zaposlenja te specijalizacije, čime se olakšava upravljanje osobljem i dodjeljivanje treninga prema stručnosti.

Svaki trening evidentira se kao zaseban zapis u bazi te je povezan s članom, trenerom i tipom treninga. Uz datum, vrijeme i trajanje, moguće je evidentirati napomene te status treninga (zakazan, održan, otkazan), što omogućuje praćenje realizacije u stvarnom vremenu.

Tipovi treninga (npr. , kardio, yoga) definirani su u posebnoj tablici s pripadajućom osnovnom cijenom i opisom. Time je omogućena fleksibilna kategorizacija i jednostavno dodavanje novih vrsta usluga bez izmjena postojećih zapisa.

Sustav tako omogućuje precizno praćenje individualnih treninga, angažmana trenera i pruženih usluga, što je ključno za planiranje resursa i financijsku analizu.

## 2.3 Grupni treninzi i prisutnost članova
Grupni treninzi predstavljaju organizirane termine treninga koje vodi jedan trener, a na njima može sudjelovati više članova. Svaki grupni trening definiran je nazivom, terminom (dan i vrijeme), maksimalnim brojem članova, trajanjem i cijenom po terminu. Trener koji vodi trening jasno je naznačen u sustavu kako bi se olakšalo planiranje rasporeda i raspodjela rada.

Za svakog člana koji sudjeluje u grupnom treningu vodi se evidencija prisutnosti. Ova evidencija uključuje datum termina i informaciju je li član bio prisutan, što omogućuje praćenje sudjelovanja, izradu statistika i potencijalnu naplatu po dolasku.

Sustav na taj način omogućuje učinkovito upravljanje grupnim treninzima, praćenje broja sudionika te transparentno vođenje evidencije o dolascima, što je korisno i za trenere i za upravu teretane.

## 2.4 Oprema i rezervacije
U teretani se vodi detaljna evidencija o svakoj spravi i opremi koja je dostupna članovima i osoblju. Svaki komad opreme ima jedinstvenu šifru, naziv, datum nabave, stanje (npr. nova, ispravna, u servisu), vrijednost te podatke o proizvođaču, modelu i jamstvu. Ovaj sustav evidencije omogućuje praćenje životnog ciklusa opreme i planiranje održavanja ili zamjene.

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





## Zaključak
U ovom projektu razvijen je detaljan model baze podataka koji omogućuje učinkovito upravljanje poslovanjem teretane. Obuhvaćeni su svi ključni aspekti – članstvo, članarine, treninzi, prisutnost, oprema, osoblje te financijske transakcije. Normalizacijom podataka i implementacijom stranih ključeva osigurana je konzistentnost i povezanost podataka, dok se fleksibilnim strukturama (npr. ENUM, tekstualna polja, napomene) omogućuje dodatna prilagodba stvarnim poslovnim potrebama.

Za daljnje poboljšanje sustava mogu se razmotriti sljedeće nadogradnje:

Dodavanje korisničkih računa i autentikacije za pristup sustavu (članovi i osoblje).

Praćenje analitike – izvještaji o broju dolazaka, najpopularnijim treninzima, prihodima po tipu članarine i sl.

Automatska obavijest članovima (e-mail ili SMS) o isteku članarine, zakazanim treninzima ili promjenama termina.

Integracija s online sustavima za plaćanje radi veće dostupnosti i praktičnosti.

Mobilna aplikacija ili web sučelje za članove kako bi mogli samostalno pregledavati treninge, rezervirati opremu i pratiti napredak.

U konačnici, ovaj sustav predstavlja temelj za cjelovito digitalno upravljanje teretanom, a njegovim daljnjim razvojem može se postići veća učinkovitost, bolja korisnička podrška i kvalitetnije poslovno odlučivanje.








