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

기존 fk 삭제 : alter table post drop foreign key fk명;
새로운 fk 추가 : alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;
새로운 fk에 맞는 테스트- 삭제 테스트 , 수정 테스트 : select *from author; -> 삭제 후 select *from post; -> null로 변경 되었는지 확인 
                                                                    -> 수정후                     -> 똑같이 수정 되었는지 확인 

--foreign key 
부모테이블에 없는 데이터가 자식테이블에 inset 될수 없다.
on delete : 기본값 - restrict , cascade , set null
on upsate : 기본값 - restrict , cascade , set null

--부모테이블이 삭제되는 경우(hard delete)
중요x -> 같이 삭제, cascade

--default 옵션
--어떤 컬럼이든 default 지정이 가능하지만 , 일반적으로 enum타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';

--auto_increment : 숫자값을 입력 안했을때, 마지막에 입력된 가장 큰 값에 +1 만큼 자동으로 증가된 숫자값 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

--uuid 타입
alter table post add column user_id chqr(36)  default(uuid());
