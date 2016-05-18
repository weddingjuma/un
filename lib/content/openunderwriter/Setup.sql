CREATE DATABASE IF NOT EXISTS OU_3_0_OpenUnderwriter character set utf8;
GRANT ALL ON OU_3_0_OpenUnderwriter.* TO 'openquote'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
GRANT ALL ON OU_3_0_OpenUnderwriter.* TO 'openquote'@'localhost.localdomain' IDENTIFIED BY 'password' WITH GRANT OPTION;
