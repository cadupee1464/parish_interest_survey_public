with unique_ministries as (
    select distinct ministry
    from {{ ref('int_unpivot')}}
)

select
    {{ dbt_utils.generate_surrogate_key(['ministry']) }} as ministry_id,
    ministry
from unique_ministries