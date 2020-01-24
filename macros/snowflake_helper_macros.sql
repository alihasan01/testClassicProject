/*
    cloning a table relation
*/
{% macro clone_table_relation_if_exists(old_relation ,clone_relation) %}
  {% if old_relation is not none %}
    {{ log("Cloning existing relation " ~ old_relation ~ " as a backup with name " ~ clone_relation) }}
    {% call statement('clone_relation', auto_begin=False) -%}
        CREATE OR REPLACE TABLE {{ clone_relation }}
            CLONE {{ old_relation }}
    {%- endcall %}
  {% endif %}
{% endmacro %}

/*
    Backing up (Copy of) a (transient) table relation
*/
{% macro copyof_table_relation_if_exists(old_relation ,clone_relation) %}
  {% if old_relation is not none %}
    {{ log("Copying of existing relation " ~ old_relation ~ " as a backup with name " ~ clone_relation) }}
    {% call statement('clone_relation', auto_begin=False) -%}
        CREATE OR REPLACE TABLE {{ clone_relation }}
            AS SELECT * FROM {{ old_relation }}
    {%- endcall %}
  {% endif %}
{% endmacro %}

{% macro alter_column_type(relation, column_name, new_column_type) -%}
  {{ return(adapter_macro('alter_column_type', relation, column_name, new_column_type)) }}
{% endmacro %}

{% macro default__alter_column_type(relation, column_name, new_column_type) -%}
  {#
    1. Create a new column (w/ temp name and correct type)
    2. Copy data over to it
    3. Drop the existing column (cascade!)
    4. Rename the new column to existing column
  #}
  {%- set tmp_column = column_name + "__dbt_alter" -%}

  {% call statement('alter_column_type') %}
    alter table {{ relation }} add column {{ tmp_column }} {{ new_column_type }};
    update {{ relation }} set {{ tmp_column }} = {{ column_name }};
    alter table {{ relation }} drop column {{ column_name }} cascade;
    alter table {{ relation }} rename column {{ tmp_column }} to {{ column_name }}
  {% endcall %}

{% endmacro %}

{%- macro create_table_stmt_fromfile(relation, sql) -%}
    {{ log("Creating table abc" ~ relation) }}

    {{ sql }}
    ;

{%- endmacro -%}