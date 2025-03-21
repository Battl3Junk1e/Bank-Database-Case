# Normalization and 3NF

## What is Third Normal Form (3NF)?

Third Normal Form (3NF) is a database design approach aimed at reducing data redundancy and eliminating undesirable characteristics like insertion, update, and deletion anomalies. For a table to be in 3NF, it must satisfy the following conditions:  
- **1NF (First Normal Form):**  
The table has a primary key, and all attributes contain only atomic (indivisible) values.  
- **2NF (Second Normal Form):**  
The table is in 1NF, and every non-key attribute is fully functionally dependent on the primary key.  
- **3NF (Third Normal Form):**  
The table is in 2NF, and there are no transitive dependencies among the non-key attributes (i.e., non-key attributes do not depend on other non-key attributes).

## How the Big Bank Schema Follows 3NF

- **Atomicity and Primary Keys:**  
  Every table in the schema defines a primary key (typically an auto-incremented integer) and ensures that all columns hold atomic values.

- **Functional Dependencies:**  
  Each table is designed so that non-key columns are fully functionally dependent on the primary key. For example, in the `Customer` table, the customer's first name, last name, and contact information depend solely on `CustomerID`.

- **Elimination of Transitive Dependencies:**  
  By separating entities into different tables (e.g., splitting account types, transaction types, and roles into their own tables), the design avoids transitive dependencies. This separation ensures that updates to attributes in one table (like updating a transaction type) do not cause anomalies in another table.

- **Use of Foreign Keys:**  
  The schema extensively uses foreign keys to enforce relationships between tables, further ensuring that data remains consistent and adheres to normalization rules.

This design minimizes redundancy and improves maintainability while ensuring the integrity of the data through proper relational mapping.
