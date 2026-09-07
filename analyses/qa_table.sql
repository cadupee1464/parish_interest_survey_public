with qa_checks as (
    select
        'response_count' as metric,
        count(*) as observed_value,
        45 as expected_value
    from {{ ref('stg_interest_survey')  }}

    union all

    select
        'distinct_respondents',
        count(distinct response_id),
        45
    from {{ ref('dim_responses')  }}

    union all

    select
        'distinct_ministries',
        count(distinct ministry_id),
        15
    from {{ ref('dim_ministry')  }}

    union all

    select
        'duplicate_response_ministry_pairs',
        count(*) - count(distinct concat(response_id, '-', ministry_id)),
        0
    from {{  ref('fact_interest')  }}

    union all

    select
        'null_fact_foreign_keys',
        count(*),
        0
    from {{ ref('fact_interest')  }}
    where (response_id is null) or (ministry_id is null) 

)

select 
    *,
    CASE 
        WHEN observed_value = expected_value THEN 'Pass'
        ELSE 'Review'
    END AS qa_status
from qa_checks