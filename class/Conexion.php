sdf<?php

namespace AppMain;
use Mysqli;
use PDO;

class Conexion{
	protected $mysqli;
    protected $pdo;

    public function setUsername($username){
        global $CFG;
        $CFG->dbuser=$username;
    }

    public function setDataBase($database){
        global $CFG;
        $CFG->dbname=$database;
    }


    public function setPassword($password){
        global $CFG;
        $CFG->dbpass = $password;
    }

    protected function conectar(){
        global $CFG;
        $this->mysqli=new mysqli($CFG->dbhost,$CFG->dbuser,$CFG->dbpass,$CFG->dbname);	
         if($this->mysqli->connect_errno > 0){ 
            die("Imposible conectarse a con la base de datos [" . $this->mysqli->connect_error . "]");   
         }
		 $this->mysqli->set_charset("utf8");
    }

    protected function query($query){
        try{
            $result = $this->mysqli->query($query) or die($query);	
            return $result;
        }catch(Exception $e){

        }
    }

    protected function closeConexion(){
        $this->mysqli->close();	
    }

    protected function conectarPDO(){ 
        global $CFG;
        try{
            $this->pdo = new PDO("mysql:host=".$CFG->dbhost.";dbname=".$CFG->dbname.";charset=utf8",$CFG->dbuser,$CFG->dbpass);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);                
        }
        catch(PDOException $Exception ){
            #throw new MyDatabaseException( $Exception->getMessage( ) , $Exception->getCode( ) );
        }
    }

    protected function queryPDO($query,$params){
        try{
            $stmt=$this->pdo->prepare($query);
            $stmt->execute($params);
            if (!$stmt) {
                #die($dbh->errorInfo());
            }
            return $stmt;
        }catch(PDOException $Exception ){
            #throw new MyDatabaseException( $Exception->getMessage( ) , $Exception->getCode( ) );
        }
    }

    protected function closeConexionPDO() {
        $this->pdo=null;
    }

}
?>