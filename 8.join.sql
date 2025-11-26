--case1 : author inner join post
--글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
select a.*, p.* from author a inner join post p on a.id=p.author_id;

--casae2 : post inner join author
--글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on p.author_id=a.id;
--글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*,a.email from post p inner join author a on p.author_id = a.id;

--case3 : author left join post
--글쓴이는 모두 조회하되 , 만약 쓴 글이 있다면 글도 함께 조회
select * from author a left join post p on a.id=p.author_id;

--case4 : post lefft join author
--글을 모두 조회하되, 글쓴이가 있다면 글쓴이도 함께 조회
select * from post p left join author a on a.id=p.author_id;

--글쓴이가 있는 글 중에서 글의 제목과 저자의 email,저자의 나이를 출력하되,저자의 나이가 30세 이상인 글만 출력
select p.title,a.email,a.age from post p inner join author a on p.author_id = a.id where a.age>=30;

--실습)글의 저자의 이름이 빈값(null)이 아닌 글 목록만을 출력 
select p.*,a.name from post p inner join author a on p.author_id=a.id where a.name is not null;

--조건에 맞는 도서와 저자 리스트 출력

--없어진 기록 찾기

--union : 두 테이블의 select 결과를 횡으로 결합
--union시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title,contents from post;
--union은 기본적으로 distinct 적용, 중복 허용하려면 union all 사용
select name, email from author union all select title,contents from post;

--서브쿼리 : select문 안에 또다른 select문을 서브쿼리라고 함
--where 절 안에 서브쿼리
--한번이라도 글을 쓴 author의 목록 조회(중복제거)
select distinct a.* from author a inner join post p on a.id=p.author_id;
--null값은 in 조건절에서 자동으로 제외
select * from author where id in (select author_id from post);

--컬럼 위치에 서브쿼리
--회원별로 본인의 쓴 글의 개수를 출력. ex)email,post_count
--서브쿼리 : join 보다 성능 떨어짐 
select email, (select count(*) from post p where p.author_id=a.id ) as post_count from author a;

--from절 위치에 서브쿼리
select a.* from (select * from author) as a;

--group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여 , 하나의 행(row) 처럼 취급 
select author_id from post group by author_id;
select author_id,count(*) from post group by author_id;

--회원별로 본인의 쓴 글의 개수를 출력 ex) email, post_count (left join으로 풀이)
select a.email,count(p.id) from author a left join post p on a.id=p.author_id group by a.email;

--집계함수
select coount(*) from author;
select sum(age) from author;
select avg(age) from author;
--소수점 3번째 자리까지 반올림 
select round(avg(age),3) from author;

--group by 와 집계함수
--회원의 이름별 숫자를 출력하고, 이름별 나이의 평균값을 출력하라
select name , count(*)as count,avg(age) as age from author group by name;

--where 와 group by 
--날짜값이 null인 데이터는 제외하고 , 날짜별 post 글의 개수 출력
select date_formate(created_time,'%Y-%m-%d') ,count(*) from post where created_time is not null group by date_formate(created_time,'%Y-%m-%d');

--자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE,COUNT(*) AS CARS FROM CAR_RENTAL_COMPANY_CAR WHERE OPTIONS LIKE'%시트%'GROUP BY CAR_TYPE ORDER BY CAR_TYPE;
--입양 시각 구하기(1)
SELECT DATE_FORMAT(DATETIME,'%H') AS HOUR ,COUNT(*) AS COUNT FROM ANIMAL_OUTS WHERE DATE_FORMAT(DATETIME,'%H')>='09'AND DATE_FORMAT(DATETIME,'%H')<'20' GROUP BY HOUR ORDER BY HOUR;

--group by와 having
--having 은 group by를 통해 나온 집계값에 대한 조건
--글을 3번 이상 쓴 사람 author_id 찾기 
select author_id,count(*) from post group by author_id having count(*) >=3;

--동명 동물 수 찾기 -> haveing
SELECT NAME,COUNT(*) AS COUNT 
FROM ANIMAL_INS WHERE NAME IS NOT NULL
GROUP BY NAME HAVING COUNT(*)>=2
ORDER BY NAME;
--카테고리 별 도서 판매량 집계하기 ->join까지
SELECT B.CATEGORY,SUM(S.SALES) AS TOTAL_SALES 
FROM BOOK B INNER JOIN BOOK_SALES S ON B.BOOK_ID= S.BOOK_ID 
WHERE DATE_FORMAT(S.SALES_DATE ,'%Y-%m')='2022-01' 
GROUP BY B.CATEGORY
ORDER BY B.CATEGORY;
--조건에 맞는 사용자와 총 거래금액 조회하기 ->join 까지
SELECT USER_ID,NICKNAME,SUM(B.PRICE)AS TOTAL_SALES 
FROM USED_GOODS_USER U 
INNER JOIN  USED_GOODS_BOARD B ON U.USER_ID=B.WRITER_ID 
WHERE B.STATUS='DONE' 
GROUP BY USER_ID
HAVING SUM(B.PRICE)>=700000
ORDER BY TOTAL_SALES;


--다중열 group by
--group by 첫번째컬럼,두번쨰컬럼 : 첫번째컬럼으로 grouping 이후에 두번째컬럼으로 grouping 
--post 테이블에서 작성자별로 구분하여 같은 제목의 글의 개수를 출력하시오
select author_id,title,count(*) from post group by author_id,title;

--재구매가 일어난 상품과 회원 리스트 구하기 
SELECT USER_ID , PRODUCT_ID 
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >=2
ORDER BY USER_ID,PRODUCT_ID DESC;

