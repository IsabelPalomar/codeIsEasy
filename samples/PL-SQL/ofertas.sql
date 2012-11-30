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

