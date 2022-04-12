---a
----EL LA EXTENSIÓN DE DATO A INGRESAR NO COINCIDE POR LO QUE HAY QUE CAMBIARLA
----ALTER TABLE erp.tb_site ALTER COLUMN cust_no SET DATA TYPE CHAR(6);
----LAS LLAVES FORANEAS DE LOS CLIENTES NO EXISTEN POR LO TANTO NO SE PUEDEN INGRESAR LOS REGISTROS SOLICITADOS 

--INSERT INTO erp.tb_site(cust_no, site_id, site_code, site_name, site_address, site_city, site_country, site_phone, co_code, last_update_date)
	--VALUES ('C00007', 27,'S1202','ALMACEN VIGO', 'camino des Relfas, 120', 'Vigo','España',NULL,'AB1', CURRENT_DATE),
		--('C00007', 28, 'S1203', 'OFICINA MALLORCA', 'Carrer del Romaní, 1','MALLORCA','España', NULL, 'BB5', CURRENT_DATE),
		--('C00001', 29, 'S0103', 'ALMACEN GRENOBLE', 'Rue Augereau, 2', 'Genoble', 'Francia', 31123311231, 'XX6', CURRENT_DATE);

---b
ALTER TABLE erp.tb_site
		ADD CONSTRAINT CK_TELEFONO_EXTRANJERO
		 	CHECK(site_phone IS NOT NULL AND site_country!='España');
		
--c
CREATE VIEW erp.v_imp_pendiente as
	SELECT CO.co_code,CO.co_name,CU.cust_no,CU.cust_name,I.iva_amount, I.tot_amount, I.payed
		FROM erp.tb_company as CO, erp.tb_customer as CU, erp.tb_invoice as I
			WHERE CO.co_code=I.co_code AND CU.cust_no=I.cust_no AND I.payed='N'
				ORDER BY CO.co_name ASC, CU.cust_no DESC;
--d
	ALTER TABLE erp.tb_site ADD COLUMN active_date DATE NOT NULL DEFAULT CURRENT_DATE;
		ALTER TABLE erp.v_imp_pendiente
    OWNER TO postgres;
	
--e
CREATE USER registerer WITH PASSWORD '1234';
CREATE ROLE lectura_edicion;
GRANT CONNECT ON DATABASE pec2 TO lectura_edicion;
GRANT USAGE ON SCHEMA erp TO lectura_edicion;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE erp.tb_iva TO lectura_edicion;
GRANT SELECT, INSERT ON TABLE erp.tb_company TO lectura_edicion;
