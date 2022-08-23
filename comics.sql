create database `comics`; 

use `comics`; 

create table `read`(id integer primary key, name varchar(50));

insert into `read` values (1, 'Watchmen');
insert into `read` values (2, 'The Long Halloween');
insert into `read` values (3, 'Maximum Carnage');
insert into `read` values (4, 'Arkham Asylum');
insert into `read` values (5, 'The Boys');

create table `series`(series_id integer primary key, series_name varchar (50)); 

insert into `series` values (1, 'Watchmen');
insert into `series` values (2, 'Batman');
insert into `series` values (3, 'Spiderman');
insert into `series` values (4, 'Batman');
insert into `series` values (5, 'The Boys');

