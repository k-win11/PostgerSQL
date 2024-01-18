--Create a table which tracks operations performed on other tables

CREATE TABLE table_changed_logs (
  change_type TEXT NOT NULL,  
  changed_table_name TEXT NOT NULL, 
  changed_on date NOT NULL
);


-- Function to track what changes were made to a table (INSERT, UPDATE, DELETE)

CREATE OR REPLACE FUNCTION table_changed_logs_func() RETURNS TRIGGER AS $table_changed_trigger$
   BEGIN
      INSERT INTO table_changed_logs(change_type, changed_table_name, changed_on)
      VALUES (TG_OP, TG_TABLE_NAME, current_timestamp);
      RETURN NEW;
   END;
$table_changed_trigger$ LANGUAGE plpgsql;


--Create two triggers using the same function

CREATE TRIGGER employees_inserted_trigger 
AFTER INSERT ON employees
EXECUTE PROCEDURE table_changed_logs_func();

CREATE TRIGGER employees_updated_trigger 
AFTER UPDATE ON employees
EXECUTE PROCEDURE table_changed_logs_func();


--Insert a new record into the employees table

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('Julia', 'Dennis', 'Engineering', 80000);


--Table update tracked and other trigger also fired

SELECT * FROM table_changed_logs;


SELECT * from new_employee_logs;

--Update employee salaries

UPDATE employees
SET salary = 1.05 * salary
WHERE salary < 85000


--Both triggers would have been fired

SELECT * FROM table_changed_logs;

SELECT * FROM employee_salary_logs;

--

-We can see the trigger using the following query (should be 4 triggers)

SELECT tgname FROM pg_trigger;


--Drop triggers

DROP TRIGGER employees_inserted_trigger ON employees;


--We can see the trigger using the following query (should be 3 triggers)

SELECT tgname FROM pg_trigger;


