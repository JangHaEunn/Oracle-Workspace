-- 1. 
SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 이름 , TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS 입학년도
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = 002
ORDER BY ENTRANCE_DATE ASC;

-- 2.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3; 

-- 3.
SELECT PROFESSOR_NAME AS 교수이름 , EXTRACT(YEAR FROM SYSDATE)- (1900+SUBSTR(PROFESSOR_SSN, 1,2)) AS 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) = 1 
ORDER BY 나이 ASC;

-- 4.
SELECT SUBSTR(PROFESSOR_NAME,2,2) AS 이름
FROM TB_PROFESSOR;

-- 5.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - (1900+SUBSTR(STUDENT_SSN, 1, 2)) > 20;

-- 6. 
SELECT TO_CHAR(TO_DATE('20201225'),'DAY')
FROM DUAL;

-- 7.
SELECT TO_CHAR(TO_DATE('99/10/11','YY/MM/DD'), 'YYYY"년" MM"월" DD"일"')
FROM DUAL; -- 2099년 10월 11일

SELECT TO_CHAR(TO_DATE('49/10/11','YY/MM/DD'), 'YYYY"년" MM"월" DD"일"')
FROM DUAL; -- 2049년 10월 11일

SELECT TO_CHAR(TO_DATE('99/10/11','RR/MM/DD'), 'YYYY"년" MM"월" DD"일"')
FROM DUAL; -- 1999년 10월 11일

SELECT TO_CHAR(TO_DATE('49/10/11','RR/MM/DD'), 'YYYY"년" MM"월" DD"일"')
FROM DUAL; -- 2049년 10월 11일

-- 8.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) <2000;

-- 9. 
SELECT ROUND(AVG(POINT),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- 10.
SELECT DEPARTMENT_NO AS 학과번호 , COUNT(* ) AS "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;


-- 11.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;
    
-- 12.
SELECT SUBSTR(TERM_NO,1,4) AS 년도, ROUND(AVG(POINT),1) AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO,1,4)
ORDER BY SUBSTR(TERM_NO,1,4);


-- 13.
SELECT DEPARTMENT_NO AS "학과코드명", SUM(DECODE(ABSENCE_YN, 'Y', 1, 'N', 0)) AS "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;


-- 14.
SELECT STUDENT_NAME AS "동일이름", COUNT(STUDENT_NAME) AS "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(STUDENT_NAME) > 1
ORDER BY STUDENT_NAME;

-- 15.
SELECT NVL(SUBSTR(TERM_NO,1,4),' ') AS 년도, NVL(SUBSTR(TERM_NO, -2,2),' ') AS 학기, ROUND(AVG(POINT),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO, -2,2))
ORDER BY SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO, -2,2);
