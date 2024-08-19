-- Updating the comment_text of post_id 3
UPDATE Comments 
SET comment_text = 'So Yummy!' 
WHERE post_id = 3;

-- Checking the data
SELECT *
FROM Comments;

-- Selecting all the posts where user_id is 1
SELECT *
FROM Posts
WHERE user_id = 1;

-- Selecting all the posts and ordering them by created_at in descending order
SELECT *
FROM Posts
ORDER BY created_at DESC;

--Counting the number of likes for each post and showing only the posts with more than 2 likes
SELECT post_id, count('like_id') as 'total_likes'
FROM Likes
GROUP BY post_id
HAVING count('like_id') > 2

-- Finding the total number of likes for all posts
SELECT count(*) as 'total_likes_on_all_posts'
FROM Likes;

-- OR
WITH cte as(
	SELECT post_id, count(like_id) as 'total_likes'
	FROM Likes
	GROUP BY post_id
)


SELECT sum(total_likes) as 'number_of_likes'
FROM cte;

-- Finding all the users who have commented on post_id 1
SELECT u.user_id, u.name 
FROM users u
INNER JOIN Comments c
ON u.user_id = c.user_id
WHERE c.post_id = 1

-- Ranking the posts based on the number of likes
WITH cte as(
	SELECT post_id, count(like_id) as 'total_no_of_likes'
	FROM Likes
	GROUP BY post_id
)
SELECT p.post_id, p.caption, c.total_no_of_likes,
DENSE_RANK() OVER(ORDER BY c.total_no_of_likes DESC) as 'rank_by_no_of_likes'
FROM posts p 
INNER JOIN cte c
ON p.post_id = c.post_id

-- Finding all the posts and their comments using a Common Table Expression (CTE)
SELECT p.post_id as 'post_id', c.post_id as 'comment_on_post_id', c.comment_text
FROM Posts p 
INNER JOIN Comments c
ON p.post_id = c.post_id;

-- Categorizing the posts based on the number of likes
WITH cte as(
	SELECT post_id, count(like_id) as 'total_no_of_likes'
	FROM Likes
	GROUP BY post_id
)

SELECT post_id, 
total_no_of_likes,
CASE
	WHEN total_no_of_likes = 0 THEN 'No Likes'
	WHEN total_no_of_likes > 2 THEN 'Good Likes'
	WHEN total_no_of_likes <= 2 THEN 'Few Likes'
	ELSE 'Could not comment!'
END as 'category_on_no_of_likes'
FROM cte

-- Finding all the posts created in the last month
SELECT * 
FROM Posts
WHERE datepart(month,created_at) = (month(CURRENT_TIMESTAMP) - 1) 

-- Which users have liked post_id 2?
SELECT u.user_id, u.name, l.post_id 
FROM Users u 
INNER JOIN Likes l
ON u.user_id = l.user_id
WHERE l.post_id = 2

-- Which posts have no comments? Deleted post_id = 5 to verify the results
SELECT p.post_id, p.caption 
FROM Posts p
LEFT JOIN Comments c
ON p.post_id = c.post_id
WHERE c.post_id is NULL

-- Which posts were created by users who have no followers? Deleted follower_id = 8,7 to verify the results
WITH cte AS(
	SELECT f.follower_user_id, p.user_id
	FROM Followers f
	RIGHT JOIN Posts p
	ON f.follower_user_id = p.user_id
	WHERE f.follower_user_id IS NULL
)
SELECT u.user_id, u.name
FROM Users u
INNER JOIN cte c
ON u.user_id = c.user_id

-- What is the average number of likes per post?
WITH cte AS(
	SELECT post_id, count(like_id) as 'total_no_of_likes'
	FROM Likes
	GROUP BY post_id
)
SELECT post_id, round(avg(total_no_of_likes),2) as 'avg_of_likes'
FROM cte
GROUP BY post_id

-- Which user has the most followers
WITH cte AS(
	SELECT user_id, count(user_id) as 'cnt_user_id' 
	FROM Followers
	GROUP BY user_id
)

SELECT TOP 1 u.name, c.cnt_user_id 
FROM Users u
INNER JOIN cte c
ON u.user_id = c.user_id
ORDER BY c.cnt_user_id DESC










