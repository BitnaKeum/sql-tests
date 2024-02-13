-- Testdome Pets 문제
-- https://www.testdome.com/questions/sql/pets/102268

SELECT DISTINCT name
FROM (SELECT name FROM dogs 
      UNION
      SELECT name FROM cats);