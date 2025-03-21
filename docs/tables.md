# Tables Overview

This page provides an explanation for each table in the Big Bank database schema.

## Branch
- **Description:** Stores information about bank branches.
- **Columns:**
  - `BranchID`: Primary key, auto-increment.
  - `BranchName`: Name of the branch.
  - `Location`: Physical address.
  - `ContactNumber`: Contact details.

## Employee
- **Description:** Contains employee records associated with branches.
- **Columns:**
  - `EmployeeID`: Primary key, auto-increment.
  - `BranchID`: Foreign key referencing `Branch(BranchID)`.
  - `FirstName`, `LastName`: Employee names.
  - `Position`: Job title.
  - `HireDate`: Date of hire.

## Customer
- **Description:** Stores customer details.
- **Columns:**
  - `CustomerID`: Primary key, auto-increment.
  - `BranchID`: Foreign key referencing `Branch(BranchID)`.
  - `FirstName`, `LastName`: Customer names.
  - `DateOfBirth`: Birth date.
  - `Email`: Unique email address.
  - `Phone`: Unique phone number.

## AccountType
- **Description:** Defines types of bank accounts (e.g., Checking, Savings).
- **Columns:**
  - `AccountTypeID`: Primary key, auto-increment.
  - `AccountType`: Unique account type name.

## Account
- **Description:** Represents bank accounts.
- **Columns:**
  - `AccountID`: Primary key, auto-increment.
  - `Balance`: Current balance.
  - `AccountTypeID`: Foreign key referencing `AccountType(AccountTypeID)`.
  - `BranchID`: Foreign key referencing `Branch(BranchID)`.

## DispositionRole
- **Description:** Lists roles for account dispositions (e.g., Owner, User).
- **Columns:**
  - `RoleID`: Primary key, auto-increment.
  - `Role`: Unique role name.

## Dispositions
- **Description:** Associates customers with accounts and defines their role.
- **Columns:**
  - `DispositionID`: Primary key, auto-increment.
  - `CustomerID`: Foreign key referencing `Customer(CustomerID)`.
  - `AccountID`: Foreign key referencing `Account(AccountID)`.
  - `RoleID`: Foreign key referencing `DispositionRole(RoleID)`.

## CardType
- **Description:** Defines types of cards (e.g., Debit, Credit).
- **Columns:**
  - `CardTypeID`: Primary key, auto-increment.
  - `TypeName`: Unique card type name.

## Card
- **Description:** Stores card details issued to accounts.
- **Columns:**
  - `CardID`: Primary key, auto-increment.
  - `AccountID`: Foreign key referencing `Account(AccountID)`.
  - `CardTypeID`: Foreign key referencing `CardType(CardTypeID)`.
  - `CardNumber`: Unique card number.
  - `ExpiryDate`: Card expiration date.
  - `IsValid`: Indicates card validity.
  - `OnlinePurchases`, `Worldwide`: Additional card features.

## Merchant
- **Description:** Stores merchant details.
- **Columns:**
  - `MerchantID`: Primary key, auto-increment.
  - `Name`: Merchant name.

## CardTransaction
- **Description:** Logs transactions made with cards.
- **Columns:**
  - `TransactionID`: Primary key, auto-increment.
  - `CardID`: Foreign key referencing `Card(CardID)`.
  - `TransactionDate`: Defaults to current date.
  - `Amount`: Transaction amount.
  - `Merchant`: Foreign key referencing `Merchant(MerchantID)`.

## TransactionType
- **Description:** Lists types of transactions (e.g., Deposit, Withdrawal).
- **Columns:**
  - `TransactionTypeID`: Primary key, auto-increment.
  - `TransactionType`: Unique transaction type name.

## AccountTransaction
- **Description:** Logs account-level transactions.
- **Columns:**
  - `TransactionID`: Primary key, auto-increment.
  - `AccountID`: Foreign key referencing `Account(AccountID)`.
  - `TransactionDate`: Defaults to current date.
  - `TransactionTypeID`: Foreign key referencing `TransactionType(TransactionTypeID)`.
  - `Amount`: Transaction amount.

## InterestRate
- **Description:** Stores interest rate information.
- **Columns:**
  - `RateID`: Primary key, auto-increment.
  - `InterestRate`: The rate value (non-negative).
  - `IsVariable`: Indicates if the rate is variable.

## Loan
- **Description:** Contains loan details for customers.
- **Columns:**
  - `LoanID`: Primary key, auto-increment.
  - `CustomerID`: Foreign key referencing `Customer(CustomerID)`.
  - `AccountID`: Foreign key referencing `Account(AccountID)`.
  - `LoanAmount`: Principal amount of the loan.
  - `InterestRateID`: Foreign key referencing `InterestRate(RateID)`.
  - `LoanStartDate`: Date when the loan started.
  - `LoanTermMonths`: Loan term in months.

## SecurityType
- **Description:** Defines types of collateral (e.g., Car, House).
- **Columns:**
  - `SecurityTypeID`: Primary key, auto-increment.
  - `SecurityType`: Unique security type name.

## Securities
- **Description:** Represents collateral associated with loans.
- **Columns:**
  - `SecurityID`: Primary key, auto-increment.
  - `CustomerID`: Foreign key referencing `Customer(CustomerID)`.
  - `LoanID`: Foreign key referencing `Loan(LoanID)`.
  - `SecurityTypeID`: Foreign key referencing `SecurityType(SecurityTypeID)`.
  - `EstimatedValue`: Estimated value of the security.
  - `Description`: Additional details.
  - `OwnershipDocument`: Path to any ownership documentation.

## PaymentMethod
- **Description:** Lists accepted payment methods.
- **Columns:**
  - `PaymentMethodID`: Primary key, auto-increment.
  - `MethodName`: Unique method name (e.g., Bank Transfer, Cash).

## LoanPayment
- **Description:** Records loan payment details.
- **Columns:**
  - `PaymentID`: Primary key, auto-increment.
  - `LoanID`: Foreign key referencing `Loan(LoanID)`.
  - `PaymentDate`: Defaults to current date.
  - `AmountPaid`: Amount that was paid.
  - `PaymentMethodID`: Foreign key referencing `PaymentMethod(PaymentMethodID)`.

## FeeCharges
- **Description:** Logs fees and charges applied to accounts.
- **Columns:**
  - `FeeID`: Primary key, auto-increment.
  - `AccountID`: Foreign key referencing `Account(AccountID)`.
  - `FeeType`: Type or description of the fee.
  - `FeeAmount`: Amount of the fee.
  - `ChargedDate`: Defaults to current date.

## ServiceRequestType
- **Description:** Defines types of service requests (e.g., Account Inquiry, Card Replacement).
- **Columns:**
  - `RequestTypeID`: Primary key, auto-increment.
  - `RequestType`: Unique request type name.

## ServiceRequestStatus
- **Description:** Lists the statuses for service requests.
- **Columns:**
  - `RequestStatusID`: Primary key, auto-increment.
  - `RequestStatus`: Unique status description (e.g., Pending, Completed).

## ServiceRequest
- **Description:** Tracks customer service requests.
- **Columns:**
  - `RequestID`: Primary key, auto-increment.
  - `CustomerID`: Foreign key referencing `Customer(CustomerID)`.
  - `RequestTypeID`: Foreign key referencing `ServiceRequestType(RequestTypeID)`.
  - `RequestStatusID`: Foreign key referencing `ServiceRequestStatus(RequestStatusID)`.
  - `RequestDate`: Defaults to current date.

## OnlineBankingStatus
- **Description:** Defines the statuses for online banking sessions (e.g., Active, Locked).
- **Columns:**
  - `StatusID`: Primary key, auto-increment.
  - `Status`: Unique status description.

## OnlineBanking
- **Description:** Manages online banking sessions for customers.
- **Columns:**
  - `SessionID`: Primary key, auto-increment.
  - `CustomerID`: Foreign key referencing `Customer(CustomerID)`.
  - `LastLogin`: Defaults to current date.
  - `StatusID`: Foreign key referencing `OnlineBankingStatus(StatusID)`.
