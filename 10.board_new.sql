--회원 테이블 생성 
--id(pk) , email(unique,not null), name(not null) , password(not null)
create table author(id bigint auto_increment primary key,
email varchar(255) not null unique,
name varchar(255), password varchar(255) not null);
--주소 테이블
--id, country , city , street , author_id(fk)
create table address(id bigint auto_increment primary key,
country varchar(255) not null,  city varchar(255) not null, 
street varchar(255) not null, author_id bigint not null unique, 
foreign key(author_id) references author(id));
--post 테이블 
--id , title(not null),contents
create table post (id bigint auto_increment primary key, title varchar(255)not null , contents varchar(3000));

--연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key,
author_id bigint not null , post_id bigint not null,
foreign key (author_id) references author(id),foreign key(post_id) references post(id) );

--복합키를 이용한 연결 테이블 생성
create table author_post_list(author_id bigint not null , post_id bigint not null,
primary key(author_id , post_id) foreign key (author_id) references author(id),foreign key(post_id) references post(id) );

--회워가입 및 주소 생성
insert into author (email,name,password) values('ccc@naver.com','hong2','135135');
insert into address(country,city,street,author_id)values('korea','seoul','sindaebang2',3);

--글쓰기
insert into post(title,contents)values('hello2','hello world222..');
insert into author_post_list(author_id,post_id) values(3,2);
insert into author_post_list(author_id,post_id) values(3,1);
--글전체 조회하기 : 제목 ,내용 , 글쓴이 이름이 조회가 되도록 select쿼리 생성
select p.title,p.contents,a.name 
from author_post_list l inner join author a on
l.author_id=a.id
inner join post p
on p.id=post_id;
