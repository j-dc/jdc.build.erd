
CREATE SCHEMA test;


CREATE TABLE test.customers (
    customerId SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE test.orders (
    orderId SERIAL PRIMARY KEY,
    customerId INT NOT NULL,
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    totalAmount NUMERIC(10,2),
    FOREIGN KEY (customerId) REFERENCES test.customers(customerId)
);


CREATE TABLE test.orderItems (
    orderItemId SERIAL PRIMARY KEY,
    orderId INT NOT NULL,
    productName VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    FOREIGN KEY (orderId) REFERENCES test.orders(orderId)
);








