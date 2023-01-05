--hire date(입사일)을 이용해서 '홍길동님은 2003년 1월 3일에 입사했습니다.'로 출력하는 query를 작성하시오.
SELECT first_name || '님은' 
        || to_char(hire_date, 'yyyy') ||'년 '
        || ltrim(to_char(hire_date, 'mm'), '0') ||'월 '
        || ltrim(to_char(hire_date, 'dd'), '0') ||'일에 입사했습니다.'
FROM employees;

/*---------------------------------------
일반함수(null)
1. nvl(컬럼, 대체값) : 첫번째 인자값이 null이면 0으로 대체해서 출력한다.
    - 대체할 값이 숫자이면 두번째 인자값에 숫자를 지정한다.
    - 대체할 값이 문자이면 두번째 인자값에 문자를 지정한다.
    - 대체할 값이 날짜이면 두번째 인자값에 날짜를 지정한다.
---------------------------------------*/
DESC employees;

SELECT commission_pct, nvl(commission_pct, 0)
FROM employees;

SELECT first_name, manager_id, nvl(to_char(manager_id), 'CEO')
FROM employees;

/*------------------------------------------------------------
일반함수(NULL)
2. nvl2(컬럼, 대체값1, 대체값2) : 컬럼의 값이 null이 아니면 대체값1, null이면 대체값2로 출력한다.
------------------------------------------------------------*/
SELECT commission_pct, nvl2(commission_pct, 1, 0)
FROM employees;

SELECT count(*) AS 전체사원수, 
       sum(nvl2(commission_pct, 1, 0)) AS "커미션지급 사원수",
       count(*)-sum(nvl2(commission_pct, 1, 0)) AS "커미션미지급 사원수"
FROM employees;

/*------------------------------------------------------------------------
일반함수(NULL)
3. NULLIF(컬럼, 비교값)
    컬럼값과 비교값이 같으면 NULL로 리턴하고 같지 않으면 컬럼의 값으로 리턴한다.
------------------------------------------------------------------------*/
SELECT commission_pct, NULLIF(commission_pct, 0.4)
FROM employees;

/*-----------------------------------------------------------------
일반함수(NULL)
4. coalesce(컬럼1, 컬럼2)
    - 컬럼1, 컬럼2 모두 Null이 아니면 컬럼1을 리턴한다.
    - 컬럼1, 컬럼2 중 Null이 아닌 컬럼을 리턴한다.
    - 컬럼1, 컬럼2 모두 Null이면 Null을 리턴한다.
-----------------------------------------------------------------*/
SELECT first_name, commission_pct, salary, coalesce(commission_pct, salary)
FROM employees;



/*-----------------------------------------------------------------
decode(컬럼, 값1, 처리1, 값2, 처리2, 그 밖의 처리)
java의 switch~case문과 비슷
-----------------------------------------------------------------*/
SELECT first_name, department_id,
        decode(department_id, 10, 'ACCOUNTING',
                              20, 'RESEARCH',
                              30, 'SALES',
                              40, 'OPERATIONS', 'OTHERS') AS department_name
FROM employees;

-- 직급이 'PR_REP'인 사원은 5%, 'SA_MAN'인 사원은 10%,
-- 'AC_MGR'인 사원은 15%, 'PU_CLERK'인 사원은 20%를 인상
SELECT job_id, salary, decode(job_id, 'PR_PEP', salary * 1.05,
                                      'SA_MAN', salary * 1.1,
                                      'AC+MGR', salary * 1.15,
                                      'PU_CLERK', salary * 1.2, salary) AS newsal
FROM employees;

/*------------------------------------------------------------------
case when 조건식1 then 처리1
     when 조건식2 then 처리2
     when 조건식3 then 처리3
     else 처리n
end AS alias;

java에서 다중 if~else문과 비슷
------------------------------------------------------------------*/
-- 입사일(hire_date) 1~3이면 '1사분기', 4-6이면 '2사분기',
--                  7~9이면 '3사분기', 10~12이면 '4사분기'
--로 처리를 하고 사원명(first_name), 입사일(hire_date), 분기로 출력하시오.
SELECT first_name, hire_date, CASE WHEN to_char(hire_date, 'mm') <= 3 THEN '1사분기'
                                   WHEN to_char(hire_date, 'mm') <= 6 THEN '2사분기'
                                   WHEN to_char(hire_date, 'mm') <= 9 THEN '3사분기'
--                                 WHEN to_char(hire_date, 'mm') <= 12 THEN '4사분기'
                                   ELSE '4사분기'
                                END AS "분기"
FROM employees;

--salary의 값이 10000미만이면 '하', 10000이상 20000미만이면 '중', 20000이상이면 '상'
--으로 출력하도록 query문을 작성하시오.

SELECT first_name, salary, CASE WHEN salary < 10000 THEN '하'
                                WHEN salary < 20000 THEN '중'
                                ELSE '상'
                                END AS "구분"

FROM employees;

/*---------------------------------------------------------------------
집계함수(Aggregate Function), 그룹함수(Group Function)
max([DISTINCT] | [ALL] 컬럼) : 최대값
min([DISTINCT] | [ALL] 컬럼) : 최소값
count([DISTINCT] | [ALL] 컬럼) : 개수
sum([DISTINCT] | [ALL] 컬럼) : 합계
avg([DISTINCT] | [ALL] 컬럼) : 평균
stddev([DISTINCT] | [ALL] 컬럼) : 표준편차
variance([DISTINCT] | [ALL] 컬럼) : 분산
----------------------------------------------------------------------*/

SELECT max(salary), min(salary), count(salary), sum(salary), avg(salary), stddev(salary), variance(salary)
FROM employees;

SELECT max(DISTINCT salary), min(DISTINCT salary), count(DISTINCT salary),
sum(DISTINCT salary), avg(DISTINCT salary), stddev(DISTINCT salary), variance(DISTINCT salary)
FROM employees;

--NULL값이 아닌 레코드수를 리턴
SELECT count(commission_pct)
FROM employees; --35

--모든 레코드수를 리턴
SELECT count(*)
FROM employees; --107

SELECT count(employee_id)
FROM employees; --107

--NULL값이 아닌 레코드에서 중복제거 개수를 리턴
SELECT count(DISTINCT commission_pct)
FROM employees; --7

SELECT count(ALL commission_pct)
FROM employees; --35

--집계함수와 단순컬럼은 함께 사용할 수 없다.(출력되는 레코드(row) 수가 다르기 때문이다.)
--ORA-00937: not a single-group group function(단일 그룹의 그룹함수가 아닙니다.)
SELECT first_name, count(*)
FROM employees;

--그룹함수와 단순컬럼을 사용하기 위해서는 단순컬럼을 그룹화 해야 한다.(GROUP BY)
SELECT department_id, count(*)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 50이하인 부서번호에 대해서 NULL이 아닌 부서별의 직원수를 출력하시오.
SELECT department_id, count(*)
FROM employees
/*WHERE department_id IS NOT NULL*/
GROUP BY department_id
HAVING department_id >= 50 OR department_id IS NULL /* NULL은 비교연산자를 사용할 수 없다.*/
ORDER BY department_id;


-- 부서별 직원수가 5이하인 경우만 출력하시오.
SELECT department_id, count(*) AS "인원수"
FROM employees
GROUP BY department_id
HAVING count(*) <= 5
ORDER BY department_id;

--업무별(job_id) 급여합계를 출력하시오.
SELECT job_id, sum(salary)
FROM employees
GROUP BY job_id;

-- 부서별 최소급여, 최대급여를 출력하는데 최소급여와 최대급여가 같지 않은 경우에만 부서별 오름차순으로 출력하시오.
SELECT department_id, min(salary), max(salary)
FROM employees
GROUP BY department_id
HAVING min(salary) != max(salary)
ORDER BY department_id;




*------------------------------
문제
------------------------------*/
--1) 모든사원에게는 상관(Manager)이 있다. 하지만 employees테이블에 유일하게 상관이
--   없는 로우가 있는데 그 사원(CEO)의 manager_id컬럼값이 NULL이다. 상관이 없는 사원을
--   출력하되 manager_id컬럼값 NULL 대신 CEO로 출력하시오.

SELECT first_name, manager_id
FROM employees
GROUP BY manager_id
HAVING manager_id IS NULL
ORDER BY manager_id;
    

--2) 가장최근에 입사한 사원의 입사일과 가장오래된 사원의 입사일을 구하시오.
SELECT first_name, hire_date
HAVING max(hire_date)
FROM employees;
 
--3) 부서별로 커미션을 받는 사원의 수를 구하시오.
   
   
--4) 부서별 최대급여가 10000이상인 부서만 출력하시오.
SELECT department_id, salary
HAVING salary >= 10000
FROM employees;
  

--5) employees 테이블에서 직종이 'IT_PROG'인 사원들의 급여평균을 구하는 SELECT문장을 기술하시오.
  

--6) employees 테이블에서 직종이 'FI_ACCOUNT' 또는 'AC_ACCOUNT' 인 사원들 중 최대급여를  구하는 SELECT문장을 기술하시오.   
   
  

--7) employees 테이블에서 50부서의 최소급여를 출력하는 SELECT문장을 기술하시오.
    
    
--8) employees 테이블에서 아래의 결과처럼 입사인원을 출력하는 SELECT문장을 기술하시오.
--   <출력:  2001		   2002		       2003
 --  	     1          7                6   >
   		   
   
    
--9) employees 테이블에서 각 부서별 인원이 10명 이상인 부서의 부서코드,
--  인원수,급여의 합을 구하는  SELECT문장을 기술하시오.
   SELECT department_id, count(*), sum(salary)
   From employees   
   GROUP BY department_id
   HAVING count(*) >= 10;
  
--10) employees 테이블에서 이름(first_name)의 세번째 자리가 'e'인 직원을 검색하시오.
    --instr(데이터, 찾을 문자, 시작위치, 순서)
    SELECT first_name
    FROM employees
    WHERE instr(first_name, 'e')=3;

    SELECT first_name
    FROM employees
    WHERE instr(first_name, 'e', 3, 2)=8;
    
    SELECT instr('korea','e',2,2)
    FROM dual; --0
    
    SELECT instr('koreae','e',2,2)
    FROM dual; --6

/*
    java            oracle
    indexOf("e")    instr(first_name, 'e')
    CharAt          

*/

     