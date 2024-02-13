-- Testdome Web Shop 문제
-- https://www.testdome.com/questions/sql/web-shop/102281

SELECT A.name, B.name
FROM items A
  INNER JOIN
  (SELECT id, name FROM sellers WHERE rating>4) B
  ON A.sellerId=B.id;