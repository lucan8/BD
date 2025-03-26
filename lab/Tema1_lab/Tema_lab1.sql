/*
1)(2p) Sa se afiseze numele, salariul, titlul jobului, codul si numele
departamentului, id-ul locatiei, orasul si tara in care lucreaza angajatii
condusi direct de �hunoldalexander� si care au fost angajati intre
01-07-1991 si 28-02-1999. Pe ultima coloana se va afisa numele
managerului (Hunold), concatenat cu spatiu, concatenat cu prenumele sau
(Alexander). Coloana o sa se numeasca Nume si Prenume Manager.
*/
SELECT E.first_name, E.last_name, E.salary, J.job_title,D.department_id, D.department_name,L.location_id, L.city, C.country_name,
M.first_name || ' ' || M.last_name AS "Nume si Prenume Manager"
FROM locations L
JOIN countries C ON  C.country_id = L.country_id
JOIN departments D ON D.location_id = L.location_id
JOIN employees M ON M.employee_id = D.manager_id
JOIN employees E ON E.department_id = D.department_id
JOIN jobs J ON E.job_id = J.job_id WHERE E.manager_id = 
(SELECT employee_id FROM employees WHERE first_name = 'Alexander' AND last_name = 'Hunold')
AND E.hire_date BETWEEN to_date('01-07-1991', 'dd-mm-yyyy') AND to_date('28-02-1999', 'dd-mm-yyyy');

/*
2. (3p) Sa se listeze codul departamentului, numele departamentului si codul
managerului de departament. In cazul in care un departament nu are
manager se va afisa pe coloana respectiva, in output, mesajul:
�Departamentul <department_id> nu are manager� (ex: Departamentul
120 nu are manager). Coloana se va numi �Manageri departamente�. De
asemenea, in cadrul aceleiasi cereri, sa se afiseze atat departamentele care
au angajati, cat si cele fara angajati. In cazul in care un departament are
angajati, se va afisa si codul acestor angajati (o coloana unde se vor afisa
codurile de angajati pentru fiecare departament in parte). Daca un
departament nu are angajati, se va afisa pe coloana respectiva, in output,
mesajul: �Departamentul nu are angajati�. Coloana se va numi �Angajati
departamente�. In final se vor afisa 4 coloane: department_id,
department_name, Angajati departamente, Manageri departamente.
In acest caz, fiind mai multe randuri returnate, atasati un singur print
screen care sa cuprinda toate cele 4 coloane, dar doar ultimele 25 de inregistrari.
*/
SELECT d.department_id, d.department_name, 
nvl(to_char(d.manager_id), 'Departamentul ' || to_char(d.department_id)|| ' nu are manager') AS "Manageri departamente",
nvl(to_char(e.employee_id), 'Departamentul nu are angajati') AS "Angajati departamente"
FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id ORDER BY d.department_id;
/*
3. (3p) Sa se afiseze codul si numele angajatilor, codul departamentului,
salariul si codul job-ului tuturor angaja?ilor care lucreaza in departamente
si al caror salariu si comision coincid cu salariul si comisionul unui
angajat din Oxford (scris exact asa).
*/
SELECT first_name, department_id, salary, job_id  FROM employees
WHERE department_id is not NULL AND (salary, commission_pct) IN 
(SELECT salary, commission_pct FROM employees WHERE department_id IN
(SELECT department_id FROM departments WHERE location_id = 
(SELECT location_id FROM locations WHERE city = 'Oxford')));
/*
4. (4p) Sa se creeze tabelele urmatoare CAMPANIE_PNU si
SPONSOR_PNU
Unde PNU se formeaza astfel:
� P -> prima litera din prenume
� NU -> primele doua litere din nume

CAMPANIE_PNU

( cod_campanie � cheie primara,

titlu -> titlul campaniei � nu poate fi null,
data_start -> data la care incepe campania � are implicit
valoarea sysdate,
data_end -> data la care se incheie campania � este o data
inserata in momentul inserarii inregistrarii in baza de date; aceasta data trebuie
sa fie mai mare decat data_start,
valoare -> pretul campaniei � poate fi null,
cod_sponsor � cheie externa
)

SPONSOR_PNU

( cod_sponsor � cheie primara,

nume -> denumirea sponsorului � nu poate fi null si trebuie sa
aiba o valoare unica,
email -> poate fi null si are o valoare unica
)
*/
CREATE TABLE CAMPANIE_CLU(
    cod_campanie INTEGER CONSTRAINT campanie_pk PRIMARY KEY,
    titlu VARCHAR2(50) NOT NULL,
    data_start DATE DEFAULT SYSDATE,
    data_end DATE,
    valoare VARCHAR2(50),
    cod_sponsor INTEGER,
    CONSTRAINT date_ck CHECK(data_start < data_end)
);
CREATE TABLE SPONSOR_CLU(
    cod_sponsor INTEGER CONSTRAINT sponsor_pk PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL CONSTRAINT nume_sponsor_uniq UNIQUE,
    email VARCHAR(100) CONSTRAINT email_sponsor_uniq UNIQUE
);
/*Adaugarea constraintului de foreign key pt cod_sponsor, cu stergere in cascada*/
ALTER TABLE campanie_clu 
ADD CONSTRAINT camp_cod_sponsor_fk FOREIGN KEY(cod_sponsor) REFERENCES sponsor_clu(cod_sponsor) ON DELETE CASCADE;

DESCRIBE campanie_clu;
DESCRIBE sponsor_clu;
/*
5. (3p) Sa se insereze in baza de date urmatoarele inregistrari, folosind la
alegere metoda implicita sau explicita, precizand varianta aleasa.
*/
INSERT ALL
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(10, 'CISCO', 'cisco@gmail.com')
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(20, 'KFC', NULL)
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(30, 'ADOBE', 'adobe@adobe.com')
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(40, 'BRD', NULL)
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(50, 'VODAFONE', 'vdf@gmail.com')
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(60, 'BCR', NULL)
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(70, 'SAMSUNG', NULL)
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(80, 'IBM', 'ibm@ibm.com')
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(90, 'OMV', NULL)
INTO sponsor_clu(cod_sponsor, nume, email) VALUES(100, 'ENEL', NULL)

INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(1, 'CAMP1', sysdate, to_date('20-06-2024', 'dd-mm-yyyy'), 1200, 10)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(2, 'CAMP2', sysdate, to_date('25-07-2024', 'dd-mm-yyyy'), 3400, 20)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(3, 'CAMP3', sysdate, to_date('10-06-2024', 'dd-mm-yyyy'), NULL, 30)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(4, 'CAMP4', sysdate, to_date('20-06-2024', 'dd-mm-yyyy'), NULL, 40)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(5, 'CAMP5', sysdate, to_date('05-06-2024', 'dd-mm-yyyy'), 2200, 50)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(6, 'CAMP6', sysdate, to_date('15-08-2024', 'dd-mm-yyyy'), NULL, 60)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(7, 'CAMP7', sysdate, to_date('02-09-2024', 'dd-mm-yyyy'), 5500, 70)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(8, 'CAMP8', sysdate, to_date('10-10-2024', 'dd-mm-yyyy'), NULL, 20)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(9, 'CAMP9', sysdate, to_date('10-06-2024', 'dd-mm-yyyy'), 4000, 30)
INTO campanie_clu(cod_campanie, titlu, data_start, data_end, valoare, cod_sponsor) VALUES(10, 'CAMP10', sysdate, to_date('25-09-2024', 'dd-mm-yyyy'), 3500, NULL)
SELECT 1 FROM dual;
SELECT * FROM campanie_clu;
SELECT * FROM sponsor_clu;
COMMIT;

/*
6. (2p) Sa se stearga campaniile care vor expira inainte de data 01-07-2024.
Se va adauga un print screen cu rezultatele ramase in urma stergerii, dupa
care se vor anula modificarile.
*/
DELETE FROM campanie_clu WHERE data_end < to_date('01-07-2024', 'dd-mm-yyyy');
SELECT * FROM campanie_clu;
ROLLBACK;


/*
7. (3p) Sa se modifice valoarea tuturor campaniilor, aplicandu-se o majorare
cu 25%. Daca o campanie nu are valoare, atunci ea este o campanie
caritabila si se va completa cu textul �Campanie Caritabila�. Se va atasa
in document un print cu valorile modificate (output-ul dupa rulare) dupa
care se vor anula modificarile.
*/
UPDATE campanie_clu SET valoare = nvl(to_char(valoare + 0.25 * valoare), 'Campanie Caritabila');
SELECT * FROM campanie_clu;
ROLLBACK;
/*
8. (3p) Sa se stearga sponsorul 20 din baza de date. Explicati in cuvinte
pasii necesari rezolvarii cu succes a cerintei. Dupa stergere anulati
modificarile.
*/
/*EXPLICATIE: campanie referentiaza sponsor prin cod_sponsor deci ne vom folosi de on delete cascade
pentru a sterge din ambele tabele in care apare sponsoru respectiv(fara on delete cascade ar fii trebuit
sa stergem mai intai din tabelul copil(campanie) apoi tabelul tata(sponsor)*/
DELETE FROM sponsor_clu WHERE cod_sponsor = 20;
ROLLBACK

/*
9. (2p) Stergeti sponsorii care nu sponsorizeaza nicio campanie. Dupa
stergere realizati un print screen output-ului (SELECT * FROM sponsor),
dupa care salvati modificarile.
*/
DELETE FROM sponsor_clu WHERE cod_sponsor NOT IN (SELECT cod_sponsor FROM campanie_clu WHERE cod_sponsor IS NOT NULL);
SELECT * FROM sponsor_clu;
ROLLBACK