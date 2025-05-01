CREATE TABLE test.orders (
    orderId INT  IDENTITY(1,1),
    customerId INT NOT NULL,
    orderDate DATETIME DEFAULT GETDATE(),
    totalAmount DECIMAL(10,2),
    CONSTRAINT PK_orders PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES test.customers(customerId)
);