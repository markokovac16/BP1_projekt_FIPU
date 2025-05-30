DROP DATABASE IF EXISTS teretana;
CREATE DATABASE teretana;
USE teretana;

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
        WHEN COUNT(ro.id)  BETWEEN 5 AND 19 THEN 'Popularna'
        WHEN COUNT(ro.id) > 19 THEN 'Vrlo popularna'
        ELSE 'Normalno'
    END AS prioritet
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme AND ro.status != 'otkazana'
GROUP BY o.id
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

-- Učestalost korištenja opreme (Vladan)
CREATE OR REPLACE VIEW ucestalost_koristenja_opreme AS
SELECT 
    o.naziv AS oprema,
    COUNT() AS broj_koristenja,
    COUNT(DISTINCT ro.id_clana) AS broj_clanova,
    MAX(ro.datum) AS zadnje_koristenje,
    ROUND(COUNT() * 100.0 / (SELECT COUNT(*) FROM rezervacija_opreme), 2) AS postotak_od_svih
FROM oprema o
JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
WHERE ro.status = 'potvrđena'
GROUP BY o.id
HAVING broj_koristenja > 0
ORDER BY broj_koristenja DESC;

-- Oprema s najviše otkazivanja rezervacija (Vladan)
CREATE OR REPLACE VIEW otkazane_rezervacije_po_opremi AS
SELECT 
    o.naziv AS oprema,
    COUNT() AS broj_otkazanih,
    COUNT(DISTINCT ro.id_clana) AS broj_clanova,
    MAX(ro.datum) AS zadnje_otkazivanje,
    ROUND(COUNT() * 100.0 / (SELECT COUNT(*) FROM rezervacija_opreme WHERE status = 'otkazana'), 2) AS postotak_od_otkazanih
FROM oprema o
JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
WHERE ro.status = 'otkazana'
GROUP BY o.id
HAVING broj_otkazanih > 0
ORDER BY broj_otkazanih DESC; 

------------------------------------------------------------------------------------
-- Prikaz vrijenosti opreme ovisno o stanju (Vladan)
CREATE OR REPLACE VIEW vrijednost_opreme_po_stanju AS
SELECT
    o.stanje,
    COUNT(*)              AS broj_opreme,
    SUM(o.vrijednost)     AS ukupna_vrijednost,
    ROUND(AVG(o.vrijednost), 2) AS prosjecna_vrijednost
FROM oprema o
GROUP BY o.stanje
ORDER BY ukupna_vrijednost DESC;


-- Prikaz statistike opreme (Vladan)
CREATE OR REPLACE VIEW oprema_statistika AS
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
    COUNT(ro.id) AS broj_rezervacija,
    COUNT(DISTINCT ro.id_clana) AS broj_razlicitih_korisnika,
    COALESCE(SUM(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)), 0) AS ukupno_trajanje_min,
    ROUND(COALESCE(AVG(TIMESTAMPDIFF(MINUTE, ro.vrijeme_pocetka, ro.vrijeme_zavrsetka)), 0), 1) AS prosjecno_trajanje_min,
    MAX(ro.datum) AS zadnja_rezervacija,
    DATEDIFF(o.garancija_do, CURRENT_DATE) AS dana_do_isteka_garancije
FROM oprema o
LEFT JOIN rezervacija_opreme ro 
    ON o.id = ro.id_opreme
    AND ro.status IN ('aktivna', 'završena')
GROUP BY
    o.id,
    o.sifra,
    o.naziv,
    o.proizvodac,
    o.model,
    o.stanje,
    o.vrijednost,
    o.datum_nabave,
    o.garancija_do
ORDER BY
    ukupno_trajanje_min DESC;

-----------------------------
         -- UPITI --
-----------------------------
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










