-- Deliverable 1:  The Number of Retiring Employees by Title
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO num_ret_emp
FROM titles AS t
    LEFT JOIN employees as e
        ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

COPY num_ret_emp
TO 'C:\Users\Public\retirement_titles.csv'
DELIMITER ','
CSV HEADER;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO uniq_ret_titles
FROM num_ret_emp AS rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

COPY uniq_ret_titles
TO 'C:\Users\Public\unique_titles.csv'
DELIMITER ','
CSV HEADER;

-- Retrieve the number of employees by their most recent job title
SELECT COUNT (ut.emp_no), ut.title
INTO retiring_titles
FROM uniq_ret_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC;

COPY retiring_titles
TO 'C:\Users\Public\retiring_titles.csv'
DELIMITER ','
CSV HEADER;


-- Deliverable 2:  The Employees Eligible for the Mentorship Program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO elig_mentor
FROM employees AS e
    INNER JOIN department_employees AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

COPY elig_mentor
TO 'C:\Users\Public\mentorship_eligibility.csv'
DELIMITER ','
CSV HEADER;