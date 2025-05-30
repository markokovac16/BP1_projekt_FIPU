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
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id)
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

CREATE TABLE tip_treninga (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE,
    osnovna_cijena DECIMAL(6,2) NOT NULL CHECK (osnovna_cijena >= 0),
    opis TEXT
);

CREATE TABLE privatni_trening (
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
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_trenera) REFERENCES trener(id),
    FOREIGN KEY (id_tip_treninga) REFERENCES tip_treninga(id)
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
    FOREIGN KEY (id_trenera) REFERENCES trener(id)
);

CREATE TABLE prisutnost_grupni (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_grupnog_treninga INT NOT NULL,
    datum DATE NOT NULL,
    prisutan BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id)
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
    FOREIGN KEY (id_clana) REFERENCES clan(id),
    FOREIGN KEY (id_opreme) REFERENCES oprema(id),
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
    iznos DECIMAL(6,2) NOT NULL CHECK (iznos > 0),
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

-- Podaci za tipove treninga (Karlo Perić)
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

-- Podaci za privatne treninge (Karlo Perić)
INSERT INTO privatni_trening (id_clana, id_trenera, id_tip_treninga, datum, vrijeme, trajanje, status, cijena, napomena) VALUES
(3, 1, 3, '2025-05-05', '09:00:00', 60, 'održan', 0.00, 'Uključeno u Premium plan'),  
(3, 1, 9, '2025-05-08', '09:00:00', 75, 'održan', 30.00, 'Dodatni trening - naplaćuje se'),
(6, 2, 2, '2025-05-07', '14:00:00', 60, 'održan', 0.00, 'Uključeno u Premium plan'),  
(6, 3, 7, '2025-05-11', '11:00:00', 60, 'održan', 20.00, 'Dodatni trening - naplaćuje se'),
(12, 4, 4, '2025-06-01', '12:00:00', 60, 'zakazan', 0.00, 'Uključeno u Premium plan'), 
(12, 5, 8, '2025-05-13', '15:00:00', 60, 'održan', 22.00, 'Dodatni trening - naplaćuje se'),
(13, 1, 1, '2025-06-02', '17:00:00', 60, 'otkazan', 0.00, 'Uključeno u Premium plan'),
(19, 2, 6, '2025-06-03', '17:00:00', 60, 'zakazan', 0.00, 'Uključeno u Premium plan'), 
(21, 3, 10, '2025-05-12', '13:00:00', 75, 'održan', 0.00, 'Uključeno u Premium plan'),
(21, 4, 6, '2025-05-16', '14:00:00', 60, 'održan', 28.00, 'Dodatni trening - naplaćuje se'),
(2, 2, 2, '2025-05-05', '10:30:00', 45, 'održan', 25.00, 'Dodatni privatni trening'), 
(2, 3, 6, '2025-06-04', '16:00:00', 60, 'zakazan', 28.00, 'Dodatni privatni trening'), 
(5, 5, 2, '2025-05-07', '13:00:00', 45, 'održan', 25.00, 'Dodatni privatni trening'), 
(11, 4, 5, '2025-05-10', '09:00:00', 45, 'održan', 18.00, 'Dodatni privatni trening'),  
(17, 2, 2, '2025-05-14', '18:00:00', 45, 'održan', 25.00, 'Dodatni privatni trening'),
(18, 5, 5, '2025-05-12', '10:00:00', 60, 'održan', 18.00, 'Dodatni privatni trening'),
(20, 1, 1, '2025-06-05', '12:00:00', 60, 'zakazan', 20.00, 'Dodatni privatni trening'),
(26, 4, 4, '2025-05-13', '16:00:00', 60, 'održan', 22.00, 'Dodatni privatni trening'),
(1, 1, 1, '2025-05-11', '15:00:00', 60, 'održan', 20.00, 'Dodatni privatni trening'),  
(4, 4, 4, '2025-06-06', '12:00:00', 60, 'zakazan', 22.00, 'Dodatni privatni trening'), 
(7, 1, 5, '2025-05-08', '15:00:00', 60, 'održan', 18.00, 'Dodatni privatni trening'),  
(8, 2, 6, '2025-06-07', '12:00:00', 60, 'zakazan', 28.00, 'Dodatni privatni trening'),
(14, 3, 8, '2025-05-10', '11:00:00', 60, 'održan', 22.00, 'Dodatni privatni trening'), 
(23, 1, 1, '2025-05-09', '10:00:00', 60, 'održan', 20.00, 'Dodatni privatni trening'),
(39, 2, 2, '2025-06-08', '14:00:00', 45, 'otkazan', 25.00, 'Dodatni privatni trening'),
(44, 3, 7, '2025-06-09', '11:00:00', 60, 'zakazan', 20.00, 'Dodatni privatni trening');


-- Podaci za grupne treninge (Karlo Perić)
INSERT INTO grupni_trening (naziv, id_trenera, max_clanova, dan_u_tjednu, vrijeme, trajanje, cijena_po_terminu, opis) VALUES
('Pilates za početnike', 3, 12, 'Ponedjeljak', '18:00:00', 60, 15.00, 'Pilates za sve razine'),
('HIIT jutarnji', 4, 15, 'Utorak', '07:00:00', 45, 18.00, 'Jutarnji visoko intenzivni trening'),
('HIIT večernji', 4, 15, 'Utorak', '19:00:00', 45, 18.00, 'Večernji visoko intenzivni trening'),
('Spinning', 5, 15, 'Srijeda', '18:30:00', 45, 16.00, 'Indoor biciklizam'),
('Yoga relax', 3, 10, 'Četvrtak', '18:00:00', 60, 20.00, 'Yoga za opuštanje'),
('CrossFit', 4, 12, 'Petak', '19:00:00', 60, 22.00, 'Funkcionalni fitness'),
('Zumba vikend', 6, 20, 'Subota', '10:00:00', 60, 12.00, 'Plesni fitness program'),
('Snaga & Kondicija', 1, 10, 'Subota', '11:30:00', 75, 25.00, 'Trening snage s utezima'),
('Kardio Mix', 5, 15, 'Nedjelja', '10:00:00', 45, 14.00, 'Kombinacija kardio vježbi'),
('Funkcionalni trening', 2, 12, 'Ponedjeljak', '19:30:00', 60, 20.00, 'Funkcionalni pokret'),
('Pilates napredni', 3, 8, 'Srijeda', '20:00:00', 60, 18.00, 'Napredni Pilates'),
('Power Yoga', 3, 10, 'Petak', '17:30:00', 75, 22.00, 'Dinamična yoga');


-- Podaci za prisutnost (Marko Aleksić)
INSERT INTO prisutnost_grupni (id_clana, id_grupnog_treninga, datum, prisutan) VALUES
(2, 1, '2025-05-05', TRUE), (3, 1, '2025-05-05', TRUE), (5, 1, '2025-05-05', TRUE), (6, 1, '2025-05-05', TRUE),
(11, 2, '2025-05-06', TRUE), (12, 2, '2025-05-06', TRUE), (13, 2, '2025-05-06', TRUE), (18, 2, '2025-05-06', TRUE),
(19, 3, '2025-05-06', TRUE), (21, 3, '2025-05-06', TRUE), (25, 3, '2025-05-06', TRUE), (26, 3, '2025-05-06', TRUE),
(29, 4, '2025-05-07', TRUE), (34, 4, '2025-05-07', TRUE), (35, 4, '2025-05-07', TRUE), (36, 4, '2025-05-07', TRUE),
(42, 5, '2025-05-08', TRUE), (48, 5, '2025-05-08', TRUE), (2, 5, '2025-05-08', TRUE), (3, 5, '2025-05-08', TRUE),
(8, 6, '2025-05-09', TRUE), (15, 6, '2025-05-09', TRUE), (24, 6, '2025-05-09', TRUE), (33, 6, '2025-05-09', TRUE),
(39, 7, '2025-05-10', TRUE), (45, 7, '2025-05-10', TRUE), (8, 8, '2025-05-10', TRUE), (15, 8, '2025-05-10', TRUE),
(1, 1, '2025-05-12', TRUE), (4, 2, '2025-05-13', TRUE), (9, 4, '2025-05-15', TRUE), 
(16, 6, '2025-05-16', TRUE), (22, 8, '2025-05-18', TRUE), (30, 1, '2025-05-19', TRUE),
(37, 3, '2025-05-20', TRUE), (43, 5, '2025-05-22', TRUE), (49, 7, '2025-05-24', TRUE),
(7, 9, '2025-05-11', TRUE), (14, 10, '2025-05-05', TRUE), (23, 11, '2025-05-14', TRUE), 
(38, 12, '2025-05-16', TRUE), (44, 1, '2025-05-26', TRUE),
(2, 1, '2025-05-12', TRUE), (3, 1, '2025-05-12', TRUE), (5, 1, '2025-05-12', TRUE), (6, 1, '2025-05-12', TRUE),
(11, 2, '2025-05-13', TRUE), (12, 2, '2025-05-13', TRUE), (13, 3, '2025-05-13', TRUE), (18, 3, '2025-05-13', TRUE),
(19, 4, '2025-05-15', TRUE), (21, 4, '2025-05-15', TRUE), (25, 5, '2025-05-16', TRUE), (26, 5, '2025-05-16', TRUE),
(29, 6, '2025-05-16', TRUE), (34, 6, '2025-05-16', TRUE), (35, 7, '2025-05-17', TRUE), (36, 7, '2025-05-17', TRUE),
(42, 8, '2025-05-18', TRUE), (48, 8, '2025-05-18', TRUE), (8, 9, '2025-05-18', TRUE), (15, 9, '2025-05-18', TRUE),
(24, 10, '2025-05-19', TRUE), (33, 10, '2025-05-19', TRUE), (39, 11, '2025-05-21', TRUE), (45, 11, '2025-05-21', TRUE),
(2, 12, '2025-05-23', TRUE), (3, 12, '2025-05-23', TRUE), (5, 2, '2025-05-20', TRUE), (6, 3, '2025-05-21', TRUE),
(2, 1, '2025-05-26', TRUE), (3, 1, '2025-05-26', TRUE), (5, 1, '2025-05-26', TRUE), (6, 1, '2025-05-26', TRUE),
(11, 10, '2025-05-26', TRUE), (12, 10, '2025-05-26', TRUE), (18, 10, '2025-05-26', TRUE), (26, 10, '2025-05-26', TRUE),
(1, 1, '2025-05-26', TRUE), (9, 10, '2025-05-26', TRUE),
(7, 1, '2025-05-26', TRUE),
(11, 2, '2025-05-27', TRUE), (12, 2, '2025-05-27', TRUE), (13, 2, '2025-05-27', TRUE), (18, 2, '2025-05-27', TRUE),
(19, 3, '2025-05-27', TRUE), (21, 3, '2025-05-27', TRUE), (25, 3, '2025-05-27', TRUE), (26, 3, '2025-05-27', TRUE),
(4, 2, '2025-05-27', TRUE), (16, 3, '2025-05-27', TRUE),
(14, 2, '2025-05-27', TRUE),
(29, 4, '2025-05-28', TRUE), (34, 4, '2025-05-28', TRUE), (35, 4, '2025-05-28', TRUE), (36, 4, '2025-05-28', TRUE),
(2, 11, '2025-05-28', TRUE), (3, 11, '2025-05-28', TRUE), (5, 11, '2025-05-28', TRUE), (6, 11, '2025-05-28', TRUE),
(8, 4, '2025-05-28', TRUE), (15, 11, '2025-05-28', TRUE), (24, 4, '2025-05-28', TRUE), (33, 11, '2025-05-28', TRUE),
(22, 4, '2025-05-28', TRUE), (30, 11, '2025-05-28', TRUE),
(23, 4, '2025-05-28', TRUE),
(42, 5, '2025-05-29', TRUE), (48, 5, '2025-05-29', TRUE), (2, 5, '2025-05-29', TRUE), (3, 5, '2025-05-29', TRUE),
(11, 5, '2025-05-29', TRUE), (12, 5, '2025-05-29', TRUE), (18, 5, '2025-05-29', TRUE), (26, 5, '2025-05-29', TRUE),
(39, 5, '2025-05-29', TRUE), (45, 5, '2025-05-29', TRUE),
(37, 5, '2025-05-29', TRUE), (43, 5, '2025-05-29', TRUE),
(38, 5, '2025-05-29', TRUE),
(19, 6, '2025-05-30', TRUE), (21, 6, '2025-05-30', TRUE), (25, 6, '2025-05-30', TRUE), (29, 6, '2025-05-30', TRUE),
(34, 6, '2025-05-30', TRUE), (35, 6, '2025-05-30', TRUE), (36, 6, '2025-05-30', TRUE), (42, 6, '2025-05-30', TRUE),
(2, 12, '2025-05-30', TRUE), (3, 12, '2025-05-30', TRUE), (5, 12, '2025-05-30', TRUE), (6, 12, '2025-05-30', TRUE),
(8, 6, '2025-05-30', TRUE), (15, 12, '2025-05-30', TRUE), (24, 6, '2025-05-30', TRUE), (33, 12, '2025-05-30', TRUE),
(49, 6, '2025-05-30', TRUE), (1, 12, '2025-05-30', TRUE),
(44, 6, '2025-05-30', TRUE), (7, 12, '2025-05-30', TRUE);

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
('OPR-030', 'Sprava za hiperektenziju', '2022-11-21', 'ispravna', 1700.00, 'Westside', 'RH2022', '2025-11-21'),
('OPR-031', 'Multifunkcionalni squat rack', '2024-11-01', 'nova', 5000.00, 'Rogue', 'Monster Rack', '2027-11-01'),
('OPR-032', 'Battle rope 15m',               '2024-10-15', 'nova', 300.00,  'Tiguar', 'BR15',        '2026-10-15'),
('OPR-033', 'Plyo kutija set (3 kom)',       '2024-09-20', 'nova', 450.00,  'Reebok', 'PlyoBoxPro',  '2026-09-20');

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
(1, 29.99, '2025-05-05', 'kartica', 'R-2025-001', 5.00, 1, 'Osnovna članarina - svibanj 2025'),
(3, 69.99, '2025-05-02', 'kartica', 'R-2025-002', 0.00, 1, 'Premium članarina - svibanj 2025'),
(4, 29.99, '2025-05-08', 'transfer', 'R-2025-003', 10.00, 2, 'Osnovna članarina - svibanj 2025'),
(6, 69.99, '2025-05-03', 'kartica', 'R-2025-004', 0.00, 1, 'Premium članarina - svibanj 2025'),
(9, 29.99, '2025-05-10', 'gotovina', 'R-2025-005', 3.00, 7, 'Osnovna članarina - svibanj 2025'),
(10, 299.99, '2025-05-01', 'transfer', 'R-2025-006', 0.00, 2, 'Godišnja Standard članarina 2025'),
(13, 69.99, '2025-05-07', 'kartica', 'R-2025-007', 15.00, 1, 'Premium članarina - svibanj 2025'),
(14, 19.99, '2025-05-09', 'PayPal', 'R-2025-008', 0.00, 7, 'Student Basic članarina - svibanj 2025'),
(16, 29.99, '2025-05-06', 'kartica', 'R-2025-009', 0.00, 1, 'Osnovna članarina - svibanj 2025'),
(19, 69.99, '2025-05-04', 'kartica', 'R-2025-010', 0.00, 1, 'Premium članarina - svibanj 2025'),
(20, 299.99, '2025-05-01', 'kartica', 'R-2025-011', 0.00, 2, 'Godišnja Standard članarina 2025'),
(22, 29.99, '2025-05-10', 'gotovina', 'R-2025-012', 8.00, 7, 'Osnovna članarina - svibanj 2025'),
(24, 29.99, '2025-05-08', 'kartica', 'R-2025-013', 0.00, 1, 'Student Plus članarina - svibanj 2025'),
(2, 49.99, '2025-05-15', 'kartica', 'R-2025-014', 20.00, 1, 'Napredna članarina - svibanj 2025'),
(5, 49.99, '2025-05-18', 'transfer', 'R-2025-015', 12.00, 2, 'Napredna članarina - svibanj 2025'),
(7, 19.99, '2025-05-12', 'gotovina', 'R-2025-016', 0.00, 7, 'Student Basic članarina - svibanj 2025'),
(8, 29.99, '2025-05-20', 'kartica', 'R-2025-017', 0.00, 1, 'Student Plus članarina - svibanj 2025'),
(11, 49.99, '2025-05-13', 'PayPal', 'R-2025-018', 2.50, 2, 'Napredna članarina - svibanj 2025'),
(12, 399.99, '2025-05-17', 'transfer', 'R-2025-019', 0.00, 2, 'Godišnja Premium članarina 2025'),
(15, 29.99, '2025-05-14', 'kartica', 'R-2025-020', 0.00, 1, 'Student Plus članarina - svibanj 2025'),
(17, 299.99, '2025-05-16', 'kartica', 'R-2025-021', 0.00, 2, 'Godišnja Standard članarina 2025'),
(18, 49.99, '2025-05-19', 'gotovina', 'R-2025-022', 0.00, 7, 'Napredna članarina - svibanj 2025'),
(21, 399.99, '2025-05-11', 'kartica', 'R-2025-023', 0.00, 2, 'Godišnja Premium članarina 2025'),
(23, 19.99, '2025-05-22', 'PayPal', 'R-2025-024', 0.00, 7, 'Student Basic članarina - svibanj 2025'),
(25, 69.99, '2025-05-15', 'kartica', 'R-2025-025', 25.00, 1, 'Premium članarina - svibanj 2025'),
(26, 49.99, '2025-05-17', 'transfer', 'R-2025-026', 7.00, 2, 'Napredna članarina - svibanj 2025'),
(27, 69.99, '2025-05-21', 'kartica', 'R-2025-027', 0.00, 1, 'Premium članarina - svibanj 2025'),
(28, 299.99, '2025-05-13', 'kartica', 'R-2025-028', 0.00, 2, 'Godišnja Standard članarina 2025'),
(29, 399.99, '2025-05-16', 'transfer', 'R-2025-029', 0.00, 2, 'Godišnja Premium članarina 2025'),
(30, 29.99, '2025-05-12', 'gotovina', 'R-2025-030', 4.00, 7, 'Osnovna članarina - svibanj 2025'),
(31, 19.99, '2025-05-09', 'kartica', 'R-2025-031', 0.00, 1, 'Student Basic članarina - svibanj 2025'),
(32, 29.99, '2025-05-06', 'gotovina', 'R-2025-032', 6.00, 7, 'Student Plus članarina - svibanj 2025'),
(33, 29.99, '2025-05-08', 'transfer', 'R-2025-033', 0.00, 2, 'Student Plus članarina - svibanj 2025'),
(34, 49.99, '2025-05-18', 'kartica', 'R-2025-034', 0.00, 1, 'Napredna članarina - svibanj 2025'),
(35, 299.99, '2025-05-20', 'PayPal', 'R-2025-035', 0.00, 2, 'Godišnja Standard članarina 2025');


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
SELECT * FROM treneri_statistika;

-- Pogled 5: Raspored budućih treninga (Karlo Perić)
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
SELECT * FROM raspored_buducih_treninga;

-- Pogled 6: Analiza tipova treninga (Karlo Perić)
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
SELECT * FROM analiza_tipova_treninga;

-- ==========================================
-- MARKO KOVAČ: Pogledi za osoblje i plaćanja
-- ==========================================

-- Pogled 7: Pregled osoblja s performansama za tekući mjesec
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
    
    -- Dodatne korisne informacije
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

-- Pogled 8: Financijski pregled za tekući mjesec
CREATE OR REPLACE VIEW dodatni_troskovi_clanova AS
SELECT 
    c.id,
    c.ime,
    c.prezime,
    cl.tip AS tip_clanarine,
    
    COUNT(pt.id) AS broj_privatnih_treninga,
    COALESCE(SUM(pt.cijena), 0) AS troskovi_privatni_treninzi,
    
    COUNT(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN pr.id 
        ELSE NULL 
    END) AS broj_dodatnih_grupnih,
    COALESCE(SUM(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
        ELSE 0 
    END), 0) AS troskovi_grupni_treninzi,
    

    COALESCE(SUM(pt.cijena), 0) + 
    COALESCE(SUM(CASE 
        WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
        ELSE 0 
    END), 0) AS ukupno_dodatni_troskovi,

    CASE 
        WHEN c.id_clanarina IN (6, 7) THEN 0.00
        ELSE cl.cijena
    END AS mjesecni_iznos_clanarine,
    
    CASE 
        WHEN c.id_clanarina IN (6, 7) THEN 
            COALESCE(SUM(pt.cijena), 0) + 
            COALESCE(SUM(CASE 
                WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
                ELSE 0 
            END), 0)
        ELSE 
            cl.cijena + 
            COALESCE(SUM(pt.cijena), 0) + 
            COALESCE(SUM(CASE 
                WHEN cl.tip IN ('Osnovna', 'Student - Basic') THEN gt.cijena_po_terminu 
                ELSE 0 
            END), 0)
    END AS ukupno_za_naplatu_ovaj_mjesec,
    
    CASE 
        WHEN c.id_clanarina IN (6, 7) THEN 'DA' 
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
GROUP BY c.id, c.ime, c.prezime, cl.tip, cl.cijena, c.id_clanarina
ORDER BY ukupno_dodatni_troskovi DESC;

-- Pogled 9: Pregled aktivnosti trenera za tekući mjesec (Marko Kovač)
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


-- ==========================================
-- VLADAN KRIVOKAPIC: Pogledi za opremu i rezervacije
-- ==========================================

-- Pogled 9: Trenutno stanje i vrijednost opreme (Vladan)
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

-- Oprema po proizvodacu (Vladan)
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


-- Pogled 10: Broj rezervacija po opremi (Vladan)
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

-- Pogled 11: Prosječno korištenje opreme po članu (Vladan)
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

-- Pogled 12: Top 5 najkorištenijih sprava po trajanju (Vladan)
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

-- Pogled 13: Oprema koja se još nije koristila (Vladan)
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
    COUNT(p.id) AS trenutno_prijavljenih,
    GREATEST(gt.max_clanova - COUNT(p.id), 0) AS slobodnih_mjesta,
    ROUND((LEAST(COUNT(p.id), gt.max_clanova) / gt.max_clanova) * 100, 1) AS popunjenost_postotak,
    CONCAT(t.ime, ' ', t.prezime) AS trener,
    CASE 
        WHEN COUNT(p.id) >= gt.max_clanova THEN 'Puno'
        WHEN COUNT(p.id) > (gt.max_clanova * 0.8) THEN 'Skoro puno'
        WHEN COUNT(p.id) > (gt.max_clanova * 0.5) THEN 'Umjereno'
        ELSE 'Ima mjesta'
    END AS status_popunjenosti
FROM grupni_trening gt
LEFT JOIN prisutnost_grupni p 
    ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    AND p.prisutan = TRUE
JOIN trener t ON gt.id_trenera = t.id
WHERE gt.aktivan = TRUE
GROUP BY gt.id
ORDER BY popunjenost_postotak DESC;


-- testiranje pogleda
SELECT * FROM popunjenost_grupnih_treninga;


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
LEFT JOIN prisutnost_grupni p ON c.id = p.id_clana
WHERE c.aktivan = TRUE
GROUP BY c.id
HAVING ukupno_prijava > 0
ORDER BY postotak_prisutnosti DESC, ukupno_prijava DESC;


-- testiranje pogleda
SELECT * FROM aktivnost_clanova_grupni;




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
LEFT JOIN prisutnost_grupni p ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
WHERE gt.aktivan = TRUE
GROUP BY gt.dan_u_tjednu
ORDER BY FIELD(gt.dan_u_tjednu, 'Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja');


-- testiranje pogleda
SELECT * FROM statistika_grupnih_po_danima;



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

    -- Privatni treninzi
    COUNT(DISTINCT pt.id) AS broj_treninga,
    COUNT(DISTINCT pt.id_clana) AS broj_klijenata,
    
    COALESCE(ROUND(AVG(CASE WHEN pt.status = 'održan' THEN pt.cijena END), 2), 0) AS prosjecna_cijena,
    COALESCE(SUM(CASE WHEN pt.status = 'održan' THEN pt.cijena ELSE 0 END), 0) AS prihod,
    COALESCE(SUM(CASE WHEN pt.status = 'održan' THEN pt.trajanje ELSE 0 END), 0) / 60.0 AS sati,

    -- Otkazani treninzi
    COUNT(CASE WHEN pt.status = 'otkazan' THEN 1 END) AS broj_otkazanih,

    -- Postotak otkazanih
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

-- Upit 5: Analiza opterećenosti trenera (Karlo Perić)
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

-- Upit 6: ROI analiza tipova treninga (Karlo Perić)
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


-- ==========================================
-- MARKO KOVAČ: Složeni upiti za osoblje i plaćanja
-- ==========================================

-- Upit 7: Koji zaposlenici rade s najskupljim klijentima
SELECT 
    o.ime,
    o.prezime,
    o.uloga,
    COUNT(DISTINCT p.id_clana) AS broj_klijenata,
    COUNT(p.id) AS ukupno_transakcija,
    SUM(p.iznos - p.popust) AS ukupni_prihod,
    ROUND(SUM(p.iznos - p.popust) / COUNT(DISTINCT p.id_clana), 2) AS prihod_po_klijentu,
    MAX(p.iznos - p.popust) AS najveca_pojedinacna_naplata,
    GROUP_CONCAT(DISTINCT p.nacin_placanja ORDER BY p.nacin_placanja) AS nacini_placanja_koje_koristi
FROM osoblje o
JOIN placanje p ON o.id = p.id_osoblje
WHERE o.uloga IN ('Recepcionist', 'Voditelj') AND o.aktivan = TRUE
GROUP BY o.id, o.ime, o.prezime, o.uloga
ORDER BY prihod_po_klijentu DESC;


-- Upit 8: Analiza plaćanja po načinu (Marko Kovač)
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


-- Upit 9: Koji zaposlenici daju popuste i koliki je ukupni iznos popusta(EUR)  'Recepcionist', 'Voditelj'
SELECT 
    o.ime,
    o.prezime,
    o.uloga,
    COUNT(CASE WHEN p.popust > 0 THEN 1 END) AS broj_popusta_odobren,
    COUNT(p.id) AS ukupno_naplata,
    ROUND((COUNT(CASE WHEN p.popust > 0 THEN 1 END) * 100.0) / COUNT(p.id), 2) AS postotak_s_popustom,
    ROUND(AVG(CASE WHEN p.popust > 0 THEN p.popust END), 2) AS prosjecni_popust_kad_da,
    SUM(p.popust) AS ukupni_popusti_dani,
    SUM(p.iznos) AS ukupni_bruto_iznos,
    SUM(p.iznos - p.popust) AS ukupni_neto_iznos,
    ROUND((SUM(p.popust) * 100.0) / SUM(p.iznos), 2) AS postotak_umanjenja_prihoda
FROM osoblje o
JOIN placanje p ON o.id = p.id_osoblje
WHERE o.uloga IN ('Recepcionist', 'Voditelj') AND o.aktivan = TRUE
GROUP BY o.id, o.ime, o.prezime, o.uloga
ORDER BY ukupni_popusti_dani DESC;


-- ==========================================
-- VLADAN: Složeni upiti za opremu i rezervacije
-- ==========================================
-- Upit za izvlacenje osnovnih podataka i detaljna statistika (Vladan)
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
GROUP BY
    o.id,
    o.sifra,
    o.naziv,
    o.proizvodac,
    o.stanje
ORDER BY
    rezervacije_posljednjih_30_dana DESC,
    dana_od_zadnje_rezervacije ASC;

-- Analiza rezervacija, trajanja i garancije opreme (Vladan)

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
    COALESCE(r.broj_razlicitih_dana, 0)          AS broj_razlicitih_dana,
    r.prva_rezervacija,
    r.zadnja_rezervacija,
    COALESCE(r.rezervacije_zadnjih_30_dana, 0)   AS rezervacije_zadnjih_30_dana,
    ROUND(
      COALESCE(r.rezervacije_zadnjih_30_dana,0) * 100
      / NULLIF(COALESCE(r.ukupno_rezervacija,0),0)
      ,1
    )                                           AS postotak_rezervacija_30_od_ukupnih,
    ROUND(
      COALESCE(r.ukupno_rezervacija,0)
      / NULLIF(COALESCE(r.broj_razlicitih_dana,1),1)
      ,2
    )                                           AS prosjek_rezervacija_po_danu,
    DATEDIFF(CURRENT_DATE, COALESCE(r.zadnja_rezervacija, o.datum_nabave))
                                                AS dana_od_zadnje_rezervacije,
    DATEDIFF(o.garancija_do, CURRENT_DATE)       AS dana_do_isteka_garancije,
    CASE
      WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) < 0 THEN 'Jamstvo isteklo'
      WHEN DATEDIFF(o.garancija_do, CURRENT_DATE) <= 30 THEN 'Jamstvo uskoro istječe'
      ELSE 'Garancija valjana'
    END                                          AS status_garancije,
    CASE
      WHEN COALESCE(r.rezervacije_zadnjih_30_dana,0) >= 10 THEN 'Visoka'
      WHEN COALESCE(r.rezervacije_zadnjih_30_dana,0) >= 5  THEN 'Srednja'
      ELSE 'Niska'
    END                                          AS kategorija_koristenja
FROM oprema o
LEFT JOIN res r ON o.id = r.id_opreme
ORDER BY
    rezervacije_zadnjih_30_dana DESC,
    dana_od_zadnje_rezervacije ASC;


     -- Trend koristenja opreme (Vladan)

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
        ROW_NUMBER() OVER(PARTITION BY id_opreme ORDER BY yw DESC) AS rn
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
    COALESCE(f.avg_zadnja_4_tjedna,0)    AS avg_zadnja_4_tjedna,
    COALESCE(f.avg_prethodna_4_tjedna,0) AS avg_prethodna_4_tjedna,
    ROUND(
      COALESCE(f.avg_zadnja_4_tjedna,0)
      - COALESCE(f.avg_prethodna_4_tjedna,0)
      ,2
    )                                    AS razlika,
    CASE
      WHEN f.avg_zadnja_4_tjedna > f.avg_prethodna_4_tjedna THEN 'Rastući trend'
      WHEN f.avg_zadnja_4_tjedna < f.avg_prethodna_4_tjedna THEN 'Opadajući trend'
      ELSE 'Stabilno'
    END                                   AS trend_koristenja
FROM oprema o
LEFT JOIN filtrirani f ON o.id = f.id_opreme
ORDER BY
    razlika DESC;






-- ==========================================
-- MARKO ALEKSIĆ: Složeni upiti za grupne treninge i prisutnost
-- ==========================================

-- Upit 13: Analiza najprofitabilnijih grupnih programa (Marko Aleksić)
WITH prisutnosti_clean AS (
    SELECT DISTINCT id_grupnog_treninga, datum, id_clana
    FROM prisutnost_grupni
    WHERE prisutan = TRUE
    AND datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
),
termini AS (
    SELECT 
        gt.id AS trening_id,
        gt.max_clanova,
        p.datum,
        COUNT(p.id_clana) AS broj_prisutnih
    FROM grupni_trening gt
    LEFT JOIN prisutnosti_clean p 
        ON gt.id = p.id_grupnog_treninga
    WHERE gt.aktivan = TRUE
    GROUP BY gt.id, p.datum
    HAVING p.datum IS NOT NULL
),
prisutni_korigirani AS (
    SELECT 
        trening_id,
        COUNT(*) AS broj_termina,
        SUM(LEAST(broj_prisutnih, max_clanova)) AS efektivno_prisutnih
    FROM termini
    GROUP BY trening_id
),
grupni_statistika AS (
    SELECT 
        gt.id,
        gt.naziv,
        gt.dan_u_tjednu,
        gt.cijena_po_terminu,
        gt.max_clanova,
        COALESCE(pk.broj_termina, 0) AS broj_termina,
        COALESCE(pk.efektivno_prisutnih, 0) AS efektivno_prisutnih,
        CONCAT(t.ime, ' ', t.prezime) AS trener
    FROM grupni_trening gt
    JOIN trener t ON gt.id_trenera = t.id
    LEFT JOIN prisutni_korigirani pk ON gt.id = pk.trening_id
    WHERE gt.aktivan = TRUE
)
SELECT 
    naziv,
    dan_u_tjednu,
    trener,
    cijena_po_terminu,
    max_clanova,
    broj_termina,
    max_clanova * broj_termina AS ukupni_kapacitet,
    efektivno_prisutnih AS ukupno_prisutnih,
    ROUND(efektivno_prisutnih * cijena_po_terminu, 2) AS ukupni_prihod,
    ROUND(efektivno_prisutnih / NULLIF(broj_termina, 0), 1) AS prosječno_prisutnih_po_terminu,
    ROUND((efektivno_prisutnih / NULLIF(broj_termina * max_clanova, 0)) * 100, 2) AS iskorištenost_kapaciteta,
    CASE 
        WHEN efektivno_prisutnih * cijena_po_terminu > 1000 THEN 'Vrlo profitabilan'
        WHEN efektivno_prisutnih * cijena_po_terminu > 500 THEN 'Profitabilan'
        WHEN efektivno_prisutnih * cijena_po_terminu > 200 THEN 'Umjereno profitabilan'
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
    SUM(p.prisutan = TRUE) AS prisutni,
    SUM(p.prisutan = FALSE) AS odsutni,
    ROUND(SUM(p.prisutan = TRUE) * 100.0 / NULLIF(COUNT(p.id), 0), 2) AS postotak_prisutnosti,
    MAX(p.datum) AS zadnji_dolazak,
    DATEDIFF(CURRENT_DATE, MAX(p.datum)) AS dana_od_zadnjeg_dolaska
FROM clan c
JOIN clanarina cl ON c.id_clanarina = cl.id
LEFT JOIN prisutnost_grupni p ON c.id = p.id_clana
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
LEFT JOIN prisutnost_grupni p 
    ON gt.id = p.id_grupnog_treninga 
    AND p.datum >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
WHERE gt.aktivan = TRUE
GROUP BY gt.dan_u_tjednu, gt.vrijeme
ORDER BY 
    FIELD(gt.dan_u_tjednu, 'Ponedjeljak', 'Utorak', 'Srijeda', 'Četvrtak', 'Petak', 'Subota', 'Nedjelja'),
    gt.vrijeme;
