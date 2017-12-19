DROP TABLE IF EXISTS purchases_items;
DROP TABLE IF EXISTS purchases_orders;
DROP TABLE IF EXISTS sale_items;
DROP TABLE IF EXISTS sale_orders;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS artists;

-- Table artists
CREATE TABLE artists (
  art_id SERIAL4 PRIMARY KEY,
  art_name  VARCHAR(50) UNIQUE NOT NULL,
  art_photo VARCHAR(50) UNIQUE NOT NULL
);

-- Table genres
CREATE TABLE genres (
  gen_id SERIAL4 PRIMARY KEY,
  gen_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table albums
CREATE TABLE albums (
  alb_id SERIAL4 PRIMARY KEY,
  alb_title VARCHAR(50) UNIQUE NOT NULL,
  alb_price INT2 NOT NULL,
  alb_image VARCHAR(50),
  alb_art_id INT4 REFERENCES artists(art_id) NOT NULL,
  alb_gen_id INT4 REFERENCES genres(gen_id) NOT NULL,
  alb_qty_available INT2 NOT NULL,
  alb_qty_min INT2 NOT NULL,
  alb_qty_max INT2 NOT NULL
);

-- Table suppliers
CREATE TABLE suppliers (
  sup_id SERIAL4 PRIMARY KEY,
  sup_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table customers
CREATE TABLE customers (
  cus_id SERIAL4 PRIMARY KEY,
  cus_name VARCHAR(50) UNIQUE NOT NULL
);


-- Table purchases orders
CREATE TABLE purchase_orders (
  pro_id SERIAL4 PRIMARY KEY,
  pro_sup_id INT4 REFERENCES suppliers(sup_id),
  pro_total_price INT2 NOT NULL,
  pro_date DATE NOT NULL,
  pro_statuts VARCHAR(1)
);

-- Table purchases items
CREATE TABLE purchase_items (
  pri_id SERIAL4 PRIMARY KEY,
  pri_qty INT2 NOT NULL,
  pri_unit_price INT2 NOT NULL,
  pri_alb_id INT4 REFERENCES albums(alb_id),
  pri_pro_id INT4 REFERENCES purchase_orders(pro_id)
);



-- Table sales_main
CREATE TABLE sale_orders (
  slo_id SERIAL4 PRIMARY KEY,
  slo_cus_id INT4 REFERENCES customers(cus_id),
  slo_total_price INT2 NOT NULL,
  slo_date DATE NOT NULL,
  slo_status VARCHAR(1)
);

-- Table sales_items
CREATE TABLE sale_items (
  sli_id SERIAL4 PRIMARY KEY,
  sli_qty INT2 NOT NULL,
  sli_unit_price INT2 NOT NULL,
  sli_alb_id INT4 REFERENCES albums(alb_id),
  sli_slo_id INT4 REFERENCES sale_orders(slo_id)
);
