/*
    <시퀀스 SEQUENCE>
    
    자동으로 번호를 발생시켜주는 역할을 하는 객체(자동번호부여기)
    정수값을 자동으로 순차적으로 발생시켜줌
    
    EX) 주차번호, 회원번호, 사원번호, 게시글번호
    -> 순차적으로 겹치지 않는 숫자를 채번할때 사용할 예정
    
    [표현법]
    CREATE SEQUENCE 시퀀스 명
    [
        START WITH 시작 숫자 -> 처음 발생시킬 시작값(DEFAULT 1)
        INCREMENT BY 증가값  -> 한번 시퀀스 증가할때마다 몇씩 증가할지 결정(DEFAULT 1)
        MAXVALUE 최대값 -> 최대값 지정
        MINVALUE 최소값 -> 최소값 지정
        CYCLE/NOCYCLE -> 값의 순환여부 . 
        CACHE 바이트크기 / NOCACHE -> 캐시메모리 지정여부. CACHE_SIZE의 기본값은 20BYTE
        
        * 캐시메모리 ? 
        시퀀스로부터 미리 발생될 값들을 생성해서 저장해두는 공간
        매번 호출할때마다 새로이 번호를 생성하는것보다 캐시메모리 공간에 미리 생성된 값들을 가져다 쓰게 되면 속도가 더 빠름
        단, 접속이 끊기고 나서 재접속 후 기존에 생성되어있던 값들은 제거됨. 
    ]
*/

CREATE SEQUENCE SEQ_TEST;

-- 시퀀스에 대한 정보를 조회할 데이터 딕셔너리 호출
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;


/*
    2. 시퀀스 사용 구문
    시퀀스명.CURRVAL : 현재 시퀀스의 값(마지막으로 성공적으로 발생된 NEXTVAL값)
    시퀀스명.NEXTVAL : 현재 시퀀스의 값을 증가시키고, 그 증가된 시퀀스의 값 == 시퀀스명.CURRVAL+INCREMENT_BY로 증가된 값
    
    단, 시퀀스 생성 후 첫 NEXTVAL은 START WITH으로 지정된 시작값으로 발생 따라서 시퀀스 생성 후 첫 CURRVAL은 수행이 불가능함. 
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- 시퀀스 SEQ_EMPNO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
-- 시퀀스가 생성되고 나서 NEXTVAL을 한번이라도 수행하지 않는 이상 CURRVAL을 수행할 수 없다. 
--> CURRVAL은 마지막으로 성종적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값이기 때문. 

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305

SELECT * FROM USER_SEQUENCES;
-- LAST NUMBER: 현재 시퀀스에 앞으로 NEXTVAL을 수행하면 반환시킬 값. 
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
-- 시퀀스 SEQ_EMPNO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
-- 지정한 MAXVALUE 값을 초과했기 때문에 오류 발생.

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;

/*
    3. 시퀀스 변경
    ALTER SEQUENCE 시퀀스명 
        -- START WITH 시작 숫자 -> 처음 발생시킬 시작값(DEFAULT 1)
        -- START WITH은 변경이 불가능함 : STARTWITH을 바꾸고 싶다면 시퀀스를 삭제했다가 재생성해줘야함. 
        
    INCREMENT BY 증가값  -> 한번 시퀀스 증가할때마다 몇씩 증가할지 결정(DEFAULT 1)
    MAXVALUE 최대값 -> 최대값 지정
    MINVALUE 최소값 -> 최소값 지정
    CYCLE/NOCYCLE -> 값의 순환여부. 
    CACHE 바이트크기 / NOCACHE -> 캐시메모리 지정여부. CACHE_SIZE의 기본값은 20BYTE
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310+10

DROP SEQUENCE SEQ_EMPNO;

--------------------------------------------------------------------------------

-- 매번 새로운 사번이 발생되는 시퀀스 생성(시퀀스명 : SEQ_EID)
-- 시작값은 300, 증가값은 1, 최대값은 400으로 설정

-- 사번이 추가될 때 실행할 INSERT문 작성 후 사번컬럼에 시퀀스를 이용하여 데이터 추가 

CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 400;


INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL, HIRE_DATE)
VALUES (SEQ_EID.NEXTVAL, '홍길동', '111111-1111111', 'J1', 'S1', SYSDATE);

-- 시퀀스는 INSERT문의 PK값에 넣을때 많이 사용됨.

/*
    사용할 수 없는 구문
    1. VIEW의 SELECT구문
    2. DISTINCE 포함된 SELECT 문
    3. GROUP BY HAVING ORDER BY가 있는 SELECT문
    4. SELECT, DELETE, UPDATE 서브쿼리문 안
    5. CREATE TABLE, ALTER TABLE의 DEFAULT 값으로 사용불가. 
    
*/