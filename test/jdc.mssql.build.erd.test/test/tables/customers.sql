CREATE TABLE test.customers (
    customerId INT IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    CONSTRAINT PK_customers PRIMARY KEY (customerId)
);

