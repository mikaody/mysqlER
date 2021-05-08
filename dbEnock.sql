-- tutorial https://www.techonthenet.com/

DROP DATABASE IF EXISTS dbEnock;
CREATE DATABASE dbEnock;

CREATE TABLE dbEnock.jobs(
	idjob INT AUTO_INCREMENT NOT NULL,
	job VARCHAR(55) NOT NULL,
	PRIMARY KEY(idjob)
);

CREATE TABLE dbEnock.users(
    iduser INT AUTO_INCREMENT NOT NULL,
    tel VARCHAR(55) NOT NULL DEFAULT "+26134...",
    address VARCHAR(55) NOT NULL DEFAULT "LOT...",
    email VARCHAR(55) NOT NULL,
    mdp blob NOT NULL,
    name VARCHAR(255) NULL,
    idjob INT NOT NULL,
    PRIMARY KEY(iduser),
    FOREIGN KEY users(idjob) REFERENCES jobs(idjob)
);

INSERT INTO dbEnock.jobs(job) VALUES
	("agriculteur"),
	("livreur"),
	("vendeur");

-- INSERT INTO dbEnock.users(email,mdp,idjob) VALUES
-- 	('enock@site.com',AES_ENCRYPT('123', 'pass'), 1),	
-- 	('koto@site.com',AES_ENCRYPT('123', 'pass'), 1),    
-- 	('liva@site.com',AES_ENCRYPT('123', 'pass'), 3),   
-- 	('rajao@site.com',AES_ENCRYPT('123', 'pass'), 2),    
-- 	('bean@site.com',AES_ENCRYPT('123', 'pass'), 1)    
-- ;

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
-- cast(aes_decrypt(mdp, "pass") as VARCHAR(55))
CREATE PROCEDURE listUsers ()
 BEGIN
   SELECT iduser, email, mdp, name, isAdmin, isConnected FROM users;
 END;
//

DELIMITER ;

-- CALL listUsers();

DELIMITER //

CREATE PROCEDURE editPassById (IN param1 VARCHAR(55), IN param2 VARCHAR(55)) -- declare procedure with two parameters who are param1 and param2 --
 BEGIN -- IN means the parameter is the parameter using when we call the procedure
 	   -- OUT means the parameter is the returned value whenever it can be row or multiple rows and can be only used external of the procedure
       -- INOUT means the parameter is a global variable
-- https://zinoui.com/blog/storing-passwords-securely#:~:text=To%20encrypt%20a%20password%20use%20the%20ENCODE%20%28str%2Cpass_str%29,the%20ENCODE%20function%20use%20the%20DECODE%20%28crypt_str%2Cpass_str%29%20function%3A
   UPDATE users SET users.mdp = MD5(param2) WHERE users.iduser = param1;
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

CREATE PROCEDURE beConnectedByNameAndPassword (IN param1 VARCHAR(55), IN param2 VARCHAR(55))
 BEGIN
   UPDATE users SET users.isConnected = true WHERE users.name = param1 AND users.mdp = param2;
 END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE getIdByLogin (IN param1 VARCHAR(55), IN param2 VARCHAR(55))
 BEGIN
   SELECT users.iduser FROM users WHERE users.name = param1 AND users.mdp = param2;
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

DELIMITER //

CREATE PROCEDURE listUsersAndJobs ()
 BEGIN
   SELECT users.name, users.email, jobs.job FROM users JOIN jobs ON users.idjob=jobs.idjob;
 END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE listUsersFindByJob (IN param1 VARCHAR(55))
 BEGIN
   SELECT users.name, users.email, jobs.job FROM users JOIN jobs ON jobs.idjob WHERE jobs.job LIKE CONCAT('%',param1,'%');
 END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE setNameUserById (IN param1 INT, IN param2 VARCHAR(55))
 BEGIN
      UPDATE users SET users.name = param2 WHERE users.iduser = param1;
 END;
//

DELIMITER ;



DELIMITER //

CREATE PROCEDURE cryptMyPass(IN identifiant INT, IN nouveauMdp VARCHAR(55))
 BEGIN
  UPDATE users SET users.mdp = AES_ENCRYPT(nouveauMdp, 'pass') WHERE users.iduser = identifiant;
 END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE decryptMyPass(IN identifiant INT)
 BEGIN
  SELECT cast(aes_decrypt(users.mdp, 'pass') AS VARCHAR(55)) FROM `users` WHERE users.iduser = identifiant;
 END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE saveNewUser(IN myemail VARCHAR(55),IN myname VARCHAR(55), IN passw VARCHAR(55) )
 BEGIN
    INSERT INTO dbEnock.users(email,name,mdp,idjob,isAdmin,isConnected) VALUES
      (myemail,myname,AES_ENCRYPT(passw, 'pass'),1,false,false) 
    ;
 END;
//

DELIMITER ;

-- exemple: SELECT cast(aes_decrypt(aes_encrypt('123', 'pass'), 'pass') AS char) as decrypted  FROM users WHERE users.iduser = 1;


-- CALL setNameUserById(1, "admin");
-- CALL setNameUserById(2, "koto");
-- CALL setNameUserById(3, "liva");
-- CALL setNameUserById(4, "rajao");
-- CALL setNameUserById(5, "bean");

-- CALL beConnectedByNameAndPassword("admin", 123); -- email = admin@site.com password = 123
-- CALL beConnectedByNameAndPassword("koto", 123); -- email = koto@site.com password = 123





-- CALL listUsers();

-- CALL logout(2);

-- CALL listUsers();

-- CALL beConnectedByNameAndPassword("koto", "koto70?"); -- email = koto@site.com password = "koto70?"

-- CALL listUsers();

-- CALL listUsersAndJobs();

-- CALL listUsersFindByJob('agriculteur');

-- CALL cryptMyPass(1, 'admin123');

-- CALL listUsers();

-- CALL decryptMyPass(1);

-- CALL saveNewUser("lita@gmail.com","lita","lita123" );

-- CALL listUsersAndJobs();
