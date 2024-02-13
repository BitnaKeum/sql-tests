### SQL 실행되는 순서

: `FROM` - `WHERE` - `GROUP BY` - `HAVING` - `SELECT` - `ORDER BY`

---
<br>

# CREATE 절

### 사용자 생성
```sql
CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
```

### 테이블 생성
```sql
CREATE TABLE 테이블명(
    컬럼명 타입 제약조건,    # 제약조건(생략 가능): NOT NULL / NULL / UNIQUE(=중복X)
    PRIMARY KEY (컬럼명),   # 생략 가능, NOT NULL & UNIQUE 조건을 포함함
    FOREIGN KEY (컬럼명) REFERENCES 관계테이블명(관계테이블 컬럼명),  # 관계테이블 컬럼은 관계테이블의 PRIMARY KEY여야함
);
```

---

# ALTER 절

### 테이블 수정
```sql
ALTER TABLE 테이블명 RENAME 새테이블명;
```

```sql
ALTER TABLE 테이블명 CHANGE COLUMN 컬럼명 새컬럼명 새컬럼타입;
```

```sql
ALTER TABLE 테이블명 MODIFY COLUMN 컬럼명 새컬럼형식;
```

```sql
ALTER TABLE 테이블명 ADD COLUMN 새컬럼명 새컬럼형식;    # PRIMARY KEY 추가도 가능
```

```sql
ALTER TABLE 테이블명 DROP COLUMN 컬럼명;               # PRIMARY KEY 삭제도 가능
```

---
# DROP 절

### 테이블 삭제
- 참고: FOREIGN KEY가 있을 경우 자식 테이블부터 삭제해야함
```sql
DROP TABLE 테이블명;
```

---
# INSERT 절

### 테이블에 인스턴스 추가
```sql
INSERT INTO 테이블명 (컬럼명1, 컬럼명2, ...) 
						 VALUES (값1, 값2, ...);
```

---
# UPDATE 절

### 인스턴스 수정
```sql
UPDATE 테이블명
  SET 컬럼명1=새값1,
      컬럼명2=새값2
  WHERE 조건;   # 생략 가능
```

---
# DELETE 절

### 인스턴스 삭제
- 참고: 자식 테이블이 있는 경우, 부모 테이블에서 참조된 인스턴스들은 삭제되지 않고 에러 발생
```sql
DELETE FROM 테이블명;
```
```sql
DELETE FROM 테이블명 WHERE 조건;
```

---
# GRANT/REVOKE 절
### 사용자 권한 설정
```sql
GRANT 권한1, 권한2 PRIVILEGES ON 테이블명 TO 사용자명 IDENTIFIED BY 비밀번호;   # 권한: ALL, SELECT, ...
FLUSH PRIVILEGES;   # GRANT문을 실행하는 명령어로, GRANT문이 여러개 있어도 한번만 작성
```

### 사용자 권한 해제
```sql
REVOKE 권한1, 권한2 ON 테이블명 TO 사용자명;
```

---

# SELECT 절

### 행 가져오기

```sql
SELECT 컬럼명 FROM 테이블명
```
- `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` 절을 추가할 수 있음
- 컬럼명에다가 aggregate 함수를 사용할 수 있음: `SUM()`, `AVG()`, `MIN()`, `MAX()`, `COUNT()`
- 컬럼명 앞에 `DISTINCT` 키워드를 붙이면 해당 컬럼의 값이 중복되지 않게 출력할 수 있음
- `SELECT 컬럼명 + '고객님' FROM 테이블명` 이런식도 가능함

### CASE WHEN 구문

- 사용법 1
  ```sql
  SELECT 
    CASE WHEN 조건1 THEN 값1
         WHEN 조건2 THEN 값2
         ELSE 값3    # ELSE는 생략 가능
    END as 새컬럼명
  FROM 테이블명
  ```
- 사용법 2
  ```sql
  SELECT 
    집계함수(CASE WHEN 조건1 THEN 값1
                  WHEN 조건2 THEN 값2
                  ELSE 값3
            END) as 새컬럼명
  FROM 테이블명
  ```

- 예시
  ```sql
  SELECT NAME as '이름',
    CASE WHEN AGE BETWEEN 10 AND 20 THEN '10대'
         WHEN AGE BETWEEN 20 AND 30 THEN '20대'
         ELSE AGE
    END as '나이대'
  FROM [MEMBER]
  ```

- 문제: 성별 및 연령대별로 회원의 수를 카운트하되, 가입한 날짜(join_date)가 2018년인 회원과 2019년인 회원 수를 나눠서 카운트하시오. (출력 컬럼: gender, ageband, join_2018, join_2019)
  ```sql
  SELECT gender, ageband,
    COUNT(CASE WHEN YEAR(join_date)=2018 THEN join_date
          END) as join_2018,
    COUNT(CASE WHEN YEAR(join_date)=2019 THEN join_date
          END) as join_2019,
  FROM [MEMBER]
  GROUP BY gender, ageband;
  ```


### FROM 절

- 테이블명 별칭(alias) 설정하기
  ```sql
  FROM 테이블명 AS 별칭
  ```
  ```sql
  FROM 테이블명 별칭
  ```
- 예시
  ```sql
  SELECT C.name, C.address
  FROM customer C
  WHERE C.age > 21;
  ```


### JOIN

- INNER JOIN
  ```sql
  SELECT 컬럼명 FROM 테이블명1 INNER JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```
  ```sql
  SELECT 컬럼명 FROM 테이블명1 JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```
  ```sql
  SELECT 컬럼명 FROM 테이블명1, 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```

- LEFT OUTER JOIN (LEFT JOIN)<br>
  : 왼쪽 테이블은 다 출력, 오른쪽 테이블은 조건 만족하는 것만 붙여서 출력
  ```sql
  SELECT 컬럼명 FROM 테이블명1 LEFT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```

- RIGHT OUTER JOIN (RIGHT JOIN)<br>
  : 오른쪽 테이블은 다 출력, 왼쪽 테이블은 조건 만족하는 것만 붙여서 출력
  ```sql
  SELECT 컬럼명 FROM 테이블명1 RIGHT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```

- FULL OUTER JOIN (FULL JOIN)<br>
  : 왼쪽 테이블과 오른쪽 테이블을 합집합해서 다 출력
  ```sql
  SELECT 컬럼명 FROM 테이블명1 FULL OUTER JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;
  ```


### WHERE 절

- `AND`
- `OR`
- `<>`: 값이 다른거 찾을때 (ex: `WHERE age <> 20`)
- `BETWEEN 값1 AND 값2`: 값1 이상 값2 이하
- `IN`: 속하는거 찾을때  (ex: `WHERE age IN (20, 30)`)
- `LIKE`: 패턴 지정해서 찾을때. %는 모든 글자, _는 한 글자를 의미 (ex: `WHERE name LIKE '김%'`, `WHERE name LIKE '_수진'`)
- `EXISTS`: 뒤에 보통 서브쿼리가 옴. 서브쿼리의 결과가 한건이라도 존재하면 조건 만족.
- `NOT EXISTS`


### GROUP BY 절
: 집계함수를 적용할 그룹을 나누는 기능
- 이 경우 `SELECT` 절에는 GROUP BY의 대상 컬럼 및 aggregation 함수만 올 수 있다


### HAVING 절
: GROUP BY 결과 (각 그룹)에 대한 조건을 지정하는 기능
- GROUP BY 절이 있을 때만 사용가능
- 문제: 주소지(addr)별로 남자인 회원의 수를 집계하되, 50명 이상인 경우만 나오도록 하여라.
  ```sql
  SELECT addr, COUNT(mem_no) as mem_cnt
  FROM [MEMBER]
  WHERE gender='man'
  GROUP BY addr
  HAVING COUNT(mem_no) >= 50;
  ```


### ORDER BY 절
- `ASC`, `DESC` (ex: `ORDER BY user_name ASC`)


### UNION/INTERSECT/EXCEPT
- `UNION`: 합집합 (중복은 존재하지 않음)
- `INTERSECT`: 교집합 (모든 컬럼 값이 동일)
- `EXCEPT`: 차집합 (앞에꺼에서 뒤에꺼를 제거)
- 예시
  ```sql
  SELECT column_name(s) FROM table1
  UNION
  SELECT column_name(s) FROM table2;
  ```

---

# 서브 쿼리 (Sub-query) 예제

- 문제: [MEMBER] 테이블에서 gender='man'인 회원의 모든 주문 내역을 [ORDER] 테이블에서 조회하여라.
  ```sql
  SELECT *
  FROM [ORDER]
  WHERE mem_no IN (SELECT mem_no
    FROM [MEMBER]
    WHERE gender='man');
  ```

- 문제: 수학 과목을 수강하는 학생들의 점수를 조회하여라.
  ```sql
  SELECT 학생이름, 수학점수
  FROM (SELECT 학생.학생이름 AS 학생이름,
               과목.과목점수 AS 수학점수
        FROM 학생, 과목 
        WHERE 학생.학생이름 = 과목.학생이름 AND 과목.과목이름 = '수학');
  ```

- 문제: 수학 과목을 수강하는 학생들의 모든 정보를 조회하여라.
  ```sql
  SELECT *
  FROM 학생
  WHERE 학생.학생이름 IN (SELECT 과목.학생이름 FROM 과목 WHERE 과목.과목이름='수학');
  ```

- 문제: 사원들의 평균 급여보다 더 많은 급여를 받는 사원을 검색하여라.
  ```sql
  SELECT NAME, SALARY
  FROM EMPLOYEE
  WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
  ```

- 문제: 30번 부서에서 급여를 가장 많이 받는 사원보다 전체 부서 사원 중 더 많은 급여를 받는 사원의 이름과 급여를 출력하시오.
  - 답안1
    ```sql
    SELECT NAME, SALARY
    FROM EMPLOYEE
    WHERE SALARY > (SELECT MAX(SALARY)
                    FROM EMPLOYEE
                    WHERE DEPT_NO=30);
    ```
  - 답안2
    ```sql
    SELECT NAME, SALARY
    FROM EMPLOYEE
    WHERE SALARY > ALL (SELECT SALARY
                        FROM EMPLOYEE
                        WHERE DEPT_NO=30);
    ```

- 문제: MANAGER 직급의 사원들 중 DEPT_HISTORY 테이블에 정보가 있는 사원들의 사원번호, 이름, 부서 번호를 출력하시오.
  ```sql
  SELECT E.EMPNO, E.NAME, E.DEPTNO
  FROM EMPLOYEE E
  WHERE E.JOB='MANAGER'
    AND EXISTS(SELECT 1
               FROM DEPT_HISTORY D 
               WHERE E.EMPNO=D.EMPNO);
  ```
  
 