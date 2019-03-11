<?php
#m	Representación numérica de una mes, con ceros iniciales	01 hasta 12
#M	Una representación textual corta de un mes, tres letras	Jan hasta Dec
#n	Representación numérica de un mes, sin ceros iniciales	1 hasta 12

echo date('m').'<br>'; #RETORNA '03'
echo date('n'); #RETORNA '3'

#La siguiente consulta si el mes el valor es 2019-03-07 00:00:00 retorna 3
#SELECT MONTH(created_at) AS mes FROM empresas WHERE id = 1

?>