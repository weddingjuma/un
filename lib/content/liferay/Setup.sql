CREATE DATABASE IF NOT EXISTS OU_3_0_Liferay character set utf8;
GRANT ALL ON OU_3_0_Liferay.* TO 'openquote'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
GRANT ALL ON OU_3_0_Liferay.* TO 'openquote'@'localhost.localdomain' IDENTIFIED BY 'password' WITH GRANT OPTION;

SET FOREIGN_KEY_CHECKS=0;

USE OU_3_0_Liferay;

source ./content/liferay/Liferay.sql

