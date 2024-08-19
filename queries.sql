-- write your queries here --

-- 1. Join the two tables so that every column and record appears, regardless of if there is not an owner_id .--
SELECT * FROM owners FULL JOIN vehicles ON owners.id = vehicles.owner_id;

-- 2. Count the number of cars for each owner. Display the owners first_name , last_name and count of vehicles. The first_name should be ordered in ascending order. --
SELECT first_name, last_name, vehicle_count FROM owners JOIN (SELECT owner_id, COUNT(*) AS vehicle_count FROM vehicles GROUP BY owner_id) count_tab 
ON owners.id = count_tab.owner_id ORDER BY vehicle_count ASC;

-- 3. Count the number of cars for each owner and display the average price for each of the cars as integers. Display the owners first_name , 
-- last_name, average price and count of vehicles. The first_name should be ordered in descending order. Only display results with more than one vehicle 
-- and an average price greater than 10000. --
SELECT first_name, last_name, ROUND(avg_price), vehicle_count FROM owners JOIN 
    (SELECT owner_id, COUNT(*) AS vehicle_count, AVG(price) AS avg_price FROM vehicles GROUP BY owner_id) ctab 
ON owners.id = ctab.owner_id 
WHERE vehicle_count > 1 AND avg_price > 10000 
ORDER BY first_name DESC;


-- https://sqlzoo.net/wiki/The_JOIN_operation --
-- Q13: List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises. --
-- Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this 
-- column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2. --
WITH alltab AS (
SELECT mdate, id,
  team1,
  CASE WHEN teamid=team1 THEN 1 ELSE 0 END score1,
  team2,
  CASE WHEN teamid=team2 THEN 1 ELSE 0 END score2
  FROM game LEFT JOIN goal ON matchid = id
)

SELECT mdate, team1, SUM(score1) AS score1, team2, SUM(score2) AS score2
FROM alltab
GROUP BY id
ORDER BY mdate, id, team1, team2

-- https://sqlzoo.net/wiki/More_JOIN_operations --
-- Q12: Lead actor in Julie Andrews movies. List the film title and the leading actor for all of the films 'Julie Andrews' played in. --
SELECT title, name FROM movie 
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE movie.id IN
(SELECT movieid FROM casting
JOIN actor ON actor.id = actorid
WHERE name = 'Julie Andrews')
AND ord = 1

-- https://sqlzoo.net/wiki/More_JOIN_operations --
-- Q13: Actors with 15 leading roles. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. --
SELECT name FROM actor 
JOIN (
SELECT actorid, COUNT(*) FROM casting WHERE ord = 1 GROUP BY actorid
HAVING COUNT(*) >= 15
) ctab
ON ctab.actorid = actor.id
ORDER BY name

-- https://sqlzoo.net/wiki/More_JOIN_operations --
-- Q14: released in the year 1978. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, num_actor FROM movie JOIN 
(SELECT movieid, COUNT(*) AS num_actor FROM casting GROUP BY movieid) ctab
ON ctab.movieid = movie.id
WHERE yr = 1978
ORDER BY num_actor DESC, title

-- https://sqlzoo.net/wiki/More_JOIN_operations --
-- Q15: with 'Art Garfunkel'. List all the people who have worked with 'Art Garfunkel'. --
SELECT name FROM actor 
JOIN casting ON casting.actorid = actor.id
WHERE movieid IN
(SELECT movieid from casting
JOIN actor ON actor.id = actorid
WHERE name = 'Art Garfunkel')
AND name != 'Art Garfunkel'