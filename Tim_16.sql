DROP DATABASE IF EXISTS teretana;
CREATE DATABASE teretana;
USE teretana;

-- Tablica: clanarina
CREATE TABLE clanarina (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tip VARCHAR(50) NOT NULL,
    cijena DECIMAL(6,2) NOT NULL,
    trajanje INT NOT NULL,
    opis TEXT
);

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

INSERT INTO clan (ime, prezime, email, telefon, datum_uclanjenja, id_clanarina) VALUES
('Ana', 'Anić', 'ana.anic@example.com', '0911111111', '2025-01-15', 1),
('Ivan', 'Ivić', 'ivan.ivic@example.com', '0922222222', '2025-02-01', 2),
('Petra', 'Perić', 'petra.peric@example.com', '0933333333', '2025-03-01', 3);

-- Tablica: trener
CREATE TABLE trener (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    specijalizacija VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

INSERT INTO trener (ime, prezime, specijalizacija, email, telefon) VALUES
('Marko', 'Marić', 'Kondicijska priprema', 'marko.maric@example.com', '0914445555'),
('Lana', 'Lukić', 'Rehabilitacija', 'lana.lukic@example.com', '0926667777');

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

INSERT INTO trening (id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje) VALUES
(1, 1, 'Kondicijski', '2025-05-10', '10:00:00', 60),
(2, 2, 'Rehabilitacijski', '2025-05-11', '15:00:00', 45);

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

INSERT INTO grupni_trening (naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme) VALUES
('Pilates', 2, 15, 'Ponedjeljak', '18:00:00'),
('HIIT', 1, 20, 'Srijeda', '19:00:00');

-- Tablica: prisutnost
CREATE TABLE prisutnost (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT,
    id_grupnog_treninga INT,
    datum DATE,
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id)
);

INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum) VALUES
(1, 1, '2025-05-05'),
(2, 2, '2025-05-07');

-- Tablica: oprema
CREATE TABLE oprema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sifra VARCHAR(20) NOT NULL UNIQUE,
    naziv VARCHAR(100),
    datum_nabave DATE,
    stanje VARCHAR(50)
);

INSERT INTO oprema (sifra, naziv, datum_nabave, stanje) VALUES
('SPR-001', 'Bench klupa', '2023-05-01', 'ispravna'),
('SPR-002', 'Traka za trčanje', '2024-01-15', 'u servisu');

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

INSERT INTO rezervacija_opreme (id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka) VALUES
(1, 1, '2025-05-08', '09:00:00', '09:45:00'),
(2, 2, '2025-05-08', '10:00:00', '10:30:00');

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

INSERT INTO placanje (id_clana, id_clanarina, iznos, datum_uplate, nacin_placanja) VALUES
(1, 1, 29.99, '2025-01-15', 'kartica'),
(2, 2, 49.99, '2025-02-01', 'gotovina');

-- Tablica: osoblje
CREATE TABLE osoblje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    uloga VARCHAR(50),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

INSERT INTO osoblje (ime, prezime, uloga, email, telefon) VALUES
('Josip', 'Jurić', 'Recepcionist', 'josip.juric@example.com', '099888999'),
('Maja', 'Majić', 'Voditelj', 'maja.majic@example.com', '098777666');

-- VIEWOVI
CREATE VIEW aktivni_clanovi AS
SELECT c.id, c.ime, c.prezime, cl.tip, cl.cijena, c.datum_uclanjenja
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id;

CREATE VIEW financije AS
SELECT p.id, c.ime, c.prezime, cl.tip, p.iznos, p.datum_uplate, p.nacin_placanja
FROM placanje p
JOIN clan c ON p.id_clana = c.id
JOIN clanarina cl ON p.id_clanarina = cl.id;

CREATE VIEW trener_grupni AS
SELECT t.ime, t.prezime, gt.naziv, gt.dan_u_tjednu, gt.vrijeme
FROM trener t
JOIN grupni_trening gt ON t.id = gt.id_trenera;

CREATE VIEW stanje_opreme AS
SELECT * FROM oprema;

CREATE VIEW rezervacije_opreme AS
SELECT ro.id, c.ime, c.prezime, o.naziv, ro.datum, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka
FROM rezervacija_opreme ro
JOIN clan c ON ro.id_clana = c.id
JOIN oprema o ON ro.id_opreme = o.id;

CREATE VIEW redoviti_clanovi AS
SELECT c.id, c.ime, c.prezime, COUNT(p.id) AS broj_prisutnosti
FROM clan c
JOIN prisutnost p ON c.id = p.id_clana
GROUP BY c.id
HAVING COUNT(p.id) > 1;

CREATE VIEW treninzi_po_treneru AS
SELECT t.ime, t.prezime, COUNT(tr.id) AS broj_treninga
FROM trener t
LEFT JOIN trening tr ON t.id = tr.id_trenera
GROUP BY t.id;

CREATE VIEW statistika_prisutnosti AS
SELECT gt.naziv, COUNT(p.id_clana) AS broj_prisutnih
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga
GROUP BY gt.id;

CREATE VIEW zaposlenici_teretane AS
SELECT * FROM osoblje;

CREATE VIEW neplacene_clanarine AS
SELECT c.id, c.ime, c.prezime
FROM clan c
LEFT JOIN placanje p ON c.id = p.id_clana
WHERE p.id IS NULL;
