#!/bin/bash
printInfo "\nConnected to \"$dbname\""
printFn "   Creating Table   "
printFn "Already existing tables: " "ls -1 ./databases/$dbname"

read -p "Enter table name you want to create : " tableName
## this variable is to check PK 
NoPK_Yet="true"

if [ $tableName ]
then
    if [ -a  ./databases/$dbname/"$tableName" ]
        then
        printInfo "Table with name \"$tableName\" already exists"    
    else
        touch ./databases/$dbname/.tmptable/"$tableName" 
        read -p "Enter number of coloumns : " coloumnsNomber

        ############################################
        ## to check if number of coloumns is int
        until [ $coloumnsNomber ]
        do
            printInfo "Please enter a valid number"
            read -p "Enter number of coloumns : " coloumnsNomber
        done

        ############################################
        ## to check if number of coloumns is int
        expr $coloumnsNomber + 1 2> /dev/null >> /dev/null
        while [ $? != 0 ]
        do
            printInfo "Please enter a valid number"
            read -p "Enter number of coloumns : " coloumnsNomber
            expr $coloumnsNomber + 1 2> /dev/null >> /dev/null
        done
        ############################################
        ## now read colomn type and names
        i=1
        while [ $i -le $coloumnsNomber ]
        do
            
            ########################
            ## gen name of field
            read -p "Enter column $i name : " coloumnsName;
            while [ -z "$coloumnsName" ]; do
                printInfo "Field name can't be empty";
                read -p "Enter column $i name : " coloumnsName;
            done
            ########################

            ##############################
            ## check if field is PK or not
            while [ $NoPK_Yet == "true" ]
            do         
                echo "is this feild a primary key?"
                select answer in "y" "n"
                do
                    case $answer in
                    "y" )
                        echo -n "%PK%" >> ./databases/$dbname/.tmptable/$tableName
                        NoPK_Yet="false"
                        break
                        ;;
                    "n" )
                        break 
                        ;; 
                    * )
                        printInfo "Please choose a valid option [use 1 or 2 ]"
                        ;;
                    esac
                done 
                break
            done
            ##############################


            ########################
            ## get datatype of field
            read -p "Enter a valid column $i datatype : [string/int] " dataType;
            while [[ "$dataType" != *(int)*(string) || -z $dataType ]]
            do
                printInfo "Invalid datatype"
                read -p "Enter a valid column $i datatype again : [string/int] " dataType;
            done
            ##############

            ########################################
            ## write in the table file; check to stop adding ":" in the last field
            if [ $i -eq $coloumnsNomber ]
                then
                echo $coloumnsName"%"$dataType"%" >> ./databases/$dbname/.tmptable/$tableName
            else
                echo -n $coloumnsName"%"$dataType"%:" >> ./databases/$dbname/.tmptable/$tableName
            fi
            ##############################
            ((i=$i+1))

        done
        
        mv ./databases/$dbname/.tmptable/$tableName ./databases/$dbname/$tableName
        printInfo "\nTable created successfully"    
    fi
else
    printInfo "invalid input please enter a valid name"
fi

routeFromTable createTable.sh "Create table .."
