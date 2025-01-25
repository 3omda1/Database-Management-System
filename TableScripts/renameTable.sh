#!/bin/bash 
printInfo "\nConnected to \"$dbname\""
printFn "   Rename Table   "
printFn "avilable tables are : " "ls -1 ./databases/$dbname"
read -p "Enter table name you want to rename : " tableName

if [ $tableName ]
then
    if [ -a  ./databases/$dbname/"$tableName" ]
    then
        read -p "Enter the new name : " newName
        if [ -a  ./databases/$dbname/"$newName" ]
        then
            printInfo "tbale with the name \"$newName\" exists"
        else
        mv  ./databases/$dbname/"$tableName"  ./databases/$dbname/"$newName"
        printInfo "Table \"$tableName\" changed to \"$newName\""
        fi
    else
        printInfo "\"$tableName\" Doesn't exist"
    fi
else
  printInfo "invalid input please enter a valid name"
fi


routeFromTable renameTable.sh "Rename table .."


