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


-- 2. 구구단 짝수 출력
-- 2-1) FOR LOOP
-- 2-2) WHILE LOOP


DECLARE
    DAN NUMBER := 2;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
    BEGIN 
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
END;
/

DECLARE
    DAN NUMBER := 2;
    I NUMBER := 1;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('---- '||DAN || ' 단 ----');
    BEGIN 
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
END;
/
