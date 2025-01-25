function checkPkInsert
{
        read -p "enter ($fieldName) of type ($fieldType) : " value
        ############################
        ## check empty
        if [ "$value" ]
        then
            echo "nothin">> /dev/null
            #nothing
        else 
            printInfo "please enter a valid value"
            checkPkInsert
        fi
        
        ###########################
        ## check data type
        if [ $fieldType == "int" ]
            then
           # checkInt "$value"
            if [ $? != 0 ]
            then
            printInfo "please enter a valid value"
            checkPkInsert
            fi
        fi

        ############################
        ## check PK constraint
        checkPK $i "$value"
        if [ $? != 0 ]
        then
            printInfo "Violation of PK constraint"
            printInfo "please enter a valid value"
            checkPkInsert
        fi
}

function checkNormalInsert
{
        read -p "enter ($fieldName) of type ($fieldType) : " value
        ############################
        ## check empty
        if [ "$value" ]
        then
            echo "nothin">> /dev/null
            #nothing
        else 
            printInfo "please enter a valid value"
            checkNormalInsert
        fi
        
        ###########################
        ## check data type
        if [ $fieldType == "int" ]
            then
           # checkInt "$value"
            if [ $? != 0 ]
            then
            printInfo "please enter a valid value"
            checkNormalInsert
            fi
        fi
}





printInfo "\nConnected to \"$dbname\""
printFn "   Insert Record   "
printFn "avilable tables: " "ls -1 ./databases/$dbname"

read -p "please enter table name : " tableName

if [ $tableName ]
then
    if [ -a ./databases/$dbname/$tableName ]
        then
        coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`

        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            ##############################
            ## inserting primary key field
            if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
                then 
                fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                fieldType=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
                printInfo "this is primary key it must be uniqe"
                
                checkPkInsert
                insertField "$value"


            #########################    
            ## inserting normal field
            else
                fieldName=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                fieldType=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
                
                checkNormalInsert
                insertField "$value"
            fi
        done
    else
        printInfo "Table \"$tableName\" doesn't exist"
    fi
else
    printInfo "Invalid input please enter a valid name"
fi

routeFromTable insertRecord.sh "Insert record .."
