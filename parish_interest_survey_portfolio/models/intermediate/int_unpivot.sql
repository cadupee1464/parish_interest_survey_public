with pivoted_ministries as (
    select
        response_id,
        building_committee_interest,
        burial_society_interest,
        community_outreach_interest,
        choir_interest,
        events_interest,
        facilities_interest,
        flower_ministry_interest,
        spy_interest,
        homebound_interest,
        liturgical_ministry_interest,
        programs_and_fundraising_interest,
        orthodox_school_interest,
        security_interest,
        welcome_booth_interest,
        media_communications_interest
    from {{ ref('int_ministry_interest')  }}
)

select
    response_id,
    ministry,
    interested
from pivoted_ministries
unpivot (
    interested for ministry in (
        building_committee_interest as 'Building Committee',
        burial_society_interest as 'Burial Society',
        community_outreach_interest as 'Community Outreach',
        choir_interest as 'Choir',
        events_interest as 'Events',
        facilities_interest as 'Facilities & Groundskeeping',
        flower_ministry_interest as 'Flower Ministry',
        spy_interest as 'Youth Ministry',
        homebound_interest as 'Homebound Ministries',
        liturgical_ministry_interest as 'Liturgical Ministry',
        programs_and_fundraising_interest as 'Programs and Fundraising',
        orthodox_school_interest as 'Orthodox School',
        security_interest as 'Security',
        welcome_booth_interest as 'Welcome Booth',
        media_communications_interest as 'Media & Communications'
    )
)
