USE 365_database;

-- Drop the view 'purchases_info' if it already exists in the database
DROP VIEW IF EXISTS purchases_info;

-- Create a VIEW named 'purchases_info' to display information about student purchases
CREATE VIEW purchases_info AS
    SELECT 
        purchase_id,
        student_id,
        purchase_type,
        date_purchased AS date_start, -- Rename 'date_purchased' to 'date_start' for clarity
        CASE
			-- Determine the 'date_end' based on 'purchase_type' 
            -- If the purchase type is 'Monthly', add one month to 'date_purchased' to get 'date_end'
            WHEN
                purchase_type = 'Monthly'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) MONTH)
                    
			-- If the purchase type is 'Quarterly', add three months to 'date_purchased' to get 'date_end'
            WHEN
                purchase_type = 'Quarterly'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) + 2 MONTH)
                    
			-- If the purchase type is 'Annual', add twelve months to 'date_purchased' to get 'date_end'
            WHEN
                purchase_type = 'Annual'
            THEN
                DATE_ADD(MAKEDATE(YEAR(date_purchased),
                            DAY(date_purchased)),
                    INTERVAL MONTH(date_purchased) + 11 MONTH)
        END AS date_end
    FROM
        365_student_purchases;