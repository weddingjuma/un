-- Make sure the database and users are there before we try to delete them!
create database if not exists OU_3_0_Liferay character set utf8;
grant all on OU_3_0_Liferay.* to 'openquote'@'localhost' identified by 'password' with grant option;
grant all on OU_3_0_Liferay.* to 'openquote'@'localhost.localdomain' identified by 'password' with grant option;
  
-- Now do the actual tidy up 
drop database if exists OU_3_0_Liferay;
revoke all on OU_3_0_Liferay.* from 'openquote'@'localhost';
revoke all on OU_3_0_Liferay.* from 'openquote'@'localhost.localdomain';
