1. создаем юзера, как в первой лабе
create user TASK2 identified by task2
--create tablespace 
default tablespace users quota 100M ON users 
--limit temporary tablespace 10mb 
temporary tablespace temp quota 100M ON users; 

--add grants 
grant connect, resource to task2;

2. даем ему привелегии на создание таблиц и сессий
3. запускаем скрипт создания схемы ДБ crebas.sql