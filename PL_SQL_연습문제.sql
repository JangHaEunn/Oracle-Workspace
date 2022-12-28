-- 1. 사원의 연봉은 구하는 PL/SQL 블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BO EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT SALARY, BONUS
    INTO SAL, BO
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    SAL := (SAL + SAL * NVL(BO,0)) * 12;
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || SAL);
END;
/

DECLARE
    VEMP EMPLOYEE%ROWTYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT  *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF(VEMP.BONUS IS NULL)
        THEN VSALARY := VEMP.SALARY*12;
    ELSE
        VSALARY := (VEMP.SALARY + VEMP.SALARY * VEMP.BONUS) * 12;
    END IF;   
    DBMS_OUTPUT.PUT_LINE(VEMP.SALARY || ' ' || VEMP.EMP_NAME || TO_CHAR(VSALARY, 'L999,999,999'));
END;
/

        
-- 2. 구구단 짝수 출력
-- 2-1) FOR LOOP
-- 2-2) WHILE LOOP


DECLARE
    DAN NUMBER := 2;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
    
    LOOP
        FOR I IN 1..9 LOOP        
            DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || I || ' = ' || DAN*I);
        END LOOP;
        
        DAN := DAN+2;
        
        
        IF DAN = 10 THEN EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
    END LOOP;
END;
/

DECLARE
    DAN NUMBER := 2;
    I NUMBER := 1;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
   
    LOOP
        WHILE I < 10 
        LOOP        
            DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || I || ' = ' || DAN*I);
            I := I+1;
        END LOOP;
        DAN := DAN+2;
        I := 1;
        IF DAN = 10 THEN EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
    END LOOP;
END;
/
--------------------------------------------------------------------------------
DECLARE
    RESULT NUMBER;
BEGIN
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN, 2) = 0 -- 2로 나눴을때 나머지가 0인경우
            THEN
                FOR SU IN 1..9
                LOOP
                    RESULT := DAN * SU;
                     DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' ||  RESULT);
                END LOOP;
                    DBMS_OUTPUT.PUT_LINE(' ');
            END IF;
    END LOOP;
END;
/

DECLARE
    RESULT NUMBER;
    DAN NUMBER := 2;
    SU NUMBER;
BEGIN
    WHILE DAN <= 9
    LOOP
        SU := 1;
        IF MOD(DAN, 2) = 0 
            THEN
                WHILE SU <= 9
                LOOP
                    RESULT := DAN * SU;
                    DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' ||  RESULT);
                    SU := SU + 1;
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(' ');
                
        END IF;
        DAN := DAN + 1;
    END LOOP;
END;
/

