SELECT *-- Sum(cantidad)
FROM anamnesis.anam_captura_inventario
WHERE id_deposito = 1 ; --verificar cantidad de articulos y la hora

SELECT Sum(cantidad)
FROM det_inventario
WHERE inv_art_id_inventario_art = 668; --verificar el id_inventario este vacio antes de la migracion

CREATE SEQUENCE anamnesis.item_inventario START WITH 1;
--crear secuencia
drop SEQUENCE anamnesis.item_inventario ;               --borrar secuencia

insert INTO det_inventario
SELECT 668, anamnesis.item_inventario.nextval, cantidad,0,0,0, id_articulo, 1, fecha_venc, 'SI',NULL,NULL
FROM (
      SELECT Sum(cantidad) cantidad, id_articulo, Max(fecha_venc) fecha_venc
      FROM anamnesis.anam_captura_inventario
      WHERE id_deposito = 1
      AND Trunc(hora,'mm')=To_Date('01-12-17','dd-mm-rr')
      GROUP BY id_articulo --insertar en el deposito los articulos
      );
COMMIT;

ROLLBACK;

SELECT Sum(cantidad)--, Count(*)
FROM anamnesis.anam_captura_inventario
WHERE id_deposito = 1 ;      --comparar cantidad de articulos en el deposito

SELECT Sum(cantidad), Count(*)
      FROM anamnesis.anam_captura_inventario
      WHERE id_deposito = 1  --comparar cantidad de articulos en el deposito
       AND Trunc(hora,'mm')=To_Date('01-12-17','dd-mm-rr')
      --GROUP BY id_articulo
UNION ALL

SELECT Sum(cantidad), Count(*)
FROM det_inventario
WHERE inv_art_id_inventario_art = 668  ;



SELECT *--Sum(cantidad), Count(*)
      FROM anamnesis.anam_captura_inventario
      WHERE id_deposito = 1   ;




DELETE
FROM det_inventario
WHERE inv_art_id_inventario_art = 668 ;

COMMIT;



      SELECT Sum(cantidad) cantidad, id_articulo
      FROM anamnesis.anam_captura_inventario
      WHERE id_deposito = 1
      GROUP BY id_articulo --insertar en el deposito los articulos
      ;