#!/bin/bash

original_sql="db/words.sql"

new_line="SET client_encoding = 'UTF8';"

echo $new_line > temp_sql

cat $original_sql >> temp_sql

mv temp_sql db/

echo "postgres script updated"
