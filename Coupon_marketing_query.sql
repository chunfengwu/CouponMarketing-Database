use COUPON_MARKETING;

/*customer*/

select p.Product_id, p.Price, pc.Category_name 
from product p 
left join product_category pc 
on p.Category_id = pc.category_id;

select m.Product_id, m.US_size, m.Price ,m.Num_of_Stock, pc.Category_name
from (select n.Product_id, n.US_size, p.Price ,n.Num_of_Stock,p.Category_id
from  (select i.Product_id, s.US_size, i.Num_of_Stock
		from inventory i
		left join size s
		on i.Size_id = s.Size_id) n
		left join product p
		on n.Product_id = p.Product_id
		where n.Product_id = 1) m
left join product_category pc
on  m.Category_id = pc.Category_id;

select m.Product_id, m.US_size, m.Price ,m.Num_of_Stock, pc.Category_name
from (select n.Product_id, n.US_size, p.Price ,n.Num_of_Stock,p.Category_id
from  (select i.Product_id, s.US_size, i.Num_of_Stock
		from inventory i
		left join size s
		on i.Size_id = s.Size_id) n
		left join product p
		on n.Product_id = p.Product_id) m
left join product_category pc
on  m.Category_id = pc.Category_id
where m.US_size = 6 and m.Price<100 and pc.Category_name ='Boots';


Select * FROM customer order by customer_name;
set sql_safe_updates = 0;
UPDATE customer SET customer_name = "Justine Cooper" WHERE customer_name = "Justine Gates";
Select * FROM customer order by customer_name;


SELECT customer_name, order_id, order_date, order_status, s.country, street_ship AS street, city_ship AS city, state_ship AS state, zip_ship AS zip 
FROM customer c 
JOIN `order` o
ON o.customer_id = c.customer_id
JOIN ship_address s 
ON s.shipaddress_id = o.ship_address_id
WHERE customer_name = "Bailey Rosa";


INSERT INTO `order` (order_id, order_date, order_status, customer_id, ship_address_id)
VALUES (250, "2018-03-01 10:38:00", "placed", 65941121199, 117);
INSERT INTO order_product_info
VALUES (57, 250, 1, 1, 1, '');
select * from `order`;
select* from order_product_info;

SELECT Customer_Name, order_id, order_date, order_status, s.country, street_ship AS street, city_ship AS city, state_ship AS state, zip_ship AS zip 
FROM customer c JOIN `order` o
ON o.customer_id = c.customer_id
JOIN ship_address s ON s.shipaddress_id = o.ship_address_id
WHERE customer_name = "Suki Poole";

/*warehouse*/

SELECT o.order_id, order_date, order_quantity, product_id,  US_size, country, street_ship AS Street, city_ship AS City, state_ship AS State, zip_ship AS Zip
FROM `order` o JOIN order_product_info pi
ON o.order_id = pi.order_id
LEFT JOIN size 
ON size.Size_id = pi.Size_id
JOIN ship_address s
ON s.shipaddress_id = o.ship_address_id
WHERE order_status='placed';

SELECT Product_id, US_size, UK_size, Num_of_stock AS 'Quantity in Stock' 
FROM inventory i
LEFT JOIN size
ON i.Size_id = size.Size_id;

SELECT * FROM `order` WHERE order_status = 'cancelled';

DELETE FROM `order` WHERE order_status = 'cancelled';

SELECT count(order_status) FROM `order` WHERE order_status = 'cancelled';

SELECT * FROM coupon
WHERE total_num_used = (SELECT MAX(total_num_used) FROM coupon);

SELECT nn.customer_id, nn.oc AS 'Number of Coupons Used' FROM ((select customer_id, COUNT(distinct o.order_id) AS oc 
FROM `order` o join order_product_info opi on o.order_id = opi.order_id
WHERE coupon_id IS NOT NULL 
GROUP BY customer_id) nn JOIN
(SELECT customer_id, COUNT(distinct order_id) AS ao FROM `order` GROUP BY customer_id) a ON nn.customer_id = a.customer_id)
WHERE nn.oc = a.ao;

SELECT c.Customer_id, Customer_name FROM `order` o RIGHT JOIN customer c 
ON o.customer_id = c.customer_id
WHERE order_id IS NULL;

SELECT a.customer_id, a.date_m
FROM(
SELECT customer_id, COUNT(customer_id) AS size, MAX(MONTH(Order_date)) AS date_m
FROM `order`
GROUP BY customer_id ) a
WHERE 12 - date_m >= 6;

SELECT Product_id, SUM(Num_of_stock) AS `Quantity in Stock` FROM inventory 
GROUP BY Product_id
HAVING SUM(Num_of_stock) >300;

/*Index*/

CREATE INDEX order_index ON `order` (order_id);
SHOW INDEX FROM `order`;

CREATE INDEX product_index ON product (product_id);
SHOW INDEX FROM product;

/*Views*/
CREATE VIEW Customer_view AS
select o.Order_id, p.Product_id, p.Price, op.Order_quantity, c.Coupon_ID, c.Discount_Value, 
	IF(c.Coupon_ID is not null, p.Price*op.Order_quantity*(1-c.Discount_Value),p.Price*op.Order_quantity) as payment, o.Order_status
from `order` o
LEFT JOIN order_product_info op
on o.Order_id = op.Order_id
LEFT JOIN product p
on op.Product_id = p.Product_id
LEFT JOIN coupon c
on op.Coupon_id = c.Coupon_ID
group by o.Order_id;
select * from Customer_view;

CREATE VIEW Warehouse_view AS
SELECT o.Order_id, o.Order_date, o.Order_status, o.Customer_id, Customer_name, i.Product_id, i.Size_id, Num_of_Stock, ShipAddress_id, s.Country, Street_Ship, City_ship, State_ship, ZIP_ship
FROM `order` o JOIN customer c ON o.customer_id = c.customer_id
JOIN order_product_info op ON o.order_id = op.order_id
JOIN inventory i ON op.product_id = i.product_id
JOIN ship_address s ON s.ShipAddress_id = o.Ship_Address_ID;
SELECT * FROM Warehouse_view;


CREATE VIEW Coupon_view AS
select c.Coupon_ID, o.order_id, c.Discount_Value, p.Product_id, p.Price, op.Order_quantity,  p.Price*op.Order_quantity*(1-c.Discount_Value) as payment
from `order` o
LEFT JOIN order_product_info op
on o.order_id = op.order_id
LEFT JOIN product p
on op.product_id = p.product_id
LEFT JOIN coupon c
on op.coupon_id = c.coupon_id
where c.coupon_id is not null;
select * from  Coupon_view;

CREATE VIEW Customer_order_info_view AS
select c.Customer_ID, c.Customer_Name, c.Gender, c.Country, c.Street, c.City, c.State, c.ZIP, c.Email, c.Num_Visits,
c.First_Visit, c.Last_Visit, o.Order_id, p.Product_id, p.Price, op.Order_quantity, co.Coupon_ID, co.Discount_Value,
IF(co.Coupon_ID is not null, p.Price*op.Order_quantity*(1-co.Discount_Value),p.Price*op.Order_quantity) as payment, o.Order_status
from customer c
LEFT JOIN `order` o
on c.Customer_ID = o.Customer_ID
LEFT JOIN order_product_info op
on o.Order_id = op.Order_id
LEFT JOIN product p
on op.Product_id = p.Product_id
LEFT JOIN coupon co
on op.Coupon_id = co.Coupon_ID;
select * from Customer_order_info_view;


/*Triggers*/

DELIMITER $$
CREATE TRIGGER NO_DULICATE_CUSTOMER_TRIGGER
BEFORE INSERT ON customer
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT * FROM customer c WHERE c.Customer_Name = NEW.Customer_Name and c.ZIP = NEW.ZIP) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: This customer already exists';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER COUPON_EXPIRATION_SETTING_TRIGGER
BEFORE INSERT ON coupon
FOR EACH ROW
BEGIN
  IF NEW.Expiration_Time < NOW()
  THEN
   SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Expiration date can not be earlier than now!';
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER NO_EXPIRATION_COUPON_TRIGGER
BEFORE INSERT ON order_product_info
FOR EACH ROW
BEGIN
  IF (SELECT * FROM `order_product_info` op join coupon c
  ON c.Coupon_ID = op.Coupon_ID where c.Expiration_Time < NOW() )
  THEN
   SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: This coupon has been expired!';
  END IF;
END$$
DELIMITER ;



/*Metrics*/

SELECT  sum(n.Price*(1-c.Discount_Value)*n.Order_quantity) 
         as 'Revenue without Coupons'
from  
(select p.Price, o.Order_quantity, o.coupon_id
from order_product_info o
left join product p
on p.Product_id = o.Product_id
WHERE o.coupon_id IS not NULL) n
left join coupon c
on n.coupon_id = c.Coupon_ID;



SELECT  sum(p.Price*o.Order_quantity) as 'Revenue w/o Coupons'
from order_product_info o
left join product p
on p.Product_id = o.Product_id
WHERE o.coupon_id IS NULL;

SELECT COUNT(distinct o.order_id) AS `Number of Orders with Coupons` FROM `order` o JOIN order_product_info opi 
ON o.order_id = opi.order_id 
WHERE coupon_id IS NOT NULL; 

SELECT  COUNT(distinct o.order_id) AS `Number of Orders without Coupons` FROM `order` o JOIN order_product_info opi 
ON o.order_id = opi.order_id 
WHERE coupon_id IS NULL; 

select product_id, count(distinct o.order_id) as `Number of Orders w/o Coupons` from `order` o join order_product_info p 
on o.order_id = p.order_id 
where coupon_id is null
group by product_id;

select product_id, count(distinct o.order_id) as `Number of Orders w/Coupons` from `order` o join order_product_info p 
on o.order_id = p.order_id 
where coupon_id is not null 
group by product_id;

SELECT category_name, SUM(order_quantity) AS `Quantity Ordered` FROM order_product_info p JOIN product pr 
ON pr.product_id = p.product_id
JOIN product_category c ON c.category_id = pr.category_id
GROUP BY category_name
ORDER BY `Quantity Ordered` DESC;

SELECT month(Order_date) as month, count(*) as order_number_permonth 
FROM `order`
GROUP BY month(Order_date);







