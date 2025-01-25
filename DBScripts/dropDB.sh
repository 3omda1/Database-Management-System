#!/bin/bash 
printFn "   Drop Datebase   "
printFn "Avilable Databases: " "ls ./databases"

read -p "Which DB you want to drop : " dbname
if isValidName $dbname
then
    if [ -d  ./databases/$dbname ]
    then
        printInfo "Are you sure you want to delete $dbname"
        select choice in 'y' 'n'
            do 
                case $choice in
                'y') 
                    rm -r ./databases/$dbname
                    sleep .7
                    printInfo "\"$dbname\" dropped successfully"
                    menuMessage
                    read answer
                    menuBack $answer
                    echo -n "drop Db .."
                    
                    # . ./DBScripts/dropDB.sh Dalia

                    break
                    ;;
                'n') 
                    menuMessage
                    read answer
                    menuBack $answer
                    echo -n "Deleting Another Db .."
                    
                    # . ./DBScripts/dropDB.sh  Dalia           
                    break
                    ;;
                *)  
                    printInfo "Choose Valid Option"
                    ;;
                esac
                done
    else
        printInfo "\"$dbname\" Doesn't exist!"
        menuMessage
        read answer
        menuBack $answer
        echo -n "Deleting Another DB .."
        
        # . ./DBScripts/dropDB.sh Dalia
    fi
else
    menuMessage
    read answer
    menuBack $answer
    echo -n "Deleting Another DB .."
    
    # . ./DBScripts/dropDB.sh Dalia
fi


