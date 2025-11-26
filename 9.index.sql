--pk,fk,unique 제약조건 추가시 해당컬럼에 대해 index페이지 자동생성
--별도의 컬럼에 대해 index 추가 생성 가능 

--index 조회 
show index from author;

--기존 index 삭제 (기본index는 삭제할 일이 별로 없음)
alter table author drop index 인덱스명;
--신규 index 생성
create index 인덱스명 on 테이블명(컬럼명);

create index name_index on author(name);
--cardinality : 데이터의 종류

--index는 1컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index 를 설정하는것도 가능 
--이경우 두컬럼을 and조건으로 조회해야만 index를 사용
create index 인덱스명 in 테이블명 (컬럼1,컬럼2);


--index 성능 테스트
--기존 테이블 삭제 후 간단한 테이블로 인덱스 설정 또는 인덱스 미설정 테스트
create table author(id bigint auto_increment, email varchar(255), name varchar(255),primary key(id)); --0.171 sec
create table author(id bigint auto_increment, email varchar(255) unique, name varchar(255), primary key(id)); -- 0.000sec

-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;

--1.회원입장에서 게시글이 1:1인가 1:n인가
--2.회원입장에서 게시글이 필수,선택인가
--3.게시글입장에서 회원이 1:1 인가 n:1인가
--4.게시글입장에서 회원이 필수,선택인가

--1.자식에 fk 설정
--2.누가 부모고,누가 자식 테이블인가
--n:n : fk 지정 x , 값 변경 어려움