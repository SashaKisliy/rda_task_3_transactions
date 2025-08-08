-- Use our database
USE ShopDB; 

-- Start the transaction 
START TRANSACTION; 

-- Create order inside the transaction for atomicity
INSERT INTO Orders (CustomerID, Date)
VALUES (1, '2023-01-01');

-- Create order item linked to the just created order
INSERT INTO OrderItems (OrderID, ProductID, Count)
VALUES (LAST_INSERT_ID(), 1, 1);

UPDATE Products SET WarehouseAmount = WarehouseAmount - 1 WHERE ID = 1;

COMMIT; 