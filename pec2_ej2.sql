---a)
SELECT cust_no, cust_name, cust_cif 
	FROM erp.tb_customer 
		WHERE cust_name LIKE 'AGR%' 
			ORDER BY cust_no DESC;
			
---b)
SELECT CU.cust_no, CU.cust_name, S.site_address, S.site_city, I.invoice_no
	FROM erp.tb_customer as CU, erp.tb_site as S, erp.tb_invoice as I
		WHERE I.cust_no=S.cust_no AND S.cust_no=CU.cust_no AND S.site_city='Granada'
			ORDER BY CU.cust_no ASC, I.invoice_no DESC;
			
---c)
SELECT CO.co_code, CO.co_name, count(I.invoice_no) as total_fact
	FROM erp.tb_company as CO, erp.tb_invoice as I
		WHERE CO.co_code=I.co_code
			GROUP BY CO.co_code,CO.co_name
				ORDER BY total_fact DESC, CO.co_name ASC
					LIMIT 3;

---d)
SELECT I.invoice_no, CU.cust_name, CO.co_name, count(L.line_num) as line_total
	FROM erp.tb_invoice as I, erp.tb_customer as CU, erp.tb_company as CO, erp.tb_lines as L
		WHERE L.invoice_id=I.invoice_id AND I.cust_no=CU.cust_no AND I.co_code=CO.co_code
			GROUP BY I.invoice_no,CU.cust_name, CO.co_name
				HAVING count(L.line_num)>=18
					ORDER BY line_total DESC;
					
---e			
SELECT CO.co_code,CO.co_name,CU.cust_no,CU.cust_name,I.iva_amount, I.tot_amount, I.payed
	FROM erp.tb_company as CO, erp.tb_customer as CU, erp.tb_invoice as I
		WHERE CO.co_code=I.co_code AND CU.cust_no=I.cust_no AND I.payed='N'
			ORDER BY CO.co_name ASC, CU.cust_no DESC;

			

			
		