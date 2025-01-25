#!/bin/bash
## functions for table
function insertField {
      if [ $i -eq $coloumnsNomber ]
                then
                echo $1 >> ./databases/$dbname/$tableName
            else
                echo -n $1":" >> ./databases/$dbname/$tableName
      fi
}

#############################

function checkPK {
   if `cut -f$1 -d: ./databases/$dbname/$tableName | grep -w $2 >> /dev/null 2>/dev/null`
        then
        return 1
    else
        return 0
    fi 
}

#############################
## route from table function 

function routeFromTable
{
echo -e "${bold}Choose option of the following:${normal}"
select answer in "back to preivous menu" "back to main menu" "try again"
do
    case $answer in
    "back to preivous menu"  )
        echo -n "going back .."
        
        afterConnection
        break
        ;;
    "back to main menu"  )
        menuBack y
        break
        ;;    
    "try again" )
       echo -n "$2"
       
       . ./TableScripts/"$1"
        break
        ;; 
    * )
        printInfo "Please choose a valid option [1, 2 or 3]"
        ;;
    esac
done 
}



function afterConnection 
{
    clear
    printInfo "\nConnected to \"$dbname\""
    printFn "Available tables: " "ls -1 ./databases/$dbname"

    rm ./databases/$dbname/.tmptable/* >> /dev/null 2>/dev/null
    echo "===================================="

    select option in "Create table" "Drop table"  "Update table" "Insert record" "Delete from table" "Select from table" "Back to main menu"
    do
        case $option in 
            "Create table" )
                echo -n "Create table .."
                
                . ./TableScripts/createTable.sh
                ;;
            "Drop table" )
                echo -n "Drop table .."
                
                . ./TableScripts/dropTable.sh
                ;;   
            "Update table" )
                echo -n "Update table .."
                
                . ./TableScripts/updateRecord.sh
                ;;
            "Insert record" )
                echo -n "insert into table .."
                
                . ./TableScripts/insertRecord.sh
                ;;
            "Delete from table" )
                echo -n "Delete from table .."
                
                . ./TableScripts/deleteRecord.sh
                ;;
            "Select from table" )
                echo -n "Select from table .."
                
                . ./TableScripts/selectRecords.sh
                ;;
            "Back to main menu" )
                menuBack y
                ;;   
            * )
                printInfo "Please choose valid option"
                ;;
        esac
    done
}

function beforeConnection
{
    clear
    printFn "   Connect to DB   "
    printFn "Available Databases:" "ls -1 ./databases"
    read -p "Enter DB name : " dbname
    if [ -d ./databases/$dbname ]
        then
        echo -n "Connecting to \"$dbname\".."
        
        afterConnection 
    else
        printInfo "\"$dbname\" doesn't exist"
        menuMessage
        read answer
        menuBack $answer
        echo -n "Connecting to another DB .."
         
        . ./DBSelectionMenu.sh
    fi
}

beforeConnection
