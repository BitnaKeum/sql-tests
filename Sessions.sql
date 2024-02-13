-- Testdome Sessions 문제
-- https://www.testdome.com/questions/sql/sessions/102292

SELECT userId UserId, AVG(duration) AverageDuration
FROM sessions
GROUP BY userId
HAVING COUNT(userId) > 1;