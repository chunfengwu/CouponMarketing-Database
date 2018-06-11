INSERT INTO customer
VALUES (37875593499, 'Preston Cherry', 'Male', 'United States', '5815 Augue Ave', 'Salt Lake City', 'Utah', 84101, 
'1-576-557-8961', 'facilisis.eget.ipsum@massa.co.uk', 4861, 7, '20170401 02:16:00', '20180120 07:45:00');

INSERT INTO coupon
VALUES ('A1',1, '20170101 00:00:00', '20170131 00:00:00', 0.05, 1);


INSERT INTO ship_address
VALUES (100,'United States', '5815 Augue Ave', 'Salt Lake City', 'Utah', 84101);


INSERT INTO inventory
VALUES (1, 1, 1, 84);

INSERT INTO product
VALUES (1, 80, 'A001');


INSERT INTO order_product_info
VALUES (1, 200, 1, 3, 3, null);


INSERT INTO `order` (order_id, order_date, order_status, customer_id, ship_address_id)
VALUES (200, '20170520 15:22:00', 'delivered', 37875593499, 100);


INSERT INTO product_category
VALUES ('A001', 'Sandals');


INSERT INTO size
VALUES (1, 5, 3);

