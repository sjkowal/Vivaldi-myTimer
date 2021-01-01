#!/bin/bash

echo "create user '$1'@'%';"|mysql --user=root --password=secret
cat vivaldi.sql|mysql --user=$1 
