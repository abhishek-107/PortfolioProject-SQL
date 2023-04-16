-- Finding the 10 best selling video games.

SELECT TOP 10 * 
FROM game_sales$
ORDER BY Total_Shipped DESC

-- Finding the missing review scores.

SELECT COUNT(G.Name)
FROM game_sales$ AS G
LEFT JOIN game_reviews$ AS R
ON G.Name = R.Name
WHERE critic_score IS NULL
AND user_score IS NULL

-- Finding the years that video game critics loved.

SELECT TOP 10 g.Year, ROUND(AVG(r.critic_score), 2) AS avg_critic_score
FROM game_sales$ g
INNER JOIN game_reviews$ r
ON g.Name = r.Name
GROUP BY g.Year
ORDER BY avg_critic_score DESC

-- Finding if 1982 was really great?

SELECT TOP 10 g.year, ROUND(AVG(r.critic_score), 2) AS avg_critic_score, COUNT(g.Name) AS num_games
FROM game_sales$ g
INNER JOIN game_reviews$ r
ON g.Name = r.Name
GROUP BY g.year
HAVING COUNT(g.Name) > 4
ORDER BY avg_critic_score DESC

-- Finding the years that dropped off the critics favourites list.

SELECT year, avg_critic_score
FROM top_critic_scores$
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_scores_more_than_fou$
ORDER BY avg_critic_score DESC

-- Finding the years video game players loved.

SELECT TOP 10 g.year, COUNT(g.Name) AS num_games, ROUND(AVG(r.user_score), 2) AS avg_user_score
FROM game_sales$ g
INNER JOIN game_reviews$ r
ON g.Name = r.Name
GROUP BY g.year
HAVING COUNT(g.Name) > 4
ORDER BY avg_user_score DESC

-- Finding the years that both players and critics loved

SELECT year
FROM top_critic_scores_more_than_fou$
INTERSECT
SELECT year
FROM top_user_scores_more_than_four_$;

-- Finding the sales in the best video game years.

SELECT g.year, SUM(g.Total_Shipped) AS total_games_sold
FROM game_sales$ g
WHERE g.year IN (SELECT year
FROM top_critic_scores_more_than_fou$
INTERSECT
SELECT year
FROM top_user_scores_more_than_four_$
)
GROUP BY g.year
ORDER BY total_games_sold DESC;
