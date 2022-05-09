--3
---a)
--Los operadores clasicos no poseen soporte linguistico, es decir que no pueden coincidir entre palabras conjugadas con su infinitivo. 
--Las busquedas deben ser exactas con la  coincidencia que se pretende. 
--Además, al no tener un soporte de indice, se deben procesar todos los documentos implicados para cada busqueda, y eso lo vuelve poco eficiente.
-- A diferencia de las busquedas de texto extendidas, no posee un mecanismo de normalizacion y ponderacion de las palabras dentro del documento. 
-- Esto genera que no pueda distinguir un orden o clasificacion entre todos los documentos coincidentes con la consulta, tomando a todos con el mismo nivel de coincidencia.
--------------------------------------------------------------------------------------------------------------------------
---b)
--tsvector es un tipo de datos que consiste en una lista de palabras de un documento, normalizadas
--Se elimina artículos, conjuciones signos de puntuación para dejar solo lexico básico con su respectiva posicipon
--'to_tsvector' analiza el texto o documento recibido por parametro, y devuelve un listado con cada palabra de manera normalizada, junto con todas las posiciones donde esa palabra fue encontrada.
--to_tsevectot() convierte un string en tsvector
---Previo a devolver el listado, la funcion realiza filtros para que cada palabra se devuelva en conjugacion singular, llamados lexemas, e ignorando las palabras que refieran a pronombres, articulos, conjugaciones y signos de puntuacion. 
---Ademas, recibe un parametro opcional que refiere a la configuracion del texto, para que el motor de la base decida con que diccionario o idioma generar los lexemas.
---El tipo de dato que devuelve es un 'tsvector'.
--EJEMPLO
SET SCHEMA 'erp';
select to_tsvector('english', tb_company.co_name )
from tb_company
---da la posición de cada palabra en el nombre
-------------------------------------------------------------------------------
-- 'to_tsquery' trabaja de la misma forma que 'to_tsvector', pero parseando las consultas recibidas con los lexemas a buscar (palabras normalizadas) y sus operadores lógicos. 
--Con esto, rearma la consulta para ser utilizada sobre un tsvector, y poder decidir si el tsquery se verifica en el tsvector relacionado.
--Esta funcion devuelve un tipo de dato tsquery.
-- EJEMPLO devuelve todas los registros de tb_lines que tienen el lexema 'semilla' en su descripcion.
select line_id, description
from tb_lines
where to_tsvector(description) @@ to_tsquery('semilla');
----------------------
-- 'ts_rank' calcula la relevancia de un documento respecto de un tsquery, en función de la cantidad de veces que se encuentra cada término de búsqueda, o la posición dentro del documento. Con esto, se puede ordenar los documentos consultados, para encontrar los que tienen mayor (o menor) coincidencias sobre la busqueda analizada.
-- Podemos realizar en nuestra base una comparacion de los distintos items vendidos, y categoria tiene mayores ventas.
select distinct lines.invoice_id, inv.cust_no, inv.invoice_no,
    ts_rank(to_tsvector(
        (select string_agg(description, ' ') from tb_lines tl where tl.invoice_id=lines.invoice_id)
        ), query) as rank
from tb_lines lines,tb_invoice inv,
     to_tsquery('semilla & comida & estiercol ') query
where  inv.invoice_id=lines.invoice_id
order by rank desc
limit 10;
















