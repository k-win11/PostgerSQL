--Triggers 

--We can create triggers for any DML statements
--Eg, we can create a trigger when a new entry is inserted
--Or we can create a trigger when a field is updated etc.


CREATE TABLE employees(
   id INT GENERATED ALWAYS AS IDENTITY,
   first_name TEXT NOT NULL,
   last_name TEXT NOT NULL,
   department TEXT NOT NULL,  
   salary INT NOT NULL,
   PRIMARY KEY(id)
);

INSERT INTO employees (first_name, last_name, department, salary)
VALUES 
('Alice', 'Smith', 'Engineering', 125000),
('Bob', 'Baker', 'Sales', 85000);

SELECT * FROM employees



--Now let's create a entry table where we audit new employees

CREATE TABLE new_employee_logs (
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  joining_date date NOT NULL
);


SELECT * FROM new_employee_logs;


-- Create a function

CREATE OR REPLACE FUNCTION new_employee_joining_func() RETURNS TRIGGER AS $new_employee_trigger$
   BEGIN
      INSERT INTO new_employee_logs(first_name, last_name, joining_date)
      VALUES (new.first_name, new.last_name, current_timestamp);
      RETURN NEW;
   END;
$new_employee_trigger$ LANGUAGE plpgsql;

--Now create a trigger for this function (note that this is an AFTER INSERT and a row-level trigger)

CREATE TRIGGER new_employee_trigger 
AFTER INSERT ON employees
FOR EACH ROW 
EXECUTE PROCEDURE new_employee_joining_func();

--Now let's insert some values within employees table and notice how trigger works

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('John', 'Watson', 'Sales', 65000);


SELECT * FROM employees;

-- We see the new entry is added
--Now check the emp_joining_logs table and we see the
--The name and time on which the new value was added

SELECT * from new_employee_logs;

--Now let's create a trigger when a value in a table is updated
--Create another table for auditing salary increment

CREATE TABLE employee_salary_logs (
   id INT GENERATED ALWAYS AS IDENTITY,
   first_name TEXT NOT NULL,
   last_name TEXT NOT NULL,
   old_salary INT NOT NULL,
   incremented_salary INT NOT NULL,
   incremented_on DATE NOT NULL
);

-- Now let's create a function
-- If the salary is incremented, then let's aduit the last name and 
--  the time we incremented the salary and what the old salary and new salary is 

CREATE OR REPLACE FUNCTION employee_salary_update_func()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
  IF NEW.salary <> OLD.salary THEN
     INSERT INTO employee_salary_logs(first_name, last_name, old_salary, incremented_salary, incremented_on)
     VALUES(OLD.first_name, OLD.last_name, OLD.salary, NEW.salary, now());
  END IF;

  RETURN NEW;
END;
$$


--Let's create the trigger

CREATE TRIGGER employee_salary_update_trigger
  AFTER UPDATE
  ON employees
  FOR EACH ROW
  EXECUTE PROCEDURE employee_salary_update_func();
  
--Now let's view the employees table entires

SELECT * FROM employees

--Let's update the salary of an employee

UPDATE employees
SET salary = 75000
WHERE last_name = 'Watson'; 


SELECT * FROM employees;

--We see the value is changed
--Now let's observe the audits table

SELECT * FROM employee_salary_logs;

--We see the old salary, new salary and the time on which we changed the salary
--One more update, increment all salaries by 10%

UPDATE employees
SET salary = 1.1 * salary

--Again check (there should be a total of 4 entries, 2 for Watson)

SELECT * FROM employee_salary_logs;
