USE 365_database;

DROP VIEW IF EXISTS purchases_info;

CREATE VIEW purchases_info AS
    SELECT 
        purchase_id,
        student_id,
        purchase_type,
        date_purchased AS date_start,
        CASE
            WHEN
                purchase_type = 'Monthly'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) MONTH)
            WHEN
                purchase_type = 'Quarterly'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) + 2 MONTH)
            WHEN
                purchase_type = 'Annual'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) + 11 MONTH)
        END AS date_end
    FROM
        365_student_purchases;