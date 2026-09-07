{% macro make_bool(column, term) %}

case
    when lower({{ column }}) LIKE '%{{ term | lower }}%' THEN TRUE
    else false
end

{% endmacro %}