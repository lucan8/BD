/*
DESCRIBE employees;
DESCRIBE jobs;
DESCRIBE job_history;
DESCRIBE departments;
DESCRIBE locations;
DESCRIBE countries;
DESCRIBE regions;
*/

/*
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM job_history;
SELECT * FROM locations;
SELECT * FROM countries;
SELECT * FROM regions;
*/

/* 4. 
SELECT employee_id, first_name, job_id, hire_date FROM employees;

/*6.
SELECT (first_name || ', ' || last_name || ', ' || job_id) "Detalii angajat" FROM employees;


/*7
SELECT (first_name || ' ' || last_name) "employee name", salary FROM employees WHERE salary > 2850;

/*8
SELECT (first_name || ' ' || last_name) "employee name", department_id FROM employees WHERE employee_id = 104;

/*9
SELECT (first_name || ' ' || last_name) "employee name", salary FROM employees WHERE salary < 1400 OR salary > 24000;
SELECT (first_name || ' ' || last_name) "employee name", salary FROM employees WHERE salary BETWEEN 3000 AND 7000;
SELECT (first_name || ' ' || last_name) "employee name", salary FROM employees WHERE salary >= 3000 AND salary <= 7000;

/*10 Diferenta intre start_date si hire_date
SELECT employees.first_name, jobs.job_title, start_date FROM job_history 
INNER JOIN employees ON employees.employee_id = job_history.employee_id
INNER JOIN jobs ON jobs.job_id = job_history.job_id;
WHERE start_date BETWEEN to_date('20-FEB-1987','DD-MON-YYYY') AND to_date('01-MAY-1989','DD-MON-YYYY') ORDER BY start_date;
/*11
SELECT first_name, department_id FROM employees WHERE department_id in (10, 30) ORDER BY first_name;
/*12
SELECT first_name "Angajat", salary "Salariu lunar" FROM employees WHERE department_id in (10, 30) AND salary > 1500 ORDER BY first_name;
/*13
SELECT to_char(SYSDATE, 'dd.mm.yyyy') "DATE" FROM dual;
/*14
SELECT first_name, hire_date FROM employees WHERE TO_CHAR(hire_date, 'YYYY') = '1987' ORDER BY hire_date DESC;
SELECT first_name, hire_date FROM employees WHERE hire_date LIKE '%87%' ORDER BY hire_date DESC;

/*15
SELECT first_name, jobs.job_title FROM employees INNER JOIN jobs ON jobs.job_id = employees.job_id WHERE manager_id is NULL;

/*16
SELECT first_name, salary, commission_pct FROM employees WHERE commission_pct IS NOT NULL ORDER BY salary DESC, commission_pct DESC; 
/*17
SELECT first_name, salary, commission_pct FROM employees ORDER BY salary DESC, commission_pct DESC; 

/*18*
SELECT first_name FROM employees WHERE first_name LIKE '__a%';

/*19
SELECT first_name FROM employees WHERE first_name LIKE '%l%l%' AND department_id = 30 OR manager_id = 102;

/*20*/
SELECT first_name, salary, jobs.job_title "Job" FROM employees 
INNER JOIN jobs ON jobs.job_id = employees.job_id 
WHERE (upper(jobs.job_title) LIKE '%CLERK%' OR upper(jobs.job_title) LIKE '%REP%') AND salary NOT IN (1000, 2000, 3000) ORDER BY salary DESC;

