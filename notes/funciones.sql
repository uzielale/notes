FUNCIONES MYSQL

FUNCTION 1 (Actualizar acumulado evaluacion descendente)
##########################################################################################################################################
DROP FUNCTION IF EXISTS getAcumuladoEvaluacion;

DELIMITER $$
CREATE FUNCTION getAcumuladoEvaluacion (_user_id VARCHAR(36), _evaluacion_id VARCHAR(36), _cargo_id VARCHAR(36), _anio INT, _semestre INT)
RETURNS varchar(30) CHARSET utf8 
BEGIN 
DECLARE done INT DEFAULT 0;
DECLARE done_old INT DEFAULT 0;
DECLARE _acumulado DOUBLE DEFAULT 0;
DECLARE _indicador_id VARCHAR(36) DEFAULT NULL;
DECLARE _cargo_indicador_id VARCHAR(36) DEFAULT NULL;
DECLARE _cumplimiento INTEGER DEFAULT 0;
DECLARE _cumplimiento_indicador_al INTEGER DEFAULT 0;
DECLARE _ponderacion INTEGER DEFAULT 0;
DECLARE _contador INTEGER DEFAULT 0;
DECLARE _acumulado_ind_1 VARCHAR(255) DEFAULT NULL;
DECLARE _acumulado_ind_2 VARCHAR(255) DEFAULT NULL;
DECLARE _acumulado_ind_3 VARCHAR(255) DEFAULT NULL;
DECLARE _acumulado_ind_4 VARCHAR(255) DEFAULT NULL;
DECLARE _acumulado_ind_5 VARCHAR(255) DEFAULT NULL;
DECLARE _acumulado_ind_6 VARCHAR(255) DEFAULT NULL;
DECLARE _indicador_al_user INTEGER DEFAULT 0;

DECLARE cursor_indicadores CURSOR FOR SELECT i.indicador_id, ci.cargo_indicador_id FROM cargo AS c
INNER JOIN cargo_indicador AS ci ON c.cargo_id = ci.cargo_id
INNER JOIN indicador AS i ON ci.indicador_id = i.indicador_id
WHERE c.cargo_id = _cargo_id  ORDER BY i.nombre ASC;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

SELECT ual.id, ual.valor INTO _indicador_al_user,  _cumplimiento_indicador_al
FROM evaluacion AS e 
INNER JOIN usuario AS u ON e.evaluado_id = u.id
INNER JOIN usuario_ambiente_laboral AS ual ON u.id = ual.user_id
WHERE e.evaluacion_id = _evaluacion_id AND e.estado = 'FINALIZADO_ED' AND e.anno = _anio AND e.trimestre = _semestre AND ual.anno = _anio AND ual.semestre = _semestre LIMIT 1;

IF _indicador_al_user = 0 THEN 
	SELECT ial.valor INTO _cumplimiento_indicador_al
	FROM evaluacion AS e 
	INNER JOIN usuario AS u ON e.evaluado_id = u.id
	INNER JOIN indicador_ambiente_laboral AS ial ON u.area_id = ial.areaid
	WHERE e.evaluacion_id = _evaluacion_id AND e.estado = 'FINALIZADO_ED' AND e.anno = _anio AND e.trimestre = _semestre  AND ial.periodoid = 'eab51633-091b-11e9-a65f-000c2916686f' AND u.area_id IS NOT NULL LIMIT 1;
END IF;
SET done = 0;

OPEN cursor_indicadores;
loop_cursor: LOOP
FETCH cursor_indicadores INTO _indicador_id, _cargo_indicador_id;
	IF done THEN
      	LEAVE loop_cursor;
    END IF;
	SET done_old = done;
	SELECT cumplimiento INTO _cumplimiento FROM evaluacion_indicador WHERE evaluacion_id = _evaluacion_id AND indicador_id = _indicador_id LIMIT 1; 
	SELECT ponderado INTO _ponderacion FROM cargo_indicador_pond WHERE cargo_indicador_id = _cargo_indicador_id AND anno = _anio AND trimestre = _semestre LIMIT 1; 
	IF _cumplimiento > 0 THEN
   		SET _acumulado = _acumulado + ((_cumplimiento / 100) * _ponderacion);
   	END IF;
    	IF _contador = 0 THEN
   		SET _acumulado_ind_1 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
   	IF _contador = 1 THEN
   		SET _acumulado_ind_2 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
   	IF _contador = 2 THEN
   		SET _acumulado_ind_3 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
   	IF _contador = 3 THEN
   		SET _acumulado_ind_4 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
   	IF _contador = 4 THEN
   		SET _acumulado_ind_5 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
   	IF _contador = 5 THEN
   		SET _acumulado_ind_6 = CONCAT(_indicador_id,'_', _cumplimiento, '_', _ponderacion, '_', ((_cumplimiento / 100) * _ponderacion));
   	END IF;
    SET _cumplimiento = 0;
   	SET _ponderacion = 0;
    SET _contador = ( _contador + 1 );
    SET done = done_old;
END LOOP loop_cursor;
IF _acumulado > 0 THEN
	IF _cumplimiento_indicador_al > 0 THEN
		SET _acumulado = (_acumulado * 0.9) + (_cumplimiento_indicador_al*0.1);
	END IF;
END IF;
RETURN FORMAT(_acumulado, 2); 
CLOSE cursor_indicadores;
END$$

DELIMITER ;

SELECT getAcumuladoEvaluacion('5f6f79d7-c90e-11e6-a511-1c6f65990c34', 'd525c1cc-0927-11e9-a65f-000c2916686f', '3e3ed576-be52-11e6-9387-a088694cea32', 2018, 2);

UPDATE evaluacion SET acumulado_procedure = getAcumuladoEvaluacion(evaluado_id, evaluacion_id, cargo_evaluado_id, 2018, 2)
WHERE anno = 2018 AND trimestre = 2 AND tipo = 'DESCENDENTE' AND estado = 'FINALIZADO_ED' 
##########################################################################################################################################