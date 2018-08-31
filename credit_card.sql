--Make idempotent
DROP TABLE IF EXISTS SalesLT.CreditCard;
--Create new table for credit cards
SELECT CustomerID, rowguid
--make sure card number starts with a 4 and is the right length, but don't worry about check digits in the number syntax
, 4000000000000000 + 1000000*CAST(ABS(CHECKSUM(NEWID())) % 1000000000 as bigint) + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 as bigint) AS CARD_NUMBER
--create a 3-digit / 4-digit number which is mostly 3, and padded with 0s at the beginning if needed
, CASE WHEN RIGHT(rowguid,1) = '4' THEN RIGHT(CustomerID,1) ELSE '' END + 
RIGHT('0000'+CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR(3)),3) AS [SERVICE_CODE]
--MMYY from 0110 to 1229
, RIGHT('000'+CAST((1+ABS(CHECKSUM(NEWID())) % 12) AS VARCHAR(3)),2) + CAST(10+ABS(CHECKSUM(NEWID())) % 20 AS VARCHAR(2)) AS [EXPIRY_DATE] 
INTO SalesLT.CreditCard
FROM AdventureWorksLT.SalesLT.Customer
ORDER BY CustomerID;
--Test
SELECT B.*, A.* FROM SalesLT.Customer A LEFT JOIN SalesLT.CreditCard B ON A.CustomerID=B.CustomerID;