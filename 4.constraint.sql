-- not null 제약 조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약 조건 제거
alter table author modify column name varchar(255);
--not null , unique 동시 추가
alter table author modify column email varchar(255) not null unique;

-- pk , fk 추가/제거
-- pk 제약조건 삭제
alter table post drop primary key;
pk 조회 : describe post;
제약조건 테이블 조회: select *from information_schema.key_column_usage where table_name='post';
제약조건을 별도로 삭제 
-- fk 제약조건 삭제
alter table post drop foreign key fk명;
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/on update 제약조건 변경 테스트 
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

기존 fk 삭제
새로운 fk 추가
새로운 fk에 맞는 테스트- 삭제 테스트 , 수정 테스트
