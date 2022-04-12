--a)
SELECT invoice_id, payed,
		CASE WHEN payed='N' THEN 'PENDIENTE'
			 WHEN payed='Y'THEN 'PAGADA'
			 ELSE 'OTRO'
		END
	FROM  erp.tb_invoice;

CREATE TABLE tb_prueba(
	prueba INT PRIMARY KEY,
	descripcion1 VARCHAR(200),
	descripcion2 VARCHAR(200)
	);
INSERT INTO public.tb_prueba( prueba, descripcion1, descripcion2)
	VALUES (1,NULL,'D12'),(2, 'D21','D22');

SELECT prueba, COALESCE (descripcion1,descripcion2,'none') FROM tb_prueba;

SELECT prueba, NULLIF(descripcion1,'D21')  FROM tb_prueba;

INSERT INTO tb_prueba (prueba, descripcion1,descripcion2) VALUES(3,'D31','D32') RETURNING prueba, descripcion1;


			
			
