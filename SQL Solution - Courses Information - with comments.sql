USE 365_database;

-- Create a CTE (Common Table Expression) to calculate the total minutes watched and number of unique students per course
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

-- Create a second CTE to calculate the average minutes watched per student for each course
title_average_minutes AS
(
SELECT 
    m.course_id,
    m.course_title,
    m.total_minutes_watched,
    round(m.total_minutes_watched/m.num_students, 2) as average_minutes
    FROM
title_total_minutes m -- Referencing the first CTE here
),

-- Create a third CTE to add course ratings. For each course, calculate the total number of ratings and their average
title_ratings AS
(
SELECT 
    a.*,
    COUNT(course_rating) AS number_of_ratings,
    
    -- If there are no ratings, set average rating to 0
    IF(COUNT(course_rating) != 0, SUM(course_rating) / COUNT(course_rating), 0) AS average_rating
FROM
    title_average_minutes a -- Referencing the second CTE here
        LEFT JOIN
    365_course_ratings r USING (course_id)
GROUP BY course_id
)

-- Finally, select all fields from the last CTE to get the desired result set
SELECT 
    *
FROM
    title_ratings;