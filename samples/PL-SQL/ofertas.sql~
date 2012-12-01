/**
 * @ 29 noviembre 2012
 * Obtener listado de ofertas personalizadas de un cliente -sample
 */

select r.* from (
  select o.*, rownum o_rownum
  from (
    select oferta.*
    from TBL_OFERTAS oferta
    join DIC_TIPOS_OFERTA tipo on tipo.ID_TIPO_OFERTA = oferta.ID_TIPO_OFERTA
    where 1=1
      and tipo.TIPO_OFERTA = 'PERSONALIZADA'
      and oferta.VALIDADA = 'S'
      and oferta.ID_OFERTA in (
        select ID_OFERTA from REL_OFERTAS_CLIENTE where ID_CLIENTE = '4'
      )
  ) o   where rownum <= '31'
) r where o_rownum > 1


/**
 * Obtener listado de ofertas sugeridas de un cliente en específico  -sample
 */

select r.* from (
  select o.*, rownum o_rownum
  from (
    select oferta.*
    from TBL_OFERTAS oferta
    join DIC_TIPOS_OFERTA tipo on tipo.ID_TIPO_OFERTA = oferta.ID_TIPO_OFERTA
    where 1=1
      and tipo.TIPO_OFERTA = 'SUGERIDA'
      and oferta.VALIDADA = 'S'
      and oferta.ID_OFERTA in (
        select ID_OFERTA from REL_OFERTAS_CLIENTE where ID_CLIENTE = '4'
      )
    
  ) o   where rownum <= '31'
) r where o_rownum > 0

/**
* Obtain taken offers of a specific customer --- sample
*/

  SELECT REGISTROS.*
	FROM (
	    SELECT OFERTAS.*, ROWNUM O_ROWNUM 
	    FROM (
		SELECT 
		    O.TITULO,
		    (SELECT ARCHIVO_IMAGEN FROM DIC_IMAGENES WHERE ID_IMAGEN = O.ID_IMAGEN) AS IMAGEN,
		    (SELECT C.CATEGORIA FROM DIC_CATEGORIAS C, DIC_SUBCATEGORIAS S, REL_SUBCATEGORIAS_OFERTA SO WHERE S.ID_SUBCATEGORIA = SO.ID_SUBCATEGORIA AND C.ID_CATEGORIA = S.ID_CATEGORIA AND SO.ID_OFERTA = O.ID_OFERTA AND ROWNUM = 1) AS CATEGORIA,
		    O.PRECIO_REAL,
		    O.BENEFICIO,
		    (SELECT PA_GENERAL.F_FORMATO_FECHA(FECHA_ACEPTACION, 2) FROM LOG_ACEPTACIONES_OFERTA WHERE ID_OFERTA = O.ID_OFERTA AND ID_CLIENTE = 50 AND ROWNUM = 1) AS FECHA_ACEPTACION, -- PI_ID_CLIENTE
		    TRUNC(O.FECHA_FIN)-TRUNC(O.FECHA_INICIO) AS DIAS_VIGENCIA,
		    (SELECT COUNT(1) FROM LOG_ACEPTACIONES_OFERTA WHERE ID_OFERTA = O.ID_OFERTA AND ID_CLIENTE = 50) AS ACEPTADAS -- PI_ID_CLIENTE
		FROM TBL_OFERTAS O
	    ) OFERTAS
	    WHERE ACEPTADAS > 0
	    AND ROWNUM <= 10 -- PI_NUM_REG_FIN
	    ) REGISTROS
	WHERE O_ROWNUM > 0 -- PI_NUM_REG_INI
	ORDER BY FECHA_ACEPTACION DESC





