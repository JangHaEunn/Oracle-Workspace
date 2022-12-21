-- 2_1. CREATE TABLE 권한 부여 받기 전. 
CREATE TABLE TEST(
    TEST_ID NUMBER
); -- ORA-01031: 권한이 불충분합니다

-- 2_2. CREATE TABLE 권한 부여 받은 후 
CREATE TABLE TEST2(
    TEST_ID NUMBER
);

-- 테이블 생성권한 부여받은 후 TABLE 스페이스를 할당받으면, 계정이 소유하고 있는 테이블들을 조작하는 것도 가능해짐 (DML)
INSERT INTO TEST2 VALUES(1);
-- 테이블스페이스 'USERS'에 대한 권한이 없습니다. 

-- 4. 뷰 만들어보기
CREATE VIEW V_TEST
AS SELECT * FROM TEST2;

-- 5. 
-- SAMPLE계정에서 KH계정의 테이블에 접근해서 조회해보기 -- 불가능->권한 부여 후 가능 
SELECT * FROM KH.EMPLOYEE;

INSERT INTO KH.DEPARTMENT VALUES('D0','회계부','L2');

CREATE TABLE TEST3(
    TEST_ID NUMBER
);
