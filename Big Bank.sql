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
-- ==========================
-- Branch Table
-- ==========================
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(255) NOT NULL,
    ContactNumber NVARCHAR(20)
);

-- ==========================
-- Employee Table
-- ==========================
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE CASCADE,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
	Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL
);

-- ==========================
-- Customer Table
-- ==========================
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE SET NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20) UNIQUE
);

-- ==========================
-- Account Table
-- ==========================
CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    AccountType NVARCHAR(50) NOT NULL CHECK (AccountType IN ('Checking', 'Savings', 'Business')),
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE SET NULL
);

-- ==========================
-- Dispositions Table (Junction Table for Customers and Accounts)
-- ==========================
CREATE TABLE Dispositions (
    DispositionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Owner', 'User', 'Joint'))
);
-- ==========================
-- CardTypes Table
-- ==========================
CREATE TABLE CardTypes (
    CardTypeID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    CardType NVARCHAR(50) NOT NULL CHECK (CardType IN ('Debit', 'Credit', 'Prepaid')),
    CardNumber CHAR(16) UNIQUE NOT NULL,
    ExpiryDate DATE NOT NULL
);
-- ==========================
-- Card Table
-- ==========================
CREATE TABLE Card (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    CardTypeID INT FOREIGN KEY REFERENCES CardTypes(CardTypeID) ON DELETE CASCADE,
    CardNumber CHAR(16) UNIQUE NOT NULL,
    ExpiryDate DATE NOT NULL
);

-- ==========================
-- CardTransaction Table
-- ==========================
CREATE TABLE CardTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT FOREIGN KEY REFERENCES Card(CardID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    Merchant NVARCHAR(100) 
);

-- ==========================
-- AccountTransaction Table
-- ==========================
CREATE TABLE AccountTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    TransactionType NVARCHAR(50) NOT NULL CHECK (TransactionType IN ('Deposit', 'Withdrawal', 'Transfer', 'Payment')),
    Amount DECIMAL(18,2) NOT NULL
);

-- ==========================
-- Loan Table
-- ==========================
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE SET NULL,
    LoanAmount DECIMAL(18,2) NOT NULL,
    InterestRateID INT FOREIGN KEY REFERENCES InterestRate(RateID) ON DELETE SET NULL,
    LoanStartDate DATE NOT NULL,
    LoanTermMonths INT NOT NULL
);

-- ==========================
-- Loan Payment Table
-- ==========================
CREATE TABLE LoanPayment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT FOREIGN KEY REFERENCES Loan(LoanID) ON DELETE CASCADE,
    PaymentDate DATE DEFAULT GETDATE(),
    AmountPaid DECIMAL(18,2) NOT NULL
);

-- ==========================
-- Interest Rate Table
-- ==========================
CREATE TABLE InterestRate (
    RateID INT PRIMARY KEY IDENTITY(1,1),
    InterestRate DECIMAL(5,2) NOT NULL CHECK (InterestRate >= 0)
);

-- ==========================
-- Fee & Charges Table
-- ==========================
CREATE TABLE FeeCharges (
    FeeID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    FeeType NVARCHAR(100) NOT NULL,
    FeeAmount DECIMAL(18,2) NOT NULL,
    ChargedDate DATE DEFAULT GETDATE()
);

-- ==========================
-- Service Requests Table
-- ==========================
CREATE TABLE ServiceRequests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    RequestType NVARCHAR(100) NOT NULL CHECK (RequestType IN ('Account Inquiry', 'Card Replacement', 'Loan Request', 'Dispute')),
    RequestStatus NVARCHAR(50) NOT NULL CHECK (RequestStatus IN ('Pending', 'Completed', 'Rejected')),
    RequestDate DATETIME DEFAULT GETDATE()
);

-- ==========================
-- Online Banking Table
-- ==========================
CREATE TABLE OnlineBanking (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    LastLogin DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Active', 'Locked'))
);
