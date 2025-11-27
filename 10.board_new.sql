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
--최초생성자
insert into post(title,contents)values('hello2','hello world222..');
insert into author_post_list(author_id,post_id) values(3,2);
insert into author_post_list(author_id,post_id) values(3,1);
--추후 참여자
--update
--insert into author_post_list values(,)
--글전체 조회하기 : 제목 ,내용 , 글쓴이 이름이 조회가 되도록 select쿼리 생성
select p.title,p.contents,a.name 
from author_post_list l inner join author a on
l.author_id=a.id
inner join post p
on p.id=post_id;

select p.id, p.title,p.contents,a.name from psot p inner join author_post_list l on p.id=1.post_id inner join author on author_id=l.author_id;

--정규화의 직관적인 룰
--1. 데이터의 원자성 보장
--2. 성격의차이
--3. 데이터 중복 방지
--4. 확장성

--엑셀로 더미데이터 넣은 캡쳐본 제출
--erd설계 -> 캡쳐 제출
--erd기반의 db구축


CREATE TABLE buyer (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255), email VARCHAR(255), address VARCHAR(255));

CREATE TABLE seller (id BIGINT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255),email VARCHAR(255),warehouse VARCHAR(255));

CREATE TABLE product (num BIGINT AUTO_INCREMENT PRIMARY KEY,list VARCHAR(255),price BIGINT,stock BIGINT,seller_id BIGINT NOT NULL,FOREIGN KEY (seller_id) REFERENCES seller(id));

CREATE TABLE ordernum (num BIGINT AUTO_INCREMENT PRIMARY KEY,orderdate DATETIME,buyer_id BIGINT NOT NULL,FOREIGN KEY (buyer_id) REFERENCES buyer(id));

CREATE TABLE orderlist (list BIGINT AUTO_INCREMENT PRIMARY KEY,qty BIGINT,order_num BIGINT NOT NULL,product_num BIGINT NOT NULL,FOREIGN KEY (order_num) REFERENCES ordernum(num),FOREIGN KEY (product_num) REFERENCES product(num));


--회원가입 
insert into buyer (name, email, address ) 
values ('AA','AA@NAVER.COM','신대방동'),('BB','BB@NAVER.COM','신대방동1'),('CC','CC@NAVER.COM','신대방동2'),('DD','DD@NAVER.COM','신대방동3'),('EE','EE@NAVER.COM','신대방동4');

insert into seller (name, email, warehouse ) 
values ('AAA','AAA@NAVER.COM','서울물류창고'),('BBB','BBB@NAVER.COM','서울물류창고1'),('CCC','CCC@NAVER.COM','서울물류창고2'),('DDD','DDD@NAVER.COM','서울물류창고3'),('EEE','EEE@NAVER.COM','서울물류창고4');

--상품등록
INSERT INTO product (list, price, stock, seller_id)
VALUES ('사과', 10000, 50, 1),('딸기',5000,50,1),('포도',4000,50,2),('배',3000,30,3),('바나나',2000,20,4);

--주문하기
INSERT INTO ordernum (orderdate, buyer_id)VALUES (NOW(), 1);
INSERT INTO orderlist (qty, order_num, product_num)VALUES (20, 1, 1);
update product set stock =stock - 20 where num=1;

--상품정보조회
select*from product;

--주문상세조회
select o.num,p.list,p.price,o.orderdate,ol.qty ,o.buyer_id 
from ordernum o inner join orderlist ol on 
o.num=ol.order_num inner join product p on p.num=ol.product_num;