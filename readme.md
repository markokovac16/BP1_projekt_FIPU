# Projekt16 - Sustav za upravljanje teretanom

## Opis poslovnog procesa

Sustav za teretanu prati sljedeće poslovne procese:
- Registracija novih članova
- Evidencija članarina
- Zakazivanje individualnih i grupnih treninga
- Rezervacija opreme (sprava ili prostora za trening)

Postupak započinje učlanjenjem novog člana, nakon čega se odabire odgovarajući paket članarine. Član može zakazati trening s trenerom ili se pridružiti grupnom treningu, a sustav evidentira prisutnost na treninzima. Paralelno se prati stanje opreme te se po potrebi generiraju izvještaji o financijskim tokovima, popisu najposjećenijih treninga, ili aktivnostima trenera.

## ER dijagram

ER dijagram za teretanu obuhvaća sljedeće entitete i veze:
- **Član** - s atributima poput ID, ime, prezime, kontakt podaci, datum učlanjenja
- **Članarina** - vrsta, cijena, trajanje, opis
- **Trener** - ID, ime, prezime, specijalizacija, kontakt
- **Trening** - evidencija individualnih treninga (povezanih s članom i trenerom) s datumom, vremenom i trajanjem
- **Grupni_trening** - naziv, dan u tjednu, vrijeme, maksimalni broj članova, veza prema treneru
- **Prisutnost** - bilježi prisutnost članova na grupnim treninzima
- **Oprema** - sprave i druga oprema, s podacima o statusu, datumu nabave
- **Rezervacija_opreme** - evidentira rezervacije opreme, povezuje članove s opremom
- **Plaćanje** - bilježi uplate članarina s datumom, iznosom i načinom plaćanja
- **Osoblje** - dodatni entitet za evidenciju zaposlenika poput recepcionista

## Relacijski model (shema)

Tablice u relacijskom modelu teretane:
- član (id, ime, prezime, email, telefon, datum_učlanjenja, id_clanarina)
- članarina (id, tip, cijena, trajanje, opis)
- trener (id, ime, prezime, specijalizacija, email, telefon)
- trening (id, id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje)
- grupni_trening (id, naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme)
- prisutnost (id, id_clana, id_grupnog_treninga, datum)
- oprema (id, sifra, naziv, datum_nabave, stanje)
- rezervacija_opreme (id, id_clana, id_opreme, datum, vrijeme_početka, vrijeme_zavrsetka)
- placanje (id, id_clana, id_clanarina, iznos, datum_uplate, nacin_placanja)
- osoblje (id, ime, prezime, uloga, email, telefon)

## EER dijagram (MySQL Workbench)

Nakon definiranja ER dijagrama kreirana je logička shema u MySQL Workbench-u (EER dijagram) koja vizualno prikazuje sve tablice i njihove veze. Dijagram jasno prikazuje primarne i strane ključeve te veze između entiteta.

## Tablice

Svaka tablica u bazi detaljno je opisana s atributima, tipovima podataka, primarnim ključevima, stranim ključevima i ograničenjima:

- **Tablica član**: Evidentira podatke o članovima. Atribut id je primarni ključ, a atribut id_clanarina je strani ključ koji povezuje člana s odabranim paketom članarine.
- **Tablica trening**: Evidentira individualne treninge – povezivanje s članom i trenerom omogućuje praćenje izvedenih treninga.
- **Tablica rezervacija_opreme**: Povezuje člana s opremom putem stranih ključeva, omogućujući praćenje rezervacija.