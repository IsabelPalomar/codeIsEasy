/**
 * @author Isabel Palomar
 * December 11, 2012
*/


/**
 * Obtains related offers for these can be visualized by the commerce (take offer)  ---- sample ------------------------------------------------
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
