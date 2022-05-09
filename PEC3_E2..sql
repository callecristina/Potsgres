--2
---a)
----- Se crea las tablas según las especificaciones
SET SCHEMA 'erp';
CREATE TABLE tb_quarter(
	quarter INT NOT NULL,
	year INT NOT NULL,
	cust_no CHAR(5) NOT NULL,
	iva_percent INT NOT NULL,
	amount REAL NOT NULL,
	PRIMARY KEY(quarter,year)
	FOREIGN KEY(cust_no) REFERENCES erp.tb_customer(cust_no)
	)
---b)
--Se crea procesamiento con parametro año y trimestre para hacer la busqueda
CREATE OR REPLACE PROCEDURE pr_calc_quarter(_year INT, _quarter INT)
    LANGUAGE plpgsql
AS $$
BEGIN
		SELECT 
		EXTRACT(QUARTER from inv.last_update_date) AS quarter,
		EXTRACT(YEAR FROM inv.last_update_date) AS year,
		inv.cust_no AS cust_no, 
		iva_percent AS iva_percent,
		SUM(tot_amount) AS tot_amount
	FROM erp.tb_invoice inv
		INNER JOIN tb_iva iva ON iva.co_code = inv.co_code
		INNER JOIN tb_site site ON site.site_id = inv.site_id
		AND site.cust_no = inv.cust_no
		AND site.co_code = inv.co_code
	WHERE EXTRACT(QUARTER from inv.last_update_date)=_quarter AND EXTRACT(YEAR FROM inv.last_update_date)=_year
	GROUP BY inv.cust_no, iva.iva_percent, inv.last_update_date;
END
$$
--c)
--Se crea una función parametros que devuelve una tabla
CREATE OR REPLACE FUNCTION fn_calc_quarter(_year INT, _quarter INT)
	RETURNS TABLE(
				quarter INT,
    			year INT,
    			cust_no CHAR(5),
    			iva_percent INT,
    			amount REAL)
	AS $fcq$
	BEGIN
		RETURN QUERY
			SELECT DISTINCT
				extract(quarter from inv.last_update_date) as quarter,
				extract(year from inv.last_update_date) as year,
				inv.cust_no, 
				iva_percent,
				SUM(tot_amount) OVER (PARTITION BY inv.cust_no, iva.iva_percent) AS amount
			FROM erp.tb_invoice inv
				INNER JOIN tb_iva iva ON iva.co_code = inv.co_code
				INNER JOIN tb_site site ON site.site_id = inv.site_id
				AND site.cust_no = inv.cust_no
				AND site.co_code = inv.co_code
			WHERE quater=_quarter AND year=_year;
	END;
	$fcq$
	LANGUAGE plpgsql;










