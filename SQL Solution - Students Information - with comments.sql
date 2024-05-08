USE 365_database;

-- Begin main query to retrieve student data with related metrics
SELECT 
    student_id,
    student_country,
    date_registered,
    date_watched,
    minutes_watched,
    onboarded,
    -- Determine if the student had a paid membership on a specific date
    MAX(paid) AS paid
FROM
    ( -- Sub-query to check if the date the student watched falls between the payment start and end dates
    SELECT 
        a.*,
		IF(date_watched BETWEEN p.date_start AND p.date_end, 1, 0) AS paid
    FROM
        ( -- Sub-query to aggregate the minutes watched by student and date_watched; Determine if a student has onboarded or not
        SELECT 
        i.*,
            l.date_watched,
            
            -- If no watch date, set minutes to 0, else sum the minutes watched and round to two decimal places
            IF(l.student_id IS NULL, 0, ROUND(SUM(l.minutes_watched), 2)) AS minutes_watched,
            
            -- Determine if the student has onboarded (1 for onboarded, 0 for not onboarded)
            IF(l.student_id IS NULL, 0, 1) AS onboarded
    FROM
        365_student_info i
	-- Left join on student learning data to include all students, even if they didn't have learning data
    LEFT JOIN 365_student_learning l USING (student_id)
    GROUP BY student_id , date_watched) a
    
    -- Left join with purchases_info to associate payment details with students
    LEFT JOIN purchases_info p USING (student_id)) b
    
-- Group results by individual student and the date they watched content
GROUP BY student_id , date_watched;
