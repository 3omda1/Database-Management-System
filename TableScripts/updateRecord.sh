function checkUpdate
{
    ##############################################
    ## check data type of new value
    read -p "Enter new value for (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
    
    if [ "$newValue" ]
    then
        echo "nothin">> /dev/null
        #nothing
    else 
        printInfo "please enter a valid value"
        checkUpdate
    fi

    
    if [ ${coloumnsTypes[coloumnIndex]} == "int" ]
        then
        checkInt $newValue
        if [ $? != 0 ]
        then
            printInfo "Please enter a valid value"
            printInfo "Enter only numbers"
            checkUpdate
        fi
    fi
    ####################
    ## check if he update pk

    if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
    then
        checkPK $coloumnIndex "$newValue"
        while [ $? != 0 ]
        do
            printInfo "Violation of PK constraint"
            printInfo "Please enter a valid value"
            checkUpdate
        done
    fi
}

function checkCondition
{
    
    #####################################
    ## check data type of condition value
    read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
    
    if [ "$conditionValue" ]
    then
        echo "nothin">> /dev/null
        #nothing
    else 
        printInfo "please enter a valid value"
        checkCondition
    fi

    
    if [ ${coloumnsTypes[conditionIndex]} == "int" ]
        then
        checkInt $conditionValue
        if [ $? != 0 ]
        then
            printInfo "Please enter a valid value"
            printInfo "Enter only numbers"
            checkCondition
        fi
    fi
}




printInfo "\nConnected to \"$dbname\""
printFn "   Updating Table   "
printFn "Available tables: " "ls -1 ./databases/$dbname"

echo -e -n "\n${bold}Enter table name: ${normal}"
read tableName

if [ $tableName ]
then
    if [ -a ./databases/$dbname/$tableName ]
    then
    clear
    printFn "   Updating Table $tableName   "
    coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`
       
        ## to read all column names and data types
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            #######################    
            ## this if condition because cut in case of pk is different
            if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            else
                coloumnsNames[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                coloumnsTypes[$i]=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            fi
        done
        
        echo "table columns are : "
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done
        

        ###############################################
        ## get index of the coloumn he wanted to update
        read -p "Enter column number you want to update : " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 || $coloumnIndex -gt $coloumnsNomber ]]
        do
            printInfo "Please enter a valid value"
            printInfo "Ener value in between 1 and $coloumnsNomber"
            read -p "Enter column number you want to update : " coloumnIndex 
            checkInt $coloumnIndex
        done 

        checkUpdate

        ################################
        ## read condition   
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done

        ############################
        ## check if condition index is a number 
        read -p "condition on which coloumn number : " conditionIndex 
        checkInt $conditionIndex
        while [[ $? -ne 0 || $conditionIndex -le 0 || $conditionIndex -gt $coloumnsNomber ]]
        do
            printInfo "Please enter a valid value"
            printInfo "ener value in between 1 and $coloumnsNomber"
            read -p "condition on which coloumn number : " conditionIndex 
            checkInt $conditionIndex
        done 


        checkCondition
        ############################### ci=2 && cvalue=hsn >>> $2==hsn && 3=>23 >>>> $3=23
        ## to update table 
        awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'"${conditionValue}"'" ) {$"'$coloumnIndex'"="'"${newValue}"'"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./databases/$dbname/$tableName > ./.tmp1;
        

        #####################################
        ## to prevent update if it violate pk
        if testPK=`grep "%:" ./databases/$dbname/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then 
            x=`cat ./.tmp1 | cut -f$coloumnIndex -d:| grep -w "$newValue"|wc -l | cut -f1 -d" "`
            if [ $x -gt 1 ]
            then
                printInfo "Update fail due to PK constraint violation"
                 rm ./.tmp1;
            fi   
        fi
        
        if [ -a ./.tmp1 ]
        then
            cat ./.tmp1 > ./databases/$dbname/$tableName;
            rm ./.tmp1;
            printInfo "Update successfull"
        fi
    else
        printInfo "Table \"$tableName\" doesn't exist"
    fi
else
    printInfo "Invalid input please enter a valid name"
fi

##route 

routeFromTable updateRecord.sh "Update table .."
