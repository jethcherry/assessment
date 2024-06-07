
--Table for Employee details
--1. Create two tables, employees and sales. Get a list of all employees who did not make any sales. .

CREATE TABLE EmpDetails(EmpID INT PRIMARY KEY, FullName VARCHAR(50),Department VARCHAR(50))

INSERT INTO EmpDetails
VALUES(1, 'John Smith', 'Sales'),
  (2, 'Jane Doe', 'Marketing'),
  (3, 'Bob Johnson', 'Sales'),
  (4, 'Alice Brown', 'IT'),
  (5, 'Mike Davis', 'Sales'),
  (6, 'Emily Chen', 'HR'),
  (7, 'David Lee', 'Finance'),
  (8, 'Sarah Taylor', 'Sales'),
  (9, 'Kevin White', 'Marketing'),
  (10, 'Lisa Nguyen', 'IT'),
  (11, 'Michael Martin', 'Sales'),
  (12, 'Rachel Patel', 'Marketing'),
  (13, 'Christopher Hall', 'IT'),
  (14, 'Jessica Lee', 'HR'),
  (15, 'Brian Kim', 'Finance'),
  (16, 'Laura Davis', 'Sales'),
  (17, 'Matthew Brown', 'Marketing'),
  (18, 'Olivia Taylor', 'IT'),
  (19, 'Daniel Chen', 'HR'),
  (20, 'Hannah White', 'Finance');


SELECT * FROM EmployeeDetails

--Table for sales details

CREATE TABLE slDetails(SalesId INT PRIMARY KEY,EmpID INT,SlDate DATE,SlAmount DECIMAL(10,4),
FOREIGN KEY (EmpID) REFERENCES EmpDetails(EmpID) )

INSERT INTO slDetails
VALUES
 (1, 1, '2022-01-01', 1000.00),
  (2, 1, '2022-01-15', 500.00),
  (3, 2, '2022-02-01', 2000.00),
  (4, 3, '2022-03-01', 800.00),
  (5, 1, '2022-04-01', 1200.00),
  (6, 4, '2022-05-01', 300.00),
  (7, 5, '2022-06-01', 2500.00),
  (8, 2, '2022-07-01', 1500.00),
  (9, 3, '2022-08-01', 1000.00),
  (10, 1, '2022-09-01', 1800.00),
  (11, 6, '2022-10-01', 400.00),
  (12, 7, '2022-11-01', 2200.00),
  (13, 8, '2022-12-01', 900.00),
  (14, 9, '2023-01-01', 1300.00),
  (15, 10, '2023-02-01', 600.00),
  (16, 1, '2023-03-01', 2000.00),
  (17, 2, '2023-04-01', 2800.00),
  (18, 3, '2023-05-01', 1500.00),
  (19, 4, '2023-06-01', 800.00),
  (20, 5, '2023-07-01', 3000.00);

SELECT *  FROM EmpDetails


--Get a list of all employees who did not make any sales. .
SELECT e.EmpID, e.FullName ,e.Department
FROM EmployeeDetails e
LEFT JOIN slDetails s ON e.EmpID = s.EmpID
WHERE s.EmpID IS NULL;


-- 2. Write one procedure that can insert or update the employee (avoid using if statement to check the statement e.g., if (statement ==’Insert))
CREATE PROCEDURE InUpdate 
(
    @EmpID INT,
    @FullName VARCHAR(50),
    @Department VARCHAR(50)
)
AS
BEGIN
    MERGE EmpDetails AS target
    USING (SELECT @EmpID AS EmpID, @FullName AS FullName, @Department AS Department) AS source (EmpID, FullName, Department)
    ON target.EmpID = source.EmpID
    WHEN MATCHED THEN
        UPDATE SET target.FullName = source.FullName, target.Department = source.Department
    WHEN NOT MATCHED THEN
        INSERT (EmpID, FullName, Department)
        VALUES (source.EmpID, source.FullName, source.Department);
END;

-- Insert a new employee record
EXEC InUpdate @EmpID = 1, @FullName = 'John Smith', @Department = 'IT';
SELECT * FROM EmpDetails;

-- Update an existing employee record
EXEC InUpdate @EmpID = 1, @FullName = 'John Smith Jr.', @Department = 'Management';
SELECT * FROM EmpDetails;

-- Insert another new employee record
EXEC InUpdate @EmpID = 2, @FullName = 'Jane Doe', @Department = 'HR';
SELECT * FROM EmpDetails;

-- Query the EmpDetails table to see the results
SELECT * FROM EmpDetails;




-- 3 Write an SQL query to fetch duplicate records from an EmployeeDetails table (without considering the primary key – EmpId)(create dummy data to use
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(50),
    Department VARCHAR(50)
);


INSERT INTO Employee (EmpID, FullName, Department)
VALUES
    (1, 'John Smith', 'IT'),
    (2, 'Jane Doe', 'HR'),
    (3, 'John Smith', 'IT'),
    (4, 'Alice Johnson', 'Finance'),
    (5, 'Bob Brown', 'IT'),
    (6, 'Jane Doe', 'HR'),
    (7, 'Charlie Black', 'Sales'),
    (8, 'John Smith', 'Management'),
    (9, 'Alice Johnson', 'Finance');

SELECT FullName,Department,COUNT(*)
FROM Employee
GROUP BY FullName, Department
HAVING COUNT (*) > 1;



-- 4 Write an SQL query to fetch only odd rows from the table (create dummy data to use)SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY EmpID) AS rowNumFROM Employee)AS SUbQuery WHERE SUbQuery.rowNum % 2 = 1-- 5 Write a function that can calculate age given a certain date of birth ( 06/06/2023 should output zero )
CREATE TABLE DOB (
    DOBId INT PRIMARY KEY, 
    DOBDate DATE
);

INSERT INTO DOB (DOBId, DOBDate)
VALUES
    (1, '1990-06-06'),
    (2, '2000-06-06'),
    (3, '2023-06-06'),
    (4, '1980-07-01'),
    (5, '1995-03-15'),
    (6, '2005-01-01'),
    (7, '2010-06-06'),
    (8, '1992-02-28'),
    (9, '2002-08-12'),
    (10, '2020-09-01');


CREATE FUNCTION Age(@DOBDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Today DATE = GETDATE();
    DECLARE @Age INT;
    
    IF (@DOBDate > @Today)
        SET @Age = 0;
    ELSE
        SET @Age = DATEDIFF(YEAR, @DOBDate, @Today) -
                   CASE
                       WHEN (MONTH(@Today) < MONTH(@DOBDate)) OR
                            (MONTH(@Today) = MONTH(@DOBDate) AND DAY(@Today) < DAY(@DOBDate))
                           THEN 1
                       ELSE 0
                   END;
    
    RETURN @Age;
END;
GO


SELECT DOBId, DOBDate, dbo.Age(DOBDate) AS Age
FROM DOB;
