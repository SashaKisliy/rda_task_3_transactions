#! /bin/bash

taskText=$(cat task.sql)
afterTransactionStart="${taskText#*'START TRANSACTION;'}" 

# test if there is only one transaction in the script
startTransactionStr=$(cat task.sql | grep "^START TRANSACTION;" || true)
wordCount=$(echo $startTransactionStr | wc -w ) 
if [ "$wordCount" = "2" ]; then
    echo "checked number of transactions - ok"
else
    echo "error: wrong number of transactions, expected: 1"
    exit 1
fi

# test that "INSERT INTO Orders" exists and is inside the transaction
insertIntoOrdersAnywhere=$(echo $taskText | grep "INSERT INTO Orders" || true)
if [ -z "$insertIntoOrdersAnywhere" ]; then
    echo "error: Orders are not updated in the script"
    exit 1
else 
    echo "checked if Orders are updated inside the script - ok"
fi
insertIntoOrdersInside=$(echo $afterTransactionStart | grep "INSERT INTO Orders" || true)
if [ -z "$insertIntoOrdersInside" ]; then
    echo "error: Orders are not updated inside of the transaction"
    exit 1
else 
    echo "checked if Orders are updated inside of the transaction - ok"
fi

# test if "INSERT INTO OrderItems" is between the "START TRANSACTION" and "COMMIT"
insertIntoOrderItems=$(echo $afterTransactionStart | grep "INSERT INTO OrderItems" || true)
if [ -z "$insertIntoOrderItems" ]; then
    echo "error: OrderItems are not updated inside of the transaction"
    exit 1
else 
    echo "checked if OrderItems are updated inside of the transaction - ok"
fi

# test if "UPDATE Products" is between the "START TRANSACTION" and "COMMIT"
updateProducts=$(echo $afterTransactionStart | grep "UPDATE Products SET WarehouseAmount" || true)
if [ -z "$updateProducts" ]; then
    echo "error: Products are not updated inside of the transaction"
    exit 1
else 
    echo "checked if Products are updated inside of the transaction - ok"
fi