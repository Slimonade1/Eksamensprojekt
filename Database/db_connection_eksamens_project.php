    <?php
		function OpenConnPDO()
		{
			$db_host = "mysql104.unoeuro.com";
			$db_name = "civilgames_dk";
			$db_username = "civilgames_dk_db_times";
			$db_password = "zngmcFbtx9hHyr3efwED";

			#Set up logindata for PDO
			$dsn = "mysql:dbname=$db_name;host=$db_host;charset=utf8mb4;port=3306";			
			
			#Attempt connection and catch error
			try{
				$pdo = new PDO($dsn, $db_username, $db_password); 	
			}
			catch (\PDOException $e){
				print_response("no_return", [], "db_login_error");
				die;
			}
			
			return $pdo;
		}
		
		function CloseConnPDO($pdo)
		{
			//$pdo -> close();
		}
    ?>
	