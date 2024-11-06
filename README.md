##Data Modeling 
--please find attached a sketch an Entity Relationship Diagram 

##Data Engineering 
(please note: there was a process failure when I tried to import the files, did try to DROP the tables and recreate the schema) 
-create table for employees using foreign keys(title_i)d and primary keys(emp_no)

   CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    title_id VARCHAR(10) NOT NULL,
    birth_date DATE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    sex VARCHAR(1) NOT NULL,
    hire_date DATE,
    FOREIGN KEY (title_id) REFERENCES titles(title_id)
);

-create the table for departments, salaries,titles,depmartment manager, and depmartment employee 

CREATE TABLE titles (
    title_id VARCHAR(10) PRIMARY KEY,  
    title VARCHAR(50) NOT NULL
);

-- Insert titles data
INSERT INTO titles (title_id, title)
VALUES 
    ('s0001', 'Staff'),
    ('s0002', 'Senior Staff'),
    ('e0001', 'Assistant Engineer'),
    ('e0002', 'Engineer'),
    ('e0003', 'Senior Engineer'),
    ('e0004', 'Technique Leader'),
    ('m0001', 'Manager');

-- Create departments table
CREATE TABLE departments (
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(30) NOT NULL
);
-- Insert departments data
INSERT INTO departments (dept_no, dept_name)
VALUES 
    ('d001', 'Marketing'),
    ('d002', 'Finance'),
    ('d003', 'Human Resources'),
    ('d004', 'Production'),
    ('d005', 'Development'),
    ('d006', 'Quality Management'),
    ('d007', 'Sales'),
    ('d008', 'Research'),
    ('d009', 'Customer Service');

-- Create dept_emp table
CREATE TABLE dept_emp (
    emp_no INT,
    dept_no VARCHAR(4),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Create dept_manager table 
CREATE TABLE dept_manager (
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL DEFAULT CURRENT_DATE,
    to_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, dept_no),
    CHECK (to_date IS NULL OR to_date >= from_date)
);

-- Create salary table with constraints
CREATE TABLE salary (
    emp_no INT NOT NULL,
    salary NUMERIC(10,2) NOT NULL CHECK (salary > 0),
    from_date DATE NOT NULL DEFAULT CURRENT_DATE,
    to_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date),
    CHECK (to_date IS NULL OR to_date >= from_date)
);
 
-- Create indexes for better performance
CREATE INDEX idx_salary_emp_no ON salary(emp_no);
CREATE INDEX idx_dept_manager_emp_no ON dept_manager(emp_no);
CREATE INDEX idx_dept_manager_dept_no ON dept_manager(dept_no);

##Data Analysis 
-please find below the lists:
- Part a: list the employee number
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    s.salary,
	e.sex
FROM employees e
JOIN salary s ON e.emp_no = s.emp_no
WHERE s.to_date IS NULL OR s.to_date >= CURRENT_DATE;
 
-- Part b:List(hired in 1986)
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name,
    dm.from_date AS manager_since
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON dm.dept_no = d.dept_no
WHERE(dm.to_date IS NULL OR dm.to_date >= CURRENT_DATE)
 AND EXTRACT(YEAR FROM e.hire_date)= 1986;

--part c: list the manager for each department 
SELECT d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date IS NULL; 

--part d: list the department number for each employee
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.end_date IS NULL;

--part e: list whose first name is Hercules and last name begins with B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--part f: list each employee in sales department 
SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' AND de.to_date IS NULL; 

--part g: list each employee in the sales and development departments 
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development') AND de.to_date IS NULL;

--part h:list the frequency counts(descending order)
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
