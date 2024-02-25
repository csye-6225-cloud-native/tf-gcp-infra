#!/bin/bash

cat <<EOF > /home/csye6225/webapp.env
SPRING_DATASOURCE_URL=jdbc:postgresql://${db_hostname}:5432/${db_name}
SPRING_DATASOURCE_USERNAME=${db_username}
SPRING_DATASOURCE_PASSWORD=${db_password}
EOF
