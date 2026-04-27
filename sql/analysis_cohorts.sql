WITH user_first_activity AS (
    SELECT
        user_id,
        MIN(event_timestamp::date) AS first_activity_date,
        DATE_TRUNC('month', MIN(event_timestamp)) AS cohort_month
    FROM events
    GROUP BY user_id
),

user_monthly_activity AS (
    SELECT
        user_id,
        DATE_TRUNC('month', event_timestamp) AS activity_month,
        COUNT(*) AS events_count
    FROM events
    GROUP BY user_id, DATE_TRUNC('month', event_timestamp)
),

cohort_data AS (
    SELECT
        fa.user_id,
        fa.cohort_month,
        ma.activity_month,

        -- різниця в місяцях (ключ для cohort analysis)
        (
            EXTRACT(YEAR FROM ma.activity_month) - EXTRACT(YEAR FROM fa.cohort_month)
        ) * 12 +
        (
            EXTRACT(MONTH FROM ma.activity_month) - EXTRACT(MONTH FROM fa.cohort_month)
        ) AS cohort_index,

        ma.events_count

    FROM user_first_activity fa
    JOIN user_monthly_activity ma
        ON fa.user_id = ma.user_id
)

SELECT
    user_id,
    cohort_month,
    activity_month,
    cohort_index,
    events_count

FROM cohort_data
ORDER BY cohort_month, cohort_index DESC;