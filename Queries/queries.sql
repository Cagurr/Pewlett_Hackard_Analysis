-- Determine the retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     managers.emp_no,
     managers.from_date,
     managers.to_date
FROM departments
INNER JOIN managers
ON departments.dept_no = managers.dept_no;

-- Joining retirement_info and department_employees tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    department_employees.to_date
FROM retirement_info
LEFT JOIN department_employees
ON retirement_info.emp_no = department_employees.emp_no;

-- Join retirement_info and department_employees tables with aliases
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN department_employees as de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables with aliases
SELECT d.dept_name,
     m.emp_no,
     m.from_date,
     m.to_date
FROM departments as d
INNER JOIN managers as m
ON d.dept_no = m.dept_no;

-- Join retirement_info and department_employees tables to find current employees
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN department_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_counts
FROM current_emp as ce
LEFT JOIN department_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Query to export table to csv
COPY emp_counts
TO 'C:\Users\Public\emp_counts.csv'
DELIMITER ','
CSV HEADER;

-- Employee Info: List of employees with employee number, first and last name, gender, and salary
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN department_employees as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

COPY emp_info
TO 'C:\Users\Public\emp_info.csv'
DELIMITER ','
CSV HEADER;

--Management Info: List of managers for each department with department number, department name, manager's employee number, first and last name, starting and ending date of employment
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM managers AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

COPY manager_info
TO 'C:\Users\Public\mgmt_info.csv'
DELIMITER ','
CSV HEADER;

--Department Retirees: Updated current_emp list with a new employee department attribute
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    d.dept_name
INTO dept_info
FROM current_emp as ce
    INNER JOIN department_employees as de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments as d
        ON (de.dept_no = d.dept_no);

COPY dept_info
TO 'C:\Users\Public\dept_info.csv'
DELIMITER ','
CSV HEADER;

-- Sales-specific retirement information list
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    d.dept_name
INTO sales_emp
FROM retirement_info as ri
    INNER JOIN department_employees as de
        ON (ri.emp_no = de.emp_no)
    INNER JOIN departments as d
        ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (d.dept_no = 'd007');

COPY sales_emp
TO 'C:\Users\Public\sales_dept_info.csv'
DELIMITER ','
CSV HEADER;

-- Sales and Development-specific retirement information list
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    d.dept_name
INTO sales_dev_emp
FROM retirement_info as ri
    INNER JOIN department_employees as de
        ON (ri.emp_no = de.emp_no)
    INNER JOIN departments as d
        ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (d.dept_no IN ('d007','d005'));

COPY sales_dev_emp
TO 'C:\Users\Public\sales_dev_info.csv'
DELIMITER ','
CSV HEADER;