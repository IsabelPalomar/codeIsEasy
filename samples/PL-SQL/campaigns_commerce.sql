/**
 * @author Isabel Palomar
 * December 11, 2012
*/


/**
 *  Obtain campaigns with suggested and personalized offers of a specific customer -sample ---------------------------------------------------------
*/

SELECT r.* FROM 
    ( SELECT o.*, rownum o_rownum 
      FROM 
          ( SELECT c.ID_CAMPANA,
            c.ID_COMERCIO, c.ID_SUCURSAL,
            c.TITULO_CAMPANA,
            c.DESCRIPCION,
            TO_CHAR(c.FECHA_CREACION, 'dd/mm/YYYY') AS FECHA_CREACION,
            TO_CHAR(c.FECHA_VENCIMIENTO, 'dd/mm/YYYY') AS FECHA_VENCIMIENTO,
            c.NUMERO_CLIENTES, 
            c.ACTIVO, 
            c.ID_TIPO_OFERTA 
            FROM TBL_CAMPANAS c
              INNER JOIN REL_COMERCIOS_CAMPANA rc ON rc.ID_CAMPANA = c.ID_CAMPANA 
              WHERE 1=1 
              AND c.ACTIVO = 'S' 
              AND rc.ID_COMERCIO = '980' 
              AND rc.ID_SUCURSAL = '860' 
            ) 
        o WHERE rownum <= '15' )r 
      WHERE 1=1 
      AND o_rownum > '0' 
      AND SYSDATE <= TO_DATE(FECHA_VENCIMIENTO, 'dd/mm/YYYY') 
      ORDER BY FECHA_CREACION DESC
