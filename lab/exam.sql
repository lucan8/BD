/*Lucan Cristian Stefan 152 NR 1*/
/*1*/
SELECT t.id "Cod turist", t.nume || ' ' || t.prenume "Nume si Prenume turist", h.id "Cod hotel",
h.denumire "Denumire hotel", h.nr_stele "Nr.stele", f.denumire "Denumire facilitate", r.data_rezervare "Data rezervare"
FROM hotel h JOIN camera c ON c.id_hotel = h.id
JOIN rezervare r ON r.id_camera = c.id
LEFT JOIN facilitati_hotel fh ON fh.id_hotel = h.id
LEFT JOIN facilitate f ON f.id = fh.id_facilitate
JOIN turist_rezervare tr ON tr.id_rezervare = r.id
JOIN turist t ON t.id = tr.id_turist
WHERE data_rezervare >= to_date('01-JAN-2023', 'dd-MON-YYYY') AND
data_rezervare <= to_date('31-DEC-2023', 'dd-MON-YYYY');

/*2*/
CREATE VIEW aux AS 
SELECT h.id, h.denumire, COUNT(DISTINCT t.id) nr_tur, SUM(tc.tarif) s
FROM hotel h JOIN camera c ON c.id_hotel = h.id
JOIN tarif_camera tc ON tc.id_camera = c.id
JOIN rezervare r ON r.id_camera = c.id
JOIN turist_rezervare tr ON tr.id_rezervare = r.id
JOIN turist t ON t.id = tr.id_turist
WHERE nr_zile = 1
GROUP BY h.id, h.denumire;

SELECT a.id, a.denumire, a.s FROM aux a
WHERE a.nr_tur = (SELECT MAX(nr_tur) FROM aux);
/*3*/
/*Obtinem facilitatile tabelului din CONSTANTA cu 3 stele*/
CREATE VIEW facilitati_constanta AS
SELECT f.id id_fac, f.denumire den_fac, h.id id_hotel FROM facilitate f
JOIN facilitati_hotel fh ON  fh.id_facilitate = f.id
JOIN hotel h ON h.id = fh.id_hotel
WHERE nr_stele = 3 AND upper(h.localitate) = 'CONSTANTA';

/*Cele care au facilitatile celor din constanta*/
CREATE VIEW hotele_smek AS 
SELECT h.id, h.denumire, COUNT(f.id) nr_fac FROM facilitate f
JOIN facilitati_hotel fh ON fh.id_facilitate = f.id
JOIN hotel h ON h.id = fh.id_hotel
WHERE f.id in (SELECT id_fac FROM facilitati_constanta) AND h.id not in (SELECT id_hotel FROM facilitati_constanta)
GROUP BY h.id, h.denumire;

/*Selectam informatiile necesare pt tabele care intalnesc cond*/
SELECT h.id, h.denumire, f.denumire FROM hotele_smek h
JOIN facilitati_hotel fh ON fh.id_hotel = h.id
JOIN facilitate f ON f.id = fh.id_facilitate
WHERE h.nr_fac = (SELECT COUNT(*) FROM facilitati_constanta);
/*4*/
/*MET1*/
CREATE TABLE CAPACITATE_HOTEL AS
SELECT h.id cod_hotel, h.denumire nume_hotel, SUM(c.capacitate) capacitate FROM hotel h
JOIN camera c ON c.id_hotel = h.id
GROUP BY h.id, h.denumire;
/*MET2*/
CREATE TABLE CAPACITATE_HOTEL(
    cod_hotel int primary key not null,
    nume_hotel varchar(100),
    capacitate int
);

INSERT INTO CAPACITIATE_HOTEL VALUES(
SELECT h.id, h.denumire, SUM(c.capacitate) FROM hotel h
JOIN camera c ON c.id_hotel = h.id
GROUP BY h.id, h.denumire);