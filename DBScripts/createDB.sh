#!/bin/bash

echo "===================================="

read -p "Enter new DB name? " dbname

if [ -d ./databases/$dbname  ]
		then
		echo "DB with the name \"$dbname\" already exists"
		
else
		mkdir ./databases/$dbname
		mkdir ./databases/$dbname/.tmptable
		sleep .3
		echo -n "creating a new Db .. "
		echo "\nDB with name \"$dbname\" has been created successfully"

fi



