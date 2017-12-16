DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stocks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS artists;

-- Table artists
CREATE TABLE artists (
  art_id SERIAL4 PRIMARY KEY,
  art_name VARCHAR(50) NOT NULL
);

-- Table genres
CREATE TABLE genres (
  gen_id SERIAL4 PRIMARY KEY,
  gen_name VARCHAR(50) NOT NULL
);

-- Table albums
CREATE TABLE albums (
  alb_id SERIAL4 PRIMARY KEY,
  alb_title VARCHAR(50) NOT NULL,
  alb_price INT2 NOT NULL,
  alb_cover_image VARCHAR(50),
  alb_art_id INT4 REFERENCES artists(art_id) NOT NULL,
  alb_gen_id INT4 REFERENCES genres(gen_id) NOT NULL
);

-- Table stocks
CREATE TABLE stocks (
  sto_id SERIAL4 PRIMARY KEY,
  sto_qty_available INT2 NOT NULL,
  sto_qty_min INT2 NOT NULL,
  sto_qty_max INT2 NOT NULL,
  sto_alb_id INT4 REFERENCES albums(alb_id) NOT NULL
);

-- Table suppliers
CREATE TABLE suppliers (
  sup_id SERIAL4 PRIMARY KEY,
  sup_name VARCHAR(50) NOT NULL
);

-- Table customers
CREATE TABLE customers (
  cus_id SERIAL4 PRIMARY KEY,
  cus_name VARCHAR(50) NOT NULL
);

-- Table purchases
CREATE TABLE purchases (
  pur_id SERIAL4 PRIMARY KEY,
  pur_qty INT2 NOT NULL,
  pur_unit_price INT2 NOT NULL,
  pur_total_price INT2 NOT NULL,
  pur_date DATE NOT NULL,
  pur_sup_id INT4 REFERENCES suppliers(sup_id),
  pur_alb_id INT4 REFERENCES albums(alb_id)
);

-- Table sales
CREATE TABLE sales (
  sal_id SERIAL4 PRIMARY KEY,
  sal_qty INT2 NOT NULL,
  sal_unit_price INT2 NOT NULL,
  sal_total_price INT2 NOT NULL,
  sal_date DATE NOT NULL,
  sal_cus_id INT4 REFERENCES customers(cus_id),
  sal_alb_id INT4 REFERENCES albums(alb_id)
);
