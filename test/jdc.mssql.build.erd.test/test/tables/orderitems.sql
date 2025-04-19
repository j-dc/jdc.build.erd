

CREATE TABLE test.orderItems (
    orderItemId INT IDENTITY(1,1),
    orderId INT NOT NULL,
    productName NVARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    CONSTRAINT PK_orderItems PRIMARY KEY (orderItemId),
    FOREIGN KEY (orderId) REFERENCES test.orders(orderId)
);
