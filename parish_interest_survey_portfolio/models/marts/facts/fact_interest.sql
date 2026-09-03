with positive_interested as (
    select 
    response_id,
    ministry
    from {{ ref('int_unpivot') }}
    where interested = true
)
,
responses as (
    select 
    response_id
    from {{ ref('dim_responses') }}
)
,
ministries as (
    select
        ministry,
        ministry_id
    from {{ ref('dim_ministry') }}
)

select
    r.response_id,
    m.ministry_id
from 
    positive_interested as t_i
inner join responses as r on r.response_id = t_i.response_id
inner join ministries as m on m.ministry = t_i.ministry