-- TABLE: product --
DROP TABLE product;
CREATE TABLE product 
	(prod_id int AUTO_INCREMENT,
     prod_name varchar(30) NOT NULL,
     prod_src varchar(50) NOT NULL,
     prod_sales bigint NOT NULL,
     PRIMARY KEY(prod_id));
     
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Canned Tuna', 'Puregold', 275);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Rice', 'Puregold', 300);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Diaper', 'SM', 400);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Bread', 'Landers', 275);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Mayonnaise', 'Landers', 275);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('EXO: EXIST Album', 'Naver', 1074914);
INSERT INTO product (prod_name, prod_src, prod_sales) values ('Cigarette', 'Southstar', 0);

UPDATE product
	SET prod_sales = 10
    WHERE prod_name = 'Cigarette';
    
-- TABLE: inventory --

DROP TABLE inventory;
CREATE TABLE inventory 
	(prod_id int NOT NULL,
     prod_qty bigint NOT NULL,
     prod_bad bigint NOT NULL,
     PRIMARY KEY(prod_id));
     
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (1, 125, 10);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (2, 300, 25);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (3, 225, 8);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (4, 32, 15);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (5, 57, 7);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (6, 2000000, 45090);
INSERT INTO inventory (prod_id, prod_qty, prod_bad) values (7, 50, 20);

-- TABLE: delivery --
DROP TABLE delivery;
CREATE TABLE delivery
	( _id int AUTO_INCREMENT NOT NULL,
	 delivery_id varchar(10) NOT NULL,
     delivery_date date NOT NULL,
     delivery_prod int NOT NULL,
     delivery_qty bigint NOT NULL,
     PRIMARY KEY(_id));
     
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (1, 202311101, current_date(), 1, 135);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (2, 202311102, current_date(), 2, 325);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (3, 202311103, current_date(), 3, 233);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (4, 202311104, current_date(), 4, 47);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (5, 202311105, current_date(), 5, 64);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (6, 202311106, current_date(), 6, 2000000 + 45090);
INSERT INTO delivery (_id, delivery_id, delivery_date, delivery_prod, delivery_qty) values (7, 202311107, current_date(), 7, 70);

-- TEST script --
INSERT INTO product (prod_name, prod_src, prod_sales) values ('TEST', 'TEST', 1000);
DELETE FROM product
    WHERE prod_name = 'TEST';

-- CMD for Projected Sales --
SELECT
	p.prod_id as prod_id,
    p.prod_name as prod_name,
    (p.prod_sales + i.prod_qty) as projected_sales
FROM product p
LEFT JOIN inventory i
	ON p.prod_id = i.prod_id;

-- CMD for Item Categorization --
SELECT 
	CASE
		WHEN prod_name = 'Canned Tuna' then 'FOOD'
        WHEN prod_name = 'Rice' then 'FOOD'
        WHEN prod_name = 'Bread' then 'FOOD'
        WHEN prod_name = 'Mayonnaise' then 'FOOD'
        WHEN prod_name = 'Diaper' then 'ESSENTIALS'
        WHEN prod_name = 'Cigarette' then 'RECREATIONAL'
        WHEN prod_name = 'EXO: EXIST Album' then 'OTHERS'
        END as category,
        SUM(prod_sales) as total_sales
	FROM product
    GROUP BY category;
    
-- CMD for Product Ideality --
SELECT 
	p.prod_name as productName,
	p.prod_src as productSource,
	d.delivery_qty as deliveryQuantity,
	i.prod_bad as quantityOfBadProducts,
	CASE
		WHEN prod_bad >= delivery_qty * 0.05 then 'NOT IDEAL'
			ELSE 'IDEAL'
		END as QUALITY
	FROM product p
    LEFT JOIN inventory i
		ON p.prod_id = i.prod_id
	LEFT JOIN delivery d
		on p.prod_id = d._id
    WHERE MONTH(d.delivery_date) = 11;

-- CMDS for Viewing --
SELECT * FROM product;
SELECT * FROM delivery;
SELECT * FROM inventory;

     
    

