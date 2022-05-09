--1
set schema 'erp';
---a)
----crea la función que será llamada desde el disparador para asignar el valor actual después al campo last_update_date
CREATE OR REPLACE FUNCTION ft_customer_lastupdate() RETURNS TRIGGER AS $t_customer_lastupdate$
	BEGIN
		IF NEW.last_update_date!= OLD.last_update_date
		 THEN RAISE EXCEPTION 'NO SE PUEDE MODIFICAR EL CAMPO';
		END IF;
		NEW.last_update_date = NOW();
		RETURN NEW;
	END;
$t_customer_lastupdate$ 
LANGUAGE plpgsql;
--se crea el trigger en la tabla tb_customer que llama la función antes de hacer la edición
CREATE TRIGGER t_customer_lastupdate
	BEFORE UPDATE ON tb_customer 
	FOR EACH ROW EXECUTE PROCEDURE ft_customer_lastupdate();
-----------------------------------------------------------------------------------------------------------------------	
---b)
----Creación de la función que va será llamada desde el disparador para asignar el usuario que hizo el update
CREATE OR REPLACE FUNCTION ft_customer_updatedby() RETURNS TRIGGER AS $t_customer_updatedby$ 
	BEGIN
		IF NEW.last_updated_by != OLD.last_updated_by THEN
			RAISE EXCEPTION 'NO SE PUEDE MODIFICAR EL CAMPO';
		END IF;
		NEW.last_updated_by = user;
	   	RETURN NEW;
	END;
$t_customer_updatedby$ 
LANGUAGE plpgsql;

--se crea el trigger en la tabla tb_customer que llama la función antes de hacer updated
CREATE TRIGGER t_customer_updatedby
	BEFORE UPDATE ON tb_customer 
	FOR EACH ROW EXECUTE PROCEDURE ft_customer_updatedby();
-------------------------------------------------------------------------------------------------------------
--c)
---crea la función que será llamada desde el disparador para actualizar los valores de la factura una vez sean modificada una linea 
CREATE OR REPLACE FUNCTION ft_invoice_amounts() RETURNS TRIGGER AS $t_invoice_amounts$
	BEGIN
		IF TG_OP='UPDATE' THEN
			UPDATE erp.tb_invoice set net_amount=net_, iva_amount=iva_, tot_amount=tot_
			FROM(
				SELECT SUM(net_amount)::numeric AS net_,
					   SUM(iva_amount)::numeric AS iva_,
					   SUM(net_amount) + SUM(iva_amount)::numeric AS tot_
					FROM erp.tb_lines
					WHERE tb_lines.invoice_id = NEW.invoice_id) t
			WHERE tb_invoice.inviocie_id=NEW.invioce_id;
		END IF;
		IF TG_OP='INSERT'THEN
			INSERT INTO erp.tb_invoice(invoice_id, net_amount, iva_amount, tot_amount) 
			VALUES (NEW.invoice_id, NEW.net_amount, NEW.iva_amoubnt, NEW.tot_amount);
		END IF;
		RETURN NEW;
	END;
$t_invoice_amounts$
LANGUAGE plpgsql;

--se crea el trigger en la tabla tb_customer que llama la función antes de hacer updated
CREATE TRIGGER t_invoice_amounts
	AFTER UPDATE OR INSERT ON erp.tb_lines
	FOR EACH ROW EXECUTE PROCEDURE ft_invoice_amounts();
	
	
	







