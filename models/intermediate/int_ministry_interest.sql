{{ config(
    materialized = 'ephemeral'
)
}}

with boolean_ministry as (
    select 
        response_id,
        submitted_at,
        full_name,
        in_parish_directory,
        phone_number,
        {{ make_bool('on_meal_team', 'yes') }} as on_meal_team,
        {{ make_bool('ministry_interest','building') }} as building_committee_interest,
        {{ make_bool('ministry_interest','burial') }} as burial_society_interest,
        {{ make_bool('ministry_interest','community') }} as community_outreach_interest,
        {{ make_bool('ministry_interest','choir') }} as choir_interest,
        {{ make_bool('ministry_interest','events') }} as events_interest,
        {{ make_bool('ministry_interest','facilities') }} as facilities_interest,
        {{ make_bool('ministry_interest','flower') }} as flower_ministry_interest,
        {{ make_bool('ministry_interest','saint') }} as spy_interest,
        {{ make_bool('ministry_interest','homebound') }} as homebound_interest,
        {{ make_bool('ministry_interest','liturgical') }} as liturgical_ministry_interest,
        {{ make_bool('ministry_interest','programs') }} as programs_and_fundraising_interest,
        {{ make_bool('ministry_interest','orthodox') }} as orthodox_school_interest,
        {{ make_bool('ministry_interest','security') }} as security_interest,
        {{ make_bool('ministry_interest','welcome') }} as welcome_booth_interest,
        {{ make_bool('ministry_interest','media') }} as media_communications_interest
    from {{ ref('stg_interest_survey') }}
)

select * from boolean_ministry