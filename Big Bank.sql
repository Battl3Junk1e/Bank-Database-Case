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
-- Account Types Table
-- ==========================
CREATE TABLE AccountType (
    AccountTypeID INT PRIMARY KEY IDENTITY(1,1),
    AccountType NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Checking', 'Savings', 'Business'
);

-- ==========================
-- Account Table (Normalized)
-- ==========================
CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    AccountTypeID INT FOREIGN KEY REFERENCES AccountType(AccountTypeID) ON DELETE SET NULL,
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID) ON DELETE SET NULL
);

-- ==========================
-- Disposition Roles Table
-- ==========================
CREATE TABLE DispositionRole (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    Role NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Owner', 'User', 'Joint'
);

-- ==========================
-- Dispositions Table (Normalized)
-- ==========================
CREATE TABLE Dispositions (
    DispositionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    RoleID INT FOREIGN KEY REFERENCES DispositionRole(RoleID) ON DELETE CASCADE
);

-- ==========================
-- Card Types Table
-- ==========================
CREATE TABLE CardType (
    CardTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Debit', 'Credit', 'Prepaid'
);

-- ==========================
-- Cards Table (Final Optimized Version)
-- ==========================
CREATE TABLE Card (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    CardTypeID INT FOREIGN KEY REFERENCES CardType(CardTypeID) ON DELETE CASCADE,
    CardNumber CHAR(16) UNIQUE NOT NULL,
    ExpiryDate DATE NOT NULL,
    IsValid BIT DEFAULT 0,
    OnlinePurchases BIT DEFAULT 0,
    Worldwide BIT DEFAULT 0
);

-- ==========================
-- Merchant Table
-- ==========================
CREATE TABLE Merchant (
	MerchantID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(255) NOT NULL
);
-- ==========================
-- CardTransaction Table
-- ==========================
CREATE TABLE CardTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT FOREIGN KEY REFERENCES Card(CardID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    Merchant INT FOREIGN KEY REFERENCES Merchant(MerchantID) ON DELETE CASCADE 
);

-- ==========================
-- Transaction Types Table
-- ==========================
CREATE TABLE TransactionType (
    TransactionTypeID INT PRIMARY KEY IDENTITY(1,1),
    TransactionType NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Deposit', 'Withdrawal', 'Transfer', 'Payment'
);

-- ==========================
-- Account Transactions Table 
-- ==========================
CREATE TABLE AccountTransaction (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID) ON DELETE CASCADE,
    TransactionDate DATETIME DEFAULT GETDATE(),
    TransactionTypeID INT FOREIGN KEY REFERENCES TransactionType(TransactionTypeID) ON DELETE CASCADE,
    Amount DECIMAL(18,2) NOT NULL
);

-- ==========================
-- Interest Rate Table
-- ==========================
CREATE TABLE InterestRate (
    RateID INT PRIMARY KEY IDENTITY(1,1),
    InterestRate DECIMAL(5,2) NOT NULL CHECK (InterestRate >= 0),
	IsVariable BIT DEFAULT 0
);


-- ==========================
-- Loans Table (Optimized)
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
-- Security Types Table (Reference Table)
-- ==========================
CREATE TABLE SecurityType (
    SecurityTypeID INT PRIMARY KEY IDENTITY(1,1),
    SecurityType NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Car', 'House', 'Jewelry'
);

-- ==========================
-- Securities Table (Collateral for Loans)
-- ==========================
CREATE TABLE Securities (
    SecurityID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,  -- Links to Customer, not just Loan
    LoanID INT FOREIGN KEY REFERENCES Loan(LoanID) ON DELETE CASCADE,
    SecurityTypeID INT FOREIGN KEY REFERENCES SecurityType(SecurityTypeID) ON DELETE CASCADE,
    EstimatedValue DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(255),
    OwnershipDocument NVARCHAR(255) NULL  -- Path to scanned document (if applicable)
);

-- ==========================
-- Payment Methods Table (Reference Table)
-- ==========================
CREATE TABLE PaymentMethod (
    PaymentMethodID INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Bank Transfer', 'Cash', 'Credit Card'
);

-- ==========================
-- Loan Payments Table (Optimized)
-- ==========================
CREATE TABLE LoanPayment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT FOREIGN KEY REFERENCES Loan(LoanID) ON DELETE CASCADE,
    PaymentDate DATE DEFAULT GETDATE(),
    AmountPaid DECIMAL(18,2) NOT NULL,
    PaymentMethodID INT FOREIGN KEY REFERENCES PaymentMethod(PaymentMethodID) ON DELETE SET NULL  -- Allows tracking of payment methods
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
-- Service Request Types Table
-- ==========================
CREATE TABLE ServiceRequestType (
    RequestTypeID INT PRIMARY KEY IDENTITY(1,1),
    RequestType NVARCHAR(100) UNIQUE NOT NULL  -- e.g., 'Account Inquiry', 'Card Replacement'
);

-- ==========================
-- Service Request Status Table
-- ==========================
CREATE TABLE ServiceRequestStatus (
    RequestStatusID INT PRIMARY KEY IDENTITY(1,1),
    RequestStatus NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Pending', 'Completed'
);

-- ==========================
-- Service Requests Table 
-- ==========================
CREATE TABLE ServiceRequest (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    RequestTypeID INT FOREIGN KEY REFERENCES ServiceRequestType(RequestTypeID) ON DELETE CASCADE,
    RequestStatusID INT FOREIGN KEY REFERENCES ServiceRequestStatus(RequestStatusID) ON DELETE CASCADE,
    RequestDate DATETIME DEFAULT GETDATE()
);

-- ==========================
-- Online Banking Status Table
-- ==========================
CREATE TABLE OnlineBankingStatus (
    StatusID INT PRIMARY KEY IDENTITY(1,1),
    Status NVARCHAR(50) UNIQUE NOT NULL  -- e.g., 'Active', 'Locked'
);

-- ==========================
-- Online Banking Table 
-- ==========================
CREATE TABLE OnlineBanking (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    LastLogin DATETIME DEFAULT GETDATE(),
    StatusID INT FOREIGN KEY REFERENCES OnlineBankingStatus(StatusID) ON DELETE CASCADE
);

