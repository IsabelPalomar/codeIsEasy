/**
 * @author Isabel Palomar
 * December 11, 2012
*/


/**
 * Obtains related offers for these can be visualized by the commerce (take offer)  ---- sample -------------------------------------------
*/


 Select ID_OFERTA,
        TITULO,
        VIGENTE, 
        ACEPTADA, 
        MIN(SUCURSAL) SUCURSAL,
        COUNT(SUCURSAL) NUM_SUCURSALES
 From ( 
         SELECT O.ID_OFERTA ID_OFERTA, O.TITULO, DECODE(SIGN(FECHA_FIN - SYSDATE),1,'S','N') AS VIGENTE, 
         ( Select Decode(Count(1), 0, 'N', 'S') 
	   From LOG_ACEPTACIONES_OFERTA 
           Where ID_Oferta = O.ID_OFERTA 
	   AND ID_CLIENTE = OC.ID_CLIENTE 
           AND ACEPTADO_POR = 'M' 
          )
          AS ACEPTADA,
              SUCURSAL
              FROM TBL_OFERTAS O, 
              REL_OFERTAS_CLIENTE OC,
              REL_SUCURSALES_OFERTA SO,
              REL_SUCURSALES_USUARIO SU, 
              TBL_SUCURSALES SUC 
              WHERE O.ID_OFERTA = OC.ID_OFERTA 
              AND SO.ID_OFERTA = O.ID_OFERTA 
              AND SO.ID_SUCURSAL = SU.ID_SUCURSAL 
              AND SUC.ID_SUCURSAL = SU.ID_SUCURSAL 
              AND SU.ID_USUARIO = 127 
              AND OC.ID_CLIENTE = 57 
              AND O.ACTIVO = 'S' AND O.VALIDADA = 'S' 
 ) 
Group By ID_OFERTA, TITULO, VIGENTE, ACEPTADA ORDER BY ID_OFERTA


/*
* Review if the commerce has a generic offer (final) -----------------------------------------------------------------------------------
*/


SELECT 1 
FROM TBL_OFERTAS ofertas 
  	JOIN DIC_TIPOS_OFERTA tipo
  	ON tipo.ID_TIPO_OFERTA = ofertas.ID_TIPO_OFERTA 
WHERE 1=1 AND ofertas.ID_COMERCIO = '980' 
  	--WHERE ofertas.VALIDADA='S' 
 	AND TRUNC(ofertas.FECHA_FIN) > TRUNC(SYSDATE) 
  	AND ofertas.VALIDADA != 'R'
  	--AND ofertas.VALIDADA ='N' OR ofertas.VALIDADA='S' 
  	AND tipo.TIPO_OFERTA = 'GENERICA' 
  	AND ofertas.ACTIVO = 'S' 

/*
* Obtain details of generics and validated offers  (final) -------------------------------------------------------------------------------
*/

SELECT ofertas.*
              FROM TBL_OFERTAS ofertas  
              JOIN DIC_TIPOS_OFERTA tipo ON tipo.ID_TIPO_OFERTA = ofertas.ID_TIPO_OFERTA  
              WHERE 1=1  
                AND ofertas.ID_COMERCIO = 980 
                AND TRUNC(ofertas.FECHA_FIN) > TRUNC(SYSDATE)
                AND ofertas.ACTIVO = 'S'  
                AND ofertas.VALIDADA = 'S'
                AND tipo.TIPO_OFERTA = 'GENERICA'  
              ORDER BY ofertas.FECHA_ALTA DESC  
              
/*
* Obtain active offers of a commerce -----------------------------------------------------------------------------------------------------
*/

              
select r.* from ( 
            select o.*, rownum o_rownum from ( 
                                          select oferta.ID_OFERTA, 
                                          oferta.ID_COMERCIO, 
                                          oferta.ID_SUCURSAL,
                                          oferta.ID_TIPO_DESCUENTO,
                                          oferta.ID_CAMPANA,
                                          oferta.ID_IMAGEN, 
                                          oferta.ID_TIPO_OFERTA,
                                          oferta.TITULO,
                                          oferta.BENEFICIO, 
                                          oferta.PRECIO_REAL, 
                                          oferta.CANTIDAD_LIMITE, 
                                          TO_CHAR(oferta.FECHA_INICIO, 'dd/mm/YYYY') as FECHA_INICIO,
                                          TO_CHAR(oferta.FECHA_FIN, 'dd/mm/YYYY') as FECHA_FIN, 
                                          oferta.SITIO_WEB, oferta.DESTACADA, 
                                          oferta.DESCRIPCION,
                                          oferta.DETALLES, 
                                          oferta.CONDICIONES,
                                          oferta.VALIDADA, 
                                          oferta.ACTIVO, 
                                          oferta.ID_PETICION, 
                                          oferta.ID_CAUSA_RECHAZO,
                                          cr.CAUSA_RECHAZO, 
                                          cr.DESCRIPCION AS DESCRIPCION_CAUSA_RECHAZO,
                                          oferta.OBSERVACIONES_RECHAZO, 
                                          tipo.TIPO_OFERTA,
                                          DECODE(SIGN(SYSDATE - oferta.FECHA_INICIO), -1, 'S', 'N') AS EDITABLE, 
                                          (DECODE(SIGN(SYSDATE - oferta.FECHA_INICIO), -1, (TRUNC(oferta.FECHA_INICIO)-TRUNC(SYSDATE)), 
                                          (TRUNC(oferta.FECHA_FIN)-TRUNC(SYSDATE)))) AS CONTADOR,
                                          DECODE(oferta.ACTIVO, 'S', DECODE(SIGN(TRUNC(SYSDATE) - oferta.FECHA_FIN), -1, DECODE(oferta.VALIDADA, 'S', 'Activa', 'N', 'Por Validar', 'R', 'Rechazada' ), 0, DECODE(oferta.VALIDADA, 'S', 'Activa', 'N', 'Por Validar', 'R', 'Rechazada' ), 1, 'Expirada' ), 'N', 'Inactiva', 'E', 'Expirada' ) AS ESTADO
            from TBL_OFERTAS oferta 
            inner join DIC_TIPOS_OFERTA tipo on tipo.ID_TIPO_OFERTA = oferta.ID_TIPO_OFERTA 
            left join DIC_CAUSAS_RECHAZO cr on oferta.ID_CAUSA_RECHAZO = cr.ID_CAUSA_RECHAZO 
            and cr.TIPO_RECHAZO = 'O' 
            and cr.ACTIVO = 'S' 
            where 1=1 and oferta.ID_COMERCIO = '980' 
            and oferta.id_oferta in ( 
                              select so.id_oferta 
                              from rel_sucursales_oferta so 
                              WHERE so.id_sucursal in ( 
							select id_sucursal 
                                			from rel_sucursales_usuario
                                			where id_usuario = '127' 
                                			and id_sucursal = '860' 
                              )
            ) ) o where rownum <= '15' 
            ) r where o_rownum > 0 
            and ESTADO = 'Activa' 
                      

/*
* get rejected offers and offers to validate of a commerce----------------------------------------------------------------------------------------
*/

  select r.* from ( 
		   select o.*,
                   rownum o_rownum 
                   from ( 
		   	select oferta.ID_OFERTA,
                        oferta.ID_COMERCIO, 
                        oferta.ID_SUCURSAL,
                        oferta.ID_TIPO_DESCUENTO,
                        oferta.ID_CAMPANA, 
                        oferta.ID_IMAGEN,
                        oferta.ID_TIPO_OFERTA,
                        oferta.TITULO, 
                        oferta.BENEFICIO, 
                        oferta.PRECIO_REAL, 
                        oferta.CANTIDAD_LIMITE,
                        TO_CHAR(oferta.FECHA_INICIO, 'dd/mm/YYYY') as FECHA_INICIO, 
                        TO_CHAR(oferta.FECHA_FIN, 'dd/mm/YYYY') as FECHA_FIN, 
                        oferta.SITIO_WEB, oferta.DESTACADA,
                        oferta.DESCRIPCION,
                        oferta.DETALLES, 
                        oferta.CONDICIONES,
                        oferta.VALIDADA,
                        oferta.ACTIVO, 
                        oferta.ID_PETICION, 
                        oferta.ID_CAUSA_RECHAZO, 
                        cr.CAUSA_RECHAZO, 
                        cr.DESCRIPCION AS DESCRIPCION_CAUSA_RECHAZO,
                        oferta.OBSERVACIONES_RECHAZO, 
                        tipo.TIPO_OFERTA,
                        DECODE(SIGN(SYSDATE - oferta.FECHA_INICIO), -1, 'S', 'N') AS EDITABLE,
                        (DECODE(SIGN(SYSDATE - oferta.FECHA_INICIO), -1, (TRUNC(oferta.FECHA_INICIO)-TRUNC(SYSDATE)), (TRUNC(oferta.FECHA_FIN)-TRUNC(SYSDATE)))) AS CONTADOR,
                        DECODE(oferta.ACTIVO, 'S', DECODE(SIGN(TRUNC(SYSDATE) - oferta.FECHA_FIN), -1, DECODE(oferta.VALIDADA, 'S', 'Activa', 'N', 'Por Validar', 'R', 'Rechazada' ), 0, DECODE(oferta.VALIDADA, 'S', 'Activa', 'N', 'Por Validar', 'R', 'Rechazada' ), 1, 'Expirada' ), 'N', 'Inactiva', 'E', 'Expirada' ) AS ESTADO 
                         from TBL_OFERTAS  oferta 
                         inner join DIC_TIPOS_OFERTA tipo 
                         on tipo.ID_TIPO_OFERTA = oferta.ID_TIPO_OFERTA
                         left join DIC_CAUSAS_RECHAZO cr 
                         on oferta.ID_CAUSA_RECHAZO = cr.ID_CAUSA_RECHAZO 
                         and cr.TIPO_RECHAZO = 'O' 
                         and cr.ACTIVO = 'S' 
                         -- AND CONTADOR > 3
                         where 1=1 
                         and oferta.ID_COMERCIO = '980' 
                         and oferta.id_oferta in ( 
                         			select so.id_oferta 
                                    		from rel_sucursales_oferta so
                                    		WHERE so.id_sucursal in (
                                    					select id_sucursal 
                                    					from rel_sucursales_usuario 
									where id_usuario = '127' and id_sucursal = '860'
									 ) 
						)
			 ) o where rownum <= '15' ) r where o_rownum > 0 
                          --AND CONTADOR >=3
                         and (ESTADO = 'Por Validar' OR ESTADO = 'Rechazada' ) 

