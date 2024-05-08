USE 365_database;

SELECT 
    student_id,
    student_country,
    date_registered,
    date_watched,
    minutes_watched,
    onboarded,
    MAX(paid) AS paid
FROM
    (SELECT 
        a.*,
		IF(date_watched BETWEEN p.date_start AND p.date_end, 1, 0) AS paid
    FROM
        (SELECT 
        i.*,
            l.date_watched,
            IF(l.student_id IS NULL, 0, ROUND(SUM(l.minutes_watched), 2)) AS minutes_watched,
            IF(l.student_id IS NULL, 0, 1) AS onboarded
    FROM
        365_student_info i
    LEFT JOIN 365_student_learning l USING (student_id)
    GROUP BY student_id , date_watched) a
    LEFT JOIN purchases_info p USING (student_id)) b
GROUP BY student_id , date_watched;