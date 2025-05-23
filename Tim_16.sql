-- Brisanje baze podataka ako već postoji(za clean slate pri testiranju)
DROP DATABASE IF EXISTS teretana;

-- Kreiranje nove baze podataka
CREATE DATABASE teretana;
USE teretana;

-- Tablica: članarina
CREATE TABLE clanarina (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tip VARCHAR(50) NOT NULL,
    cijena DECIMAL(6,2) NOT NULL,
    trajanje INT NOT NULL,
    opis TEXT
);

-- Podaci za vrste članarina
INSERT INTO clanarina (tip, cijena, trajanje, opis) VALUES
('Osnovna', 29.99, 30, 'Pristup svim osnovnim spravama'),
('Napredna', 49.99, 30, 'Pristup svim spravama i grupnim treninzima'),
('Premium', 69.99, 30, 'Svi treninzi + privatni ormarić + 1x tjedno individualni trening');

-- Tablica: clan
CREATE TABLE clan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20),
    datum_uclanjenja DATE NOT NULL,
    id_clanarina INT,
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id)
);

-- Podaci za članove, moguće proširiti ako je potrebno za kompleksnije upite
INSERT INTO clan (ime, prezime, email, telefon, datum_uclanjenja, id_clanarina) VALUES
('Ana', 'Anić', 'ana.anic@example.com', '0911111111', '2025-01-15', 1),
('Ivan', 'Ivić', 'ivan.ivic@example.com', '0922222222', '2025-02-01', 2),
('Petra', 'Perić', 'petra.peric@example.com', '0933333333', '2025-03-01', 3),
('Marko', 'Marković', 'marko.markovic@example.com', '0944444444', '2025-04-15', 1),
('Luka', 'Lukić', 'luka.lukic@example.com', '0955555555', '2025-05-01', 2),
('Katarina', 'Katić', 'katarina.katic@example.com', '0966666666', '2025-05-15', 3);

-- Tablica: trener
CREATE TABLE trener (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    specijalizacija VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

-- Podaci za trenere
INSERT INTO trener (ime, prezime, specijalizacija, email, telefon) VALUES
('Marko', 'Marić', 'Kondicijska priprema', 'marko.maric@example.com', '0914445555'),
('Lana', 'Lukić', 'Rehabilitacija', 'lana.lukic@example.com', '0926667777'),
('Petar', 'Perović', 'Bodybuilding', 'petar.perovic@example.com', '0937778888'),
('Ana', 'Anić', 'Funkcionalni trening', 'ana.anic@example.com', '0948889999'),
('Filip', 'Maričić', 'Rehabilitacija', 'filip.maričić@example.com', '0938140416'),
('Ante', 'Babić', 'Kardio trening', 'ante.babić@example.com', '0954704637'),
('Tomislav', 'Dominković', 'Kardio trening', 'tomislav.dominković@example.com', '0944821369'),
('Lucija', 'Šimić', 'Rehabilitacija', 'lucija.šimić@example.com', '0938035781'),
('Martina', 'Kovač', 'CrossFit', 'martina.kovač@example.com', '0983317492'),
('Davor', 'Šimić', 'Pilates', 'davor.šimić@example.com', '0977012538'),
('Nikola', 'Kovač', 'Kardio trening', 'nikola.kovač@example.com', '0949105376'),
('Martina', 'Jukić', 'CrossFit', 'martina.jukić@example.com', '0989823661'),
('Lucija', 'Babić', 'Yoga', 'lucija.babić@example.com', '0961781794'),
('Martina', 'Kovač', 'CrossFit', 'martina.kovač@example.com', '0931873048'),
('Maja', 'Pavić', 'Snaga i izdržljivost', 'maja.pavić@example.com', '0952211757');

-- Tablica: trening
CREATE TABLE trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT,
    id_trenera INT,
    tip_treninga VARCHAR(50),
    datum DATE,
    vrijeme TIME,
    trajanje INT,
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_trenera) REFERENCES trener(id)
);

-- Podaci za treninge
INSERT INTO trening (id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje) VALUES
(1, 1, 'Kondicijska priprema', '2025-05-10', '08:00:00', 60),
(2, 1, 'Kondicijska priprema', '2025-05-13', '09:00:00', 60),
(3, 1, 'Kondicijska priprema', '2025-05-20', '10:00:00', 60),
(4, 2, 'Rehabilitacija', '2025-05-11', '10:00:00', 45),
(5, 2, 'Rehabilitacija', '2025-05-18', '15:00:00', 60),
(6, 2, 'Rehabilitacija', '2025-05-25', '14:00:00', 60),
(1, 3, 'Bodybuilding', '2025-05-12', '11:00:00', 90),
(2, 3, 'Bodybuilding', '2025-05-19', '13:00:00', 75),
(5, 3, 'Bodybuilding', '2025-05-26', '12:00:00', 75),
(3, 4, 'Funkcionalni trening', '2025-05-14', '16:00:00', 60),
(4, 4, 'Funkcionalni trening', '2025-05-21', '17:00:00', 75),
(6, 4, 'Funkcionalni trening', '2025-05-28', '17:30:00', 60),
(1, 5, 'Rehabilitacija', '2025-05-15', '14:00:00', 45),
(2, 5, 'Rehabilitacija', '2025-05-22', '13:00:00', 60),
(3, 5, 'Rehabilitacija', '2025-05-29', '10:00:00', 60),
(4, 6, 'Kardio trening', '2025-05-16', '08:30:00', 45),
(5, 6, 'Kardio trening', '2025-05-23', '09:00:00', 60),
(6, 6, 'Kardio trening', '2025-05-30', '07:00:00', 60),
(1, 7, 'Kardio trening', '2025-05-17', '10:30:00', 60),
(2, 7, 'Kardio trening', '2025-05-24', '11:00:00', 45),
(3, 7, 'Kardio trening', '2025-05-31', '11:30:00', 60),
(4, 8, 'Rehabilitacija', '2025-05-18', '15:00:00', 60),
(5, 8, 'Rehabilitacija', '2025-05-25', '14:00:00', 45),
(6, 8, 'Rehabilitacija', '2025-06-01', '15:00:00', 60),
(1, 9, 'CrossFit', '2025-05-19', '17:00:00', 75),
(2, 9, 'CrossFit', '2025-05-26', '18:00:00', 60),
(3, 9, 'CrossFit', '2025-06-02', '18:30:00', 75),
(4, 10, 'Pilates', '2025-05-20', '09:00:00', 45),
(5, 10, 'Pilates', '2025-05-27', '10:00:00', 60),
(6, 10, 'Pilates', '2025-06-03', '08:30:00', 60),
(1, 11, 'Kardio trening', '2025-05-21', '11:00:00', 45),
(2, 11, 'Kardio trening', '2025-05-28', '12:00:00', 60),
(3, 11, 'Kardio trening', '2025-06-04', '10:30:00', 60),
(4, 12, 'CrossFit', '2025-05-22', '16:00:00', 60),
(5, 12, 'CrossFit', '2025-05-29', '17:00:00', 75),
(6, 12, 'CrossFit', '2025-06-05', '17:30:00', 75),
(1, 13, 'Yoga', '2025-05-23', '08:00:00', 45),
(2, 13, 'Yoga', '2025-05-30', '09:00:00', 60),
(3, 13, 'Yoga', '2025-06-06', '09:30:00', 60),
(4, 14, 'CrossFit', '2025-05-24', '13:00:00', 60),
(5, 14, 'CrossFit', '2025-05-31', '14:00:00', 75),
(6, 14, 'CrossFit', '2025-06-07', '14:30:00', 75),
(1, 15, 'Snaga i izdržljivost', '2025-05-25', '15:00:00', 90),
(2, 15, 'Snaga i izdržljivost', '2025-06-01', '16:00:00', 75),
(3, 15, 'Snaga i izdržljivost', '2025-06-08', '16:30:00', 90);

-- Tablica: grupni_trening
CREATE TABLE grupni_trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_trenera INT,
    max_clanova INT,
    dan_u_tjednu VARCHAR(15),
    vrijeme TIME,
    FOREIGN KEY (id_trenera) REFERENCES trener(id)
);

-- Podaci za grupne treninge
INSERT INTO grupni_trening (naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme) VALUES
('Pilates', 2, 15, 'Ponedjeljak', '18:00:00'),
('HIIT', 1, 20, 'Srijeda', '19:00:00'),
('Yoga', 4, 12, 'Petak', '17:30:00'),
('Lifting', 3, 18, 'Utorak', '20:00:00');

-- Tablica: prisutnost
CREATE TABLE prisutnost (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT,
    id_grupnog_treninga INT,
    datum DATE,
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id)
);

-- Podaci za prisutnost
INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum) VALUES
(1, 1, '2025-05-05'),
(2, 2, '2025-05-07'),
(3, 3, '2025-05-09'),
(4, 4, '2025-05-06');

-- Tablica: oprema
CREATE TABLE oprema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sifra VARCHAR(20) NOT NULL UNIQUE,
    naziv VARCHAR(100),
    datum_nabave DATE,
    stanje VARCHAR(50)
);

-- Podaci za opremu
INSERT INTO oprema (sifra, naziv, datum_nabave, stanje) VALUES
('SPR-001', 'Bench klupa', '2023-05-01', 'ispravna'),
('SPR-002', 'Traka za trčanje', '2024-01-15', 'u servisu'),
('SPR-003', 'Utezi', '2023-12-01', 'ispravna'),
('SPR-004', 'Kardio sprava', '2024-02-20', 'ispravna');

-- Tablica: rezervacija_opreme
CREATE TABLE rezervacija_opreme (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT,
    id_opreme INT,
    datum DATE,
    vrijeme_pocetka TIME,
    vrijeme_zavrsetka TIME,
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_opreme) REFERENCES oprema(id)
);

-- Podaci za rezervacije opreme
INSERT INTO rezervacija_opreme (id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka) VALUES
(1, 1, '2025-05-08', '09:00:00', '09:45:00'),
(2, 2, '2025-05-08', '10:00:00', '10:30:00'),
(3, 3, '2025-05-09', '16:00:00', '17:00:00');

-- Tablica: placanje
CREATE TABLE placanje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT,
    id_clanarina INT,
    iznos DECIMAL(6,2),
    datum_uplate DATE,
    nacin_placanja VARCHAR(50),
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id)
);

-- Podaci za plaćanja
INSERT INTO placanje (id_clana, id_clanarina, iznos, datum_uplate, nacin_placanja) VALUES
(1, 1, 29.99, '2025-01-15', 'kartica'),
(2, 2, 49.99, '2025-02-01', 'gotovina'),
(3, 3, 69.99, '2025-03-01', 'kartica'),
(4, 1, 29.99, '2025-04-15', 'transfer'),
(5, 2, 49.99, '2025-05-01', 'gotovina');
-- (6, 3, 69.99, '2025-02-15', 'kartica'),
-- (7, 1, 29.99, '2025-03-20', 'transfer'),
-- (8, 2, 49.99, '2025-04-10', 'gotovina'),
-- (9, 3, 69.99, '2025-05-05', 'kartica'),
-- b(10, 1, 29.99, '2025-01-30', 'transfer');

-- Tablica: osoblje
CREATE TABLE osoblje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    uloga VARCHAR(50),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

-- Podaci za osoblje
INSERT INTO osoblje (ime, prezime, uloga, email, telefon) VALUES
('Josip', 'Jurić', 'Recepcionist', 'josip.juric@example.com', '099888999'),
('Maja', 'Majić', 'Voditelj', 'maja.majic@example.com', '098777666'),
('Ana', 'Horvat', 'Trener', 'ana.horvat@example.com', '097666555'),
('Petar', 'Petrović', 'Tehničko osoblje', 'petar.petrovic@example.com', '096555444');

-- POGLEDI ZA PLAĆANJA I OSOBLJE

-- Pogled ukupnih prihoda po mjesecima
CREATE VIEW prihodi_po_mjesecima AS
SELECT 
    YEAR(datum_uplate) AS godina,
    MONTH(datum_uplate) AS mjesec,
    SUM(iznos) AS ukupni_prihod,
    COUNT(*) AS broj_uplata
FROM placanje
GROUP BY godina, mjesec
ORDER BY godina, mjesec;

-- Pogled načina plaćanja
CREATE VIEW nacini_placanja AS
SELECT 
    nacin_placanja,
    COUNT(*) AS broj_placanja,
    SUM(iznos) AS ukupni_prihod,
    AVG(iznos) AS prosjecna_uplata
FROM placanje
GROUP BY nacin_placanja;

-- Pogled članova s najvećim uplatama
CREATE VIEW najpodmireniji_clanovi AS
SELECT 
    c.id AS clan_id,
    c.ime,
    c.prezime,
    COUNT(p.id) AS broj_uplata,
    SUM(p.iznos) AS ukupni_izdaci,
    MAX(p.datum_uplate) AS zadnja_uplata
FROM clan c
JOIN placanje p ON c.id = p.id_clana
GROUP BY c.id, c.ime, c.prezime
ORDER BY ukupni_izdaci DESC
LIMIT 5;

-- Pogled za praćenje članarina
CREATE VIEW status_clanarina AS
SELECT 
    c.id AS clan_id,
    c.ime,
    c.prezime,
    cl.tip AS vrsta_clanarine,
    MAX(p.datum_uplate) AS zadnja_uplata,
    DATEDIFF(CURRENT_DATE, MAX(p.datum_uplate)) AS dana_od_zadnje_uplate
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN placanje p ON c.id = p.id_clana
GROUP BY c.id, c.ime, c.prezime, cl.tip
ORDER BY dana_od_zadnje_uplate DESC;

-- Pogled dugova
CREATE VIEW neplacene_clanarine AS
SELECT 
    c.id AS clan_id,
    c.ime,
    c.prezime,
    cl.tip AS vrsta_clanarine,
    cl.cijena AS iznos_clanarine
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN placanje p ON c.id = p.id_clana
WHERE p.id IS NULL;

-- Pogled za osoblje
CREATE VIEW osoblje_pregled AS
SELECT 
    uloga, 
    COUNT(*) AS broj_zaposlenika
FROM osoblje
GROUP BY uloga;

-- ===============================================
-- === UPITI: TRENERI I TRENING ===
-- ===============================================

-- 1. Treneri s najviše individualnih treninga u zadnjih 30 dana
DROP VIEW IF EXISTS treneri_top_30_dana;
CREATE VIEW treneri_top_30_dana AS
SELECT t.id, t.ime, t.prezime, COUNT(tr.id) AS broj_treninga
FROM trener t
JOIN trening tr ON t.id = tr.id_trenera
WHERE tr.datum >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY t.id, t.ime, t.prezime;

SELECT * 
FROM treneri_top_30_dana
ORDER BY broj_treninga DESC;

-- 2. Članovi koji su trenirali s više različitih trenera
DROP VIEW IF EXISTS clanovi_razni_treneri;
CREATE VIEW clanovi_razni_treneri AS
SELECT c.id, c.ime, c.prezime, COUNT(DISTINCT tr.id_trenera) AS broj_razlicitih_trenera
FROM clan c
JOIN trening tr ON c.id = tr.id_clana
GROUP BY c.id, c.ime, c.prezime;

SELECT * 
FROM clanovi_razni_treneri
WHERE broj_razlicitih_trenera > 1;

-- 3. Prosječno trajanje treninga po treneru + trener s najdužim prosjekom
DROP VIEW IF EXISTS prosjecno_trajanje_po_treneru;
CREATE VIEW prosjecno_trajanje_po_treneru AS
SELECT t.id, t.ime, t.prezime, AVG(tr.trajanje) AS prosjecno_trajanje
FROM trener t
JOIN trening tr ON t.id = tr.id_trenera
GROUP BY t.id, t.ime, t.prezime;

SELECT * 
FROM prosjecno_trajanje_po_treneru
ORDER BY prosjecno_trajanje DESC
LIMIT 1;

-- 4. Članovi koji su išli i na individualne i na grupne treninge
SELECT DISTINCT c.id, c.ime, c.prezime
FROM clan c
WHERE c.id IN (SELECT id_clana FROM trening)
  AND c.id IN (SELECT id_clana FROM prisutnost);

-- 5. Treneri koji vode i grupne i individualne treninge
SELECT t.id, t.ime, t.prezime
FROM trener t
WHERE EXISTS (
    SELECT 1 FROM trening tr WHERE tr.id_trenera = t.id
) AND EXISTS (
    SELECT 1 FROM grupni_trening gt WHERE gt.id_trenera = t.id
);

-- 6. Treninzi koje vodi trener izvan svoje specijalizacije
DROP VIEW IF EXISTS treninzi_izvan_specijalizacije;
CREATE VIEW treninzi_izvan_specijalizacije AS
SELECT t.id AS trening_id, tr.ime, tr.prezime, t.tip_treninga, tr.specijalizacija, t.datum
FROM trening t
JOIN trener tr ON t.id_trenera = tr.id
WHERE t.tip_treninga NOT LIKE CONCAT('%', TRIM(LEADING ' ' FROM LOWER(SUBSTRING_INDEX(tr.specijalizacija, ' ', 1))), '%');

SELECT * FROM treninzi_izvan_specijalizacije;

-- 7. Mjesečni broj treninga i prosječno trajanje
DROP VIEW IF EXISTS mjesecna_statistika_treninga;
CREATE VIEW mjesecna_statistika_treninga AS
SELECT 
    YEAR(datum) AS godina,
    MONTH(datum) AS mjesec,
    COUNT(*) AS broj_treninga,
    ROUND(AVG(trajanje), 1) AS prosjecno_trajanje
FROM trening
GROUP BY godina, mjesec;

SELECT * 
FROM mjesecna_statistika_treninga
ORDER BY godina, mjesec;