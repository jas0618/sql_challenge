-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/jL21XO
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

-- Create entities
CREATE TABLE [Employees] (
    [emp_no] INT  NOT NULL ,
    [title_id] VARCHAR  NOT NULL ,
    [birth_date] DATE  NOT NULL ,
    [first_name] VARCHAR  NOT NULL ,
    [last_name] VARCHAR  NOT NULL ,
    [sex] VARCHAR  NOT NULL ,
    [hire_date] DATE  NOT NULL ,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED (
        [emp_no] ASC
    )
)

CREATE TABLE [Departments] (
    [dept_no] VARHCAR  NOT NULL ,
    [dept_name] VARHCAR  NOT NULL ,
    CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED (
        [dept_no] ASC
    )
)

CREATE TABLE [Demp_emp] (
    [emp_no] FK>-<Employees  NOT NULL ,
    [dept_no] FK>-Departments  NOT NULL 
)

CREATE TABLE [Dept_manager] (
    [dept_no] FK>-Departments  NOT NULL ,
    [emp_no] FK>-Employees  NOT NULL 
)

CREATE TABLE [Titles] (
    [title_id] VARCHAR  NOT NULL ,
    [title] VARCHAR  NOT NULL ,
    CONSTRAINT [PK_Titles] PRIMARY KEY CLUSTERED (
        [title_id] ASC
    )
)

CREATE TABLE [Salaries] (
    [emp_no] FK>-Employees  NOT NULL ,
    [salary] NUMERIC  NOT NULL 
)

ALTER TABLE [Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_] FOREIGN KEY([])
REFERENCES [Titles] ([])

ALTER TABLE [Employees] CHECK CONSTRAINT [FK_Employees_]

COMMIT TRANSACTION QUICKDBD