 /*
    SUBQUERY (서브쿼리) 
    하나의 주된 SQL(SELECT, CREATE, UPDATE, INSERT) 안에 포함된 또 하나의 SELECT문
    
    메인 SQL 문을 위해서 보조 역할을 하는 SELECT문 
    -> 주로 조건절 안에서 쓰임. 
    
 */
 
 -- 간단 서브쿼리 예시 1
 -- 노옹철 사원과 같은 부서인 사원들.
 
-- 1) 먼저 노옹철 사원의 부서코드를 조회. 
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 부서코드가 D9인 사원들 조회.
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 두 단계를 하나로 합치기(서브쿼리를 이용해서) 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');
                    
-- 두번째 예시
-- 전체 사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급코드를 조회. 
-- 1) 전체 사원의 평균급여 구하기 
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 2) 평균 급여(3047663)보다 많은 급여를 받고 있는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 위의 두 단계를 하나로 합치기(서브쿼리를 이용해서) 
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                 FROM EMPLOYEE);
                 
/*
    서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라서 분류가 됨. 
    - 단일행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 오직 1개일 때(한 칸의 컬럼값으로 나올 때) 
    - 다중행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행일 때
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 열일 때 
    - 다중행 다중열 서브쿼리   : 서브쿼리를 수행한 결과값이 여러 행, 여러 열일때
    
    => 서브쿼리를 수행한 결과가 몇 행 몇 열이냐에 따라 사용가능한 연산자가 달라진다.
*/

/*
    1. 단일행 (단일열) 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과값이 오직 1개일 때 
    
    일반연산자 사용 가능( =, !=, >, <, >=, <= ...)
*/
-- 전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급코드 , 급여 조회 
SELECT EMP_NAME, JOB_CODE, SALARY 
  FROM EMPLOYEE
 WHERE SALARY < (SELECT ROUND(AVG(SALARY))
                 FROM EMPLOYEE); -- 결과값이 1행 1열일때, 오로지 1개의 값 (원하는 영역만 드래그해서 실행)
                 
-- 최저급여를 받는 사원의 사번, 사원명, 직급코드 , 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
  FROM EMPLOYEE
 WHERE SALARY = (SELECT MIN(SALARY)
                 FROM EMPLOYEE);


-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철');
                  
-- 사번, 이름, 부서명, 급여                   
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                  FROM EMPLOYEE
                 WHERE EMP_NAME = '노옹철');

-- 부서별 급여 합이 가장 큰 부서 하나만을 조회, 부서코드, 부서명, 급여 합
-- 1) 각 부서별 급여 합 구하기 + 가장 큰 합을 찾기
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 1단계 가지고 서브쿼리 만들기
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                    GROUP BY DEPT_CODE);
                    
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
    
    서브쿼리의 조회 결과값이 여러 행일 경우 
    
    - IN (10, 20, 30, ...) 서브쿼리 : 여러개의 결과값 중에서 하나라도 일치하는 것이 있다면 / NOT IN(일치하는 것이 없을 때)
    - > ANY (10, 20, 30, ...) : 여러개의 결과값 중에서 "하나라도" 클 경우 즉, 여러개의 결과값 중에서 가장 작은 값보다 클 경우 
    - < ANY (10, 20, 30, ...) : 여러개의 결과값 중에서 "하나라도" 작을 경우 즉, 여러개의 결과값 중에서 가장 큰 값보다 작을 경우 
    
    - > ALL : 여러개의 결과값의 모든 값보다 클 경우 
              즉, 여러개의 결과값중에서 가장 큰 값보다 클 경우
    - < ALL : 여러개의 결과값의 모든 값보다 작을 경우 
              즉, 여러개의 결과값중에서 가장 작은값보다 작을 경우
*/

-- 각 부서별 최고급여를 받는 사원의 이름, 직급코드, 급여 조회
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 위의 급여를 받는 사원을 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE);
8000000,
3900000,
2550000,
3760000,
3660000,
2890000,
2490000 
-- ,가 자동적으로 들어간다

-- 선동일 또는 유재식과 같은 부서인 사원들을 조회하시오.(사원명, 부서코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE IN (SELECT DEPT_CODE
                       FROM EMPLOYEE
                      WHERE EMP_NAME IN('선동일', '유재식'));
                    
-- 이오리 또는 하동운 사원과 같은 직급인 사원들을 조회하시오(사원명, 직급코드, 부서코드, 급여)
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN (SELECT JOB_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME IN ('이오리', '하동운'));

-- 사원 < 대리 < 과장 < 차장 < 부장 
-- 대리 직급인데도 불구하고 과장직급의 급여보다 많이 받는 사원들 조회. 

-- 1) 과장 직급의 급여들 조회 -> 다중행 단일열 
SELECT SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE 
   AND JOB_NAME = '과장'; -- 2200000, 2500000, 3760000

-- 2) 위의 급여들 보다 하나라도 더 높은 급여를 받는 직원들 조회. 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE 
  AND JOB_NAME = '대리' 
  AND SALARY >= ANY(SELECT SALARY
                    FROM EMPLOYEE E, JOB J
                    WHERE E.JOB_CODE = J.JOB_CODE 
                    AND JOB_NAME = '과장');


-- 과장 직급임에도 불구하고 "모든" 차장직급의 급여보다도 더 많이 받는 직원 조회(사번, 이름, 직급명, 급여)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE  
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
  AND SALARY > ALL(SELECT SALARY
                   FROM EMPLOYEE E, JOB J
                   WHERE E.JOB_CODE = J.JOB_CODE 
                   AND JOB_NAME = '차장');


SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE  
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
    AND SALARY > ALL(SELECT SALARY
                     FROM EMPLOYEE  
                     JOIN JOB USING(JOB_CODE)
                     WHERE JOB_NAME = '차장');
                    

/*
    3. (단일행) 다중열 서브쿼리 
    서브쿼리 조회 결과가 값은 한행이지만, 나열된 컬럼의 갯수가 여러개인 경우 
    
*/
-- 하이유 사원과 같은 부서코드, 같은 직급코드에 해당되는 사원들 조회 (사원명, 부서코드, 직급코드, 고용일)
-- 1) 하이유 사원의 부서코드와 직급코드를 먼저 조회 -> 단일행 다중열 (DEPT_CODE, JOB_CODE)
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

-- 2) 부서코드가 D5이면서 직급코드가 J5인 사원들 조회. 
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5';

-- 3) 위의 내용물들을 하나의 쿼리문으로 합치기.
-- 다중열 서브쿼리(비교할 값의 순서를 맞추는게 중요하다)
-- (비교대상컬럼1, 비교대상컬럼 2)= (비교할 값1, 비교할 값2) -> 서브쿼리로 제기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ('D5', 'J5'); -- 리터럴 값은 ERROR


SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '하이유');
                               
-- 박나라 사원과 같은 직급코드 , 같은 사수사번을 가진 사원들의 사번, 이름, 직급코드, 사수 사번을 조회
-- 다중열 서브쿼리로 작성하기 -> 한번에 안된다 싶으면 나눠서 작업해보기

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라');

/*
    4. 다중행 다중열 서브쿼리 
    서브쿼리 조회결과가 여러행 여러컬럼일 경우 
*/









