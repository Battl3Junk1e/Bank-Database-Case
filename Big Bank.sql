SET NOCOUNT ON;

USE master;

IF EXISTS (SELECT * FROM SYSDATABASES WHERE name = 'Big Bank')
	BEGIN
	ALTER DATABASE [Big Bank]
	SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE
	
	DROP DATABASE [Big Bank]
	PRINT('The database has been dropped successfully!')
	END
	ELSE
	BEGIN
	PRINT('The database does not exist')
	
END
GO

CREATE DATABASE [Big Bank]
GO

USE [Big Bank]

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(255) NOT NULL,
    ContactNumber NVARCHAR(20)
);

INSERT INTO Branch (BranchName, Location, ContactNumber)  
	VALUES  
	('Downtown Financial Center', '123 Main Street, New York, NY', '(212) 555-1234'),  
	('Silicon Valley Hub', '456 Tech Avenue, San Jose, CA', '(408) 555-5678'),  
	('Midwest Corporate Office', '789 Business Blvd, Chicago, IL', '(312) 555-7890'),  
	('Southern Regional Branch', '202 Peachtree St, Atlanta, GA', '(404) 555-3456');  

CREATE TABLE Gender(
	GenderID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(20) UNIQUE NOT NULL

);

INSERT INTO Gender (Name)  
	VALUES  
	('Male'),  
	('Female'),  
	('Non-Binary');  

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE CASCADE,
    FirstName NVARCHAR(100) NOT NULL,
	GenderID INT FOREIGN KEY REFERENCES Gender(GenderID) ON DELETE CASCADE,
    LastName NVARCHAR(100) NOT NULL,
	Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employee (BranchID, FirstName, GenderID, LastName, Position, HireDate)  
	VALUES  
	(1, 'John', 1, 'Doe', 'Branch Manager', '2020-06-15'),  
	(2, 'Emily', 2, 'Smith', 'Financial Analyst', '2021-03-10'),  
	(3, 'Alex', 3, 'Taylor', 'IT Specialist', '2019-09-25'),  
	(4, 'Michael', 1, 'Brown', 'Loan Officer', '2022-01-12'),  
	(2, 'Sophia', 2, 'Davis', 'Customer Service Representative', '2023-07-08');  


CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE SET NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
	Adress NVARCHAR(200) NOT NULL,
	SSN NVARCHAR(20) UNIQUE NOT NULL,
	GenderID INT FOREIGN KEY REFERENCES Gender(GenderID) ON DELETE CASCADE,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20) UNIQUE
);

INSERT INTO Customer (BranchID, FirstName, LastName, Adress, SSN, GenderID, DateOfBirth, Email, Phone)  
	VALUES  
	(1, 'James', 'Anderson', '100 Elm St, New York, NY', '123-45-6789', 1, '1985-04-12', 'james.anderson@email.com', '(212) 555-9876'),  
	(2, 'Emma', 'Johnson', '500 Oak Ave, San Jose, CA', '234-56-7890', 2, '1992-07-08', 'emma.johnson@email.com', '(408) 555-1234'),  
	(3, 'Liam', 'Martinez', '700 Pine Rd, Chicago, IL', '345-67-8901', 1, '1988-11-23', 'liam.martinez@email.com', '(312) 555-4567'),  
	(4, 'Olivia', 'Brown', '900 Maple Ln, Atlanta, GA', '456-78-9012', 2, '1995-02-15', 'olivia.brown@email.com', '(404) 555-6789'),  
	(1, 'Noah', 'Williams', '120 Cedar St, New York, NY', '567-89-0123', 1, '1982-09-30', 'noah.williams@email.com', '(212) 555-2345'),  
	(2, 'Ava', 'Taylor', '222 Birch Blvd, San Jose, CA', '678-90-1234', 2, '1999-06-18', 'ava.taylor@email.com', '(408) 555-3456'),  
	(3, 'Mason', 'Harris', '333 Redwood Dr, Chicago, IL', '789-01-2345', 1, '1980-12-05', 'mason.harris@email.com', '(312) 555-5678'),  
	(4, 'Sophia', 'White', '444 Palm Ct, Atlanta, GA', '890-12-3456', 2, '1993-03-27', 'sophia.white@email.com', '(404) 555-7890'),  
	(1, 'Ethan', 'Moore', '555 Spruce St, New York, NY', '901-23-4567', 1, '1976-08-14', 'ethan.moore@email.com', '(212) 555-3456'),  
	(2, 'Isabella', 'Clark', '666 Fir Ln, San Jose, CA', '012-34-5678', 3, '2000-05-22', 'isabella.clark@email.com', '(408) 555-4567');  


CREATE TABLE AccountType (
    AccountTypeID INT PRIMARY KEY IDENTITY(1,1),
    AccountType NVARCHAR(50) UNIQUE NOT NULL 
);

INSERT INTO AccountType (AccountType)  
	VALUES  
	('Checking'),  
	('Savings'),  
	('Business'),  
	('Joint'),  
	('Student');  


CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    AccountTypeID INT FOREIGN KEY REFERENCES AccountType(AccountTypeID) ON DELETE SET NULL,
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE SET NULL
);

INSERT INTO Account (Balance, AccountTypeID, BranchID)  
	VALUES  
	(1500.75, 1, 1),  -- James Anderson - Checking  
	(3200.50, 2, 2),  -- Emma Johnson - Savings  
	(780.00, 1, 3),   -- Liam Martinez - Checking  
	(5400.20, 3, 4),  -- Olivia Brown - Business  
	(210.45, 4, 1),   -- Noah Williams - Joint  
	(5000.00, 2, 2),  -- Ava Taylor - Savings  
	(1350.89, 1, 3),  -- Mason Harris - Checking  
	(8900.67, 3, 4),  -- Sophia White - Business  
	(250.00, 5, 1),   -- Ethan Moore - Student  
	(1200.30, 2, 2);  -- Isabella Clark - Savings  


CREATE TABLE DispositionRole (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    Role NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Owner', 'User', 'Joint'
);

INSERT INTO DispositionRole (Role)  
	VALUES  
	('Owner'),  
	('User'),  
	('Joint');  

CREATE TABLE Dispositions (
    DispositionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    RoleID INT FOREIGN KEY REFERENCES DispositionRole(RoleID) ON DELETE CASCADE
);
INSERT INTO Dispositions (CustomerID, AccountID, RoleID)  
	VALUES  
	(1, 1, 1), 
	(2, 2, 1),  
	(3, 3, 1),  
	(4, 4, 1),  
	(5, 5, 1),  
	(6, 6, 1),  
	(7, 7, 1),  
	(8, 8, 1),  
	(9, 9, 1), 
	(10, 10, 1), 
	(1, 5, 3),  
	(2, 6, 3),  
	(3, 7, 3),   
	(4, 8, 3),    
	(5, 5, 2),  
	(6, 6, 2),   
	(7, 7, 2),  
	(8, 8, 2),   
	(9, 9, 2),    
	(10, 10, 2);   


CREATE TABLE CardType (
    CardTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO CardType (TypeName)  
	VALUES  
	('Debit'),  
	('Credit'),  
	('Prepaid');  


CREATE TABLE Card (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    CardTypeID INT FOREIGN KEY REFERENCES CardType(CardTypeID) ON DELETE CASCADE,
    CardNumber CHAR(16) UNIQUE NOT NULL,
    ExpiryDate DATE NOT NULL,
    IsValid BIT DEFAULT 0,
    OnlinePurchases BIT DEFAULT 0,
    Worldwide BIT DEFAULT 0,
	CVV INT NOT NULL,
);

INSERT INTO Card (AccountID, CardTypeID, CardNumber, ExpiryDate, IsValid, OnlinePurchases, Worldwide, CVV)  
	VALUES  
	(1, 1, '1234567812345678', '2026-11-30', 1, 1, 1, 123), 
	(2, 2, '2345678923456789', '2027-02-28', 1, 1, 1, 234),  
	(3, 1, '3456789034567890', '2026-05-15', 1, 1, 1, 345), 
	(4, 3, '4567890145678901', '2028-08-20', 1, 1, 1, 456),  
	(5, 1, '5678901256789012', '2025-12-12', 1, 1, 0, 567), 
	(6, 2, '6789012367890123', '2026-07-30', 1, 1, 1, 678),  
	(7, 1, '7890123478901234', '2026-09-05', 1, 1, 1, 789), 
	(8, 3, '8901234589012345', '2027-04-18', 1, 1, 1, 890),  
	(9, 3, '9012345690123456', '2024-10-10', 1, 1, 0, 901),   
	(10, 2, '0123456701234567', '2026-03-22', 1, 1, 1, 112);  

CREATE TABLE Merchant (
	MerchantID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(255) NOT NULL
);

INSERT INTO Merchant (Name)  
	VALUES  
	('Amazon'),  
	('Walmart'),  
	('Apple Store'),  
	('Starbucks'),  
	('Best Buy');  


CREATE TABLE CardTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT FOREIGN KEY REFERENCES Card(CardID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    Merchant INT FOREIGN KEY REFERENCES Merchant(MerchantID) ON DELETE CASCADE 
);

INSERT INTO CardTransaction (CardID, Amount, Merchant)  
	VALUES  
	(1, 150.75, 1), 
	(2, 45.20, 2), 
	(3, 120.50, 3),   
	(4, 200.00, 4), 
	(5, 300.99, 5),  
	(6, 50.00, 1),   
	(7, 85.60, 2),
	(8, 120.10, 3),   
	(9, 15.45, 4),
	(10, 210.30, 5); 

CREATE TABLE TransactionType (
    TransactionTypeID INT PRIMARY KEY IDENTITY(1,1),
    TransactionType NVARCHAR(50) UNIQUE NOT NULL 
);

INSERT INTO TransactionType (TransactionType)  
	VALUES  
	('Deposit'),  
	('Withdrawal'),  
	('Transfer'),  
	('Payment');  

CREATE TABLE AccountTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    TransactionTypeID INT FOREIGN KEY REFERENCES TransactionType(TransactionTypeID) ON DELETE CASCADE,
    Amount DECIMAL(18,2) NOT NULL
);

INSERT INTO AccountTransaction (AccountID, TransactionTypeID, Amount)  
	VALUES  
	(1, 1, 1000.00),
	(2, 2, 500.00),  
	(3, 3, 200.00),
	(4, 1, 1500.00),
	(5, 4, 300.00),
	(6, 2, 250.00),
	(7, 1, 800.00),
	(8, 3, 450.00),
	(9, 4, 100.00),
	(10, 3, 600.00);

CREATE TABLE InterestRate (
    RateID INT PRIMARY KEY IDENTITY(1,1),
    InterestRate DECIMAL(5,2) NOT NULL CHECK (InterestRate >= 0),
	IsVariable BIT DEFAULT 0
);

INSERT INTO InterestRate (InterestRate, IsVariable)  
	VALUES  
	(2.50, 0),  
	(3.75, 0),  
	(5.00, 1),  
	(1.25, 0),  
	(4.00, 1);  


CREATE TABLE Loan (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE SET NULL,
    LoanAmount DECIMAL(18,2) NOT NULL,
    InterestRateID INT FOREIGN KEY REFERENCES InterestRate(RateID) ON DELETE SET NULL,
	LoanOfficerID INT FOREIGN KEY REFERENCES Employee(EmployeeID) ON DELETE SET NULL,
    LoanStartDate DATE NOT NULL,
    LoanTermMonths INT NOT NULL
);

INSERT INTO Loan (CustomerID, AccountID, LoanAmount, InterestRateID, LoanStartDate, LoanTermMonths, LoanOfficerID)  
	VALUES  
	(1, 1, 5000.00, 1, '2023-01-15', 24, 1),  
	(2, 2, 10000.00, 2, '2022-06-10', 36, 4),  
	(3, 3, 1500.00, 3, '2023-09-05', 12, 1),  
	(4, 4, 8000.00, 4, '2023-03-18', 48, 4),  
	(5, 5, 2000.00, 5, '2023-11-22', 24, 1),  
	(6, 6, 3000.00, 1, '2023-05-13', 18, 4),  
	(7, 7, 4500.00, 3, '2023-08-30', 36, 1),  
	(8, 8, 12000.00, 2, '2022-10-21', 60, 4),  
	(9, 9, 3500.00, 4, '2023-07-01', 24, 1),  
	(10, 10, 6000.00, 1, '2023-12-01', 12, 4);  


CREATE TABLE SecurityType (
    SecurityTypeID INT PRIMARY KEY IDENTITY(1,1),
    SecurityType NVARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO SecurityType (SecurityType)  
	VALUES  
	('Car'),  
	('House'),  
	('Jewelry'),  
	('Artwork'),  
	('Gold'),  
	('Stocks'),  
	('Real Estate'),  
	('Business Equipment'),  
	('Furniture'),  
	('Antiques');  

CREATE TABLE Securities (
    SecurityID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    LoanID INT FOREIGN KEY REFERENCES Loan(LoanID) ON DELETE NO ACTION,
    SecurityTypeID INT FOREIGN KEY REFERENCES SecurityType(SecurityTypeID) ON DELETE CASCADE,
    EstimatedValue DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(255),
    OwnershipDocument NVARCHAR(255) NULL  -- Path to scanned document (if applicable)
);

INSERT INTO Securities (CustomerID, LoanID, SecurityTypeID, EstimatedValue, Description, OwnershipDocument)  
	VALUES  
	(1, 1, 1, 15000.00, 'Car - 2020 Toyota Corolla', 'C:\Documents\CarOwnership\Toyota_Corolla.pdf'),  
	(2, 2, 2, 250000.00, 'House - 3 Bedroom in Downtown', 'C:\Documents\HouseOwnership\Downtown_House.pdf'),  
	(3, 3, 3, 5000.00, 'Gold Ring', 'C:\Documents\GoldOwnership\GoldRing.pdf'),  
	(4, 4, 4, 35000.00, 'Artwork - Modern Painting', 'C:\Documents\ArtworkOwnership\Modern_Painting.pdf'),  
	(5, 5, 5, 15000.00, 'Stocks - 1000 shares of XYZ Corp', 'C:\Documents\StocksOwnership\XYZ_Corp.pdf'),  
	(6, 6, 6, 100000.00, 'Real Estate - Commercial Property', 'C:\Documents\RealEstateOwnership\Commercial_Property.pdf'),  
	(7, 7, 7, 5000.00, 'Business Equipment - Industrial Machinery', 'C:\Documents\BusinessEquipment\Industrial_Machinery.pdf'),  
	(8, 8, 8, 2000.00, 'Antiques - Vintage Furniture', 'C:\Documents\AntiqueOwnership\Vintage_Furniture.pdf'),  
	(9, 9, 9, 1000.00, 'Furniture - Luxury Sofa Set', 'C:\Documents\FurnitureOwnership\Luxury_Sofa.pdf'),  
	(10, 10, 10, 3000.00, 'Car - 2018 Honda Civic', 'C:\Documents\CarOwnership\Honda_Civic.pdf');  


CREATE TABLE PaymentMethod (
    PaymentMethodID INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(50) UNIQUE NOT NULL 
);

INSERT INTO PaymentMethod (MethodName)  
	VALUES  
	('Credit Card'),  
	('Debit Card'),  
	('Bank Transfer'),  
	('Cash'),  
	('Cheque'),  
	('Mobile Payment'),  
	('PayPal');  

CREATE TABLE LoanPayment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT FOREIGN KEY REFERENCES Loan(LoanID) ON DELETE CASCADE,
    PaymentDate DATE DEFAULT GETDATE(),
    AmountPaid DECIMAL(18,2) NOT NULL,
    PaymentMethodID INT FOREIGN KEY REFERENCES PaymentMethod(PaymentMethodID) ON DELETE SET NULL  -- Allows tracking of payment methods
);

INSERT INTO LoanPayment (LoanID, AmountPaid, PaymentMethodID)  
	VALUES  
	(1, 500.00, 1),  
	(2, 1000.00, 2),  
	(3, 200.00, 3),  
	(4, 1500.00, 4),  
	(5, 250.00, 5),  
	(6, 300.00, 6),  
	(7, 450.00, 7),  
	(8, 800.00, 1),  
	(9, 100.00, 2),  
	(10, 600.00, 3);  

CREATE TABLE FeeCharges (
    FeeID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    FeeType NVARCHAR(100) NOT NULL,
    FeeAmount DECIMAL(18,2) NOT NULL,
    ChargedDate DATE DEFAULT GETDATE()
);

INSERT INTO FeeCharges (AccountID, FeeType, FeeAmount)  
	VALUES  
	(1, 'Monthly Maintenance Fee', 5.00),  
	(2, 'Overdraft Fee', 35.00),  
	(3, 'ATM Withdrawal Fee', 2.50),  
	(4, 'Late Payment Fee', 25.00),  
	(5, 'Monthly Maintenance Fee', 5.00),  
	(6, 'Account Inactivity Fee', 15.00),  
	(7, 'Overdraft Fee', 40.00),  
	(8, 'Monthly Maintenance Fee', 5.00),  
	(9, 'ATM Withdrawal Fee', 3.00),  
	(10, 'Late Payment Fee', 30.00);  

CREATE TABLE ServiceRequestType (
    RequestTypeID INT PRIMARY KEY IDENTITY(1,1),
    RequestType NVARCHAR(100) UNIQUE NOT NULL 
);

INSERT INTO ServiceRequestType (RequestType)  
	VALUES  
	('Account Inquiry'),  
	('Card Replacement'),  
	('Account Closure'),  
	('Transaction Dispute'),  
	('Loan Inquiry'),  
	('Change of Address'),  
	('Balance Inquiry'),  
	('Lost Card Report'),  
	('Request for New Checks'),  
	('Update Personal Information');  

CREATE TABLE ServiceRequestStatus (
    RequestStatusID INT PRIMARY KEY IDENTITY(1,1),
    RequestStatus NVARCHAR(50) UNIQUE NOT NULL 
);

INSERT INTO ServiceRequestStatus (RequestStatus)  
	VALUES  
	('Pending'),  
	('Completed'),  
	('In Progress'),  
	('Cancelled'),  
	('On Hold'),  
	('Rejected');  

CREATE TABLE ServiceRequest (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    RequestTypeID INT FOREIGN KEY REFERENCES ServiceRequestType(RequestTypeID) ON DELETE CASCADE,
    RequestStatusID INT FOREIGN KEY REFERENCES ServiceRequestStatus(RequestStatusID) ON DELETE CASCADE,
    RequestDate DATETIME DEFAULT GETDATE()
);

INSERT INTO ServiceRequest (CustomerID, RequestTypeID, RequestStatusID)  
	VALUES  
	(1, 1, 1),  
	(2, 2, 3),  
	(3, 3, 1),  
	(4, 4, 5),  
	(5, 5, 2),  
	(6, 6, 4),  
	(7, 7, 1),  
	(8, 8, 6),  
	(9, 9, 2),  
	(10, 10, 3);  


CREATE TABLE OnlineBankingStatus (
    StatusID INT PRIMARY KEY IDENTITY(1,1),
    Status NVARCHAR(50) UNIQUE NOT NULL 
);

INSERT INTO OnlineBankingStatus (Status)  
	VALUES  
	('Active'),  
	('Locked'),  
	('Suspended'),  
	('Inactive'),  
	('Pending');  

CREATE TABLE OnlineBanking (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    LastLogin DATETIME DEFAULT GETDATE(),
    StatusID INT FOREIGN KEY REFERENCES OnlineBankingStatus(StatusID) ON DELETE CASCADE
);

INSERT INTO OnlineBanking (CustomerID, StatusID)  
	VALUES  
	(1, 1),  
	(2, 1),  
	(3, 2),  
	(4, 1),  
	(5, 3),  
	(6, 1),  
	(7, 4),  
	(8, 5),  
	(9, 1),  
	(10, 2);  
