-- Use a Common Table Expression to join tables A and B with the MAP table
WITH C AS (
  SELECT A.dimension_1, M.correct_dimension_2 AS dimension_2, A.measure_1, B.measure_2
  FROM A
  JOIN MAP M ON A.dimension_1 = M.dimension_1
  LEFT JOIN B ON A.dimension_1 = B.dimension_1
  UNION 
  SELECT B.dimension_1, M.correct_dimension_2 AS dimension_2, A.measure_1, B.measure_2
  FROM B
  JOIN MAP M ON B.dimension_1 = M.dimension_1 
  LEFT JOIN A ON B.dimension_1 = A.dimension_1
)

-- Aggregate measure_1 and measure_2 for distinct pairs of dimension_1 and dimension_2
-- Replace NULL values with 0
SELECT dimension_1, dimension_2, SUM(COALESCE(measure_1, 0)) AS measure_1, SUM(COALESCE(measure_2, 0)) AS measure_2
FROM C
GROUP BY dimension_1, dimension_2;
