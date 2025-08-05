-- Welcome to spotify data analysis project--

CREATE TABLE spotify(
	Artist VARCHAR(50),
	Track VARCHAR(255),
	Album VARCHAR(255),
	Album_type VARCHAR(50),
	Danceability FLOAT,
	Energy FLOAT,
	Loudness FLOAT,
	Speechiness FLOAT,
	Acousticness FLOAT,
	Instrumentalness FLOAT,
	Liveness FLOAT,
	Valence FLOAT,
	Tempo FLOAT,
	Duration_min FLOAT,
	Title VARCHAR(255),
	Channel VARCHAR(250),
	Views BIGINT,
	Likes BIGINT,
	Comments BIGINT,
	Licensed BOOLEAN,
	official_video BOOLEAN,	
	Stream BIGINT,
	nergyLiveness FLOAT,
	most_playedon VARCHAR(50)
);

-- Now we import values into table


-- ## Analysis question --

-- ### Easy Level
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
-- 2. List all albums along with their respective artists.
-- 3. Get the total number of comments for tracks where `licensed = TRUE`.
-- 4. Find all tracks that belong to the album type `single`.
-- 5. Count the total number of tracks by each artist.

-- ### Medium Level
-- 1. Calculate the average danceability of tracks in each album.
-- 2. Find the top 5 tracks with the highest energy values.
-- 3. List all tracks along with their views and likes where `official_video = TRUE`.
-- 4. For each album, calculate the total views of all associated tracks.
-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

-- ### Advanced Level
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
-- 2. Write a query to find tracks where the liveness score is above the average.
-- 3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**



-- Question and answer

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
-- Answer to the question no 1

SELECT
	track
FROM 
	spotify
WHERE
	stream>1000000000

	
-- 2. List all albums along with their respective artists.
-- Answer to the question no 2

SELECT 
	DISTINCT album,
	artist
FROM 
	spotify	
	
-- 3. Get the total number of comments for tracks where `licensed = TRUE`.
-- Answer to the question no 3
SELECT
	SUM(comments) AS total_comments
FROM
	spotify
WHERE
	licensed='true'


-- 4. Find all tracks that belong to the album type `single`.
-- Answer to the question no 4

SELECT 
	track,
	album_type
FROM 
	spotify
WHERE
	album_type='single'

-- 5. Count the total number of tracks by each artist.
-- Answer to the question no 5

SELECT 
	artist,
	COUNT(*)  AS total_tracks
FROM
	spotify
GROUP BY 1
ORDER BY 2 DESC;	
	

-- ### Medium Level
-- 6. Calculate the average danceability of tracks in each album.
-- Answer to the question no 6
SELECT
	album,
	AVG(danceability) as average_dancebility
FROM 
	spotify
GROUP BY 1
ORDER BY 2 DESC

-- 7. Find the top 5 tracks with the highest energy values.
-- Answer to the question no 7
SELECT 
	track,
	energy
FROM
	spotify
ORDER BY 2 DESC

-- 8. List all tracks along with their views and likes where `official_video = TRUE`.
-- Answer to the question no 8
SELECT
	track,
	SUM(views) AS Total_views,
	SUM(likes) AS Total_likes
FROM
	spotify
WHERE
	official_video='true'
GROUP BY 1	

-- 9. For each album, calculate the total views of all associated tracks.
-- Answer to the question no 9
SELECT
	album,
	track,
	SUM(views)
FROM
	spotify
GROUP BY 1,2
ORDER BY 3 DESC

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
-- Answer to the question no 10
SELECT
	track
FROM
	(SELECT
		track,
		COALESCE(SUM(CASE WHEN most_playedon ='Spotify' THEN stream END), 0) AS stream_on_spotify,
	 	COALESCE (SUM(CASE WHEN most_playedon ='Youtube' THEN stream END),0) AS stream_on_youtube
	FROM
		spotify
	GROUP BY 1
) AS t1

WHERE
	stream_on_spotify>stream_on_youtube
	AND
	stream_on_youtube<>0


-- Advanced problem
	
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
-- Answer to the question no 11
WITH ranking_of_views
AS(
SELECT 
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views)) AS rank
FROM
	spotify
GROUP BY 1,2
ORDER BY artist,total_views
)

SELECT
	*
FROM
	ranking_of_views
WHERE 
	rank<=3

-- 12. Write a query to find tracks where the liveness score is above the average.
-- Answer to the question no 12
SELECT
	track,
	liveness
FROM
	spotify
WHERE
	liveness>(SELECT
					AVG(liveness)
				FROM
					spotify)


/*13. Use a `WITH` clause to calculate the difference between the highest and lowest energy values for
tracks in each album.*/
-- Answer to the question no 13
WITH all_difference_min_max
AS(
SELECT
	album,
	MAX(energy) AS max_energy,
	MIN(energy) AS min_energy
FROM
	spotify
GROUP BY 1
)
SELECT
	album,
	ROUND((max_energy - min_energy)::NUMERIC, 2) AS difference_between_highest_and_the_lowest_energy
FROM
all_difference_min_max
ORDER BY 1

-------------------------------END OF THE PROJECT---------------------------------------------------------





