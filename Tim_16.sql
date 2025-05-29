-- Brisanje baze podataka ako već postoji
DROP DATABASE IF EXISTS teretana;
CREATE DATABASE teretana;
USE teretana;

-- ========================================
-- ČLANARINA I ČLAN
-- ========================================

CREATE TABLE clanarina (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tip VARCHAR(50) NOT NULL UNIQUE,
    cijena DECIMAL(6,2) NOT NULL CHECK (cijena >= 0),
    trajanje INT NOT NULL CHECK (trajanje > 0),
    opis TEXT
);

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
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================
-- TRENER I TIPOVI TRENINGA
-- ========================================

CREATE TABLE trener (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    specijalizacija VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    datum_zaposlenja DATE DEFAULT (CURRENT_DATE),
    godine_iskustva INT DEFAULT 0,
    aktivan BOOLEAN DEFAULT TRUE
);

-- NOVA TABLICA: Tipovi treninga (3NF)
CREATE TABLE tip_treninga (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE,
    osnovna_cijena DECIMAL(6,2) NOT NULL CHECK (osnovna_cijena >= 0),
    opis TEXT
);

CREATE TABLE trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_trenera INT NOT NULL,
    id_tip_treninga INT NOT NULL,
    datum DATE NOT NULL,
    vrijeme TIME NOT NULL,
    trajanje INT NOT NULL CHECK (trajanje > 0 AND trajanje <= 180),
    napomena TEXT,
    status ENUM('zakazan', 'održan', 'otkazan') DEFAULT 'zakazan',
    cijena DECIMAL(6,2),
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_tip_treninga) REFERENCES tip_treninga(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ========================================
-- GRUPNI TRENING I PRISUTNOST
-- ========================================

CREATE TABLE grupni_trening (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_trenera INT NOT NULL,
    max_clanova INT NOT NULL CHECK (max_clanova > 0 AND max_clanova <= 30),
    dan_u_tjednu ENUM('Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja') NOT NULL,
    vrijeme TIME NOT NULL DEFAULT '18:00:00',
    trajanje INT DEFAULT 60 CHECK (trajanje > 0),
    cijena_po_terminu DECIMAL(5,2) NOT NULL CHECK (cijena_po_terminu > 0),
    aktivan BOOLEAN DEFAULT TRUE,
    opis TEXT,
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE prisutnost (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_grupnog_treninga INT NOT NULL,
    datum DATE NOT NULL,
    prisutan BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ========================================
-- OPREMA I REZERVACIJE
-- ========================================

CREATE TABLE oprema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sifra VARCHAR(20) NOT NULL UNIQUE,
    naziv VARCHAR(100) NOT NULL,
    datum_nabave DATE NOT NULL,
    stanje ENUM('ispravna', 'u servisu', 'potrebna zamjena dijela', 'neispravna', 'nova') DEFAULT 'nova',
    vrijednost DECIMAL(8,2) DEFAULT 0.00,
    proizvodac VARCHAR(50),
    model VARCHAR(50),
    garancija_do DATE
);

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
    CHECK (vrijeme_zavrsetka > vrijeme_pocetka)
);

-- ========================================
-- OSOBLJE I PLAĆANJA
-- ========================================

CREATE TABLE osoblje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    uloga ENUM('Recepcionist', 'Voditelj', 'Čistačica', 'Održavanje', 'Administrator', 'Nutricionist') NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    datum_zaposlenja DATE DEFAULT (CURRENT_DATE),
    radno_vrijeme VARCHAR(50),
    aktivan BOOLEAN DEFAULT TRUE
);

CREATE TABLE placanje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    iznos DECIMAL(6,2) NOT NULL CHECK (iznos >= 0),
    datum_uplate DATE NOT NULL,
    nacin_placanja ENUM('gotovina', 'kartica', 'transfer', 'PayPal', 'kripto') DEFAULT 'kartica',
    broj_racuna VARCHAR(20) UNIQUE,
    popust DECIMAL(5,2) DEFAULT 0.00 CHECK (popust >= 0 AND popust <= 100),
    id_osoblje INT NOT NULL,
    opis TEXT,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_osoblje) REFERENCES osoblje(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- Podaci za vrste članarina (Martina Ilić)
INSERT INTO clanarina (tip, cijena, trajanje, opis) VALUES
('Osnovna', 29.99, 30, 'Pristup svim osnovnim spravama'),
('Napredna', 49.99, 30, 'Pristup svim spravama i grupnim treninzima'),
('Premium', 69.99, 30, 'Svi treninzi + 1x tjedno individualni trening'),
('Student - Basic', 19.99, 30, 'Osnovni pristup za studente - samo teretana'),
('Student - Plus', 29.99, 30, 'Pristup za studente - teretana + grupni treninzi'),
('Godišnja Standard', 299.99, 365, 'Godišnja članarina s 15% popusta'),
('Godišnja Premium', 399.99, 365, 'Godišnja premium članarina s 20% popusta');

-- Podaci za članove (Martina Ilić)
INSERT INTO clan (ime, prezime, email, telefon, datum_uclanjenja, id_clanarina, datum_rodjenja, spol, adresa, grad) VALUES
('Ivana', 'Krpan', 'ivana.krpan@example.com', '0911234567', '2023-05-15', 1, '1995-03-12', 'Ž', 'Ilica 1', 'Zagreb'),
('Marko', 'Barišić', 'marko.barisic@example.com', '0921231234', '2024-01-10', 2, '1990-08-22', 'M', 'Vukovarska 22', 'Zagreb'),
('Ana', 'Radić', 'ana.radic@example.com', '0981112222', '2022-12-01', 3, '1988-11-05', 'Ž', 'Savska 33', 'Zagreb'),
('Petar', 'Kovačević', 'petar.kovacevic@example.com', '0979876543', '2023-08-20', 1, '1992-04-18', 'M', 'Dubrava 44', 'Zagreb'),
('Luka', 'Grgić', 'luka.grgic@example.com', '0917654321', '2023-02-12', 2, '1994-07-30', 'M', 'Maksimirska 55', 'Zagreb'),
('Matea', 'Babić', 'matea.babic@example.com', '0929871234', '2024-03-04', 3, '1991-09-14', 'Ž', 'Trešnjevka 66', 'Zagreb'),
('Tomislav', 'Vuković', 'tomislav.vukovic@example.com', '0982221111', '2023-05-07', 4, '2000-01-25', 'M', 'Studentski dom', 'Zagreb'),
('Maja', 'Horvat', 'maja.horvat@example.com', '0913334444', '2023-11-03', 5, '1997-12-08', 'Ž', 'Heinzelova 10', 'Zagreb'),
('Filip', 'Novak', 'filip.novak@example.com', '0924445555', '2024-02-18', 1, '1993-06-21', 'M', 'Jarunska 25', 'Zagreb'),
('Kristina', 'Marić', 'kristina.maric@example.com', '0985556666', '2023-09-14', 6, '1989-02-14', 'Ž', 'Britanski trg 5', 'Zagreb'),
('Dario', 'Petković', 'dario.petkovic@example.com', '0976667777', '2022-07-22', 2, '1996-10-03', 'M', 'Savska 50', 'Zagreb'),
('Petra', 'Jukić', 'petra.jukic@example.com', '0918889999', '2024-05-11', 7, '1985-05-17', 'Ž', 'Gajeva 15', 'Zagreb'),
('Ivan', 'Čović', 'ivan.covic@example.com', '0931111000', '2023-03-25', 3, '1991-01-29', 'M', 'Palmotićeva 30', 'Zagreb'),
('Ema', 'Matić', 'ema.matic@example.com', '0942222111', '2024-04-08', 4, '1999-08-11', 'Ž', 'Frankopanska 8', 'Zagreb'),
('Dominik', 'Šimić', 'dominik.simic@example.com', '0953333222', '2023-01-16', 5, '1987-11-26', 'M', 'Ilica 150', 'Zagreb'),
('Sara', 'Božić', 'sara.bozic@example.com', '0964444333', '2022-10-30', 1, '1994-04-07', 'Ž', 'Radnička 40', 'Zagreb'),
('Matej', 'Pavić', 'matej.pavic@example.com', '0975555444', '2024-06-12', 6, '1998-07-19', 'M', 'Kaptol 20', 'Zagreb'),
('Lucija', 'Dragić', 'lucija.dragic@example.com', '0986666555', '2023-12-07', 2, '1990-12-01', 'Ž', 'Miramarska 100', 'Zagreb'),
('Antonio', 'Blažević', 'antonio.blazevic@example.com', '0917777666', '2022-05-19', 3, '1995-09-13', 'M', 'Amruševa 5', 'Zagreb'),
('Nikolina', 'Katić', 'nikolina.katic@example.com', '0928888777', '2024-01-24', 6, '1986-03-05', 'Ž', 'Tratinska 25', 'Zagreb'),
('Josip', 'Mandić', 'josip.mandic@example.com', '0939999888', '2023-07-11', 7, '1992-10-20', 'M', 'Heinzelova 70', 'Zagreb'),
('Petra', 'Cvitković', 'petra.cvitkovic@example.com', '0940000999', '2022-11-28', 1, '1988-01-16', 'Ž', 'Jurišićeva 12', 'Zagreb'),
('Mateo', 'Rašić', 'mateo.rasic@example.com', '0951111222', '2024-03-17', 4, '1997-06-28', 'M', 'Deželićeva 60', 'Zagreb'),
('Laura', 'Tomić', 'laura.tomic@example.com', '0962222333', '2023-04-14', 5, '1993-11-11', 'Ž', 'Nova Ves 10', 'Zagreb'),
('Bruno', 'Galić', 'bruno.galic@example.com', '0973333444', '2022-08-05', 3, '1989-05-23', 'M', 'Rooseveltov trg 6', 'Zagreb'),
('Valentina', 'Lukić', 'valentina.lukic@example.com', '0984444555', '2024-02-29', 2, '1996-08-09', 'Ž', 'Bogovićeva 3', 'Zagreb'),
('Hrvoje', 'Milošević', 'hrvoje.milosevic@example.com', '0915555666', '2023-10-21', 3, '1984-12-17', 'M', 'Klaićeva 18', 'Zagreb'),
('Tea', 'Perić', 'tea.peric@example.com', '0926666777', '2022-06-13', 6, '1998-02-28', 'Ž', 'Šubićeva 29', 'Zagreb'),
('Domagoj', 'Barbarić', 'domagoj.barbaric@example.com', '0987777888', '2024-05-02', 7, '1991-07-04', 'M', 'Radićeva 50', 'Zagreb'),
('Klara', 'Rukavina', 'klara.rukavina@example.com', '0948888999', '2023-09-08', 1, '1995-10-15', 'Ž', 'Marulićev trg 14', 'Zagreb'),
('Nikola', 'Đurić', 'nikola.djuric@example.com', '0959999000', '2022-12-16', 4, '1987-04-02', 'M', 'Zrinjevac 8', 'Zagreb'),
('Dora', 'Stanić', 'dora.stanic@example.com', '0960000111', '2024-07-23', 5, '1999-01-07', 'Ž', 'Teslina 12', 'Zagreb'),
('Vedran', 'Antić', 'vedran.antic@example.com', '0971111333', '2023-05-30', 5, '1990-09-22', 'M', 'Draškovićeva 45', 'Zagreb'),
('Anja', 'Filipović', 'anja.filipovic@example.com', '0982222444', '2022-04-06', 2, '1994-06-12', 'Ž', 'Petrinjska 35', 'Zagreb'),
('Marko', 'Zadravec', 'marko.zadravec@example.com', '0993333555', '2024-08-14', 3, '1988-03-25', 'M', 'Varsavska 20', 'Zagreb'),
('Nina', 'Bošnjak', 'nina.bosnjak@example.com', '0914444666', '2023-01-27', 6, '1997-11-08', 'Ž', 'Vlaška 80', 'Zagreb'),
('Marin', 'Crnković', 'marin.crnkovic@example.com', '0925555777', '2022-09-12', 7, '1985-08-14', 'M', 'Masarykova 15', 'Zagreb'),
('Ivona', 'Mihaljević', 'ivona.mihaljevic@example.com', '0986666888', '2024-06-20', 1, '1996-12-03', 'Ž', 'Praška 25', 'Zagreb'),
('Stipe', 'Lovrić', 'stipe.lovric@example.com', '0947777999', '2023-11-15', 4, '1992-02-19', 'M', 'Runjaninova 10', 'Zagreb'),
('Lana', 'Ježić', 'lana.jezic@example.com', '0958888111', '2022-03-09', 5, '1989-07-31', 'Ž', 'Ribnjak 5', 'Zagreb'),
('David', 'Petrić', 'david.petric@example.com', '0969999222', '2024-04-25', 4, '1998-05-06', 'M', 'Demetrova 22', 'Zagreb'),
('Tina', 'Knežević', 'tina.knezevic@example.com', '0911010101', '2024-05-20', 2, '1992-05-10', 'Ž', 'Horvaćanska 12', 'Zagreb'),
('Mario', 'Šarić', 'mario.saric@example.com', '0922020202', '2024-06-01', 3, '1987-09-23', 'M', 'Vrbik 8', 'Zagreb'),
('Ivana', 'Barić', 'ivana.baric@example.com', '0933030303', '2024-06-15', 1, '1995-12-30', 'Ž', 'Selska 77', 'Zagreb'),
('Krešimir', 'Jurić', 'kresimir.juric@example.com', '0944040404', '2024-07-01', 4, '1990-03-18', 'M', 'Vlaška 12', 'Zagreb'),
('Martina', 'Petrović', 'martina.petrovic@example.com', '0955050505', '2024-07-10', 5, '1998-11-11', 'Ž', 'Kranjčevićeva 5', 'Zagreb'),
('Dino', 'Lovrić', 'dino.lovric@example.com', '0966060606', '2024-07-20', 6, '1993-04-04', 'M', 'Medveščak 9', 'Zagreb'),
('Petra', 'Vidić', 'petra.vidic@example.com', '0977070707', '2024-08-01', 7, '1997-07-07', 'Ž', 'Kneza Mislava 3', 'Zagreb'),
('Filip', 'Babić', 'filip.babic@example.com', '0988080808', '2024-08-10', 2, '1991-10-10', 'M', 'Kralja Držislava 2', 'Zagreb'),
('Lea', 'Mikulić', 'lea.mikulic@example.com', '0999090909', '2024-08-15', 1, '1996-02-02', 'Ž', 'Palmotićeva 18', 'Zagreb');


-- Podaci za trenere (Karlo Perić)
INSERT INTO trener (ime, prezime, specijalizacija, email, telefon, datum_zaposlenja, godine_iskustva) VALUES
('Ivan', 'Perić', 'Kondicijski trener / Snaga', 'ivan.peric@teretana.com', '0911001001', '2022-01-10', 7),
('Marija', 'Jurić', 'Rehabilitacija / Funkcionalni trening', 'marija.juric@teretana.com', '0911001002', '2021-09-15', 5),
('Ana', 'Knežević', 'Pilates / Yoga', 'ana.knezevic@teretana.com', '0911001004', '2022-06-20', 6),
('Luka', 'Novak', 'HIIT / CrossFit', 'luka.novak@teretana.com', '0911001005', '2023-01-12', 4),
('Maja', 'Grgić', 'Spinning / Kardio', 'maja.grgic@teretana.com', '0911001006', '2022-11-05', 8),
('Tomislav', 'Vuković', 'Zumba / Grupni treninzi', 'tomislav.vukovic@teretana.com', '0911001007', '2021-12-10', 3);

-- DODAVANJE TIPOVA TRENINGA 
INSERT INTO tip_treninga (naziv, osnovna_cijena, opis) VALUES
('Kondicijski', 20.00, 'Osnovni kondicijski trening'),
('Rehabilitacija', 25.00, 'Rehabilitacijski i terapeutski trening'),
('Bodybuilding', 30.00, 'Trening za povećanje mišićne mase'),
('Funkcionalni', 22.00, 'Funkcionalni trening za svakodnevne aktivnosti'),
('Kardio', 18.00, 'Kardiovaskularni trening'),
('CrossFit', 28.00, 'Visoko intenzivni CrossFit trening'),
('Pilates', 20.00, 'Pilates za fleksibilnost i snagu'),
('Yoga', 22.00, 'Yoga za opuštanje i fleksibilnost'),
('Snaga', 30.00, 'Trening snage s utezima'),
('Powerlifting', 35.00, 'Specifičan powerlifting trening');



-- Podaci za treninge (Karlo Perić)
INSERT INTO trening (id_clana, id_trenera, id_tip_treninga, datum, vrijeme, trajanje, status, cijena) VALUES
(1, 1, 1, '2025-05-05', '09:00:00', 60, 'održan', 20.00),  
(2, 2, 2, '2025-05-05', '10:30:00', 45, 'održan', 25.00), 
(3, 3, 3, '2025-05-06', '11:00:00', 90, 'održan', 30.00),  
(4, 4, 4, '2025-05-06', '12:00:00', 60, 'zakazan', 22.00), 
(5, 5, 2, '2025-05-07', '13:00:00', 45, 'održan', 25.00), 
(6, 6, 5, '2025-05-07', '14:00:00', 60, 'održan', 18.00),  
(7, 1, 5, '2025-05-08', '15:00:00', 60, 'održan', 18.00),  
(1, 2, 2, '2025-05-08', '16:00:00', 45, 'održan', 25.00),  
(2, 3, 6, '2025-05-09', '17:00:00', 60, 'zakazan', 28.00), 
(3, 4, 7, '2025-05-09', '18:00:00', 60, 'održan', 20.00),  
(4, 5, 5, '2025-05-10', '09:00:00', 45, 'održan', 18.00),  
(5, 6, 6, '2025-05-10', '10:00:00', 60, 'održan', 28.00),  
(6, 1, 8, '2025-05-11', '11:00:00', 60, 'održan', 22.00), 
(7, 2, 6, '2025-05-11', '12:00:00', 60, 'zakazan', 28.00),
(1, 3, 9, '2025-05-12', '13:00:00', 75, 'održan', 30.00),
(3, 5, 8, '2025-05-13', '15:00:00', 60, 'održan', 22.00),  
(4, 6, 4, '2025-05-13',  '16:00:00', 60, 'održan', 22.00),
(5, 1, 1, '2025-05-14', '17:00:00', 60, 'zakazan', 20.00),
(6, 2, 2, '2025-05-14', '18:00:00', 45, 'održan', 25.00); 


-- Podaci za grupne treninge (Marko Aleksić)
INSERT INTO grupni_trening (naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme, trajanje, cijena_po_terminu, opis) VALUES
('Pilates', 3, 12, 'Ponedjeljak', '18:00:00', 60, 25.00, 'Pilates za sve razine'),
('HIIT', 4, 15, 'Utorak', '19:00:00', 45, 20.00, 'Visoko intenzivni intervalni trening'),
('Spinning', 5, 15, 'Srijeda', '18:30:00', 45, 20.00, 'Indoor biciklizam'),
('Yoga', 3, 10, 'Četvrtak', '18:00:00', 60, 25.00, 'Yoga za fleksibilnost i opuštanje'),
('CrossFit', 4, 12, 'Petak', '19:00:00', 60, 25.00, 'Funkcionalni fitness'),
('Zumba', 6, 20, 'Subota', '10:00:00', 60, 15.00, 'Plesni fitness program'),
('Snaga & Kondicija', 1, 10, 'Subota', '11:30:00', 75, 30.00, 'Trening snage s utezima'),
('Kardio Mix', 5, 15, 'Nedjelja', '10:00:00', 45, 15.00, 'Kombinacija kardio vježbi');


-- Podaci za prisutnost (Marko Aleksić)
INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum, prisutan) VALUES
-- Tjedan 1
(1, 1, '2025-05-05', TRUE), (2, 1, '2025-05-05', TRUE), (3, 1, '2025-05-05', TRUE), (4, 1, '2025-05-05', FALSE), (5, 1, '2025-05-05', TRUE),
(6, 2, '2025-05-06', TRUE), (7, 2, '2025-05-06', TRUE), (8, 2, '2025-05-06', TRUE), (9, 2, '2025-05-06', FALSE), (10, 2, '2025-05-06', TRUE),
(11, 3, '2025-05-07', TRUE), (12, 3, '2025-05-07', TRUE), (13, 3, '2025-05-07', TRUE), (14, 3, '2025-05-07', FALSE), (15, 3, '2025-05-07', TRUE),
(16, 4, '2025-05-08', TRUE), (17, 4, '2025-05-08', TRUE), (18, 4, '2025-05-08', TRUE), (19, 4, '2025-05-08', FALSE), (20, 4, '2025-05-08', TRUE),
(21, 5, '2025-05-09', TRUE), (22, 5, '2025-05-09', TRUE), (23, 5, '2025-05-09', TRUE), (24, 5, '2025-05-09', FALSE), (25, 5, '2025-05-09', TRUE),
(26, 6, '2025-05-10', TRUE), (27, 6, '2025-05-10', TRUE), (28, 6, '2025-05-10', TRUE), (29, 6, '2025-05-10', FALSE), (30, 6, '2025-05-10', TRUE),
(31, 7, '2025-05-10', TRUE), (32, 7, '2025-05-10', TRUE), (33, 7, '2025-05-10', TRUE), (34, 7, '2025-05-10', FALSE), (35, 7, '2025-05-10', TRUE),
(36, 8, '2025-05-11', TRUE), (37, 8, '2025-05-11', TRUE), (38, 8, '2025-05-11', TRUE), (39, 8, '2025-05-11', FALSE), (40, 8, '2025-05-11', TRUE),

-- Tjedan 2
(1, 1, '2025-05-12', TRUE), (2, 1, '2025-05-12', TRUE), (3, 1, '2025-05-12', TRUE), (4, 1, '2025-05-12', TRUE), (5, 1, '2025-05-12', FALSE),
(6, 2, '2025-05-13', TRUE), (7, 2, '2025-05-13', TRUE), (8, 2, '2025-05-13', TRUE), (9, 2, '2025-05-13', TRUE), (10, 2, '2025-05-13', FALSE),
(11, 3, '2025-05-14', TRUE), (12, 3, '2025-05-14', TRUE), (13, 3, '2025-05-14', TRUE), (14, 3, '2025-05-14', TRUE), (15, 3, '2025-05-14', FALSE),
(16, 4, '2025-05-15', TRUE), (17, 4, '2025-05-15', TRUE), (18, 4, '2025-05-15', TRUE), (19, 4, '2025-05-15', TRUE), (20, 4, '2025-05-15', FALSE),
(21, 5, '2025-05-16', TRUE), (22, 5, '2025-05-16', TRUE), (23, 5, '2025-05-16', TRUE), (24, 5, '2025-05-16', TRUE), (25, 5, '2025-05-16', FALSE),
(26, 6, '2025-05-17', TRUE), (27, 6, '2025-05-17', TRUE), (28, 6, '2025-05-17', TRUE), (29, 6, '2025-05-17', TRUE), (30, 6, '2025-05-17', FALSE),
(31, 7, '2025-05-17', TRUE), (32, 7, '2025-05-17', TRUE), (33, 7, '2025-05-17', TRUE), (34, 7, '2025-05-17', TRUE), (35, 7, '2025-05-17', FALSE),
(36, 8, '2025-05-18', TRUE), (37, 8, '2025-05-18', TRUE), (38, 8, '2025-05-18', TRUE), (39, 8, '2025-05-18', TRUE), (40, 8, '2025-05-18', FALSE),

-- Tjedan 3
(41, 1, '2025-05-19', TRUE), (42, 1, '2025-05-19', TRUE), (43, 1, '2025-05-19', TRUE), (44, 1, '2025-05-19', TRUE), (45, 1, '2025-05-19', FALSE),
(46, 2, '2025-05-20', TRUE), (47, 2, '2025-05-20', TRUE), (48, 2, '2025-05-20', TRUE), (49, 2, '2025-05-20', TRUE), (50, 2, '2025-05-20', FALSE),
(41, 3, '2025-05-21', TRUE), (42, 3, '2025-05-21', TRUE), (43, 3, '2025-05-21', TRUE), (44, 3, '2025-05-21', TRUE), (45, 3, '2025-05-21', FALSE),
(46, 4, '2025-05-22', TRUE), (47, 4, '2025-05-22', TRUE), (48, 4, '2025-05-22', TRUE), (49, 4, '2025-05-22', TRUE), (50, 4, '2025-05-22', FALSE),
(41, 5, '2025-05-23', TRUE), (42, 5, '2025-05-23', TRUE), (43, 5, '2025-05-23', TRUE), (44, 5, '2025-05-23', TRUE), (45, 5, '2025-05-23', FALSE),
(46, 6, '2025-05-24', TRUE), (47, 6, '2025-05-24', TRUE), (48, 6, '2025-05-24', TRUE), (49, 6, '2025-05-24', TRUE), (50, 6, '2025-05-24', FALSE),
(41, 7, '2025-05-24', TRUE), (42, 7, '2025-05-24', TRUE), (43, 7, '2025-05-24', TRUE), (44, 7, '2025-05-24', TRUE), (45, 7, '2025-05-24', FALSE),
(46, 8, '2025-05-25', TRUE), (47, 8, '2025-05-25', TRUE), (48, 8, '2025-05-25', TRUE), (49, 8, '2025-05-25', TRUE), (50, 8, '2025-05-25', FALSE);



-- Podaci za opremu (Vladan)
INSERT INTO oprema (sifra, naziv, datum_nabave, stanje, vrijednost, proizvodac, model, garancija_do) VALUES
('OPR-001', 'Klupa za potiskivanje', '2022-01-15', 'ispravna', 3500.00, 'Technogym', 'BenchPro 2021', '2025-01-15'),
('OPR-002', 'Traka za trčanje', '2023-03-10', 'ispravna', 4200.00, 'Life Fitness', 'RunX 500', '2026-03-10'),
('OPR-003', 'Set bučica', '2021-09-05', 'ispravna', 1500.00, 'Reebok', 'Hex Set', '2024-09-05'),
('OPR-004', 'Veslački trenažer', '2022-06-20', 'ispravna', 2800.00, 'Concept2', 'Model D', '2025-06-20'),
('OPR-005', 'Stalak za čučnjeve', '2020-11-12', 'potrebna zamjena dijela', 3200.00, 'Hammer Strength', 'PowerRack', '2023-11-12'),
('OPR-006', 'Sobni bicikl', '2023-02-01', 'ispravna', 2100.00, 'Schwinn', 'IC7', '2026-02-01'),
('OPR-007', 'Set girja', '2021-07-18', 'ispravna', 900.00, 'Gorilla Sports', 'KB2021', '2024-07-18'),
('OPR-008', 'Sprava za povlačenje odozgo', '2022-04-25', 'ispravna', 2600.00, 'Matrix', 'LatX', '2025-04-25'),
('OPR-009', 'Eliptični trenažer', '2023-05-15', 'ispravna', 3500.00, 'Precor', 'EFX 885', '2026-05-15'),
('OPR-010', 'Smith mašina', '2022-08-30', 'ispravna', 4000.00, 'Gym80', 'SM2022', '2025-08-30'),
('OPR-011', 'TRX sustav', '2023-01-10', 'ispravna', 600.00, 'TRX', 'Pro4', '2026-01-10'),
('OPR-012', 'Medicinske lopte', '2021-10-22', 'ispravna', 500.00, 'Adidas', 'MB2021', '2024-10-22'),
('OPR-013', 'Stepper', '2022-12-05', 'ispravna', 1800.00, 'StairMaster', 'SM5', '2025-12-05'),
('OPR-014', 'Leg press', '2021-05-17', 'ispravna', 3300.00, 'Panatta', 'LP2021', '2024-05-17'),
('OPR-015', 'Šipka za zgibove', '2023-04-12', 'ispravna', 400.00, 'Decathlon', 'PB100', '2026-04-12'),
('OPR-016', 'Kablovski sustav', '2022-09-09', 'ispravna', 3700.00, 'Body-Solid', 'CC2022', '2025-09-09'),
('OPR-017', 'Kotač za trbušnjake', '2021-08-03', 'ispravna', 150.00, 'Nike', 'AR2021', '2024-08-03'),
('OPR-018', 'Uže za treniranje', '2023-03-20', 'ispravna', 250.00, 'Tiguar', 'BR2023', '2026-03-20'),
('OPR-019', 'Sprava za opružanje nogu', '2022-07-14', 'ispravna', 2100.00, 'Impulse', 'LE2022', '2025-07-14'),
('OPR-020', 'Sprava za veslanje u sjedenju', '2021-11-28', 'ispravna', 2300.00, 'Gym80', 'SR2021', '2024-11-28'),
('OPR-021', 'Sprava za prsa', '2023-02-18', 'ispravna', 3400.00, 'Technogym', 'CP2023', '2026-02-18'),
('OPR-022', 'Valjak za masažu', '2022-05-06', 'ispravna', 80.00, 'Blackroll', 'FR2022', '2025-05-06'),
('OPR-023', 'Stanica za propadanja', '2021-12-13', 'ispravna', 350.00, 'Kettler', 'DS2021', '2024-12-13'),
('OPR-024', 'Pliometrijska kutija', '2023-06-01', 'ispravna', 200.00, 'Reebok', 'PBX2023', '2026-06-01'),
('OPR-025', 'Sprava za stražnjicu i bedra', '2022-10-19', 'ispravna', 1200.00, 'Rogue', 'GHD2022', '2025-10-19'),
('OPR-026', 'Spinning bicikl', '2023-01-25', 'ispravna', 2100.00, 'Keiser', 'M3i', '2026-01-25'),
('OPR-027', 'Torba za snagu', '2021-06-11', 'ispravna', 180.00, 'Tiguar', 'PB2021', '2024-06-11'),
('OPR-028', 'Ski trenažer', '2022-03-29', 'ispravna', 2200.00, 'Concept2', 'SkiErg2', '2025-03-29'),
('OPR-029', 'Podloga za istezanje', '2023-05-08', 'ispravna', 60.00, 'Domyos', 'SM2023', '2026-05-08'),
('OPR-030', 'Sprava za hiperektenziju', '2022-11-21', 'ispravna', 1700.00, 'Westside', 'RH2022', '2025-11-21');


-- Podaci za rezervacije opreme (Vladan)
INSERT INTO rezervacija_opreme (id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka, status) VALUES
(1, 1, '2025-05-08', '09:00:00', '09:45:00', 'završena'),
(2, 2, '2025-05-08', '10:00:00', '10:30:00', 'završena'),
(3, 3, '2025-05-09', '16:00:00', '17:00:00', 'završena'),
(4, 4, '2025-05-10', '08:30:00', '09:15:00', 'završena'),
(5, 5, '2025-05-10', '12:00:00', '12:45:00', 'završena'),
(6, 6, '2025-05-11', '14:00:00', '15:00:00', 'završena'),
(7, 7, '2025-05-11', '15:30:00', '16:30:00', 'završena'),
(1, 8, '2025-05-12', '09:00:00', '10:00:00', 'završena'),
(2, 9, '2025-05-12', '10:30:00', '11:30:00', 'završena'),
(3, 10, '2025-05-13', '17:00:00', '17:45:00', 'završena'),
(4, 11, '2025-05-13', '18:00:00', '18:30:00', 'završena'),
(5, 12, '2025-05-14', '07:00:00', '07:45:00', 'završena'),
(6, 13, '2025-05-14', '16:00:00', '16:45:00', 'završena'),
(7, 14, '2025-05-15', '11:00:00', '11:30:00', 'završena'),
(1, 15, '2025-05-15', '14:00:00', '14:45:00', 'završena'),
(2, 16, '2025-05-16', '08:00:00', '08:45:00', 'završena'),
(3, 17, '2025-05-16', '19:00:00', '20:00:00', 'završena'),
(4, 18, '2025-05-17', '10:00:00', '11:00:00', 'završena'),
(5, 19, '2025-05-17', '15:00:00', '16:00:00', 'završena'),
(6, 20, '2025-05-18', '09:00:00', '09:45:00', 'završena'),
(7, 21, '2025-05-18', '13:00:00', '14:00:00', 'završena'),
(8, 22, '2025-05-19', '07:30:00', '08:30:00', 'završena'),
(9, 23, '2025-05-19', '08:30:00', '09:30:00', 'završena'),
(10, 24, '2025-05-20', '16:00:00', '17:00:00', 'aktivna'),
(11, 25, '2025-05-20', '17:30:00', '18:15:00', 'aktivna'),
(12, 26, '2025-05-21', '11:00:00', '11:45:00', 'aktivna'),
(13, 27, '2025-05-21', '18:00:00', '19:00:00', 'aktivna'),
(14, 28, '2025-05-22', '06:30:00', '07:30:00', 'aktivna'),
(15, 29, '2025-05-22', '14:00:00', '15:00:00', 'aktivna'),
(1, 30, '2025-05-23', '10:00:00', '11:00:00', 'aktivna');



-- Podaci za osoblje (Marko Kovač)
INSERT INTO osoblje (ime, prezime, uloga, email, telefon, datum_zaposlenja, radno_vrijeme) VALUES
('Ivana', 'Horvat', 'Recepcionist', 'ivana.horvat@teretana.com', '0911111111', '2022-01-10', '06:00-14:00'),
('Marko', 'Novak', 'Voditelj', 'marko.novak@teretana.com', '0922222222', '2021-03-01', '08:00-16:00'),
('Ana', 'Kovač', 'Čistačica', 'ana.kovac@teretana.com', '0933333333', '2023-05-15', '14:00-22:00'),
('Petar', 'Barišić', 'Održavanje', 'petar.barisic@teretana.com', '0944444444', '2022-09-20', '08:00-16:00'),
('Lucija', 'Jurić', 'Administrator', 'lucija.juric@teretana.com', '0955555555', '2021-12-01', '09:00-17:00'),
('Maja', 'Grgić', 'Nutricionist', 'maja.grgic@teretana.com', '0966666666', '2023-02-10', '10:00-18:00'),
('Tomislav', 'Vuković', 'Recepcionist', 'tomislav.vukovic@teretana.com', '0977777777', '2024-01-15', '14:00-22:00'),
('Martina', 'Babić', 'Čistačica', 'martina.babic@teretana.com', '0988888888', '2022-06-01', '06:00-14:00'),
('Dino', 'Radić', 'Održavanje', 'dino.radic@teretana.com', '0999999999', '2023-03-20', '14:00-22:00'),
('Sanja', 'Vidović', 'Administrator', 'sanja.vidovic@teretana.com', '0910000000', '2022-11-10', '12:00-20:00');


-- Podaci za plaćanja (Marko Kovač)
INSERT INTO placanje (id_clana, iznos, datum_uplate, nacin_placanja, broj_racuna, popust, id_osoblje, opis) VALUES
(1, 29.99, '2025-05-05', 'kartica', 'R-2025-021', 0.00, 1, 'Osnovna članarina'),
(2, 49.99, '2025-05-07', 'gotovina', 'R-2025-022', 0.00, 2, 'Napredna članarina'),
(3, 69.99, '2025-05-09', 'kartica', 'R-2025-023', 0.00, 1, 'Premium članarina'),
(4, 29.99, '2025-05-11', 'transfer', 'R-2025-024', 0.00, 7, 'Osnovna članarina'),
(5, 49.99, '2025-05-12', 'kartica', 'R-2025-025', 0.00, 2, 'Napredna članarina'),
(6, 69.99, '2025-05-14', 'kripto', 'R-2025-026', 0.00, 1, 'Premium članarina'),
(7, 19.99, '2025-05-16', 'PayPal', 'R-2025-027', 0.00, 7, 'Student - Basic članarina'),
(8, 29.99, '2025-05-18', 'kartica', 'R-2025-028', 0.00, 1, 'Student - Plus članarina'),
(9, 299.99, '2025-05-19', 'transfer', 'R-2025-029', 0.00, 2, 'Godišnja Standard članarina'),
(10, 399.99, '2025-05-21', 'gotovina', 'R-2025-030', 0.00, 1, 'Godišnja Premium članarina'),
(11, 0.00, '2025-05-22', 'kartica', 'R-2025-031', 0.00, 7, 'Probna članarina'),
(12, 26.99, '2025-05-24', 'kartica', 'R-2025-032', 10.00, 2, 'Osnovna članarina s popustom'),
(13, 44.99, '2025-05-25', 'PayPal', 'R-2025-033', 10.00, 1, 'Napredna članarina s popustom'),
(14, 69.99, '2025-05-26', 'kripto', 'R-2025-034', 0.00, 7, 'Premium članarina'),
(15, 19.99, '2025-05-27', 'kartica', 'R-2025-035', 0.00, 2, 'Student - Basic članarina'),
(16, 29.99, '2025-05-28', 'gotovina', 'R-2025-036', 0.00, 1, 'Student - Plus članarina'),
(17, 299.99, '2025-05-29', 'transfer', 'R-2025-037', 0.00, 7, 'Godišnja Standard članarina'),
(18, 399.99, '2025-05-14', 'PayPal', 'R-2025-038', 0.00, 2, 'Godišnja Premium članarina'),
(19, 0.00, '2025-05-21', 'kartica', 'R-2025-039', 0.00, 1, 'Probna članarina'),
(20, 29.99, '2025-05-01', 'kartica', 'R-2025-040', 0.00, 7, 'Osnovna članarina'),
(21, 49.99, '2025-05-02', 'gotovina', 'R-2025-041', 0.00, 2, 'Napredna članarina'),
(22, 69.99, '2025-05-03', 'kartica', 'R-2025-042', 0.00, 1, 'Premium članarina'),
(23, 19.99, '2025-05-04', 'transfer', 'R-2025-043', 0.00, 7, 'Student - Basic članarina'),
(24, 29.99, '2025-05-05', 'kripto', 'R-2025-044', 0.00, 2, 'Student - Plus članarina'),
(25, 299.99, '2025-05-05', 'PayPal', 'R-2025-045', 0.00, 1, 'Godišnja Standard članarina'),
(26, 399.99, '2025-05-07', 'kartica', 'R-2025-046', 0.00, 7, 'Godišnja Premium članarina'),
(27, 0.00, '2025-05-08', 'gotovina', 'R-2025-047', 0.00, 2, 'Probna članarina'),
(28, 26.99, '2025-05-09', 'kartica', 'R-2025-048', 10.00, 1, 'Osnovna članarina s popustom'),
(29, 44.99, '2025-05-10', 'transfer', 'R-2025-049', 10.00, 7, 'Napredna članarina s popustom'),
(30, 69.99, '2025-05-11', 'kripto', 'R-2025-050', 0.00, 2, 'Premium članarina');


-- ========================================
-- POGLEDI (VIEWS) - Po 3 za svakog člana tima
-- ========================================

-- ==========================================
-- MARTINA ILIĆ: Pogledi za članove i članarine
-- ==========================================

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
    DATEDIFF(CURRENT_DATE, c.datum_uclanjenja) AS dana_clanstva,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, c.datum_uclanjenja) > cl.trajanje THEN 'Istekla'
        WHEN DATEDIFF(CURRENT_DATE, c.datum_uclanjenja) > (cl.trajanje - 7) THEN 'Uskoro istječe'
        ELSE 'Aktivna'
    END AS status_clanarine
FROM clan c
INNER JOIN clanarina cl ON c.id_clanarina = cl.id
WHERE c.aktivan = TRUE
ORDER BY c.datum_uclanjenja DESC;

-- Pogled 2: Statistika članarina po tipu (Martina Ilić)
CREATE OR REPLACE VIEW statistika_clanarina AS
SELECT 
    cl.tip,
    cl.cijena,
    cl.trajanje,
    COUNT(c.id) AS broj_clanova,
    COUNT(c.id) * cl.cijena AS potencijalni_prihod,
    ROUND(COUNT(c.id) * 100.0 / (SELECT COUNT(*) FROM clan WHERE aktivan = TRUE), 2) AS postotak_clanova,
    CASE 
        WHEN cl.trajanje >= 365 THEN 'Godišnja'
        WHEN cl.trajanje >= 30 THEN 'Mjesečna'
        ELSE 'Kratkotrajna'
    END AS kategorija_trajanja
FROM clanarina cl
LEFT JOIN clan c ON cl.id = c.id_clanarina AND c.aktivan = TRUE
GROUP BY cl.id, cl.tip, cl.cijena, cl.trajanje
ORDER BY broj_clanova DESC;

-- Pogled 3: Pregled članova s demografskim podacima (Martina Ilić)
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
    COUNT(*) AS broj_clanova,
    AVG(cl.cijena) AS prosjecna_cijena
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
WHERE c.aktivan = TRUE AND c.datum_rodjenja IS NOT NULL
GROUP BY c.spol, dobna_skupina, cl.tip
ORDER BY c.spol, dobna_skupina;

-- ==========================================
-- KARLO PERIĆ: Pogledi za trenere, treninge i tipove treninga
-- ==========================================

-- Pogled 4: Pregled trenera s statistikama (Karlo Perić)
CREATE OR REPLACE VIEW treneri_statistika AS
SELECT 
    t.id,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    t.specijalizacija,
    t.godine_iskustva,
    t.email,
    COUNT(DISTINCT tr.id) AS ukupno_individualnih,
    COUNT(DISTINCT gt.id) AS ukupno_grupnih,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END), 0) AS ukupno_minuta,
    COALESCE(AVG(CASE WHEN tr.status = 'održan' THEN tr.cijena END), 0) AS prosjecna_cijena,
    COALESCE(SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END), 0) AS ukupni_prihod
FROM trener t
LEFT JOIN trening tr ON t.id = tr.id_trenera
LEFT JOIN grupni_trening gt ON t.id = gt.id_trenera AND gt.aktivan = TRUE
WHERE t.aktivan = TRUE
GROUP BY t.id, t.ime, t.prezime, t.specijalizacija, t.godine_iskustva, t.email
ORDER BY ukupni_prihod DESC;

-- Pogled 5: Raspored budućih treninga (Karlo Perić)
CREATE OR REPLACE VIEW raspored_budućih_treninga AS
SELECT 
    tr.datum,
    tr.vrijeme,
    tt.naziv AS tip_treninga,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    c.telefon AS telefon_clana,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    tr.trajanje,
    tr.cijena,
    tr.status,
    tr.napomena
FROM trening tr
JOIN clan c ON tr.id_clana = c.id
JOIN trener t ON tr.id_trenera = t.id
JOIN tip_treninga tt ON tr.id_tip_treninga = tt.id
WHERE tr.datum >= CURRENT_DATE
ORDER BY tr.datum, tr.vrijeme;

-- Pogled 6: Analiza tipova treninga (Karlo Perić)
CREATE OR REPLACE VIEW analiza_tipova_treninga AS
SELECT 
    tt.id,
    tt.naziv,
    tt.osnovna_cijena,
    tt.opis,
    COUNT(tr.id) AS broj_treninga,
    COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
    COUNT(DISTINCT tr.id_trenera) AS broj_trenera,
    AVG(tr.cijena) AS prosjecna_naplata,
    SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) AS ukupni_prihod,
    ROUND(AVG(tr.cijena) * 100.0 / tt.osnovna_cijena, 2) AS postotak_naplate
FROM tip_treninga tt
LEFT JOIN trening tr ON tt.id = tr.id_tip_treninga
GROUP BY tt.id, tt.naziv, tt.osnovna_cijena, tt.opis
ORDER BY ukupni_prihod DESC;

-- ==========================================
-- MARKO KOVAČ: Pogledi za osoblje i plaćanja
-- ==========================================

-- Pogled 7: Pregled osoblja po ulogama (Marko Kovač)
CREATE OR REPLACE VIEW pregled_osoblja AS
SELECT 
    o.uloga,
    COUNT(*) AS broj_zaposlenika,
    GROUP_CONCAT(CONCAT(o.ime, ' ', o.prezime) ORDER BY o.prezime SEPARATOR ', ') AS zaposlenici,
    GROUP_CONCAT(DISTINCT o.radno_vrijeme ORDER BY o.radno_vrijeme SEPARATOR ', ') AS radna_vremena,
    COUNT(CASE WHEN o.aktivan = TRUE THEN 1 END) AS aktivni,
    COUNT(CASE WHEN o.aktivan = FALSE THEN 1 END) AS neaktivni
FROM osoblje o
GROUP BY o.uloga
ORDER BY broj_zaposlenika DESC;

-- Pogled 8: Financijski pregled po mjesecima (Marko Kovač)
CREATE OR REPLACE VIEW financijski_pregled AS
SELECT 
    YEAR(p.datum_uplate) AS godina,
    MONTH(p.datum_uplate) AS mjesec,
    COUNT(DISTINCT p.id_clana) AS broj_platioca,
    COUNT(p.id) AS broj_transakcija,
    SUM(p.iznos) AS ukupni_prihod,
    SUM(p.popust) AS ukupni_popusti,
    SUM(p.iznos) - SUM(p.popust) AS neto_prihod,
    AVG(p.iznos) AS prosjecna_uplata,
    MIN(p.iznos) AS najmanja_uplata,
    MAX(p.iznos) AS najveća_uplata
FROM placanje p
GROUP BY godina, mjesec
ORDER BY godina DESC, mjesec DESC;

-- Pogled 9: Analiza tko je izvršio naplatu (Marko Kovač)
CREATE OR REPLACE VIEW analiza_naplata_osoblja AS
SELECT 
    o.ime,
    o.prezime,
    o.uloga,
    COUNT(p.id) AS broj_naplata,
    SUM(p.iznos) AS ukupni_iznos,
    AVG(p.iznos) AS prosjecna_naplata,
    COUNT(DISTINCT p.id_clana) AS broj_klijenata,
    GROUP_CONCAT(DISTINCT p.nacin_placanja ORDER BY p.nacin_placanja SEPARATOR ', ') AS nacini_placanja
FROM placanje p
JOIN osoblje o ON p.id_osoblje = o.id
WHERE o.aktivan = TRUE
GROUP BY o.id, o.ime, o.prezime, o.uloga
ORDER BY ukupni_iznos DESC, broj_naplata DESC;


CREATE VIEW pregled_placanja_clanarine AS
SELECT 
    c.id AS clan_id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    MAX(p.datum_uplate) AS zadnja_uplata,
    CASE 
        WHEN MAX(p.datum_uplate) IS NULL THEN NULL
        WHEN MAX(p.datum_uplate) <= DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')) THEN 
            DATEDIFF(DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')), MAX(p.datum_uplate))
        ELSE NULL
    END AS dani_ranije_uplaceno,
    CASE 
        WHEN MAX(p.datum_uplate) IS NULL THEN NULL
        WHEN MAX(p.datum_uplate) > DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')) THEN 
            DATEDIFF(MAX(p.datum_uplate), DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')))
        ELSE NULL
    END AS dani_kasnjenja,
    CASE 
        WHEN MAX(p.datum_uplate) IS NULL THEN 'Nema uplata'
        WHEN MAX(p.datum_uplate) > DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')) THEN 'Kašnjenje'
        ELSE 'Uplaćeno na vrijeme'
    END AS status_uplate
FROM clan c 
JOIN clanarina cl ON c.id_clanarina = cl.id 
LEFT JOIN placanje p ON c.id = p.id_clana 
    AND MONTH(p.datum_uplate) = MONTH(CURRENT_DATE) 
    AND YEAR(p.datum_uplate) = YEAR(CURRENT_DATE) 
WHERE c.aktivan = TRUE 
GROUP BY c.id, clan, cl.tip;


-- ==========================================
-- VLADAN: Pogledi za opremu i rezervacije
-- ==========================================

-- Pogled 10: Status i analiza opreme (Vladan)
CREATE OR REPLACE VIEW status_opreme AS
SELECT 
    o.id,
    o.sifra,
    o.naziv,
    o.stanje,
    o.vrijednost,
    o.proizvodac,
    o.model,
    DATEDIFF(CURRENT_DATE, o.datum_nabave) AS starost_dana,
    COUNT(ro.id) AS broj_rezervacija,
    COALESCE(MAX(ro.datum), o.datum_nabave) AS zadnje_koristena,
    DATEDIFF(CURRENT_DATE, COALESCE(MAX(ro.datum), o.datum_nabave)) AS dana_od_zadnjeg_koristenja,
    CASE 
        WHEN o.garancija_do IS NOT NULL AND o.garancija_do > CURRENT_DATE 
        THEN CONCAT('Da (još ', DATEDIFF(o.garancija_do, CURRENT_DATE), ' dana)')
        ELSE 'Ne'
    END AS pod_garancijom,
    CASE 
        WHEN o.stanje = 'neispravna' THEN 'Hitno'
        WHEN o.stanje = 'u servisu' THEN 'U servisu'
        WHEN COUNT(ro.id) = 0 THEN 'Nekorištena'
        WHEN COUNT(ro.id) > 50 THEN 'Vrlo popularna'
        ELSE 'Normalno'
    END AS prioritet
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme AND ro.status != 'otkazana'
GROUP BY o.id
ORDER BY broj_rezervacija DESC;

--Oprema s najviše otkazivanja rezervacija(Vladan)
CREATE OR REPLACE VIEW otkazane_rezervacije_po_opremi AS
SELECT 
    o.naziv AS oprema,
    COUNT(*) AS broj_otkazanih,
    COUNT(DISTINCT ro.id_clana) AS broj_clanova,
    MAX(ro.datum) AS zadnje_otkazivanje,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rezervacija_opreme WHERE status = 'otkazana'), 2) AS postotak_od_otkazanih
FROM oprema o
JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
WHERE ro.status = 'otkazana'
GROUP BY o.id
HAVING broj_otkazanih > 0
ORDER BY broj_otkazanih DESC;

--Učestalost korištenja opreme po korisnicima (Vladan)
CREATE OR REPLACE VIEW ucestalost_koristenja_opreme_po_clanovima AS
SELECT 
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    o.naziv AS oprema,
    COUNT(ro.id) AS broj_rezervacija,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)), 1) AS prosjecno_trajanje_min,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_trajanje_min
FROM rezervacija_opreme ro
JOIN clan c ON ro.id_clana = c.id
JOIN oprema o ON ro.id_opreme = o.id
WHERE ro.status = 'završena'
GROUP BY c.id, o.id
HAVING broj_rezervacija >= 2
ORDER BY broj_rezervacija DESC;



-- Pogled 11: Analiza rezervacija opreme (Vladan)
CREATE OR REPLACE VIEW analiza_rezervacija_opreme AS
SELECT 
    o.naziv AS oprema,
    o.sifra,
    COUNT(ro.id) AS ukupno_rezervacija,
    COUNT(DISTINCT ro.id_clana) AS broj_korisnika,
    COUNT(CASE WHEN ro.status = 'završena' THEN 1 END) AS završene,
    COUNT(CASE WHEN ro.status = 'aktivna' THEN 1 END) AS aktivne,
    COUNT(CASE WHEN ro.status = 'otkazana' THEN 1 END) AS otkazane,
    AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS prosjecno_trajanje_min,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_minuta,
    ROUND(COUNT(CASE WHEN ro.status = 'završena' THEN 1 END) * 100.0 / NULLIF(COUNT(ro.id), 0), 2) AS postotak_realizacije
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
GROUP BY o.id, o.naziv, o.sifra
HAVING ukupno_rezervacija > 0
ORDER BY ukupno_rezervacija DESC;

-- Pogled 12: Najpopularnija oprema po vremenskim periodima (Vladan)
CREATE OR REPLACE VIEW popularnost_opreme_po_vremenu AS
SELECT 
    o.naziv AS oprema,
    HOUR(ro.vrijeme_pocetka) AS sat,
    DAYNAME(ro.datum) AS dan_u_tjednu,
    COUNT(*) AS broj_rezervacija,
    AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS prosjecno_trajanje,
    CASE 
        WHEN HOUR(ro.vrijeme_pocetka) BETWEEN 6 AND 10 THEN 'Jutro'
        WHEN HOUR(ro.vrijeme_pocetka) BETWEEN 11 AND 15 THEN 'Podne'
        WHEN HOUR(ro.vrijeme_pocetka) BETWEEN 16 AND 20 THEN 'Večer'
        ELSE 'Noć'
    END AS period_dana
FROM oprema o
JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
WHERE ro.status != 'otkazana'
GROUP BY o.naziv, sat, dan_u_tjednu, period_dana
ORDER BY broj_rezervacija DESC;

-- ==========================================
-- MARKO ALEKSIĆ: Pogledi za grupne treninge i prisutnost
-- ==========================================

-- Pogled 13: Popunjenost grupnih treninga (Marko Aleksić)
CREATE OR REPLACE VIEW popunjenost_grupnih_treninga AS
SELECT 
    gt.id AS trening_id,
    gt.naziv,
    gt.dan_u_tjednu,
    gt.vrijeme,
    gt.max_clanova,
    gt.cijena_po_terminu,
    COUNT(DISTINCT p.id_clana) AS trenutno_prijavljenih,
    gt.max_clanova - COUNT(DISTINCT p.id_clana) AS slobodnih_mjesta,
    ROUND((COUNT(DISTINCT p.id_clana) / gt.max_clanova) * 100, 1) AS popunjenost_postotak,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    CASE 
        WHEN COUNT(DISTINCT p.id_clana) = gt.max_clanova THEN 'Puno'
        WHEN COUNT(DISTINCT p.id_clana) > (gt.max_clanova * 0.8) THEN 'Skoro puno'
        WHEN COUNT(DISTINCT p.id_clana) > (gt.max_clanova * 0.5) THEN 'Umjereno'
        ELSE 'Ima mjesta'
    END AS status_popunjenosti
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    AND p.prisutan = TRUE
JOIN trener t ON gt.id_trenera = t.id
WHERE gt.aktivan = TRUE
GROUP BY gt.id
ORDER BY popunjenost_postotak DESC;

-- Pogled 14: Aktivnost članova na grupnim treninzima (Marko Aleksić)
CREATE OR REPLACE VIEW aktivnost_clanova_grupni AS
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    COUNT(DISTINCT p.id_grupnog_treninga) AS broj_razlicitih_treninga,
    COUNT(p.id) AS ukupno_prijava,
    COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS prisutni,
    COUNT(CASE WHEN p.prisutan = FALSE THEN 1 END) AS odsutni,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) * 100.0 / NULLIF(COUNT(p.id), 0), 2) AS postotak_prisutnosti,
    MAX(p.datum) AS zadnji_dolazak,
    DATEDIFF(CURRENT_DATE, MAX(p.datum)) AS dana_od_zadnjeg_dolaska
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN prisutnost p ON c.id = p.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id
HAVING ukupno_prijava > 0
ORDER BY postotak_prisutnosti DESC, ukupno_prijava DESC;

-- Pogled 15: Statistika grupnih treninga po danima (Marko Aleksić)
CREATE OR REPLACE VIEW statistika_grupnih_po_danima AS
SELECT 
    gt.dan_u_tjednu,
    COUNT(DISTINCT gt.id) AS broj_programa,
    COUNT(DISTINCT gt.id_trenera) AS broj_trenera,
    SUM(gt.max_clanova) AS ukupni_kapacitet,
    COUNT(p.id) AS ukupno_prijava,
    COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS ukupno_prisutnih,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) * 100.0 / NULLIF(SUM(gt.max_clanova), 0), 2) AS iskorištenost_kapaciteta,
    ROUND(AVG(gt.cijena_po_terminu), 2) AS prosjecna_cijena,
    SUM(CASE WHEN p.prisutan = TRUE THEN gt.cijena_po_terminu ELSE 0 END) AS potencijalni_prihod
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
WHERE gt.aktivan = TRUE
GROUP BY gt.dan_u_tjednu
ORDER BY FIELD(gt.dan_u_tjednu, 'Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja');

-- ========================================
-- SLOŽENI UPITI - Po 3 za svakog člana tima
-- ========================================

-- ==========================================
-- MARTINA ILIĆ: Složeni upiti za članove i članarine
-- ==========================================

-- Upit 1: Analiza zadržavanja članova (Martina Ilić)
SELECT 
    cl.tip AS tip_clanarine,
    COUNT(*) AS ukupno_clanova,
    COUNT(CASE WHEN c.aktivan = TRUE THEN 1 END) AS aktivni_clanovi,
    COUNT(CASE WHEN c.aktivan = FALSE THEN 1 END) AS neaktivni_clanovi,
    ROUND(COUNT(CASE WHEN c.aktivan = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) AS postotak_zadrzavanja,
    AVG(DATEDIFF(CURRENT_DATE, c.datum_uclanjenja)) AS prosjecna_duljina_clanstva,
    MIN(DATEDIFF(CURRENT_DATE, c.datum_uclanjenja)) AS najkraće_clanstvo,
    MAX(DATEDIFF(CURRENT_DATE, c.datum_uclanjenja)) AS najduže_clanstvo
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
GROUP BY cl.tip
ORDER BY postotak_zadrzavanja DESC;

-- Upit 2: Demografska analiza s financijskim podacima (Martina Ilić)
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

-- Upit 3: Analiza najvjernijih članova (Martina Ilić)
SELECT 
    c.id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    COUNT(p.id) AS broj_transakcija,
    SUM(p.iznos) AS ukupno_placeno,
    AVG(p.iznos) AS prosjecno_placeno,
    MAX(p.datum_uplate) AS zadnja_uplata,
    DATEDIFF(CURRENT_DATE, MAX(p.datum_uplate)) AS dana_od_zadnje_uplate,
    CASE 
        WHEN COUNT(p.id) >= 10 THEN 'Vrlo vjerni'
        WHEN COUNT(p.id) >= 5 THEN 'Vjerni'
        ELSE 'Povremeni'
    END AS status_vjernosti
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN placanje p ON c.id = p.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id, clan, cl.tip
HAVING ukupno_placeno > 0
ORDER BY ukupno_placeno DESC, broj_transakcija DESC;


-- ==========================================
-- KARLO PERIĆ: Složeni upiti za trenere, treninge i tipove
-- ==========================================

-- Upit 4: Efikasnost trenera po tipovima treninga (Karlo Perić)
SELECT 
    t.id AS trener_id,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    t.specijalizacija,
    tt.naziv AS tip_treninga,
    COUNT(tr.id) AS broj_treninga,
    COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
    AVG(tr.cijena) AS prosjecna_cijena,
    SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) AS ukupni_prihod,
    COUNT(CASE WHEN tr.status = 'otkazan' THEN 1 END) AS broj_otkazanih,
    ROUND(COUNT(CASE WHEN tr.status = 'otkazan' THEN 1 END) * 100.0 / COUNT(tr.id), 2) AS postotak_otkazanih
FROM trener t
JOIN trening tr ON t.id = tr.id_trenera
JOIN tip_treninga tt ON tr.id_tip_treninga = tt.id
WHERE t.aktivan = TRUE
GROUP BY t.id, trener, t.specijalizacija, tt.naziv
HAVING broj_treninga >= 3
ORDER BY ukupni_prihod DESC, postotak_otkazanih ASC;

-- Upit 5: Analiza opterećenosti trenera (Karlo Perić)
WITH trener_opterećenost AS (
    SELECT 
        t.id,
        CONCAT(t.ime, ' ', t.prezime) AS trener,
        COUNT(DISTINCT tr.id) AS individualni_treninzi,
        COUNT(DISTINCT gt.id) AS grupni_programi,
        SUM(CASE WHEN tr.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) THEN tr.trajanje ELSE 0 END) AS minuta_ovaj_tjedan,
        SUM(CASE WHEN tr.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN tr.trajanje ELSE 0 END) AS minuta_ovaj_mjesec,
        COUNT(DISTINCT DATE(tr.datum)) AS radnih_dana_mjesec
    FROM trener t
    LEFT JOIN trening tr ON t.id = tr.id_trenera AND tr.status != 'otkazan'
    LEFT JOIN grupni_trening gt ON t.id = gt.id_trenera AND gt.aktivan = TRUE
    WHERE t.aktivan = TRUE
    GROUP BY t.id, trener
)
SELECT 
    trener,
    individualni_treninzi,
    grupni_programi,
    ROUND(minuta_ovaj_tjedan / 60.0, 1) AS sati_ovaj_tjedan,
    ROUND(minuta_ovaj_mjesec / 60.0, 1) AS sati_ovaj_mjesec,
    radnih_dana_mjesec,
    CASE 
        WHEN minuta_ovaj_tjedan > 2400 THEN 'Preopterećen'  -- više od 40h
        WHEN minuta_ovaj_tjedan > 1800 THEN 'Vrlo zauzet'   -- 30-40h
        WHEN minuta_ovaj_tjedan > 1200 THEN 'Umjereno zauzet' -- 20-30h
        ELSE 'Dostupan'
    END AS status_opterećenosti
FROM trener_opterećenost
ORDER BY minuta_ovaj_tjedan DESC;

-- Upit 6: ROI analiza tipova treninga (Karlo Perić)
SELECT 
    tt.naziv AS tip_treninga,
    tt.osnovna_cijena,
    COUNT(tr.id) AS broj_treninga,
    COUNT(DISTINCT tr.id_clana) AS broj_klijenata,
    COUNT(DISTINCT tr.id_trenera) AS broj_trenera,
    AVG(tr.cijena) AS prosjecna_naplata,
    SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) AS ukupni_prihod,
    SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END) AS ukupno_sati,
    ROUND(SUM(CASE WHEN tr.status = 'održan' THEN tr.cijena ELSE 0 END) / 
          NULLIF(SUM(CASE WHEN tr.status = 'održan' THEN tr.trajanje ELSE 0 END), 0) * 60, 2) AS prihod_po_satu,
    ROUND(AVG(tr.cijena) / tt.osnovna_cijena * 100, 2) AS postotak_realizacije_cijene
FROM tip_treninga tt
LEFT JOIN trening tr ON tt.id = tr.id_tip_treninga
GROUP BY tt.id, tt.naziv, tt.osnovna_cijena
ORDER BY ukupni_prihod DESC;

-- ==========================================
-- MARKO KOVAČ: Složeni upiti za osoblje i plaćanja
-- ==========================================

-- Upit 7: Produktivnost osoblja po ulogama (Marko Kovač)
SELECT 
    o.uloga,
    COUNT(DISTINCT o.id) AS broj_zaposlenika,
    COUNT(p.id) AS broj_obrađenih_plaćanja,
    SUM(p.iznos) AS ukupno_obrađeno,
    AVG(p.iznos) AS prosjecno_plaćanje,
    ROUND(COUNT(p.id) / COUNT(DISTINCT o.id), 2) AS plaćanja_po_zaposleniku,
    ROUND(SUM(p.iznos) / COUNT(DISTINCT o.id), 2) AS prihod_po_zaposleniku,
    MAX(p.datum_uplate) AS zadnje_plaćanje
FROM osoblje o
LEFT JOIN placanje p ON o.id = p.id_osoblje
WHERE o.aktivan = TRUE
GROUP BY o.uloga
ORDER BY prihod_po_zaposleniku DESC;

-- Upit 8: Analiza dnevnog prihoda i broja transakcija za zadnjih 30 dana (Marko Kovač)
SELECT
    p.datum_uplate,
    COUNT(p.id) AS broj_transakcija,
    SUM(p.iznos) AS ukupni_prihod,
    SUM(p.popust) AS ukupni_popusti,
    ROUND(SUM(p.iznos) - SUM(p.popust), 2) AS neto_prihod,
    AVG(p.iznos) AS prosjecna_uplata
FROM placanje p
WHERE p.datum_uplate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY p.datum_uplate
ORDER BY p.datum_uplate DESC;

-- Upit 9: Analiza kašnjenja i neplaćenih članarina(kašnjenje je kad je uplata nakon 10.5., neplaćanje je kad ID člana nema nikakvu uplatu za ovaj mjesec) (Marko Kovač)
SELECT 
    c.id AS clan_id, 
    CONCAT(c.ime, ' ', c.prezime) AS clan, 
    cl.tip AS tip_clanarine, 
    MAX(p.datum_uplate) AS zadnja_uplata,
    CASE 
        WHEN MAX(p.datum_uplate) IS NULL THEN NULL
        WHEN MAX(p.datum_uplate) > DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')) THEN 
            DATEDIFF(MAX(p.datum_uplate), DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')))
        ELSE 0
    END AS dani_kasnjenja,
    CASE 
        WHEN MAX(p.datum_uplate) IS NULL THEN 'Nema uplata' 
        WHEN MAX(p.datum_uplate) > DATE(CONCAT(YEAR(CURRENT_DATE), '-', MONTH(CURRENT_DATE), '-10')) THEN 'Kašnjenje' 
        ELSE 'Uplaćeno na vrijeme' 
    END AS status_uplate
FROM clan c 
JOIN clanarina cl ON c.id_clanarina = cl.id 
LEFT JOIN placanje p ON c.id = p.id_clana 
    AND MONTH(p.datum_uplate) = MONTH(CURRENT_DATE) 
    AND YEAR(p.datum_uplate) = YEAR(CURRENT_DATE) 
WHERE c.aktivan = TRUE 
GROUP BY c.id, clan, cl.tip 
HAVING status_uplate = 'Kašnjenje' OR status_uplate = 'Nema uplata' 
ORDER BY dani_kasnjenja DESC, clan;

-- ==========================================
-- VLADAN: Složeni upiti za opremu i rezervacije
-- ==========================================

-- Upit 10: ROI analiza opreme (Vladan)
WITH oprema_koristenje AS (
    SELECT 
        o.id,
        o.naziv,
        o.vrijednost,
        o.datum_nabave,
        DATEDIFF(CURRENT_DATE, o.datum_nabave) AS starost_dana,
        COUNT(r.id) AS broj_rezervacija,
        SUM(TIMESTAMPDIFF(MINUTE, r.vrijeme_pocetka, r.vrijeme_zavrsetka)) AS ukupno_minuta,
        COUNT(DISTINCT r.id_clana) AS broj_korisnika,
        AVG(TIMESTAMPDIFF(MINUTE, r.vrijeme_pocetka, r.vrijeme_zavrsetka)) AS prosjecno_trajanje
    FROM oprema o
    LEFT JOIN rezervacija_opreme r ON o.id = r.id_opreme AND r.status = 'završena'
    GROUP BY o.id
)
SELECT 
    naziv,
    vrijednost,
    starost_dana,
    broj_rezervacija,
    ROUND(ukupno_minuta / 60.0, 1) AS ukupno_sati,
    broj_korisnika,
    ROUND(prosjecno_trajanje, 1) AS prosjecno_trajanje_min,
    ROUND(vrijednost / NULLIF(broj_rezervacija, 0), 2) AS trosak_po_rezervaciji,
    ROUND((ukupno_minuta / 60.0) / NULLIF(starost_dana, 0) * 365, 1) AS sati_godišnje,
    CASE 
        WHEN broj_rezervacija = 0 THEN 'Nekorištena'
        WHEN broj_rezervacija < 10 THEN 'Slabo korištena'
        WHEN broj_rezervacija < 50 THEN 'Umjereno korištena'
        ELSE 'Često korištena'
    END AS kategorija_koristenja,
    CASE 
        WHEN starost_dana > 1095 AND broj_rezervacija < 50 THEN 'Razmotriti prodaju'
        WHEN starost_dana > 730 AND broj_rezervacija > 100 THEN 'Planirati zamjenu'
        WHEN broj_rezervacija > 200 THEN 'Vrlo vrijedna'
        ELSE 'Zadržati'
    END AS preporuka
FROM oprema_koristenje
ORDER BY broj_rezervacija DESC;

-- Upit 11: Analiza efikasnosti korištenja prostora (Vladan)
SELECT
    o.naziv AS oprema,
    COUNT(ro.id) AS broj_rezervacija,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_minuta_koristenja,
    ROUND(SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) / (COUNT(DISTINCT ro.datum) * 60), 2) AS prosjecno_sati_dnevno,
    COUNT(DISTINCT ro.datum) AS broj_dana_koristenja,
    ROUND(COUNT(DISTINCT ro.datum) * 100.0 / DATEDIFF(CURRENT_DATE, o.datum_nabave), 2) AS postotak_dana_koristena,
    CASE
        WHEN COUNT(DISTINCT ro.datum) * 100.0 / DATEDIFF(CURRENT_DATE, o.datum_nabave) > 80 THEN 'Odlično iskorištena'
        WHEN COUNT(DISTINCT ro.datum) * 100.0 / DATEDIFF(CURRENT_DATE, o.datum_nabave) > 50 THEN 'Dobro iskorištena'
        WHEN COUNT(DISTINCT ro.datum) * 100.0 / DATEDIFF(CURRENT_DATE, o.datum_nabave) > 20 THEN 'Umjereno iskorištena'
        ELSE 'Slabo iskorištena'
    END AS ocjena_iskoristenosti
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme AND ro.status = 'završena'
GROUP BY o.id, o.naziv
HAVING broj_rezervacija > 0
ORDER BY postotak_dana_koristena DESC, prosjecno_sati_dnevno DESC;

-- Upit 12: Analiza održavanja i troškova opreme (Vladan)
SELECT 
    o.stanje,
    COUNT(*) AS broj_opreme,
    SUM(o.vrijednost) AS ukupna_vrijednost,
    AVG(o.vrijednost) AS prosjecna_vrijednost,
    AVG(DATEDIFF(CURRENT_DATE, o.datum_nabave)) AS prosjecna_starost_dana,
    COUNT(CASE WHEN o.garancija_do > CURRENT_DATE THEN 1 END) AS pod_garancijom,
    COUNT(CASE WHEN o.garancija_do <= CURRENT_DATE OR o.garancija_do IS NULL THEN 1 END) AS van_garancije,
    GROUP_CONCAT(DISTINCT o.proizvodac ORDER BY o.proizvodac) AS proizvođači,
    CASE 
        WHEN o.stanje = 'neispravna' THEN 'Hitno - zamijeniti'
        WHEN o.stanje = 'u servisu' THEN 'Praćenje servisa'
        WHEN o.stanje = 'potrebna zamjena dijela' THEN 'Planirati popravak'
        ELSE 'Redovno održavanje'
    END AS preporuka_održavanja
FROM oprema o
GROUP BY o.stanje
ORDER BY 
    FIELD(o.stanje, 'neispravna', 'u servisu', 'potrebna zamjena dijela', 'ispravna', 'nova');

-- ==========================================
-- MARKO ALEKSIĆ: Složeni upiti za grupne treninge i prisutnost
-- ==========================================

-- Upit 13: Analiza najprofitabilnijih grupnih programa (Marko Aleksić)
WITH grupni_statistika AS (
    SELECT 
        gt.id,
        gt.naziv,
        gt.dan_u_tjednu,
        gt.cijena_po_terminu,
        gt.max_clanova,
        COUNT(DISTINCT p.datum) AS broj_termina,
        COUNT(p.id) AS ukupno_prijava,
        COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS ukupno_prisutnih,
        AVG(CASE WHEN p.prisutan = TRUE THEN gt.cijena_po_terminu ELSE 0 END) AS prosječni_prihod_po_terminu,
        CONCAT(t.ime, ' ', t.prezime) AS trener
    FROM grupni_trening gt
    JOIN trener t ON gt.id_trenera = t.id
    LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga
    WHERE gt.aktivan = TRUE
    GROUP BY gt.id, gt.naziv, gt.dan_u_tjednu, gt.cijena_po_terminu, gt.max_clanova, trener
)
SELECT 
    naziv,
    dan_u_tjednu,
    trener,
    cijena_po_terminu,
    max_clanova,
    broj_termina,
    ukupno_prijava,
    ukupno_prisutnih,
    ROUND(ukupno_prisutnih * cijena_po_terminu, 2) AS ukupni_prihod,
    ROUND(ukupno_prisutnih / NULLIF(broj_termina, 0), 1) AS prosječno_prisutnih_po_terminu,
    ROUND((ukupno_prisutnih / NULLIF(ukupno_prijava, 0)) * 100, 2) AS postotak_prisutnosti,
    ROUND((ukupno_prisutnih / NULLIF(broj_termina, 0)) / max_clanova * 100, 2) AS iskorištenost_kapaciteta,
    CASE 
        WHEN ukupno_prisutnih * cijena_po_terminu > 1000 THEN 'Vrlo profitabilan'
        WHEN ukupno_prisutnih * cijena_po_terminu > 500 THEN 'Profitabilan'
        WHEN ukupno_prisutnih * cijena_po_terminu > 200 THEN 'Umjereno profitabilan'
        ELSE 'Malo profitabilan'
    END AS kategorija_profitabilnosti
FROM grupni_statistika
ORDER BY ukupni_prihod DESC;

-- Upit 14: Analiza prisutnosti članova na grupnim treninzima (Marko Aleksić)
SELECT 
    c.id AS clan_id,
    CONCAT(c.ime, ' ', c.prezime) AS clan,
    cl.tip AS tip_clanarine,
    COUNT(DISTINCT p.id_grupnog_treninga) AS broj_razlicitih_treninga,
    COUNT(p.id) AS ukupno_prijava,
    COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS prisutni,
    COUNT(CASE WHEN p.prisutan = FALSE THEN 1 END) AS odsutni,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) * 100.0 / NULLIF(COUNT(p.id), 0), 2) AS postotak_prisutnosti,
    MAX(p.datum) AS zadnji_dolazak,
    DATEDIFF(CURRENT_DATE, MAX(p.datum)) AS dana_od_zadnjeg_dolaska
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN prisutnost p ON c.id = p.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id, clan, cl.tip
HAVING ukupno_prijava > 0
ORDER BY postotak_prisutnosti DESC, ukupno_prijava DESC;


-- Upit 15: Optimizacija rasporeda grupnih treninga (Marko Aleksić)
SELECT 
    gt.dan_u_tjednu,
    gt.vrijeme,
    COUNT(DISTINCT gt.id) AS broj_programa,
    SUM(gt.max_clanova) AS ukupni_kapacitet,
    COUNT(p.id) AS ukupno_prijava,
    COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) AS ukupno_prisutnih,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) / NULLIF(SUM(gt.max_clanova), 0) * 100, 2) AS iskorištenost_kapaciteta,
    ROUND(COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) / NULLIF(COUNT(p.id), 0) * 100, 2) AS postotak_prisutnosti,
    SUM(CASE WHEN p.prisutan = TRUE THEN gt.cijena_po_terminu ELSE 0 END) AS ukupni_prihod,
    CASE 
        WHEN COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) / NULLIF(SUM(gt.max_clanova), 0) * 100 > 80 THEN 'Preopterećeno - dodati termin'
        WHEN COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) / NULLIF(SUM(gt.max_clanova), 0) * 100 > 60 THEN 'Dobro iskorišteno'
        WHEN COUNT(CASE WHEN p.prisutan = TRUE THEN 1 END) / NULLIF(SUM(gt.max_clanova), 0) * 100 > 30 THEN 'Prosječno iskorišteno'
        ELSE 'Slabo iskorišteno - razmotriti ukidanje'
    END AS preporuka,
    GROUP_CONCAT(DISTINCT gt.naziv ORDER BY gt.naziv SEPARATOR ', ') AS programi
FROM grupni_trening gt
LEFT JOIN prisutnost p ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
WHERE gt.aktivan = TRUE
GROUP BY gt.dan_u_tjednu, gt.vrijeme
ORDER BY 
    FIELD(gt.dan_u_tjednu, 'Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja'),
    gt.vrijeme;
