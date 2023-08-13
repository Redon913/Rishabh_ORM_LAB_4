-- Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
SELECT c.CUS_GENDER, COUNT(*) AS total_customers
FROM customer c
JOIN order o ON c.CUS_ID = o.CUS_ID
JOIN pricing p ON o.PRICING_ID = p.PRICING_ID
WHERE o.ORD_AMOUNT >= 3000
GROUP BY c.CUS_GENDER;


-- Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT o.ORD_ID, p.PRO_NAME, o.ORD_AMOUNT, o.ORD_DATE
FROM `order` o
JOIN customer c ON o.CUS_ID = c.CUS_ID
JOIN pricing pr ON o.PRICING_ID = pr.PRICING_ID
JOIN product p ON pr.PRO_ID = p.PRO_ID
WHERE c.CUS_ID = 2;


-- Display the Supplier details who can supply more than one product.
SELECT s.SUPP_ID, s.SUPP_NAME, s.SUPP_CITY, s.SUPP_PHONE, COUNT(sp.PRO_ID) AS product_count
FROM supplier s
JOIN supplier_pricing sp ON s.SUPP_ID = sp.SUPP_ID
GROUP BY s.SUPP_ID, s.SUPP_NAME, s.SUPP_CITY, s.SUPP_PHONE
HAVING product_count > 1;


-- Find the least expensive product from each category and print the table with category id, name, product name and price of the product
SELECT 
    c.CAT_ID,
    c.CAT_NAME,
    p.PRO_NAME,
    MIN(sp.SUPP_PRICE) AS product_price
FROM
    category c
JOIN
    product p ON c.CAT_ID = p.CAT_ID
JOIN
    supplier_pricing sp ON p.PRO_ID = sp.PRO_ID
WHERE
    sp.SUPP_PRICE > 0
GROUP BY
    c.CAT_ID, c.CAT_NAME, p.PRO_NAME;


-- Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT p.PRO_ID, p.PRO_NAME
FROM product p
JOIN pricing pr ON p.PRO_ID = pr.PRO_ID
JOIN `order` o ON pr.PRICING_ID = o.PRICING_ID
WHERE o.ORD_DATE > '2021-10-05';


--Display customer name and gender whose names start or end with character 'A'.
SELECT CUS_NAME, CUS_GENDER
FROM customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';


--Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
DELIMITER //

CREATE PROCEDURE GetSupplierInfoWithServiceType()
BEGIN
    SELECT
        s.SUPP_ID,
        s.SUPP_NAME,
        r.RAT_RATSTARS AS rating,
        CASE
            WHEN r.RAT_RATSTARS = 5 THEN 'Excellent Service'
            WHEN r.RAT_RATSTARS > 4 THEN 'Good Service'
            WHEN r.RAT_RATSTARS > 2 THEN 'Average Service'
            ELSE 'Poor Service'
        END AS Type_of_Service
    FROM
        supplier s
    LEFT JOIN
        rating r ON s.SUPP_ID = r.SUPP_ID;
END //

DELIMITER ;
