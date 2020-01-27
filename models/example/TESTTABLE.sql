{{
    config(materialized='persistent_table'
        ,retain_previous_version_flg=false
        ,migrate_data_over_flg=false
    )
}}

CREATE OR REPLACE TABLE "{{ database }}"."{{ schema }}"."TESTTABLE" (
ID varchar2 not null,
FIRST_NAME text,
LAST_NAME text,
CONTACT varchar2,    
PRIMARY KEY (ID)
)
