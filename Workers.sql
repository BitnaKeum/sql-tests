-- Testdome Workers 문제
-- https://www.testdome.com/questions/sql/workers/102293

SELECT A.name
FROM employees A
  LEFT JOIN
  (SELECT managerId FROM employees) B
  ON A.id=B.managerId
WHERE B.managerId IS NULL;