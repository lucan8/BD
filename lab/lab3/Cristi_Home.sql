/*6

SELECT department_id FROM departments WHERE department_name LIKE '%re%'

UNION

SELECT department_id FROM employees WHERE job_id = 'SA_REP' AND department_id IS NOT NULL;
*/

/*8*
/*Eficient minus
SELECT department_id FROM departments

MINUS

SELECT department_id FROM employees;

JOIN

SELECT d.department_id FROM departments d LEFT JOIN employees e ON e.department_id = d.department_id WHERE employee_id IS NULL;

/*Eficient
select department_id
from departments
where department_id not in 
    (select nvl(department_id, -1)
    from employees
    );
*/


    
