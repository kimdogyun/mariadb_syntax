--트랜잭션
1.하나의 쿼리작업
2.하나 이상의 쿼리를 논리적 단위로 묶은 작업


--트랜잭션 테스트를 위한 컬럼추가
alter table author add column post_count int default 0;


--트랜잭션 실습 
--post에 글쓰기 (insert).author의 post_count에 +1을 update하는 작업. 2개를 한 트랜잭션으로 처리
--start transaction은 실질적인 의미는 없고, 트랜잭션의 시작이라는 상징적인 의미만 있는 코드
start transaction;
update author set post_count=post_count+1 where id=3;
insert into post(title, contents,author_id)values('hello','helloworld...',3);
commit;

--위 트랜잭션은 실패시 자동으로 rollback이 어려움.
--stored 프로시저를 활용하여 성공시에는 commit, 실패시에는 rollback 등 동적인 프로그래밍
DELIMITER //
create procedure transaction_test()
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update author set post_count=post_count+1 where id = 3;
    insert into post(title, contentS, author_id) values("hello", "hello ...",3);
    commit;
end //
DELIMITER ;

--프로시저 호출
call transaction_test();

datebase 멀티스레드 프로그램 동시에 여러 사용자가 작업 가능
=>동시성 문제 발생
=>격리 수준 - Repeatable Read  (mariadb)
=>lost update
=>배타락-selet for update 으로 해결