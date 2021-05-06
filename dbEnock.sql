-- tutorial https://www.techonthenet.com/

DROP DATABASE IF EXISTS dbEnock;
CREATE DATABASE dbEnock;

CREATE TABLE dbEnock.users(
    iduser INT AUTO_INCREMENT NOT NULL,
    email VARCHAR(55) NOT NULL,
    mdp VARCHAR(255) NOT NULL,
    PRIMARY KEY(iduser)
);

INSERT INTO dbEnock.users(email,mdp) VALUES
	('enock@site.com','123'),	
	('koto@site.com','123'),    
	('liva@site.com','123'),    
	('rajao@site.com','123'),    
	('bean@site.com','123')    
;

ALTER TABLE dbEnock.users ADD (isAdmin boolean, isConnected boolean);

ALTER TABLE dbEnock.users MODIFY isAdmin  boolean DEFAULT false NOT NULL, MODIFY isConnected boolean DEFAULT false NOT NULL;

UPDATE users SET email = 'admin@site.com', isAdmin = true WHERE iduser=1;

DELIMITER // -- begin delimiter for creating procedure

CREATE PROCEDURE whoisadmin () -- declare procedure without paramater
 BEGIN
  -- SELECT users.iduser INTO param1 ,users.email INTO param2 FROM users WHERE users.iduser=1;
  SELECT * FROM users WHERE users.iduser=1;
 END;
//

DELIMITER ; -- end delimiter

-- CALL whoisadmin();

DELIMITER //

CREATE PROCEDURE listUsers ()
 BEGIN
   SELECT * FROM users;
 END;
//

DELIMITER ;

-- CALL listUsers();

DELIMITER //

CREATE PROCEDURE editPassById (IN param1 VARCHAR(55), IN param2 VARCHAR(55)) -- declare procedure with two parameters who are param1 and param2 --
 BEGIN -- IN means the parameter is the parameter using when we call the procedure
 	   -- OUT means the parameter is the returned value whenever it can be row or multiple rows and can be only used external of the procedure
       -- INOUT means the parameter is a global variable
   UPDATE users SET users.mdp = param2 WHERE users.iduser = param1;
 END;
//

DELIMITER ;

-- CALL editPassById(3, "test"); -- id = 3 pass="123"

DELIMITER //

CREATE PROCEDURE setUserToAdminById (IN param1 INT, IN param2 boolean)
 BEGIN
   UPDATE users SET users.isAdmin = param2 WHERE users.iduser = param1;
 END;
//

DELIMITER ;

-- CALL setUserToAdminById(4, true); -- id = 4 isAdmin = true

DELIMITER //

CREATE PROCEDURE beConnectedByEmailAndPassword (IN param1 VARCHAR(55), IN param2 VARCHAR(55))
 BEGIN
   UPDATE users SET users.isConnected = true WHERE users.email = param1 AND users.mdp = param2;
 END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE logout (IN param1 INT)
 BEGIN
   UPDATE users SET users.isConnected = false WHERE users.iduser = param1;
 END;
//

DELIMITER ;

CALL beConnectedByEmailAndPassword("admin@site.com", 123); -- email = admin@site.com password = 123
CALL beConnectedByEmailAndPassword("koto@site.com", 123); -- email = koto@site.com password = 123


CALL listUsers();

CALL editPassById(2, "koto70?"); -- id = 2 password = "koto70?"


CALL listUsers();

CALL logout(2);

CALL listUsers();

CALL beConnectedByEmailAndPassword("koto@site.com", "koto70?"); -- email = koto@site.com password = "koto70?"

CALL listUsers();
