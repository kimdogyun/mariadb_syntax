-- 사용자 목록 조회
select * from mysql.user;

--사용자생성
create user 'marketing'@'%' identified by 'test4321' ;

--사용자에게 권한부여
grant select on board.author to 'marketing'@'%';
grant select, insert on board.* to 'marketing'@'%';
grant all privileges on board.* to 'marketing'@'%';

--사용자 권한회수
revoke select on board.author from 'marketing'@'%';

--사용자 권한조회
show grants for 'marketing'@'%';

--사용자 계정 삭제
drop user 'marketing'@'%';
-- 권한 변경사항 적용
-- FLUSH PRIVILEGES;
    -- 일반적으로 workbench 등의 ui툴에서는 권한 적용명령어를 내부적으로 자동수행