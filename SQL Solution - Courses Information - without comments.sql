USE 365_database;

WITH title_total_minutes AS
(
SELECT 
    course_id, 
    course_title, 
    round(sum(minutes_watched), 2) as total_minutes_watched, 
    count(distinct student_id) as num_students
FROM
    365_course_info
        JOIN
    365_student_learning USING (course_id)
GROUP BY course_id
),

title_average_minutes AS
(
SELECT 
    m.course_id,
    m.course_title,
    m.total_minutes_watched,
    round(m.total_minutes_watched/m.num_students, 2) as average_minutes
    FROM
title_total_minutes m
),

title_ratings AS
(
SELECT 
    a.*,
    COUNT(course_rating) AS number_of_ratings,
    IF(COUNT(course_rating) != 0, SUM(course_rating) / COUNT(course_rating), 0) AS average_rating
FROM
    title_average_minutes a
        LEFT JOIN
    365_course_ratings r USING (course_id)
GROUP BY course_id
)

SELECT 
    *
FROM
    title_ratings;