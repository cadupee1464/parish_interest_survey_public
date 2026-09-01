with source as (
 select * 
 from {{ source('parish_interest_survey', 
 'anonymized_parish_interest_survey_raw')  }}   
),

renamed as(
    select
        `Timestamp` as submitted_at,
        respondent_name as full_name,
        parish_directory_status as in_parish_directory,
        phone_number,
        on_meal_team,
        ministry_interest,
        alt_ministry_interest,
        professional_skills,
        ministry_wish_list
    from source
)

select
    {{ dbt_utils.generate_surrogate_key(['submitted_at', 'full_name']) }} as response_id,
    submitted_at,
    full_name,
    in_parish_directory,
    phone_number,
    on_meal_team,
    ministry_interest,
    alt_ministry_interest,
    professional_skills,
    ministry_wish_list
from renamed
