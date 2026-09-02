with responses as (
select
    response_id,
    full_name,
    in_parish_directory,
    phone_number,
    submitted_at
from 
    {{ ref('stg_interest_survey')  }}
)

select *
from responses