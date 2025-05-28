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
    cijena DECIMAL(6,2) NOT NULL CHECK (cijena >= 0),
    trajanje INT NOT NULL CHECK (trajanje > 0),
    opis TEXT
);

-- Podaci za vrste članarina (Martina Ilić)
INSERT INTO clanarina (tip, cijena, trajanje, opis) VALUES
('Osnovna', 29.99, 30, 'Pristup svim osnovnim spravama'),
('Napredna', 49.99, 30, 'Pristup svim spravama i grupnim treninzima'),
('Premium', 69.99, 30, 'Svi treninzi + 1x tjedno individualni trening'),
('Student - Basic', 19.99, 30, 'Osnovni pristup za studente - samo teretana'),
('Student - Plus', 29.99, 30, 'Pristup za studente - teretana + grupni treninzi'),
('Godišnja Standard', 299.99, 365, 'Godišnja članarina s 15% popusta'),
('Godišnja Premium', 399.99, 365, 'Godišnja premium članarina s 20% popusta'),
('Probna', 0, 1, 'Probni trening');

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
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Podaci za članove (Martina Ilić)
INSERT INTO clan (ime, prezime, email, telefon, datum_uclanjenja, id_clanarina, datum_rodjenja, spol, adresa, grad) VALUES
('Ivana', 'Krpan', 'ivana.krpan@example.com', '0911234567', '2023-06-15', 1, '1995-03-12', 'Ž', 'Ilica 1', 'Zagreb'),
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
('Matej', 'Pavić', 'matej.pavic@example.com', '0975555444', '2024-06-12', 8, '1998-07-19', 'M', 'Kaptol 20', 'Zagreb'),
('Lucija', 'Dragić', 'lucija.dragic@example.com', '0986666555', '2023-12-07', 2, '1990-12-01', 'Ž', 'Miramarska 100', 'Zagreb'),
('Antonio', 'Blažević', 'antonio.blazevic@example.com', '0917777666', '2022-05-19', 3, '1995-09-13', 'M', 'Amruševa 5', 'Zagreb'),
('Nikolina', 'Katić', 'nikolina.katic@example.com', '0928888777', '2024-01-24', 6, '1986-03-05', 'Ž', 'Tratinska 25', 'Zagreb'),
('Josip', 'Mandić', 'josip.mandic@example.com', '0939999888', '2023-07-11', 7, '1992-10-20', 'M', 'Heinzelova 70', 'Zagreb'),
('Petra', 'Cvitković', 'petra.cvitkovic@example.com', '0940000999', '2022-11-28', 1, '1988-01-16', 'Ž', 'Jurišićeva 12', 'Zagreb'),
('Mateo', 'Rašić', 'mateo.rasic@example.com', '0951111222', '2024-03-17', 4, '1997-06-28', 'M', 'Deželićeva 60', 'Zagreb'),
('Laura', 'Tomić', 'laura.tomic@example.com', '0962222333', '2023-04-14', 5, '1993-11-11', 'Ž', 'Nova Ves 10', 'Zagreb'),
('Bruno', 'Galić', 'bruno.galic@example.com', '0973333444', '2022-08-05', 8, '1989-05-23', 'M', 'Rooseveltov trg 6', 'Zagreb'),
('Valentina', 'Lukić', 'valentina.lukic@example.com', '0984444555', '2024-02-29', 2, '1996-08-09', 'Ž', 'Bogovićeva 3', 'Zagreb'),
('Hrvoje', 'Milošević', 'hrvoje.milosevic@example.com', '0915555666', '2023-10-21', 3, '1984-12-17', 'M', 'Klaićeva 18', 'Zagreb'),
('Tea', 'Perić', 'tea.peric@example.com', '0926666777', '2022-06-13', 6, '1998-02-28', 'Ž', 'Šubićeva 29', 'Zagreb'),
('Domagoj', 'Barbarić', 'domagoj.barbaric@example.com', '0987777888', '2024-05-02', 7, '1991-07-04', 'M', 'Radićeva 50', 'Zagreb'),
('Klara', 'Rukavina', 'klara.rukavina@example.com', '0948888999', '2023-09-08', 1, '1995-10-15', 'Ž', 'Marulićev trg 14', 'Zagreb'),
('Nikola', 'Đurić', 'nikola.djuric@example.com', '0959999000', '2022-12-16', 4, '1987-04-02', 'M', 'Zrinjevac 8', 'Zagreb'),
('Dora', 'Stanić', 'dora.stanic@example.com', '0960000111', '2024-07-23', 5, '1999-01-07', 'Ž', 'Teslina 12', 'Zagreb'),
('Vedran', 'Antić', 'vedran.antic@example.com', '0971111333', '2023-05-30', 8, '1990-09-22', 'M', 'Draškovićeva 45', 'Zagreb'),
('Anja', 'Filipović', 'anja.filipovic@example.com', '0982222444', '2022-04-06', 2, '1994-06-12', 'Ž', 'Petrinjska 35', 'Zagreb'),
('Marko', 'Zadravec', 'marko.zadravec@example.com', '0993333555', '2024-08-14', 3, '1988-03-25', 'M', 'Varsavska 20', 'Zagreb'),
('Nina', 'Bošnjak', 'nina.bosnjak@example.com', '0914444666', '2023-01-27', 6, '1997-11-08', 'Ž', 'Vlaška 80', 'Zagreb'),
('Marin', 'Crnković', 'marin.crnkovic@example.com', '0925555777', '2022-09-12', 7, '1985-08-14', 'M', 'Masarykova 15', 'Zagreb'),
('Ivona', 'Mihaljević', 'ivona.mihaljevic@example.com', '0986666888', '2024-06-20', 1, '1996-12-03', 'Ž', 'Praška 25', 'Zagreb'),
('Stipe', 'Lovrić', 'stipe.lovric@example.com', '0947777999', '2023-11-15', 4, '1992-02-19', 'M', 'Runjaninova 10', 'Zagreb'),
('Lana', 'Ježić', 'lana.jezic@example.com', '0958888111', '2022-03-09', 5, '1989-07-31', 'Ž', 'Ribnjak 5', 'Zagreb'),
('David', 'Petrić', 'david.petric@example.com', '0969999222', '2024-04-25', 8, '1998-05-06', 'M', 'Demetrova 22', 'Zagreb');

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
    godine_iskustva INT DEFAULT 0,
    aktivan BOOLEAN DEFAULT TRUE
);

-- Podaci za trenere (Karlo Perić)
INSERT INTO trener (ime, prezime, specijalizacija, email, telefon, datum_zaposlenja, godine_iskustva) VALUES
('Marko', 'Marić', 'Kondicijska priprema', 'marko.maric@teretana.com', '0914445555', '2021-03-15', 8),
('Lana', 'Lukić', 'Rehabilitacija', 'lana.lukic@teretana.com', '0926667777', '2020-06-01', 10),
('Petar', 'Perović', 'Bodybuilding', 'petar.perovic@teretana.com', '0937778888', '2019-09-10', 12),
('Ana', 'Anić', 'Funkcionalni trening', 'ana.anic@teretana.com', '0948889999', '2022-01-20', 6),
('Filip', 'Maričić', 'Rehabilitacija', 'filip.maricic@teretana.com', '0938140416', '2021-11-05', 7),
('Ante', 'Babić', 'Kardio trening', 'ante.babic@teretana.com', '0954704637', '2020-08-12', 9),
('Tomislav', 'Dominković', 'Kardio trening', 'tomislav.dominkovic@teretana.com', '0944821369', '2022-04-18', 5),
('Lucija', 'Šimić', 'Rehabilitacija', 'lucija.simic@teretana.com', '0938035781', '2019-12-01', 11),
('Martina', 'Nevest', 'CrossFit', 'martina.kovac@teretana.com', '0983317492', '2021-07-22', 8),
('Davor', 'Šimić', 'Pilates', 'davor.simic@teretana.com', '0977012538', '2020-02-14', 10),
('Nikola', 'Kovač', 'Kardio trening', 'nikola.kovac@teretana.com', '0949105376', '2023-01-10', 4),
('Martina', 'Jukić', 'CrossFit', 'martina.jukic@teretana.com', '0989823661', '2021-05-30', 7),
('Lucija', 'Babić', 'Yoga', 'lucija.babic@teretana.com', '0961781794', '2019-10-20', 13),
('Martina', 'Kovačić', 'CrossFit', 'martina.kovacic@teretana.com', '0931873048', '2022-03-15', 5),
('Maja', 'Pavić', 'Snaga i izdržljivost', 'maja.pavic@teretana.com', '0952211757', '2020-11-08', 9),
('Igor', 'Matić', 'Powerlifting', 'igor.matic@teretana.com', '0911122334', '2021-09-01', 8),
('Sanja', 'Vidović', 'Yoga', 'sanja.vidovic@teretana.com', '0922233445', '2020-04-15', 10),
('Dino', 'Radić', 'Funkcionalni trening', 'dino.radic@teretana.com', '0933344556', '2022-06-20', 6);

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
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Podaci za treninge (Karlo Perić)
INSERT INTO trening (id_clana, id_trenera, tip_treninga, datum, vrijeme, trajanje, status, cijena) VALUES
(1, 1, 'Kondicijski', '2025-05-05', '09:00:00', 60, 'održan', 20.00),
(2, 2, 'Rehabilitacija', '2025-05-05', '10:30:00', 45, 'održan', 25.00),
(3, 3, 'Bodybuilding', '2025-05-06', '11:00:00', 90, 'održan', 30.00),
(4, 4, 'Funkcionalni', '2025-05-06', '12:00:00', 60, 'zakazan', 22.00),
(5, 5, 'Rehabilitacija', '2025-05-07', '13:00:00', 45, 'održan', 25.00),
(6, 6, 'Kardio', '2025-05-07', '14:00:00', 60, 'održan', 18.00),
(7, 7, 'Kardio', '2025-05-08', '15:00:00', 60, 'održan', 18.00),
(1, 8, 'Rehabilitacija', '2025-05-08', '16:00:00', 45, 'održan', 25.00),
(2, 9, 'CrossFit', '2025-05-09', '17:00:00', 60, 'zakazan', 28.00),
(3, 10, 'Pilates', '2025-05-09', '18:00:00', 60, 'održan', 20.00),
(4, 11, 'Kardio', '2025-05-10', '09:00:00', 45, 'održan', 18.00),
(5, 12, 'CrossFit', '2025-05-10', '10:00:00', 60, 'održan', 28.00),
(6, 13, 'Yoga', '2025-05-11', '11:00:00', 60, 'održan', 22.00),
(7, 14, 'CrossFit', '2025-05-11', '12:00:00', 60, 'zakazan', 28.00),
(1, 15, 'Snaga', '2025-05-12', '13:00:00', 75, 'održan', 30.00),
(2, 16, 'Powerlifting', '2025-05-12', '14:00:00', 90, 'održan', 35.00),
(3, 17, 'Yoga', '2025-05-13', '15:00:00', 60, 'održan', 22.00),
(4, 18, 'Funkcionalni', '2025-05-13', '16:00:00', 60, 'održan', 22.00),
(5, 1, 'Kondicijski', '2025-05-14', '17:00:00', 60, 'zakazan', 20.00),
(6, 2, 'Rehabilitacija', '2025-05-14', '18:00:00', 45, 'održan', 25.00);

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
    cijena_po_terminu DECIMAL(5,2) NOT NULL CHECK (cijena_po_terminu > 0),
    aktivan BOOLEAN DEFAULT TRUE,
    opis TEXT,
    FOREIGN KEY (id_trenera) REFERENCES trener(id) ON DELETE RESTRICT ON UPDATE CASCADE
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
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_grupnog_treninga) REFERENCES grupni_trening(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_clan_trening_datum (id_clana, id_grupnog_treninga, datum)
);

-- Podaci za prisutnost (Marko Aleksić)
INSERT INTO prisutnost (id_clana, id_grupnog_treninga, datum, prisutan) VALUES
(1, 1, '2025-05-05', TRUE),
(2, 2, '2025-05-05', TRUE),
(3, 3, '2025-05-06', TRUE),
(4, 4, '2025-05-06', FALSE),
(5, 5, '2025-05-07', TRUE),
(6, 6, '2025-05-07', TRUE),
(7, 7, '2025-05-08', TRUE),
(1, 8, '2025-05-08', TRUE),
(2, 9, '2025-05-09', TRUE),
(3, 10, '2025-05-09', TRUE),
(4, 11, '2025-05-10', TRUE),
(5, 10, '2025-05-10', TRUE),
(6, 1, '2025-05-11', FALSE),
(7, 2, '2025-05-11', TRUE),
(1, 3, '2025-05-12', TRUE),
(2, 4, '2025-05-12', TRUE),
(3, 5, '2025-05-13', TRUE),
(4, 6, '2025-05-13', TRUE),
(5, 7, '2025-05-14', TRUE),
(6, 8, '2025-05-14', TRUE),
(7, 9, '2025-05-15', TRUE),
(1, 10, '2025-05-15', TRUE),
(2, 11, '2025-05-16', TRUE),
(3, 9, '2025-05-16', TRUE),
(4, 1, '2025-05-17', TRUE),
(5, 2, '2025-05-17', TRUE),
(6, 3, '2025-05-18', TRUE),
(7, 4, '2025-05-18', TRUE);

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
    proizvođač VARCHAR(50),
    model VARCHAR(50),
    garancija_do DATE
);

-- Podaci za opremu (Vladan)
INSERT INTO oprema (sifra, naziv, datum_nabave, stanje, vrijednost, proizvođač, model, garancija_do) VALUES
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
    CHECK (vrijeme_zavrsetka > vrijeme_pocetka)
);

-- Podaci za rezervacije opreme (Vladan)
INSERT INTO rezervacija_opreme (id_clana, id_opreme, datum, vrijeme_pocetka, vrijeme_zavrsetka, status) VALUES
-- Popunjeno prema postojećim članovima (id_clana: 1-15), opremi (id_opreme: 1-30), i realnim datumima
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

-- Podaci za osoblje (Marko Kovač)
INSERT INTO osoblje (ime, prezime, uloga, email, telefon, datum_zaposlenja, placa, radno_vrijeme) VALUES
('Ivana', 'Horvat', 'Recepcionist', 'ivana.horvat@teretana.com', '0911111111', '2022-01-10', 900.00, '06:00-14:00'),
('Marko', 'Novak', 'Voditelj', 'marko.novak@teretana.com', '0922222222', '2021-03-01', 1600.00, '08:00-16:00'),
('Ana', 'Kovač', 'Čistačica', 'ana.kovac@teretana.com', '0933333333', '2023-05-15', 700.00, '14:00-22:00'),
('Petar', 'Barišić', 'Održavanje', 'petar.barisic@teretana.com', '0944444444', '2022-09-20', 1100.00, '08:00-16:00'),
('Lucija', 'Jurić', 'Administrator', 'lucija.juric@teretana.com', '0955555555', '2021-12-01', 1400.00, '09:00-17:00'),
('Maja', 'Grgić', 'Nutricionist', 'maja.grgic@teretana.com', '0966666666', '2023-02-10', 1300.00, '10:00-18:00'),
('Tomislav', 'Vuković', 'Recepcionist', 'tomislav.vukovic@teretana.com', '0977777777', '2024-01-15', 900.00, '14:00-22:00'),
('Martina', 'Babić', 'Čistačica', 'martina.babic@teretana.com', '0988888888', '2022-06-01', 700.00, '06:00-14:00'),
('Dino', 'Radić', 'Održavanje', 'dino.radic@teretana.com', '0999999999', '2023-03-20', 1100.00, '14:00-22:00'),
('Sanja', 'Vidović', 'Administrator', 'sanja.vidovic@teretana.com', '0910000000', '2022-11-10', 1400.00, '12:00-20:00');

-- Tablica: placanje (Marko Kovač)
CREATE TABLE placanje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_clana INT NOT NULL,
    id_clanarina INT NOT NULL,
    iznos DECIMAL(6,2) NOT NULL CHECK (iznos > 0),
    datum_uplate DATE NOT NULL,
    nacin_placanja ENUM('gotovina', 'kartica', 'transfer', 'PayPal', 'kripto') DEFAULT 'kartica',
    broj_racuna VARCHAR(20) UNIQUE,
    popust DECIMAL(5,2) DEFAULT 0.00,
    id_osoblje INT NOT NULL,
    FOREIGN KEY (id_clana) REFERENCES clan(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_clanarina) REFERENCES clanarina(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_osoblje) REFERENCES osoblje(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Podaci za plaćanja (Marko Kovač)
INSERT INTO placanje (id_clana, id_clanarina, iznos, datum_uplate, nacin_placanja, broj_racuna, popust, id_osoblje) VALUES
(1, 1, 25.00, '2024-06-15', 'kartica', 'R-2024-001', 0.00, 1),
(2, 2, 45.50, '2024-07-10', 'gotovina', 'R-2024-002', 0.00, 2),
(3, 3, 75.99, '2024-08-01', 'kartica', 'R-2024-003', 0.00, 1),
(4, 1, 25.00, '2024-08-20', 'transfer', 'R-2024-004', 0.00, 7),
(5, 2, 45.50, '2024-09-12', 'gotovina', 'R-2024-005', 0.00, 2),
(6, 3, 75.99, '2024-10-04', 'kartica', 'R-2024-006', 0.00, 1),
(7, 4, 15.00, '2024-11-07', 'kartica', 'R-2024-007', 0.00, 7),
(1, 1, 25.00, '2024-12-15', 'kartica', 'R-2024-008', 0.00, 1),
(2, 2, 45.50, '2025-01-10', 'gotovina', 'R-2025-009', 0.00, 2),
(3, 3, 75.99, '2025-02-01', 'kartica', 'R-2025-010', 0.00, 1),
(4, 1, 25.00, '2025-02-20', 'transfer', 'R-2025-011', 0.00, 7),
(5, 2, 45.50, '2025-03-12', 'gotovina', 'R-2025-012', 0.00, 2),
(6, 3, 75.99, '2025-04-04', 'kartica', 'R-2025-013', 0.00, 1),
(7, 4, 15.00, '2025-05-07', 'kartica', 'R-2025-014', 0.00, 7),
(8, 5, 22.50, '2025-05-10', 'kartica', 'R-2025-015', 0.00, 1),
(9, 6, 280.00, '2025-05-12', 'transfer', 'R-2025-016', 0.00, 2),
(10, 7, 450.00, '2025-05-15', 'kartica', 'R-2025-017', 0.00, 1),
(11, 8, 120.00, '2025-05-18', 'gotovina', 'R-2025-018', 0.00, 7),
(12, 1, 23.75, '2025-05-20', 'kartica', 'R-2025-019', 5.00, 2),
(13, 2, 40.93, '2025-05-22', 'transfer', 'R-2025-020', 10.00, 1);
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

    

-- UPIT 8: ROI (Return on Investment) za opremu
SELECT 
    o.id,
    o.naziv,
    o.vrijednost AS investicija,
    COALESCE(SUM(potencijal_prihod), 0) AS ukupni_prihod,
    ROUND(COALESCE(SUM(potencijal_prihod), 0) / o.vrijednost, 2) AS ROI,
    COUNT(DISTINCT ro.id) AS broj_rezervacija,
    SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)) AS ukupno_minuta_koristenja
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme AND ro.status != 'otkazana'
LEFT JOIN (
    SELECT 
        r.id,
        CASE 
            WHEN gt.cijena_po_terminu IS NOT NULL THEN gt.cijena_po_terminu
            ELSE 0
        END AS potencijal_prihod
    FROM rezervacija_opreme r
    LEFT JOIN clan c ON r.id_clana = c.id
    LEFT JOIN prisutnost p ON c.id = p.id_clana AND p.datum = r.datum
    LEFT JOIN grupni_trening gt ON p.id_grupnog_treninga = gt.id
    WHERE r.status != 'otkazana'
) AS prihod ON ro.id = prihod.id
GROUP BY o.id
ORDER BY ROI DESC, ukupni_prihod DESC;

-- UPIT 9: Pregled neaktivnih članova (nisu imali aktivnosti u zadnjih 30 dana)
-- UPIT 10: Kompleksna statistika teretane - mjesečni dashboard
-- UPIT 10: Kompleksna statistika teretane - mjesečni dashboard
SELECT
    godina,
    mjesec,
    -- Članstvo
    COUNT(DISTINCT c.id) AS aktivni_clanovi,
    SUM(CASE WHEN c.datum_uclanjenja BETWEEN prvi_dan AND zadnji_dan THEN 1 ELSE 0 END) AS novi_clanovi,
    -- Treninzi
    COUNT(DISTINCT t.id) AS individualni_treninzi,
    COUNT(DISTINCT p.id) AS grupni_dolazci,
    -- Oprema
    COUNT(DISTINCT r.id) AS rezervacije_opreme,
    -- Financije
    SUM(pl.iznos) AS ukupni_prihod,
    SUM(pl.popust) AS ukupni_popusti,
    -- Prosječna potrošnja po članu
    ROUND(SUM(pl.iznos) / NULLIF(COUNT(DISTINCT c.id),0), 2) AS prosjecna_potrosnja_po_clanu,
    -- Najpopularniji trening
    (SELECT tip_treninga FROM trening t2 WHERE YEAR(t2.datum)=godina AND MONTH(t2.datum)=mjesec GROUP BY tip_treninga ORDER BY COUNT(*) DESC LIMIT 1) AS najpopularniji_trening,
    -- Najkorištenija oprema
    (SELECT o.naziv FROM rezervacija_opreme r2 JOIN oprema o ON r2.id_opreme=o.id WHERE YEAR(r2.datum)=godina AND MONTH(r2.datum)=mjesec GROUP BY o.naziv ORDER BY COUNT(*) DESC LIMIT 1) AS najkorištenija_oprema
FROM
    (
        SELECT
            YEAR(datum) AS godina,
            MONTH(datum) AS mjesec,
            MIN(DATE(datum)) AS prvi_dan,
            MAX(DATE(datum)) AS zadnji_dan
        FROM (
            SELECT datum_uclanjenja AS datum FROM clan
            UNION ALL SELECT datum FROM trening
            UNION ALL SELECT datum FROM prisutnost
            UNION ALL SELECT datum FROM rezervacija_opreme
            UNION ALL SELECT datum_uplate FROM placanje
        ) datumi
        GROUP BY godina, mjesec
    ) kalendar
LEFT JOIN clan c ON YEAR(c.datum_uclanjenja)=kalendar.godina AND MONTH(c.datum_uclanjenja)=kalendar.mjesec
LEFT JOIN trening t ON YEAR(t.datum)=kalendar.godina AND MONTH(t.datum)=kalendar.mjesec AND t.status='održan'
LEFT JOIN prisutnost p ON YEAR(p.datum)=kalendar.godina AND MONTH(p.datum)=kalendar.mjesec AND p.prisutan=TRUE
LEFT JOIN rezervacija_opreme r ON YEAR(r.datum)=kalendar.godina AND MONTH(r.datum)=kalendar.mjesec AND r.status!='otkazana'
LEFT JOIN placanje pl ON YEAR(pl.datum_uplate)=kalendar.godina AND MONTH(pl.datum_uplate)=kalendar.mjesec
GROUP BY godina, mjesec
ORDER BY godina DESC, mjesec DESC;

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
        0 AS klijenati_smanjili_tezinu
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
;
