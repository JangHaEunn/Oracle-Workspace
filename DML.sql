--1. 
INSERT INTO TB_CLASS_TYPE(
    SELECT 01 AS PK_CLASS_TYPE_NO, '전공필수' AS CLASS_NAME FROM DUAL
     UNION
     SELECT 02 AS PK_CLASS_TYPE_NO, '전공선택' AS CLASS_NAME FROM DUAL
     UNION
     SELECT 03 AS PK_CLASS_TYPE_NO, '교양필수' AS CLASS_NAME FROM DUAL
     UNION
     SELECT 04 AS PK_CLASS_TYPE_NO, '교양선택' AS CLASS_NAME FROM DUAL
     UNION
     SELECT 05 AS PK_CLASS_TYPE_NO, '논문지도' AS CLASS_NAME FROM DUAL
    
);

SELECT * FROM TB_CLASS_TYPE;

-- 2. 
CREATE TABLE TB_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS FROM TB_STUDENT;

-- 3. 
CREATE TABLE TB_국어국문학과
AS SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN,1,2),'RR'),'YYYY"년"') AS 출생년도, NVL(PROFESSOR_NAME, '지도교수없음') 교수이름
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
LEFT JOIN TB_DEPARTMENT D ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과';
SELECT * FROM TB_국어국문학과;

DROP TABLE TB_국어국문학과;

-- 4. 
UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY*1.1);

SELECT * FROM TB_STUDENT;
-- 5. 
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NAME = '박건우' AND STUDENT_NO = 'A413042';

-- 6. 
UPDATE TB_STUDENT
SET STUDENT_SSN = TRUNC(SUBSTR(STUDENT_SSN,1,6));

-- 7. 
UPDATE TB_GRADE
SET POINT = 3.5
WHERE TERM_NO = '200501' AND
CLASS_NO = (SELECT CLASS_NO FROM TB_CLASS WHERE CLASS_NAME ='피부생리학'); 

-- 8.
DELETE FROM TB_GRADE 
WHERE STUDENT_NO IN (SELECT STUDENT_NO FROM TB_STUDENT WHERE ABSENCE_YN = 'Y');
