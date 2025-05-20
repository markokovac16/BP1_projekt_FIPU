-- Pogled za sve rezervacije opreme s podacima o članu i opremi
CREATE VIEW pregled_rezervacija_opreme AS
SELECT 
    ro.id AS rezervacija_id,
    c.ime AS clan_ime,
    c.prezime AS clan_prezime,
    o.naziv AS oprema,
    ro.datum,
    ro.vrijeme_pocetka,
    ro.vrijeme_zavrsetka
FROM rezervacija_opreme ro
JOIN clan c ON ro.id_clana = c.id
JOIN oprema o ON ro.id_opreme = o.id;

-- Pogled broj rezervacija po članu
CREATE VIEW broj_rezervacija_po_clanu AS
SELECT 
    c.id AS clan_id,
    c.ime,
    c.prezime,
    COUNT(ro.id) AS broj_rezervacija
FROM clan c
LEFT JOIN rezervacija_opreme ro ON c.id = ro.id_clana
GROUP BY c.id;

-- Pogled broj rezervacija po opremi
CREATE VIEW broj_rezervacija_po_opremi AS
SELECT 
    o.id AS oprema_id,
    o.naziv,
    COUNT(ro.id) AS broj_rezervacija
FROM oprema o
LEFT JOIN rezervacija_opreme ro ON o.id = ro.id_opreme
GROUP BY o.id;
