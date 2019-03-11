<?php
namespace AppMain;
use Conexion;
use PDO;

class Sql extends Conexion{

    function __construct(){

    }

    public function setGerencia($gerencia){
        parent::conectarPDO();
        $query = "INSERT INTO opn_gerencias(geren_nombre, geren_descripcion, geren_activo, geren_datecreated)
        VALUES (:geren_nombre, :geren_descripcion, :geren_activo, :geren_datecreated)";
        $params = array(':geren_nombre' =>$gerencia->geren_nombre,
                        ':geren_descripcion' => $gerencia->geren_descripcion,
                        ':geren_activo' =>$gerencia->geren_activo,
                        ':geren_datecreated' =>$gerencia->geren_datecreated);
        parent::queryPDO($query,$params);
        $insert_id=$this->pdo->lastInsertId();
        parent::closeConexionPDO();
        return $insert_id;
    }

    public function updateEstadisticasAnio($set,$set_values,$where){
        parent::conectarPDO();
        $query = "UPDATE opn_estadisticas_anio
                SET $set 
                $where ";
        $params = $set_values;
        $result=parent::queryPDO($query,$params);
        $affected_rows=$result->rowCount();
        parent::closeConexionPDO();
        return $affected_rows;
    }
}
?>