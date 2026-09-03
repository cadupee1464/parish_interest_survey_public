with interests as (
    select *
    from {{ ref('fact_interest') }}
)
,
responses as (
    select
        response_id,
        full_name,
        in_parish_directory,
        phone_number
    from {{ ref('dim_responses') }}
)
,
ministries as (
    select *
    from {{ ref('dim_ministry') }}
)

select
    r.full_name,
    r.in_parish_directory,
    coalesce(r.phone_number, '') as phone_number,
    m.ministry
from interests as i
inner join responses as r 
    on r.response_id = i.response_id
inner join ministries as m
    on m.ministry_id = i.ministry_id
