#!/bin/bash 
printInfo "\nConnected to \"$dbname\""
printFn "   Drop Table   "
printFn "avilable tables are : " "ls -1 ./databases/$dbname"

read -p "Table name you want to drop : " tableName

if [ $tableName ]
then
    if [ -f  ./databases/$dbname/$tableName ]
    then
        printInfo "Are you sure you want to delete \"$tableName\""
        select choice in 'y' 'n'
            do 
                case $choice in
                'y') 
                    rm ./databases/$dbname/$tableName
                    printInfo "Table \"$tableName\" deleted Successfully"
                    break
                    ;;
                'n') 
                    break
                    ;;
                *) printInfo "Choose Valid Option" ;;
                esac
                done
    else
        printInfo "\"$tableName\" doesn't exist!"
    fi
else
    printInfo "invalid input please enter a valid name"
fi    

routeFromTable dropTable.sh "Drop table .."


