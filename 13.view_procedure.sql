--view : 실제데이터를 참조만 하는 가상의 테이블 select만 가능
--사용목정 : 1)권한분리 2)복잡한 쿼리를 사전생성


--view 생성
create view author_view as select name,email from author;
create view author_view2 as select p.title , a.name , a.email from post p inner join author a on p.author=a.id;

--view 조회 (테이블 조회와 동일)
select * from author_view ;

--view에 대한 권한 부여
grant select on board.author_views to 'marketing'@'%';

--view 삭제
drop view author_view;

--프로시저생성
delimiter // --한칸 띄우고 //
create procedure hello_procedure()
begin
    select 'hello world';
end
// delimiter ; --//하고 한칸 띄우기, 한칸 띄우고 ;

--프로시저 호출 
call hello_procedure();

--프로시저 삭제
drop procedure hello_procedure;

--회원목록조회 프로시저 생성 - > 한글명 프로시저 가능

delimiter // 
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;

--회원상세조회 -> input(매개변수)값 여러개 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력 

delimiter // 
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id = idInput;
end
// delimiter ;

--전체회원수조회-> 변수 사용
delimiter // 
create procedure 전체회원수조회()
begin
    --변수선언
    declare authorCount bigint;
    --into를 통해 변수에 값 할당
    select count(*) into authorCount from author;
    --변수값 사용 
    select authorCount;
end
// delimiter ;

--글쓰기
delimiter // 
--사용자가 title,contents,본인의 email값을 입력
create procedure 글쓰기(in titleInput varchar(255),contentsInput varchar(3000), emailInput varchar(255))
begin
    --begin밑에 declare를 통해 변수 선언
    declare authorId bigint;
    declare postId bigint;
    --email로 회원 id찾기 
    select id into authorId from author where email=emailInput;
    --post 테이블에 insert 
    insert into post(title,contents)values(titleInput, contentsInput);
    --post 테이블에 insert된 id값 구하기
   select id into postId from post order by id desc limit 1;
    --author_post_list테이블에 insert 하기 (author_id,post_id필요)
    insert into author_post_list(author_id,post_id) values(authorId,postId);
end
// delimiter ;



delimiter // 
create procedure 글쓰기(in titleInput varchar(255),contentsInput varchar(3000), emailInput varchar(255))
begin
    declare authorId bigint;
    declare postId bigint;
    --아래 declare은 변수선언과는 상관없는 예외관련 특수문법
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into authorId from author where email=emailInput;
        insert into post(title,contents)values(titleInput, contentsInput);
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id,post_id) values(authorId,postId);
        commit;
end
// delimiter ;


-- 글삭제 -> if else문
delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

--대량글쓰기 -> while문을 통한 반복문
delimiter // 
create procedure 글도배(in count bigint, in emailInput varchar(255))
begin
    declare authorId bigint;
    declare postId bigint;
    declare countValue bigint default 0;
    while countValue<count do 
        select id into authorId from author where email=emailInput;
        insert into post(title)values('안녕하세요');
        select id into postId from post order by id desc limit 1;
        insert into author_post_list(author_id,post_id) values(authorId,postId);
        set countValue = countValue+1;
    end while;
end
// delimiter ;




--innoDB는 트랜잭션 지원 , 조회성능은 느림

--myisam은 트랜잭션 지원 x , 조회성능 빠름

--클러스터링 : 여러 서버를 묶는다

--레플리카 : 복제



