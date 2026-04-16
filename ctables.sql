CREATE TABLE Spring26_S008_T2_Product 
(
	ProductID int PRIMARY KEY,
	ProductName varchar(50) NOT NULL,
	ProductType varchar(20) CHECK (ProductType IN ('Video Game', 'Console', 'Accessories')) NOT NULL,
	Cost decimal(10,2),
	ReleaseDate date,
	Rating decimal(2,1) CHECK (Rating BETWEEN 0 and 5)
);

--Creating the 'Product Company' table
CREATE TABLE Spring26_S008_T2_Product_Company
(
	ProductID int REFERENCES Spring26_S008_T2_Product(ProductID),
	Company varchar(50) NOT NULL,
	PRIMARY KEY (ProductID, Company)
);

--Creating the 'Supplier' table
CREATE TABLE Spring26_S008_T2_Supplier
(
	SupplierID int PRIMARY KEY,
	Name varchar(50) NOT NULL,
	StartDate date
);

--Creating the 'Supplier Product Type' table
CREATE TABLE Spring26_S008_T2_Supplier_Product_Type
(
	SupplierID int REFERENCES Spring26_S008_T2_Supplier(SupplierID),
	ProductType varchar(20) CHECK (ProductType IN ('Video Game', 'Console', 'Accessories')) NOT NULL,
	PRIMARY KEY (SupplierID, ProductType)
);

--Creating the 'Store' table
CREATE TABLE Spring26_S008_T2_Store
(
	StoreID int PRIMARY KEY,
	StoreHours int NOT NULL,
	NumSections int NOT NULL,
	NumEmployees int
);

--Creating the 'Store Address' table
CREATE TABLE Spring26_S008_T2_Store_Address
(
	StoreID int REFERENCES Spring26_S008_T2_Store(StoreID),
	Street varchar(80) NOT NULL,
	City varchar(50),
	County varchar(30),
	State char(2),
	Country varchar(50),
	Zip char(5),
	CONSTRAINT pk_store_address PRIMARY KEY (StoreID, Street, County, State, Country, Zip)
);

--Creating the 'Employee' table
CREATE TABLE Spring26_S008_T2_Employee
(
	EmployeeID int PRIMARY KEY,
	Name varchar(40) NOT NULL,
	DateHired date,
	Role varchar(50),
	DOB date
);

--Creating the 'Employee Email' table
CREATE TABLE Spring26_S008_T2_Employee_Email
(
	EmployeeID int REFERENCES Spring26_S008_T2_Employee(EmployeeID),
	Email varchar(50) NOT NULL,
	CONSTRAINT chk_employee_email_format CHECK 
					(
						Email IS NOT NULL AND REGEXP_LIKE(Email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
					),
	CONSTRAINT pk_employee_email PRIMARY KEY (EmployeeID, Email)
);

--Creating the 'Employee Phone Number' table
CREATE TABLE Spring26_S008_T2_Employee_Phone_Number
(
	EmployeeID int REFERENCES Spring26_S008_T2_Employee(EmployeeID),
	PhoneNumber char(12) NOT NULL,
	PRIMARY KEY (EmployeeID, PhoneNumber)
);

--Creating the 'Customer' table
CREATE TABLE Spring26_S008_T2_Customer
(
	CustomerID int PRIMARY KEY,
	Name varchar(30) NOT NULL,
	DOB date,
	Gender varchar(6) CHECK (Gender IN ('Male', 'Female', 'Other'))
);

--Creating the 'Customer Email' table
CREATE TABLE Spring26_S008_T2_Customer_Email
(
	CustomerID int REFERENCES Spring26_S008_T2_Customer(CustomerID),
	Email varchar(50) NOT NULL,
	CONSTRAINT chk_customer_email_format CHECK 
					(
						Email IS NOT NULL AND REGEXP_LIKE(Email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
					),
	CONSTRAINT pk_customer_email PRIMARY KEY (CustomerID, Email)
);

--Creating the 'Customer Phone Number' table
CREATE TABLE Spring26_S008_T2_Customer_Phone_Number
(
	CustomerID int REFERENCES Spring26_S008_T2_Customer(CustomerID),
	PhoneNumber char(12) NOT NULL,
	PRIMARY KEY (CustomerID, PhoneNumber)
);

--Creating the 'Inventory' table
CREATE TABLE Spring26_S008_T2_Inventory
(
	InventoryID int PRIMARY KEY,
	ProductID int REFERENCES Spring26_S008_T2_Product(ProductID),
	ProductName varchar(50),
	ProductType varchar(50) CHECK (ProductType IN ('Video Game', 'Console', 'Accessories'))
);

--Creating the 'Order From' table
CREATE TABLE Spring26_S008_T2_Order_From
(
	EmployeeID int REFERENCES Spring26_S008_T2_Employee(EmployeeID),
	SupplierID int REFERENCES Spring26_S008_T2_Supplier(SupplierID),
	OrderID int,
	OrderDate date,
	Amount int,
	Cost decimal(10,2),
	PRIMARY KEY (EmployeeID, SupplierID, OrderID)
);

--Creating the 'Buys' table
CREATE TABLE Spring26_S008_T2_Buys
(
	CustomerID int REFERENCES Spring26_S008_T2_Customer(CustomerID),
	ProductID int REFERENCES Spring26_S008_T2_Product(ProductID),
	TransactionID int,
	EmployeeID int REFERENCES Spring26_S008_T2_Employee(EmployeeID),
	TransactionDate date,
	Cost decimal(10,2),
	PRIMARY KEY (CustomerID, ProductID, TransactionID)
);

--Creating the 'Payment Method' table
CREATE TABLE Spring26_S008_T2_Buys_Payment_Method
(
	CustomerID int,
	ProductID int,
	TransactionID int,
	Method varchar(20) check(Method IN ('Cash', 'Card', 'Apple Pay', 'Google Pay', 'PayPal', 'Samsung Pay', 'Store Credit')),
	CONSTRAINT fk_buys_payment_method FOREIGN KEY (CustomerID, ProductID, TransactionID) REFERENCES Spring26_S008_T2_Buys(CustomerID, ProductID, TransactionID),
	CONSTRAINT pk_buys_payment_method PRIMARY KEY (CustomerID, ProductID, TransactionID, Method)
);

--Creating the 'Inventory Inputs Info' table
CREATE TABLE Spring26_S008_T2_Inventory_Inputs_Info
(
	InventoryID int REFERENCES Spring26_S008_T2_Inventory(InventoryID),
	ProductID int REFERENCES Spring26_S008_T2_Product(ProductID),
	Sold int,
	LeftOver int,
	InventoryDate date,
	CONSTRAINT pk_Inventory_Inputs_Info PRIMARY KEY (InventoryID, ProductID, InventoryDate)
);

--Creating the 'Products Are Stored' table
CREATE TABLE Spring26_S008_T2_Products_Are_Stored
(
	ProductID int REFERENCES Spring26_S008_T2_Product(ProductID),
	StoreID int REFERENCES Spring26_S008_T2_Store(StoreID),
	Section int,
	CONSTRAINT pk_Products_Are_Stored PRIMARY KEY (ProductID, StoreID, Section)
);

--Creating the 'Employee Works At' table
CREATE TABLE Spring26_S008_T2_Employee_Works_At
(
	EmployeeID int REFERENCES Spring26_S008_T2_Employee(EmployeeID),
	StoreID int REFERENCES Spring26_S008_T2_Store(StoreID),
	WeekEndDate date,
	Transactions int,
	Hours decimal(10,2),
	Appraisals int,
	Complaints int,
	CONSTRAINT pk_Employee_Works_At PRIMARY KEY (EmployeeID, WeekEndDate, Transactions, Hours, Appraisals, Complaints)
);