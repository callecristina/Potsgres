--DROP DATABASE IF EXISTS pec2;
--CREATE DATABASE pec2
    --WITH 
    --OWNER = postgres
    --ENCODING = 'UTF8'
    --CONNECTION LIMIT = -1;
	
CREATE SCHEMA erp;

CREATE TABLE erp.tb_company (
	co_code CHAR(3) NOT NULL UNIQUE,
	co_name VARCHAR(50) NOT NULL UNIQUE,
	co_address VARCHAR(150) NOT NULL,
	co_city VARCHAR(50) NOT NULL,
	co_country VARCHAR(30) NOT NULL DEFAULT 'España',
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	PRIMARY KEY(co_code)
	);

	
CREATE TABLE erp.tb_customer(
	cust_no CHAR(5) NOT NULL,
	cust_name VARCHAR(50) NOT NULL UNIQUE,
	cust_cif VARCHAR(15) NOT NULL UNIQUE,
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	PRIMARY KEY(cust_no)
 	);

CREATE TABLE erp.tb_site(
	cust_no CHAR(5) NOT NULL,
	site_id INT NOT NULL PRIMARY KEY,
	site_code CHAR(5) NOT NULL,
	site_name VARCHAR(50) NOT NULL,
	site_address VARCHAR(150) NOT NULL,
	site_city VARCHAR(50) NOT NULL,
	site_country VARCHAR(30) NOT NULL DEFAULT 'España',
	site_phone BIGINT,
	co_code VARCHAR(3) NOT NULL,
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	FOREIGN KEY(cust_no) REFERENCES erp.tb_customer(cust_no),
	FOREIGN KEY(co_code) REFERENCES erp.tb_company(co_code)
	);

CREATE TABLE erp.tb_iva(
	co_code CHAR(3) NOT NULL,
	iva_id INT NOT NULL PRIMARY KEY,
	iva_no VARCHAR(15) NOT NULL,
	iva_percent INT NOT NULL,
	active_flag CHAR(1) NOT NULL DEFAULT 'Y',
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	FOREIGN KEY(co_code) REFERENCES erp.tb_company(co_code)
	);
	
CREATE TABLE erp.tb_invoice(
	co_code CHAR(3) NOT NULL,
	invoice_id INT NOT NULL PRIMARY KEY,
	invoice_no VARCHAR(15) NOT NULL,
	cust_no CHAR(5) NOT NULL,
	site_id INT NOT NULL,
	payed CHAR(1) NOT NULL DEFAULT 'N',
	net_amount REAL NOT NULL,
	iva_amount REAL NOT NULL,
	tot_amount REAL NOT NULL,
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	FOREIGN KEY(co_code) REFERENCES erp.tb_company(co_code),
	FOREIGN KEY(cust_no) REFERENCES erp.tb_customer(cust_no),
	FOREIGN KEY(site_id) REFERENCES erp.tb_site(site_id)
	);
	
CREATE TABLE erp.tb_lines(
	invoice_id INT NOT NULL,
	line_id INT NOT NULL PRIMARY KEY,
	line_num INT NOT NULL,
	item CHAR(5),
	description VARCHAR(120) NOT NULL,
	net_amount REAL NOT NULL,
	iva_amount REAL NOT NULL,
	last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
	last_update_date DATE NOT NULL,
	FOREIGN KEY(invoice_id) REFERENCES erp.tb_invoice(invoice_id)
);
