-- ========================================
-- SUSTAV ZA UPRAVLJANJE TERETANOM
-- Projekt za kolegij: Baze podataka 1
-- Tim: Projekt16

-- SVE JE WIP, NEPOTREBNI KOMENTARI ĆE BITI IZBRISANI NA FINALNOM COMMITU
-- ========================================

-- Brisanje baze podataka ako već postoji (za clean slate pri testiranju)
DROP DATABASE IF EXISTS teretana;

-- Kreiranje nove baze podataka
CREATE DATABASE teretana;
USE teretana;

-- ========================================
-- MARTINA ILIĆ: ČLANARINA I ČLAN
-- ========================================

-- Tablica: članarina
CREATE TABLE clanarina (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tip VARCHAR(50) NOT NULL,
    cijena DECIMAL(6,2) NOT NULL CHECK (cijena > 0),
    trajanje INT NOT NULL CHECK (trajanje > 0),
    opis TEXT,
    INDEX idx_tip (tip),
    INDEX idx_cijena (cijena)
);

-- Podaci za vrste članarina (Martina Ilić)
INSERT INTO clanarina (tip, cijena, trajanje, opis) VALUES
('Osnovna', 29.99, 30, 'Pristup svim osnovnim spravama'),
('Napredna', 49.99, 30, 'Pristup svim spravama i grupnim treninzima'),
('Premium', 69.99, 30, 'Svi treninzi + privatni ormarić + 1x tjedno individualni trening'),
('Student - Basic', 19.99, 30, 'Osnovni pristup za studente - samo teretana'),
('Student - Plus', 29.99, 30, 'Pristup za studente - teretana + grupni treninzi'),
('Vikend Standard', 24.99, 30, 'Pristup samo vikendom - osnovna oprema'),
('Vikend Premium', 34.99, 30, 'Pristup vikendom - sva oprema + grupni treninzi'),
('Godišnja Standard', 299.99, 365, 'Godišnja članarina s 15% popusta'),
('Godišnja Premium', 399.99, 365, 'Godišnja premium članarina s 20% popusta'),
('Polugodišnja Standard', 179.99, 180, 'Šestomjesečna članarina s 10% popusta'),
('Polugodišnja Premium', 249.99, 180, 'Šestomjesečna premium članarina s 15% popusta'),
('Probna', 9.99, 7, 'Tjedna probna članarina'),
('VIP Mjesečna', 99.99, 30, 'Ekskluzivni pristup + nutricionistički savjeti'),
('VIP Godišnja', 999.99, 365, 'Godišnja VIP članarina s dodatnim pogodnostima'),
('Obiteljska Standard', 89.99, 30, 'Paket za obitelj do 4 člana - osnovni pristup'),
('Obiteljska Premium', 129.99, 30, 'Paket za obitelj do 4 člana - premium pristup');

-- Tablica: član (Martina Ilić)
CREATE TABLE clan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20),
    datum_uclanjenja DATE NOT NULL DEFAULT (CURRENT_DATE),
    id_clanarina INT,
    aktivan BOOLEAN DEFAULT TRUE,
    datum_rodjenja DATE,
    spol ENUM('M', 'Ž') DEFAULT NULL,
    adresa VARCHAR(200),
    grad VARCHAR(50) DEFAULT 'Zagreb',
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_ime_prezime (ime, prezime),
    INDEX idx_email (email),
    CHECK (datum_rodjenja < datum_uclanjenja)
);

-- Podaci za članove (Martina Ilić)
INSERT INTO clan (ime, prezime, email, telefon, datum_uclanjenja, id_clanarina, datum_rodjenja, spol, adresa) VALUES
('Ivana', 'Krpan', 'ivana.krpan@example.com', '0911234567', '2023-06-15', 1, '1995-03-12', 'Ž', 'Ilica 1'),
('Marko', 'Barišić', 'marko.barisic@example.com', '0921231234', '2024-01-10', 2, '1990-08-22', 'M', 'Vukovarska 22'),
('Ana', 'Radić', 'ana.radic@example.com', '0981112222', '2022-12-01', 3, '1988-11-05', 'Ž', 'Savska 33'),
('Petar', 'Kovačević', 'petar.kovacevic@example.com', '0979876543', '2023-08-20', 1, '1992-04-18', 'M', 'Dubrava 44'),
('Luka', 'Grgić', 'luka.grgic@example.com', '0917654321', '2023-02-12', 2, '1994-07-30', 'M', 'Maksimirska 55'),
('Matea', 'Babić', 'matea.babic@example.com', '0929871234', '2024-03-04', 3, '1991-09-14', 'Ž', 'Trešnjevka 66'),
('Tomislav', 'Vuković', 'tomislav.vukovic@example.com', '0982221111', '2023-05-07', 4, '2000-01-25', 'M', 'Studentski dom'),
('Ema', 'Horvat', 'ema.horvat@example.com', '0913334444', '2022-11-18', 2, '1993-12-03', 'Ž', 'Črnomerec 77'),
('Ivana', 'Jurić', 'ivana.juric@example.com', '0971233211', '2024-04-22', 1, '1996-02-28', 'Ž', 'Novi Zagreb 88'),
('Sara', 'Šimić', 'sara.simic@example.com', '0923214567', '2023-07-30', 3, '1989-06-17', 'Ž', 'Stenjevec 99'),
('Josip', 'Mlinarić', 'josip.mlinaric@example.com', '0914567890', '2023-03-15', 2, '1997-10-11', 'M', 'Pešćenica 100'),
('Iva', 'Zadro', 'iva.zadro@example.com', '0921119999', '2022-10-25', 5, '1998-03-21', 'Ž', 'Sesvete 111'),
('Filip', 'Bosanac', 'filip.bosanac@example.com', '0981234567', '2023-09-05', 3, '1987-05-08', 'M', 'Jankomir 122'),
('Martin', 'Perić', 'martin.peric@example.com', '0918887777', '2023-12-19', 6, '1985-08-16', 'M', 'Medvešćak 133'),
('Nikola', 'Šarić', 'nikola.saric@example.com', '0925553333', '2024-02-28', 2, '1999-11-29', 'M', 'Gornji grad 144'),
('Karla', 'Novak', 'karla.novak@example.com', '0971118888', '2023-01-11', 9, '1990-04-13', 'Ž', 'Donji grad 155'),
('Dario', 'Majer', 'dario.majer@example.com', '0912224444', '2024-05-10', 1, '1993-07-07', 'M', 'Špansko 166'),
('Lana', 'Barić', 'lana.baric@example.com', '0924446666', '2023-06-03', 3, '1996-09-19', 'Ž', 'Kajzerica 177'),
('Andrej', 'Lovrić', 'andrej.lovric@example.com', '0989990000', '2023-10-14', 7, '1988-01-02', 'M', 'Utrina 188'),
('Tea', 'Bošnjak', 'tea.bosnjak@example.com', '0917776666', '2022-09-29', 8, '1994-12-24', 'Ž', 'Travno 199'),
('Rita', 'Ketić', 'rita.kettic@example.com', '0920001234', '2023-08-01', 2, '1991-05-15', 'Ž', 'Dugave 200'),
('Tina', 'Trajković', 'tina.trajkovic@example.com', '0910005678', '2023-11-21', 1, '1997-08-09', 'Ž', 'Klara 211'),
('Sandra', 'Skočić', 'sandra.skocic@example.com', '0970009876', '2024-01-15', 3, '1989-10-23', 'Ž', 'Jordanovac 222'),
('Vježbana', 'Žderić', 'vjezbana.zderic@example.com', '0980005555', '2024-03-18', 9, '1986-02-06', 'Ž', 'Volovčica 233'),
('Renata', 'Matošević', 'renata.matosevic@example.com', '0919991234', '2023-04-12', 2, '1992-06-28', 'Ž', 'Remete 244'),
('Domagoj', 'Vlašić', 'domagoj.vlasic@example.com', '0928884567', '2022-12-23', 10, '1995-09-04', 'M', 'Gračani 255'),
('Nika', 'Župan', 'nika.zupan@example.com', '0984567890', '2023-05-29', 1, '1998-11-17', 'Ž', 'Podsljeme 266'),
('Kristijan', 'Orešković', 'kristijan.oreskovic@example.com', '0971239876', '2024-02-05', 2, '1987-03-31', 'M', 'Šestine 277'),
('Lucija', 'Posavec', 'lucija.posavec@example.com', '0916549870', '2023-07-09', 3, '1993-12-12', 'Ž', 'Kustošija 288'),
('Matej', 'Raguž', 'matej.raguz@example.com', '0927418529', '2023-09-17', 4, '2001-05-26', 'M', 'Pantovcak 299'),
('Boris', 'Sokol', 'boris.sokol@example.com', '0912345678', '2024-01-20', 2, '1990-07-14', 'M', 'Vlaška 300'),
('Petra', 'Dujmović', 'petra.dujmovic@example.com', '0923456789', '2023-12-15', 5, '1994-09-22', 'Ž', 'Borongaj 311'),
('Hrvoje', 'Mihalić', 'hrvoje.mihalic@example.com', '0934567890', '2024-02-10', 6, '1988-11-30', 'M', 'Buzin 322'),
('Marina', 'Kralj', 'marina.kralj@example.com', '0945678901', '2023-11-05', 7, '1991-01-18', 'Ž', 'Blato 333'),
('Ivan', 'Tomić', 'ivan.tomic@example.com', '0956789012', '2024-03-25', 9, '1986-04-26', 'M', 'Brezovica 344');

-- ========================================
-- KARLO PERIĆ: TRENER I TRENING
-- ========================================

-- Tablica: trener (Karlo Perić)
CREATE TABLE trener (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    specijalizacija VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    datum_zaposlenja DATE DEFAULT (CURRENT_DATE),
    certifikat VARCHAR(100),
    godine_iskustva INT DEFAULT 0 CHECK (godine_iskustva >= 0),
    aktivan BOOLEAN DEFAULT TRUE,
    INDEX idx_specijalizacija (specijalizacija),
    INDEX idx_ime_prezime_trener (ime, prezime)
);

-- Podaci za trenere (Karlo Perić)
INSERT INTO trener (ime, prezime, specijalizacija, email, telefon, datum_zaposlenja, certifikat, godine_iskustva) VALUES
('Marko', 'Marić', 'Kondicijska priprema', 'marko.maric@teretana.com', '0914445555', '2021-03-15', 'NSCA-CPT', 8),
('Lana', 'Lukić', 'Rehabilitacija', 'lana.lukic@teretana.com', '0926667777', '2020-06-01', 'Fizioterapeut', 10),
('Petar', 'Perović', 'Bodybuilding', 'petar.perovic@teretana.com', '0937778888', '2019-09-10', 'IFBB Pro Card', 12),
('Ana', 'Anić', 'Funkcionalni trening', 'ana.anic@teretana.com', '0948889999', '2022-01-20', 'CrossFit Level 2', 6),
('Filip', 'Maričić', 'Rehabilitacija', 'filip.maricic@teretana.com', '0938140416', '2021-11-05', 'Fizioterapeut', 7),
('Ante', 'Babić', 'Kardio trening', 'ante.babic@teretana.com', '0954704637', '2020-08-12', 'ACE-CPT', 9),
('Tomislav', 'Dominković', 'Kardio trening', 'tomislav.dominković@teretana.com', '0944821369', '2022-04-18', 'NASM-CPT', 5),
('Lucija', 'Šimić', 'Rehabilitacija', 'lucija.simic@teretana.com', '0938035781', '2019-12-01', 'Master Fizioterapije', 11),
('Martina', 'Nevest', 'CrossFit', 'martina.kovac@teretana.com', '0983317492', '2021-07-22', 'CrossFit Level 3', 8),
('Davor', 'Šimić', 'Pilates', 'davor.simic@teretana.com', '0977012538', '2020-02-14', 'Pilates Instructor', 10),
('Nikola', 'Kovač', 'Kardio trening', 'nikola.kovac@teretana.com', '0949105376', '2023-01-10', 'Spinning Instructor', 4),
('Martina', 'Jukić', 'CrossFit', 'martina.jukic@teretana.com', '0989823661', '2021-05-30', 'CrossFit Level 2', 7),
('Lucija', 'Babić', 'Yoga', 'lucija.babic@teretana.com', '0961781794', '2019-10-20', 'RYT 500', 13),
('Martina', 'Kovačić', 'CrossFit', 'martina.kovacic@teretana.com', '0931873048', '2022-03-15', 'CrossFit Level 1', 5),
('Maja', 'Pavić', 'Snaga i izdržljivost', 'maja.pavic@teretana.com', '0952211757', '2020-11-08', 'CSCS', 9),
('Igor', 'Matić', 'Powerlifting', 'igor.matic@teretana.com', '0911122334', '2021-09-01', 'IPF Coach', 8),
('Sanja', 'Vidović', 'Yoga', 'sanja.vidovic@teretana.com', '0922233445', '2020-04-15', 'RYT 200', 10),
('Dino', 'Radić', 'Funkcionalni trening', 'dino.radic@teretana.com', '0933344556', '2022-06-20', 'TRX Instructor', 6);

-- Tablica: trening (Karlo Perić)
CREATE TABLE trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_trenera INT NOT NULL,
    tip_treninga VARCHAR(50) NOT NULL,
    datum DATE NOT NULL,
    vrijeme TIME NOT NULL,
    trajanje INT NOT NULL CHECK (trajanje > 0 AND trajanje <= 180),
    napomena TEXT,
    status ENUM('zakazan', 'održan', 'otkazan') DEFAULT 'zakazan',
    cijena DECIMAL(6,2) DEFAULT 0.00,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_datum (datum),
    INDEX idx_status (status),
    INDEX idx_tip_treninga (tip_treninga)
);

-- Podaci za treninge (Karlo Perić)
INSERT INTO trening (id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje, status, cijena) VALUES
(1, 1, 'Kondicijska priprema', '2025-05-10', '08:00:00', 60, 'održan', 35.00),
(2, 1, 'Kondicijska priprema', '2025-05-13', '09:00:00', 60, 'održan', 35.00),
(3, 1, 'Kondicijska priprema', '2025-05-20', '10:00:00', 60, 'zakazan', 35.00),
(4, 2, 'Rehabilitacija', '2025-05-11', '10:00:00', 45, 'održan', 40.00),
(5, 2, 'Rehabilitacija', '2025-05-18', '15:00:00', 60, 'održan', 50.00),
(6, 2, 'Rehabilitacija', '2025-05-25', '14:00:00', 60, 'zakazan', 50.00),
(1, 3, 'Bodybuilding', '2025-05-12', '11:00:00', 90, 'održan', 45.00),
(2, 3, 'Bodybuilding', '2025-05-19', '13:00:00', 75, 'održan', 40.00),
(5, 3, 'Bodybuilding', '2025-05-26', '12:00:00', 75, 'zakazan', 40.00),
(3, 4, 'Funkcionalni trening', '2025-05-14', '16:00:00', 60, 'održan', 35.00),
(4, 4, 'Funkcionalni trening', '2025-05-21', '17:00:00', 75, 'zakazan', 40.00),
(6, 4, 'Funkcionalni trening', '2025-05-28', '17:30:00', 60, 'zakazan', 35.00),
(7, 5, 'Rehabilitacija', '2025-05-15', '14:00:00', 45, 'održan', 40.00),
(8, 5, 'Rehabilitacija', '2025-05-22', '13:00:00', 60, 'zakazan', 50.00),
(9, 5, 'Rehabilitacija', '2025-05-29', '10:00:00', 60, 'zakazan', 50.00),
(10, 6, 'Kardio trening', '2025-05-16', '08:30:00', 45, 'održan', 30.00),
(11, 6, 'Kardio trening', '2025-05-23', '09:00:00', 60, 'zakazan', 35.00),
(12, 6, 'Kardio trening', '2025-05-30', '07:00:00', 60, 'zakazan', 35.00),
(13, 7, 'Kardio trening', '2025-05-17', '10:30:00', 60, 'održan', 35.00),
(14, 7, 'Kardio trening', '2025-05-24', '11:00:00', 45, 'zakazan', 30.00),
(15, 7, 'Kardio trening', '2025-05-31', '11:30:00', 60, 'zakazan', 35.00),
(16, 8, 'Rehabilitacija', '2025-05-18', '15:00:00', 60, 'održan', 50.00),
(17, 8, 'Rehabilitacija', '2025-05-25', '14:00:00', 45, 'zakazan', 40.00),
(18, 8, 'Rehabilitacija', '2025-06-01', '15:00:00', 60, 'zakazan', 50.00),
(19, 9, 'CrossFit', '2025-05-19', '17:00:00', 75, 'održan', 45.00),
(20, 9, 'CrossFit', '2025-05-26', '18:00:00', 60, 'zakazan', 40.00),
(21, 9, 'CrossFit', '2025-06-02', '18:30:00', 75, 'zakazan', 45.00),
(22, 10, 'Pilates', '2025-05-20', '09:00:00', 45, 'održan', 35.00),
(23, 10, 'Pilates', '2025-05-27', '10:00:00', 60, 'zakazan', 40.00),
(24, 10, 'Pilates', '2025-06-03', '08:30:00', 60, 'zakazan', 40.00),
(25, 11, 'Kardio trening', '2025-05-21', '11:00:00', 45, 'održan', 30.00),
(26, 11, 'Kardio trening', '2025-05-28', '12:00:00', 60, 'zakazan', 35.00),
(27, 11, 'Kardio trening', '2025-06-04', '10:30:00', 60, 'zakazan', 35.00),
(28, 12, 'CrossFit', '2025-05-22', '16:00:00', 60, 'održan', 40.00),
(29, 12, 'CrossFit', '2025-05-29', '17:00:00', 75, 'zakazan', 45.00),
(30, 12, 'CrossFit', '2025-06-05', '17:30:00', 75, 'zakazan', 45.00),
(31, 13, 'Yoga', '2025-05-23', '08:00:00', 45, 'održan', 30.00),
(32, 13, 'Yoga', '2025-05-30', '09:00:00', 60, 'zakazan', 35.00),
(33, 13, 'Yoga', '2025-06-06', '09:30:00', 60, 'zakazan', 35.00),
(1, 16, 'Powerlifting', '2025-05-14', '18:00:00', 90, 'održan', 50.00),
(2, 17, 'Yoga', '2025-05-15', '07:00:00', 60, 'održan', 35.00),
(3, 18, 'Funkcionalni trening', '2025-05-16', '19:00:00', 60, 'održan', 35.00),
(4, 16, 'Powerlifting', '2025-05-17', '17:00:00', 120, 'održan', 60.00),
(5, 1, 'Kondicijska priprema', '2025-05-18', '10:00:00', 45, 'otkazan', 0.00);

-- ========================================
-- MARKO ALEKSIĆ: GRUPNI TRENING I PRISUTNOST
-- ========================================

-- Tablica: grupni_trening (Marko Aleksić)
CREATE TABLE grupni_trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_trenera INT NOT NULL,
    max_clanova INT NOT NULL CHECK (max_clanova > 0 AND max_clanova <= 30),
    dan_u_tjednu ENUM('Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja') NOT NULL,
    vrijeme TIME NOT NULL DEFAULT '18:00:00',
    trajanje INT DEFAULT 60 CHECK (trajanje > 0),
    cijena_po_terminu DECIMAL(5,2) DEFAULT 15.00,
    aktivan BOOLEAN DEFAULT TRUE,
    opis TEXT,
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_dan_vrijeme (dan_u_tjednu, vrijeme),
    UNIQUE KEY uk_trener_dan_vrijeme (id_trenera, dan_u_tjednu, vrijeme)
);

-- Podaci za grupne treninge (Marko Aleksić)
INSERT INTO grupni_trening (naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme, trajanje, cijena_po_terminu, opis) VALUES
('Pilates početnici', 10, 15, 'Ponedjeljak', '18:00:00', 60, 20.00, 'Osnovni Pilates za početnike'),
('HIIT', 1, 20, 'Srijeda', '19:00:00', 45, 15.00, 'Visoko intenzivni intervalni trening'),
('Yoga jutarnja', 13, 12, 'Petak', '07:30:00', 60, 25.00, 'Jutarnja yoga za buđenje tijela'),
('Power Lifting', 16, 10, 'Utorak', '20:00:00', 90, 30.00, 'Trening snage s utezima'),
('Zumba', 17, 25, 'Četvrtak', '18:30:00', 60, 15.00, 'Plesni fitness program'),
('CrossFit početnici', 9, 15, 'Ponedjeljak', '17:00:00', 60, 25.00, 'CrossFit za početnike'),
('Spinning', 11, 20, 'Subota', '10:00:00', 45, 20.00, 'Indoor biciklizam'),
('TRX', 18, 12, 'Srijeda', '17:00:00', 45, 25.00, 'Funkcionalni trening s TRX trakama'),
('Yoga večernja', 17, 15, 'Utorak', '19:00:00', 75, 30.00, 'Opuštajuća večernja yoga'),
('HIIT napredni', 4, 15, 'Petak', '18:00:00', 60, 20.00, 'HIIT za napredne vježbače'),
('Pilates napredni', 10, 12, 'Četvrtak', '17:00:00', 60, 25.00, 'Napredni Pilates'),
('Boxing fitness', 1, 18, 'Subota', '11:00:00', 60, 20.00, 'Fitness boks bez kontakta');

-- Tablica: prisutnost (Marko Aleksić)
CREATE TABLE prisutnost (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_grupnog_treninga INT NOT NULL,
    datum DATE NOT NULL,
    prisutan BOOLEAN DEFAULT TRUE,
    napomena VARCHAR(200),
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_clan_trening_datum (id_clana, id_grupnog_treninga, datum),
    INDEX idx_datum_prisutnost (datum)
);

-- Podaci za prisutnost (Marko Aleksić)
INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum, prisutan) VALUES
(1, 1, '2025-05-05', TRUE),
(2, 2, '2025-05-07', TRUE),
(3, 3, '2025-05-09', TRUE),
(4, 4, '2025-05-06', TRUE),
(5, 5, '2025-05-08', TRUE),
(6, 6, '2025-05-05', TRUE),
(7, 7, '2025-05-10', TRUE),
(8, 8, '2025-05-07', TRUE),
(9, 9, '2025-05-06', TRUE),
(10, 10, '2025-05-09', TRUE),
(11, 1, '2025-05-12', TRUE),
(12, 2, '2025-05-14', TRUE),
(13, 3, '2025-05-16', TRUE),
(14, 4, '2025-05-13', TRUE),
(15, 5, '2025-05-15', TRUE),
(16, 6, '2025-05-12', FALSE),
(17, 7, '2025-05-17', TRUE),
(18, 8, '2025-05-14', TRUE),
(19, 9, '2025-05-13', TRUE),
(20, 10, '2025-05-16', TRUE),
(1, 1, '2025-05-19', TRUE),
(2, 2, '2025-05-21', TRUE),
(3, 3, '2025-05-23', FALSE),
(4, 4, '2025-05-20', TRUE),
(5, 5, '2025-05-22', TRUE),
(21, 6, '2025-05-19', TRUE),
(22, 7, '2025-05-24', TRUE),
(23, 8, '2025-05-21', TRUE),
(24, 9, '2025-05-20', TRUE),
(25, 10, '2025-05-23', TRUE),
(26, 11, '2025-05-08', TRUE),
(27, 12, '2025-05-10', TRUE),
(28, 1, '2025-05-26', TRUE),
(29, 2, '2025-05-28', TRUE),
(30, 3, '2025-05-30', TRUE),
(31, 4, '2025-05-27', TRUE),
(32, 5, '2025-05-29', TRUE),
(33, 6, '2025-05-26', TRUE),
(34, 7, '2025-05-31', TRUE),
(35, 8, '2025-05-28', TRUE),
(1, 11, '2025-05-15', TRUE),
(2, 12, '2025-05-17', TRUE);

-- ========================================
-- VLADAN: OPREMA I REZERVACIJA OPREME
-- ========================================

-- Tablica: oprema (Vladan)
CREATE TABLE oprema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sifra VARCHAR(20) NOT NULL UNIQUE,
    naziv VARCHAR(100) NOT NULL,
    datum_nabave DATE NOT NULL,
    stanje ENUM('ispravna', 'u servisu', 'potrebna zamjena dijela', 'neispravna', 'nova') DEFAULT 'nova',
    vrijednost DECIMAL(8,2) DEFAULT 0.00,
    lokacija VARCHAR(50) DEFAULT 'Glavna dvorana',
    proizvođač VARCHAR(50),
    model VARCHAR(50),
    garancija_do DATE,
    INDEX idx_stanje (stanje),
    INDEX idx_lokacija (lokacija)
);

-- Podaci za opremu (Vladan)
INSERT INTO oprema (sifra, naziv, datum_nabave, stanje, vrijednost, lokacija, proizvođač, model, garancija_do) VALUES
('SPR-001', 'Bench klupa', '2023-05-01', 'ispravna', 1200.00, 'Zona snage', 'TechnoGym', 'Pure Strength', '2025-05-01'),
('SPR-002', 'Traka za trčanje', '2024-01-15', 'u servisu', 3500.00, 'Kardio zona', 'Life Fitness', 'T5', '2026-01-15'),
('SPR-003', 'Set utega 5-50kg', '2023-12-01', 'ispravna', 2000.00, 'Zona slobodnih utega', 'Ivanko', 'Pro Series', '2025-12-01'),
('SPR-004', 'Eliptični trenažer', '2024-02-20', 'ispravna', 2800.00, 'Kardio zona', 'Precor', 'EFX 885', '2026-02-20'),
('SPR-005', 'Sobni bicikl', '2024-03-10', 'ispravna', 1500.00, 'Kardio zona', 'Schwinn', 'IC8', '2026-03-10'),
('SPR-006', 'Veslačka sprava', '2023-11-25', 'potrebna zamjena dijela', 1800.00, 'Kardio zona', 'Concept2', 'Model D', '2025-11-25'),
('SPR-007', 'Multigym sprava', '2022-08-05', 'ispravna', 4500.00, 'Zona snage', 'Life Fitness', 'G7', '2024-08-05'),
('SPR-008', 'Lat pulldown', '2023-09-15', 'ispravna', 2200.00, 'Zona snage', 'Hammer Strength', 'Select', '2025-09-15'),
('SPR-009', 'Leg press', '2023-10-20', 'ispravna', 3000.00, 'Zona snage', 'TechnoGym', 'Pure Strength', '2025-10-20'),
('SPR-010', 'Smith mašina', '2024-01-05', 'nova', 3500.00, 'Zona snage', 'Matrix', 'Magnum', '2026-01-05'),
('SPR-011', 'Set bučica 1-10kg', '2023-07-15', 'ispravna', 500.00, 'Zona slobodnih utega', 'York', 'Rubber Hex', '2025-07-15'),
('SPR-012', 'TRX trake (10 kom)', '2024-02-01', 'ispravna', 800.00, 'Funkcionalna zona', 'TRX', 'Pro4', '2026-02-01'),
('SPR-013', 'Kettlebell set', '2023-06-10', 'ispravna', 600.00, 'Funkcionalna zona', 'Rogue', 'E-Coat', '2025-06-10'),
('SPR-014', 'Battle rope', '2023-08-20', 'ispravna', 300.00, 'Funkcionalna zona', 'Power Systems', '40ft', NULL),
('SPR-015', 'Medicinske lopte', '2023-09-01', 'ispravna', 400.00, 'Funkcionalna zona', 'Dynamax', 'Elite', NULL),
('SPR-016', 'Ab roller', '2024-03-15', 'nova', 150.00, 'Funkcionalna zona', 'Perfect Fitness', 'Pro', '2025-03-15'),
('SPR-017', 'Stairmaster', '2023-12-10', 'ispravna', 4000.00, 'Kardio zona', 'StairMaster', 'Gauntlet', '2025-12-10'),
('SPR-018', 'Cable crossover', '2023-11-01', 'ispravna', 5000.00, 'Zona snage', 'Life Fitness', 'Signature', '2025-11-01'),
('SPR-019', 'Leg curl mašina', '2024-01-20', 'nova', 2500.00, 'Zona snage', 'Precor', 'Vitality', '2026-01-20'),
('SPR-020', 'Pec deck', '2023-10-05', 'ispravna', 2300.00, 'Zona snage', 'Cybex', 'Eagle NX', '2025-10-05'),
('SPR-021', 'Assault bike', '2024-02-15', 'nova', 1200.00, 'Kardio zona', 'Assault Fitness', 'AirBike', '2026-02-15'),
('SPR-022', 'Plyo box set', '2023-07-20', 'ispravna', 400.00, 'Funkcionalna zona', 'Rogue', 'Wood Plyo', NULL),
('SPR-023', 'Olimpijska šipka', '2023-08-15', 'ispravna', 350.00, 'Zona slobodnih utega', 'Eleiko', 'Sport Training', '2025-08-15'),
('SPR-024', 'Bumper ploče set', '2023-08-15', 'ispravna', 1000.00, 'Zona slobodnih utega', 'Eleiko', 'Sport Training', '2025-08-15'),
('SPR-025', 'GHD sprava', '2024-01-10', 'nova', 1500.00, 'Funkcionalna zona', 'Rogue', 'Abram GHD', '2026-01-10'),
('SPR-026', 'Rings', '2023-09-20', 'ispravna', 200.00, 'Funkcionalna zona', 'Rogue', 'Wood Rings', NULL),
('SPR-027', 'Sandbags', '2023-10-15', 'ispravna', 300.00, 'Funkcionalna zona', 'Brute Force', 'Athlete', NULL),
('SPR-028', 'Foam roller set', '2024-03-01', 'nova', 250.00, 'Stretching zona', 'TriggerPoint', 'GRID', '2025-03-01'),
('SPR-029', 'Yoga blokovi', '2024-03-01', 'nova', 150.00, 'Yoga studio', 'Manduka', 'Cork Block', NULL),
('SPR-030', 'Spin bike', '2024-02-10', 'nova', 2000.00, 'Spinning studio', 'Keiser', 'M3i', '2026-02-10');

-- Tablica: rezervacija_opreme (Vladan)
CREATE TABLE rezervacija_opreme (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_opreme INT NOT NULL,
    datum DATE NOT NULL,
    vrijeme_pocetka TIME NOT NULL,
    vrijeme_zavrsetka TIME NOT NULL,
    status ENUM('aktivna', 'završena', 'otkazana') DEFAULT 'aktivna',
    napomena TEXT,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_opreme) REFERENCES oprema(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_datum_vrijeme (datum, vrijeme_pocetka),
    CHECK (vrijeme_zavrsetka > vrijeme_pocetka)
);

-- Podaci za rezervacije opreme (Vladan)
INSERT INTO rezervacija_opreme (id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka, status) VALUES
(1, 1, '2025-05-08', '09:00:00', '09:45:00', 'završena'),
(2, 2, '2025-05-08', '10:00:00', '10:30:00', 'završena'),
(3, 3, '2025-05-09', '16:00:00', '17:00:00', 'završena'),
(4, 5, '2025-05-10', '08:30:00', '09:15:00', 'završena'),
(1, 4, '2025-05-10', '12:00:00', '12:45:00', 'završena'),
(5, 7, '2025-05-11', '14:00:00', '15:00:00', 'završena'),
(6, 8, '2025-05-11', '15:30:00', '16:30:00', 'završena'),
(7, 9, '2025-05-12', '09:00:00', '10:00:00', 'završena'),
(8, 10, '2025-05-12', '10:30:00', '11:30:00', 'završena'),
(9, 1, '2025-05-13', '17:00:00', '17:45:00', 'završena'),
(10, 11, '2025-05-13', '18:00:00', '18:30:00', 'završena'),
(11, 12, '2025-05-14', '07:00:00', '07:45:00', 'završena'),
(12, 13, '2025-05-14', '16:00:00', '16:45:00', 'završena'),
(13, 14, '2025-05-15', '11:00:00', '11:30:00', 'završena'),
(14, 15, '2025-05-15', '14:00:00', '14:45:00', 'završena'),
(15, 17, '2025-05-16', '08:00:00', '08:45:00', 'završena'),
(16, 18, '2025-05-16', '19:00:00', '20:00:00', 'završena'),
(17, 19, '2025-05-17', '10:00:00', '11:00:00', 'završena'),
(18, 20, '2025-05-17', '15:00:00', '16:00:00', 'završena'),
(19, 21, '2025-05-18', '09:00:00', '09:45:00', 'završena'),
(20, 3, '2025-05-18', '13:00:00', '14:00:00', 'završena'),
(21, 23, '2025-05-19', '07:30:00', '08:30:00', 'završena'),
(22, 24, '2025-05-19', '08:30:00', '09:30:00', 'završena'),
(23, 25, '2025-05-20', '16:00:00', '17:00:00', 'aktivna'),
(24, 5, '2025-05-20', '17:30:00', '18:15:00', 'aktivna'),
(25, 4, '2025-05-21', '11:00:00', '11:45:00', 'aktivna'),
(26, 30, '2025-05-21', '18:00:00', '19:00:00', 'aktivna'),
(27, 1, '2025-05-22', '06:30:00', '07:30:00', 'aktivna'),
(28, 7, '2025-05-22', '14:00:00', '15:00:00', 'aktivna'),
(29, 9, '2025-05-23', '10:00:00', '11:00:00', 'aktivna'),
(30, 11, '2025-05-23', '15:00:00', '15:30:00', 'aktivna'),
(31, 13, '2025-05-24', '09:00:00', '09:45:00', 'aktivna'),
(32, 16, '2025-05-24', '17:00:00', '17:30:00', 'aktivna'),
(33, 22, '2025-05-25', '08:00:00', '08:45:00', 'aktivna'),
(34, 28, '2025-05-25', '12:00:00', '12:30:00', 'aktivna'),
(35, 29, '2025-05-26', '10:00:00', '10:30:00', 'aktivna');

-- ========================================
-- MARKO KOVAČ: PLAĆANJE I OSOBLJE
-- ========================================

-- Tablica: placanje (Marko Kovač)
CREATE TABLE placanje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_clanarina INT NOT NULL,
    iznos DECIMAL(6,2) NOT NULL CHECK (iznos > 0),
    datum_uplate DATE NOT NULL,
    nacin_placanja ENUM('gotovina', 'kartica', 'transfer', 'PayPal', 'kripto') DEFAULT 'kartica',
    broj_racuna VARCHAR(20) UNIQUE,
    napomena TEXT,
    popust DECIMAL(5,2) DEFAULT 0.00,
    pdv DECIMAL(6,2) GENERATED ALWAYS AS (iznos * 0.25) STORED,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_datum_uplate (datum_uplate),
    INDEX idx_nacin_placanja (nacin_placanja)
);

-- Podaci za plaćanja (Marko Kovač)
INSERT INTO placanje (id_clana, id_clanarina, iznos, datum_uplate, nacin_placanja, broj_racuna, popust) VALUES
(1, 1, 29.99, '2025-01-15', 'kartica', 'R-2025-001', 0.00),
(2, 2, 49.99, '2025-02-01', 'gotovina', 'R-2025-002', 0.00),
(3, 3, 69.99, '2025-03-01', 'kartica', 'R-2025-003', 0.00),
(4, 1, 29.99, '2025-04-15', 'transfer', 'R-2025-004', 0.00),
(5, 2, 49.99, '2025-05-01', 'gotovina', 'R-2025-005', 0.00),
(6, 3, 62.99, '2025-02-15', 'kartica', 'R-2025-006', 10.00),
(7, 4, 17.99, '2025-03-20', 'transfer', 'R-2025-007', 10.00),
(8, 2, 49.99, '2025-04-10', 'gotovina', 'R-2025-008', 0.00),
(9, 3, 69.99, '2025-05-05', 'kartica', 'R-2025-009', 0.00),
(10, 1, 29.99, '2025-01-30', 'transfer', 'R-2025-010', 0.00),
(11, 2, 44.99, '2025-02-20', 'PayPal', 'R-2025-011', 10.00),
(12, 5, 24.99, '2025-03-15', 'kartica', 'R-2025-012', 0.00),
(13, 3, 69.99, '2025-04-01', 'transfer', 'R-2025-013', 0.00),
(14, 6, 299.99, '2025-01-01', 'kartica', 'R-2025-014', 0.00),
(15, 2, 49.99, '2025-02-28', 'gotovina', 'R-2025-015', 0.00),
(16, 9, 89.99, '2025-03-10', 'kartica', 'R-2025-016', 10.00),
(17, 1, 29.99, '2025-04-20', 'transfer', 'R-2025-017', 0.00),
(18, 3, 69.99, '2025-05-10', 'PayPal', 'R-2025-018', 0.00),
(19, 4, 19.99, '2025-01-25', 'kartica', 'R-2025-019', 0.00),
(20, 5, 24.99, '2025-02-15', 'gotovina', 'R-2025-020', 0.00),
(21, 2, 49.99, '2025-03-05', 'transfer', 'R-2025-021', 0.00),
(22, 1, 29.99, '2025-04-12', 'kartica', 'R-2025-022', 0.00),
(23, 3, 55.99, '2025-05-08', 'gotovina', 'R-2025-023', 20.00),
(24, 7, 179.99, '2025-02-10', 'kartica', 'R-2025-024', 0.00),
(25, 8, 9.99, '2025-03-25', 'PayPal', 'R-2025-025', 0.00),
(26, 10, 89.99, '2025-04-05', 'transfer', 'R-2025-026', 0.00),
(27, 1, 29.99, '2025-05-15', 'kartica', 'R-2025-027', 0.00),
(28, 2, 49.99, '2025-01-20', 'gotovina', 'R-2025-028', 0.00),
(29, 3, 69.99, '2025-02-25', 'kartica', 'R-2025-029', 0.00),
(30, 4, 19.99, '2025-03-30', 'transfer', 'R-2025-030', 0.00),
(31, 2, 39.99, '2025-04-25', 'PayPal', 'R-2025-031', 20.00),
(32, 5, 24.99, '2025-05-12', 'kartica', 'R-2025-032', 0.00),
(33, 6, 269.99, '2025-02-05', 'transfer', 'R-2025-033', 10.00),
(34, 7, 179.99, '2025-03-18', 'kartica', 'R-2025-034', 0.00),
(35, 9, 99.99, '2025-04-22', 'gotovina', 'R-2025-035', 0.00),
(1, 1, 29.99, '2025-02-15', 'kartica', 'R-2025-036', 0.00),
(1, 1, 29.99, '2025-03-15', 'kartica', 'R-2025-037', 0.00),
(1, 1, 29.99, '2025-04-15', 'kartica', 'R-2025-038', 0.00),
(2, 2, 49.99, '2025-03-01', 'gotovina', 'R-2025-039', 0.00),
(2, 2, 49.99, '2025-04-01', 'gotovina', 'R-2025-040', 0.00);

-- Tablica: osoblje (Marko Kovač)
CREATE TABLE osoblje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    uloga ENUM('Recepcionist', 'Voditelj', 'Čistačica', 'Održavanje', 'Administrator', 'Nutricionist') NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    datum_zaposlenja DATE DEFAULT (CURRENT_DATE),
    placa DECIMAL(7,2),
    radno_vrijeme VARCHAR(50),
    aktivan BOOLEAN DEFAULT TRUE,
    INDEX idx_uloga (uloga),
    INDEX idx_aktivan (aktivan)
);

-- Podaci za osoblje - prošireno (Marko Kovač)
INSERT INTO osoblje (ime, prezime, uloga, email, telefon, datum_zaposlenja, placa, radno_vrijeme) VALUES
('Josip', 'Jurić', 'Recepcionist', 'josip.juric@teretana.com', '099888999', '2020-01-15', 700.00, '06:00-14:00'),
('Maja', 'Majić', 'Voditelj', 'maja.majic@teretana.com', '098777666', '2019-03-01', 1200.00, '09:00-17:00'),
('Ana', 'Horvat', 'Recepcionist', 'ana.horvat@teretana.com', '097666555', '2021-06-10', 700.00, '14:00-22:00'),
('Petar', 'Petrović', 'Održavanje', 'petar.petrovic@teretana.com', '096555444', '2020-09-20', 800.00, '08:00-16:00'),
('Ivana', 'Ivanović', 'Čistačica', 'ivana.ivanovic@teretana.com', '095444333', '2021-02-15', 600.00, '06:00-14:00'),
('Marko', 'Marković', 'Administrator', 'marko.markovic@teretana.com', '094333222', '2019-05-01', 1000.00, '09:00-17:00'),
('Lucija', 'Lučić', 'Nutricionist', 'lucija.lucic@teretana.com', '093222111', '2022-01-10', 900.00, '10:00-18:00'),
('Tomislav', 'Tomić', 'Recepcionist', 'tomislav.tomic@teretana.com', '092111000', '2022-08-15', 700.00, '22:00-06:00'),
('Petra', 'Petrić', 'Čistačica', 'petra.petric@teretana.com', '091000999', '2021-11-01', 600.00, '14:00-22:00'),
('Ante', 'Antić', 'Održavanje', 'ante.antic@teretana.com', '099123456', '2020-04-20', 800.00, '16:00-00:00'),
('Marina', 'Marinović', 'Recepcionist', 'marina.marinovic@teretana.com', '098234567', '2023-01-15', 700.00, '06:00-14:00'),
('Dario', 'Darić', 'Administrator', 'dario.daric@teretana.com', '097345678', '2021-07-01', 1000.00, '09:00-17:00'),
('Kristina', 'Kristić', 'Voditelj', 'kristina.kristic@teretana.com', '096456789', '2020-03-10', 1200.00, '12:00-20:00'),
('Ivan', 'Ivanić', 'Održavanje', 'ivan.ivanic@teretana.com', '095567890', '2022-05-20', 800.00, '08:00-16:00'),
('Ema', 'Emić', 'Čistačica', 'ema.emic@teretana.com', '094678901', '2023-02-01', 600.00, '06:00-14:00');


-- ========================================
-- POGLEDI (VIEWS) - Po 2 za svakog člana tima
-- ========================================

-- MARTINA ILIĆ: Pogledi za članove i članarine

-- Pogled 1: Pregled aktivnih članova s tipom članarine (Martina Ilić)
CREATE OR REPLACE VIEW aktivni_clanovi_clanarine AS
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS puno_ime,
    c.email,
    c.telefon,
    cl.tip AS tip_clanarine,
    cl.cijena,
    c.datum_uclanjenja,
    DATEDIFF(CURRENT_DATE, c.datum_uclanjenja) AS dana_clanstva
FROM clan c
INNER JOIN clanarina cl ON c.id_clanarina = cl.id
WHERE c.aktivan = TRUE
ORDER BY c.datum_uclanjenja DESC;

-- Pogled 2: Statistika članarina po tipu (Martina Ilić)
CREATE OR REPLACE VIEW statistika_clanarina AS
SELECT 
    cl.tip,
    cl.cijena,
    COUNT(c.id) AS broj_clanova,
    COUNT(c.id) * cl.cijena AS potencijalni_mjesecni_prihod,
    ROUND(COUNT(c.id) * 100.0 / (SELECT COUNT(*) FROM clan WHERE aktivan = TRUE), 2) AS postotak_clanova
FROM clanarina cl
LEFT JOIN clan c ON cl.id = c.id_clanarina AND c.aktivan = TRUE
GROUP BY cl.id, cl.tip, cl.cijena
ORDER BY broj_clanova DESC;

-- KARLO PERIĆ: Pogledi za trenere i treninge

-- Pogled 3: Pregled trenera s brojem treninga (Karlo Perić)
CREATE OR REPLACE VIEW treneri_statistika AS
SELECT 
    t.id,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    t.specijalizacija,
    t.godine_iskustva,
    COUNT(DISTINCT tr.id) AS ukupno_individualnih,
    COUNT(DISTINCT gt.id) AS ukupno_grupnih,
    COALESCE(SUM(tr.trajanje), 0) AS ukupno_minuta_individualnih,
    COALESCE(SUM(tr.cijena), 0) AS ukupni_prihod_individualni
FROM trener t
LEFT JOIN trening tr ON t.id = tr.id_trenera AND tr.status = 'održan'
LEFT JOIN grupni_trening gt ON t.id = gt.id_trenera
WHERE t.aktivan = TRUE
GROUP BY t.id;

-- Pogled 4: Raspored treninga po danima (Karlo Perić)
CREATE OR REPLACE VIEW raspored_treninga AS
SELECT 
    tr.datum,
    tr.vrijeme,
    tr.tip_treninga,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    tr.trajanje,
    tr.status
FROM trening tr
JOIN clan c ON tr.id_clana = c.id
JOIN trener t ON tr.id_trenera = t.id
WHERE tr.datum >= CURRENT_DATE
ORDER BY tr.datum, tr.vrijeme;

-- MARKO ALEKSIĆ: Pogledi za grupne treninge i prisutnost

-- Pogled 5: Popunjenost grupnih treninga (Marko Aleksić)
CREATE OR REPLACE VIEW popunjenost_grupnih_treninga AS
SELECT 
    gt.id AS trening_id,
    gt.naziv,
    gt.dan_u_tjednu,
    gt.vrijeme,
    gt.max_clanova,
    COUNT(DISTINCT p.id_clana) AS broj_prijavljenih,
    gt.max_clanova - COUNT(DISTINCT p.id_clana) AS slobodnih_mjesta,
    CONCAT(ROUND((COUNT(DISTINCT p.id_clana) / gt.max_clanova) * 100, 1), '%') AS popunjenost,
    CONCAT(t.ime, ' ', t.prezime) AS trener
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
JOIN trener t ON gt.id_trenera = t.id
WHERE gt.aktivan = TRUE
GROUP BY gt.id
ORDER BY popunjenost DESC;

-- Pogled 6: Aktivnost članova na grupnim treninzima (Marko Aleksić)
CREATE OR REPLACE VIEW aktivnost_clanova_grupni AS
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    COUNT(DISTINCT p.id_grupnog_treninga) AS broj_razlicitih_treninga,
    COUNT(p.id) AS ukupno_dolazaka,
    COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS prisutni,
    COUNT(CASE WHEN p.prisutan = FALSE THEN 1 END) AS odsutni,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) * 100.0 / COUNT(p.id), 2) AS postotak_prisutnosti
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN prisutnost p ON c.id = p.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id
HAVING ukupno_dolazaka > 0
ORDER BY ukupno_dolazaka DESC;

-- VLADAN: Pogledi za opremu i rezervacije

-- Pogled 7: Status opreme i učestalost korištenja (Vladan)
CREATE OR REPLACE VIEW status_opreme AS
SELECT 
    o.id,
    o.sifra,
    o.naziv,
    o.stanje,
    o.lokacija,
    o.vrijednost,
    COUNT(ro.id) AS broj_rezervacija,
    COALESCE(MAX(ro.datum), o.datum_nabave) AS zadnje_koristena,
    DATEDIFF(CURRENT_DATE, COALESCE(MAX(ro.datum), o.datum_nabave)) AS dana_od_zadnjeg_koristenja,
    CASE 
        WHEN o.garancija_do IS NOT NULL AND o.garancija_do > CURRENT_DATE 
        THEN CONCAT('Da (još ', DATEDIFF(o.garancija_do, CURRENT_DATE), ' dana)')
        ELSE 'Ne'
    END AS pod_garancijom
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
GROUP BY o.id
ORDER BY broj_rezervacija DESC;

-- Pogled 8: Najpopularnija oprema po mjesecima (Vladan)
CREATE OR REPLACE VIEW popularnost_opreme_mjesecno AS
SELECT 
    YEAR(ro.datum) AS godina,
    MONTH(ro.datum) AS mjesec,
    o.naziv AS oprema,
    o.lokacija,
    COUNT(ro.id) AS broj_rezervacija,
    COUNT(DISTINCT ro.id_clana) AS broj_razlicitih_korisnika,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_minuta_koristenja
FROM rezervacija_opreme ro
JOIN oprema o ON ro.id_opreme = o.id
WHERE ro.status != 'otkazana'
GROUP BY godina, mjesec, o.id
ORDER BY godina DESC, mjesec DESC, broj_rezervacija DESC;

-- MARKO KOVAČ: Pogledi za plaćanja i osoblje

-- Pogled 9: Financijski pregled po mjesecima (Marko Kovač)
CREATE OR REPLACE VIEW financijski_pregled AS
SELECT 
    YEAR(p.datum_uplate) AS godina,
    MONTH(p.datum_uplate) AS mjesec,
    COUNT(DISTINCT p.id_clana) AS broj_platioca,
    COUNT(p.id) AS broj_transakcija,
    SUM(p.iznos) AS ukupni_prihod,
    SUM(p.popust) AS ukupni_popusti,
    SUM(p.pdv) AS ukupni_pdv,
    AVG(p.iznos) AS prosjecna_uplata,
    GROUP_CONCAT(DISTINCT p.nacin_placanja) AS nacini_placanja
FROM placanje p
GROUP BY godina, mjesec
ORDER BY godina DESC, mjesec DESC;

-- Pogled 10: Pregled osoblja po ulogama (Marko Kovač)
CREATE OR REPLACE VIEW pregled_osoblja AS
SELECT 
    o.uloga,
    COUNT(*) AS broj_zaposlenika,
    AVG(o.placa) AS prosjecna_placa,
    MIN(o.placa) AS minimalna_placa,
    MAX(o.placa) AS maksimalna_placa,
    SUM(o.placa) AS ukupni_troskovi_placa,
    GROUP_CONCAT(CONCAT(o.ime, ' ', o.prezime) ORDER BY o.prezime SEPARATOR ', ') AS zaposlenici
FROM osoblje o
WHERE o.aktivan = TRUE
GROUP BY o.uloga
ORDER BY ukupni_troskovi_placa DESC;

-- ========================================
-- SLOŽENI UPITI - 10 upita
-- ========================================

-- UPIT 1: Top 5 članova po ukupnoj potrošnji (uključuje članarine i treninge)
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    COUNT(DISTINCT p.id) AS broj_uplata_clanarine,
    COALESCE(SUM(p.iznos), 0) AS ukupno_clanarine,
    COUNT(DISTINCT t.id) AS broj_treninga,
    COALESCE(SUM(t.cijena), 0) AS ukupno_treninga,
    COALESCE(SUM(p.iznos), 0) + COALESCE(SUM(t.cijena), 0) AS ukupna_potrosnja
FROM clan c
LEFT JOIN placanje p ON c.id = p.id_clana
LEFT JOIN trening t ON c.id = t.id_clana AND t.status = 'održan'
GROUP BY c.id
ORDER BY ukupna_potrosnja DESC
LIMIT 5;

-- UPIT 2: Analiza korištenja teretane po satima
SELECT 
    HOUR(vrijeme) AS sat,
    COUNT(*) AS ukupno_aktivnosti,
    SUM(CASE WHEN tip = 'trening' THEN 1 ELSE 0 END) AS individualni_treninzi,
    SUM(CASE WHEN tip = 'grupni' THEN 1 ELSE 0 END) AS grupni_treninzi,
    SUM(CASE WHEN tip = 'rezervacija' THEN 1 ELSE 0 END) AS rezervacije_opreme
FROM (
    SELECT vrijeme, 'trening' AS tip FROM trening WHERE status = 'održan'
    UNION ALL
    SELECT vrijeme, 'grupni' AS tip FROM grupni_trening WHERE aktivan = TRUE
    UNION ALL
    SELECT vrijeme_pocetka AS vrijeme, 'rezervacija' AS tip FROM rezervacija_opreme WHERE status != 'otkazana'
) AS sve_aktivnosti
GROUP BY sat
ORDER BY sat;

-- UPIT 3: Treneri s najboljim omjerom individualnih i grupnih treninga
WITH trener_stats AS (
    SELECT 
        t.id,
        CONCAT(t.ime, ' ', t.prezime) AS trener,
        t.specijalizacija,
        COUNT(DISTINCT tr.id) AS individualni,
        COUNT(DISTINCT gt.id) * 4 AS grupni_mjesecno,
        COALESCE(AVG(tr.cijena), 0) AS prosjecna_cijena_individualnog
    FROM trener t
    LEFT JOIN trening tr ON t.id = tr.id_trenera AND tr.status = 'održan'
    LEFT JOIN grupni_trening gt ON t.id = gt.id_trenera
    WHERE t.aktivan = TRUE
    GROUP BY t.id
)
SELECT 
    *,
    individualni + grupni_mjesecno AS ukupno_treninga,
    ROUND(individualni * 100.0 / NULLIF(individualni + grupni_mjesecno, 0), 2) AS postotak_individualnih
FROM trener_stats
WHERE individualni + grupni_mjesecno > 0
ORDER BY ukupno_treninga DESC;

-- UPIT 4: Analiza profitabilnosti članarina
SELECT 
    cl.tip AS tip_clanarine,
    cl.cijena AS osnovna_cijena,
    COUNT(DISTINCT c.id) AS broj_clanova,
    COUNT(p.id) AS broj_uplata,
    SUM(p.iznos) AS stvarni_prihod,
    SUM(p.popust) AS dati_popusti,
    AVG(p.iznos) AS prosjecna_naplata,
    ROUND(AVG(p.iznos) * 100.0 / cl.cijena, 2) AS postotak_naplate
FROM clanarina cl
LEFT JOIN clan c ON cl.id = c.id_clanarina
LEFT JOIN placanje p ON cl.id = p.id_clanarina
GROUP BY cl.id
ORDER BY stvarni_prihod DESC;

-- UPIT 5: Članovi koji koriste sve usluge (individualni, grupni, oprema)
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    COUNT(DISTINCT t.id) AS broj_individualnih,
    COUNT(DISTINCT p.id_grupnog_treninga) AS broj_grupnih,
    COUNT(DISTINCT r.id_opreme) AS broj_razlicite_opreme,
    'Da' AS koristi_sve_usluge
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
JOIN trening t ON c.id = t.id_clana
JOIN prisutnost p ON c.id = p.id_clana
JOIN rezervacija_opreme r ON c.id = r.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id
HAVING broj_individualnih > 0 AND broj_grupnih > 0 AND broj_razlicite_opreme > 0
ORDER BY broj_individualnih + broj_grupnih DESC;

-- UPIT 6: Oprema koja zahtijeva održavanje (stara ili često korištena)
SELECT 
    o.sifra,
    o.naziv,
    o.stanje,
    o.datum_nabave,
    DATEDIFF(CURRENT_DATE, o.datum_nabave) AS starost_dana,
    COUNT(r.id) AS broj_koristenja_30_dana,
    CASE 
        WHEN o.stanje IN ('u servisu', 'potrebna zamjena dijela', 'neispravna') THEN 'Hitno'
        WHEN DATEDIFF(CURRENT_DATE, o.datum_nabave) > 730 THEN 'Pregled potreban'
        WHEN COUNT(r.id) > 50 THEN 'Često korištena - pregled'
        ELSE 'OK'
    END AS preporuka_odrzavanja
FROM oprema o
LEFT JOIN rezervacija_opreme r ON o.id = r.id_opreme 
    AND r.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY o.id
HAVING preporuka_odrzavanja != 'OK'
ORDER BY 
    FIELD(preporuka_odrzavanja, 'Hitno', 'Često korištena - pregled', 'Pregled potreban');

-- UPIT 7: Analiza dolazaka po danima u tjednu
SELECT 
    dan,
    COUNT(*) AS ukupno_aktivnosti,
    AVG(broj_po_danu) AS prosjek_po_tom_danu
FROM (
    SELECT DAYNAME(datum) AS dan, DATE(datum) AS datum_aktivnosti, COUNT(*) AS broj_po_danu
    FROM (
        SELECT datum FROM trening WHERE status = 'održan'
        UNION ALL
        SELECT datum FROM prisutnost WHERE prisutan = TRUE
        UNION ALL
        SELECT datum FROM rezervacija_opreme WHERE status != 'otkazana'
    ) AS sve_aktivnosti
    GROUP BY datum_aktivnosti
) AS po_danima
GROUP BY dan
ORDER BY FIELD(dan, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- UPIT 8: ROI (Return on Investment) za opremu
SELECT 
    o.naziv,
    o.vrijednost AS investicija,
    COUNT(DISTINCT r.id_clana) AS jedinstvenih_korisnika,
    COUNT(r.id) AS ukupno_koristenja,
    SUM(TIMESTAMPDIFF(HOUR, r.vrijeme_pocetka, r.vrijeme_zavrsetka)) AS sati_koristenja,
    ROUND(o.vrijednost / NULLIF(COUNT(r.id), 0), 2) AS trosak_po_koristenju,
    ROUND(COUNT(r.id) * 5.0, 2) AS procijenjeni_prihod,
    ROUND((COUNT(r.id) * 5.0 - o.vrijednost) / NULLIF(o.vrijednost, 0) * 100, 2) AS roi_postotak
FROM oprema o
LEFT JOIN rezervacija_opreme r ON o.id = r.id_opreme
WHERE o.vrijednost > 0
GROUP BY o.id
ORDER BY roi_postotak DESC;

-- UPIT 9: Pregled neaktivnih članova (nisu imali aktivnosti u zadnjih 30 dana)
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    c.email,
    c.telefon,
    cl.tip AS tip_clanarine,
    COALESCE(zadnji_trening.datum, 'Nikad') AS zadnji_individualni,
    COALESCE(zadnja_prisutnost.datum, 'Nikad') AS zadnji_grupni,
    COALESCE(zadnja_rezervacija.datum, 'Nikad') AS zadnja_oprema
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN (
    SELECT id_clana, MAX(datum) AS datum 
    FROM trening 
    WHERE status = 'održan'
    GROUP BY id_clana
) AS zadnji_trening ON c.id = zadnji_trening.id_clana
LEFT JOIN (
    SELECT id_clana, MAX(datum) AS datum 
    FROM prisutnost 
    WHERE prisutan = TRUE
    GROUP BY id_clana
) AS zadnja_prisutnost ON c.id = zadnja_prisutnost.id_clana
LEFT JOIN (
    SELECT id_clana, MAX(datum) AS datum 
    FROM rezervacija_opreme 
    WHERE status != 'otkazana'
    GROUP BY id_clana
) AS zadnja_rezervacija ON c.id = zadnja_rezervacija.id_clana
WHERE c.aktivan = TRUE
    AND (zadnji_trening.datum IS NULL OR zadnji_trening.datum < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY))
    AND (zadnja_prisutnost.datum IS NULL OR zadnja_prisutnost.datum < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY))
    AND (zadnja_rezervacija.datum IS NULL OR zadnja_rezervacija.datum < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY))
ORDER BY c.datum_uclanjenja;

-- UPIT 10: Kompleksna statistika teretane - mjesečni dashboard
SELECT 
    MONTHNAME(CURRENT_DATE) AS mjesec,
    YEAR(CURRENT_DATE) AS godina,
    (SELECT COUNT(*) FROM clan WHERE aktivan = TRUE) AS aktivni_clanovi,
    (SELECT COUNT(*) FROM clan WHERE MONTH(datum_uclanjenja) = MONTH(CURRENT_DATE)) AS novi_clanovi_ovaj_mjesec,
    (SELECT COUNT(*) FROM trening WHERE MONTH(datum) = MONTH(CURRENT_DATE) AND status = 'održan') AS odrzani_treninzi,
    (SELECT COUNT(DISTINCT id_clana) FROM prisutnost WHERE MONTH(datum) = MONTH(CURRENT_DATE)) AS clanovi_na_grupnim,
    (SELECT SUM(iznos) FROM placanje WHERE MONTH(datum_uplate) = MONTH(CURRENT_DATE)) AS prihod_ovaj_mjesec,
    (SELECT COUNT(*) FROM oprema WHERE stanje != 'ispravna') AS oprema_za_servis,
    (SELECT AVG(postotak_masti) FROM mjerenja WHERE MONTH(datum) = MONTH(CURRENT_DATE)) AS prosjecni_postotak_masti,
    (SELECT COUNT(*) FROM osoblje WHERE aktivan = TRUE) AS broj_zaposlenika;

-- ========================================
-- DODATNI POGLEDI I FUNKCIONALNOSTI
-- ========================================

-- Pogled za praćenje trendova članstva
CREATE OR REPLACE VIEW trend_clanstva AS
SELECT 
    DATE_FORMAT(datum_uclanjenja, '%Y-%m') AS mjesec,
    COUNT(*) AS novi_clanovi,
    SUM(COUNT(*)) OVER (ORDER BY DATE_FORMAT(datum_uclanjenja, '%Y-%m')) AS kumulativno_clanstvo
FROM clan
GROUP BY mjesec
ORDER BY mjesec;

-- Pogled za analizu vremena vršnog opterećenja
CREATE OR REPLACE VIEW vrsno_opterecenje AS
SELECT 
    HOUR(vrijeme) AS sat,
    DAYNAME(datum) AS dan,
    COUNT(*) AS broj_aktivnosti,
    CASE 
        WHEN COUNT(*) > 20 THEN 'Vrlo visoko'
        WHEN COUNT(*) > 15 THEN 'Visoko'
        WHEN COUNT(*) > 10 THEN 'Umjereno'
        ELSE 'Nisko'
    END AS razina_opterecenja
FROM (
    SELECT datum, vrijeme FROM trening WHERE status != 'otkazana'
    UNION ALL
    SELECT p.datum, gt.vrijeme 
    FROM prisutnost p 
    JOIN grupni_trening gt ON p.id_grupnog_treninga = gt.id
    WHERE p.prisutan = TRUE
) AS sve_aktivnosti
GROUP BY sat, dan
ORDER BY broj_aktivnosti DESC;

-- Kompleksni pogled za analizu korištenja opreme i učinkovitosti trenera
CREATE OR REPLACE VIEW oprema_trener_ucinkovitost AS
WITH oprema_statistika AS (
    SELECT 
        o.id AS oprema_id,
        o.naziv,
        o.lokacija,
        COUNT(DISTINCT r.id_clana) AS broj_korisnika,
        COUNT(r.id) AS broj_rezervacija,
        AVG(TIMESTAMPDIFF(MINUTE, r.vrijeme_pocetka, r.vrijeme_zavrsetka)) AS prosjecno_trajanje,
        o.vrijednost / NULLIF(COUNT(r.id), 0) AS trosak_po_koristenju
    FROM oprema o
    LEFT JOIN rezervacija_opreme r ON o.id = r.id_opreme AND r.status != 'otkazana'
    GROUP BY o.id
),
trener_rezultati AS (
    SELECT 
        t.id AS trener_id,
        t.ime,
        t.prezime,
        t.specijalizacija,
        COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
        COUNT(tr.id) AS broj_treninga,
        AVG(tr.cijena) AS prosjecna_cijena,
        COUNT(DISTINCT gt.id) AS broj_grupnih_programa,
        (
            SELECT COUNT(DISTINCT m2.id_clana)
            FROM mjerenja m1
            JOIN mjerenja m2 ON m1.id_clana = m2.id_clana AND m1.datum < m2.datum
            JOIN trening tr2 ON tr2.id_clana = m1.id_clana AND tr2.id_trenera = t.id
            WHERE m2.tezina < m1.tezina
            AND m1.datum BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
        ) AS klijenati_smanjili_tezinu
    FROM trener t
    LEFT JOIN trening tr ON t.id = tr.id_trenera AND tr.status = 'održan'
    LEFT JOIN grupni_trening gt ON t.id = gt.id_trenera
    GROUP BY t.id
)
SELECT 
    tr.ime,
    tr.prezime,
    tr.specijalizacija,
    tr.broj_klijenata,
    tr.broj_treninga,
    tr.prosjecna_cijena,
    tr.broj_grupnih_programa,
    tr.klijenati_smanjili_tezinu,
    ROUND(
        (tr.broj_klijenata * 0.3 + 
         tr.broj_treninga * 0.2 + 
         tr.broj_grupnih_programa * 0.2 + 
         tr.klijenati_smanjili_tezinu * 0.3) * 10, 2
    ) AS ocjena_ucinkovitosti,
    (
        SELECT GROUP_CONCAT(DISTINCT o.naziv)
        FROM trening t2
        JOIN rezervacija_opreme r ON r.id_clana = t2.id_clana 
        AND r.datum = t2.datum
        JOIN oprema o ON r.id_opreme = o.id
        WHERE t2.id_trenera = tr.trener_id
        GROUP BY t2.id_trenera
    ) AS najcesce_koristena_oprema
FROM trener_rezultati tr
ORDER BY ocjena_ucinkovitosti DESC;

-- ========================================
-- TESTNI UPITI ZA PROVJERU FUNKCIONALNOSTI
-- ========================================

-- Prikaz sadržaja svih tablica
SELECT 'ČLANARINE' AS tablica, COUNT(*) AS broj_zapisa FROM clanarina
UNION SELECT 'ČLANOVI', COUNT(*) FROM clan
UNION SELECT 'TRENERI', COUNT(*) FROM trener
UNION SELECT 'TRENINZI', COUNT(*) FROM trening
UNION SELECT 'GRUPNI TRENINZI', COUNT(*) FROM grupni_trening
UNION SELECT 'PRISUTNOST', COUNT(*) FROM prisutnost
UNION SELECT 'OPREMA', COUNT(*) FROM oprema
UNION SELECT 'REZERVACIJE', COUNT(*) FROM rezervacija_opreme
UNION SELECT 'PLAĆANJA', COUNT(*) FROM placanje
UNION SELECT 'OSOBLJE', COUNT(*) FROM osoblje
