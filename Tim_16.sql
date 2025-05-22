-- Brisanje baze podataka ako već postoji (za clean slate pri testiranju)
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

-- Podaci za članove
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
('Ana', 'Anić', 'Funkcionalni trening', 'ana.anic@example.com', '0948889999');

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
(1, 1, 'Kondicijski', '2025-05-10', '10:00:00', 60),
(2, 2, 'Rehabilitacijski', '2025-05-11', '15:00:00', 45),
(3, 3, 'Bodybuilding', '2025-05-12', '18:00:00', 90),
(4, 4, 'Funkcionalni', '2025-05-13', '17:00:00', 75);

-- ======================
-- GRUPNI TRENINZI I PRISUTNOST - marko_aleksic
-- ======================

-- Tablica: grupni_trening
CREATE TABLE grupni_trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_trenera INT,
    max_clanova INT CHECK (max_clanova > 0),
    dan_u_tjednu ENUM('Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja'),
    vrijeme TIME DEFAULT '18:00:00',
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
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id),
    UNIQUE (id_clana, id_grupnog_treninga, datum)
);

-- Podaci za prisutnost
INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum) VALUES
(1, 1, '2025-05-05'),
(2, 2, '2025-05-07'),
(3, 3, '2025-05-09'),
(4, 4, '2025-05-06');

-- Pogledi - marko_aleksic

CREATE VIEW pregled_grupnih_treninga AS
SELECT 
    gt.id AS trening_id,
    gt.naziv,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    gt.dan_u_tjednu,
    gt.vrijeme,
    gt.max_clanova
FROM grupni_trening gt
JOIN trener t ON gt.id_trenera = t.id;

CREATE VIEW popunjenost_grupnih_treninga AS
SELECT 
    gt.id AS trening_id,
    gt.naziv,
    gt.dan_u_tjednu,
    gt.vrijeme,
    gt.max_clanova,
    COUNT(p.id_clana) AS prijavljeni,
    CONCAT(ROUND((COUNT(p.id_clana) / gt.max_clanova) * 100, 1), '%') AS popunjenost
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga
GROUP BY gt.id;

CREATE VIEW aktivnost_clanova_grupni AS
SELECT 
    c.id,
    c.ime,
    c.prezime,
    COUNT(*) AS broj_dolazaka
FROM clan c
JOIN prisutnost p ON c.id = p.id_clana
GROUP BY c.id
ORDER BY broj_dolazaka DESC;

CREATE VIEW dolasci_na_treninge_po_danu AS
SELECT 
    gt.dan_u_tjednu,
    COUNT(p.id) AS broj_dolazaka
FROM grupni_trening gt
JOIN prisutnost p ON gt.id = p.id_grupnog_treninga
GROUP BY gt.dan_u_tjednu
ORDER BY FIELD(gt.dan_u_tjednu, 'Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja');

-- ======================
-- Ostatak baze: oprema, rezervacije, plaćanja, osoblje
-- ======================

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
(5, 2, 49.99, '2025-05-01', 'gotovina'),
(6, 3, 69.99, '2025-02-15', 'kartica'),
(7, 1, 29.99, '2025-03-20', 'transfer'),
(8, 2, 49.99, '2025-04-10', 'gotovina'),
(9, 3, 69.99, '2025-05-05', 'kartica'),
(10, 1, 29.99, '2025-01-30', 'transfer');

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

-- Pogled: prihodi po mjesecima
CREATE VIEW prihodi_po_mjesecima AS
SELECT 
    YEAR(datum_uplate) AS godina,
    MONTH(datum_uplate) AS mjesec,
    SUM(iznos) AS ukupni_prihod,
    COUNT(*) AS broj_uplata
FROM placanje
GROUP BY godina, mjesec
ORDER BY godina, mjesec;

-- Pogled: načini plaćanja
CREATE VIEW nacini_placanja AS
SELECT 
    nacin_placanja,
    COUNT(*) AS broj_placanja,
    SUM(iznos) AS ukupni_prihod,
    AVG(iznos) AS prosjecna_uplata
FROM placanje
GROUP BY nacin_placanja;

-- Pogled: najpodmireniji članovi
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

-- Pogled: status članarina
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

-- Pogled: neplaćene članarine
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

-- Pogled: osoblje po ulozi
CREATE VIEW osoblje_pregled AS
SELECT 
    uloga, 
    COUNT(*) AS broj_zaposlenika
FROM osoblje
GROUP BY uloga;
