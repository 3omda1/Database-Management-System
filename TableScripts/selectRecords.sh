#!/bin/bash
function printTable
{
   cat $1 | expand |awk 'length($0) > length(longest) { longest = $0 } { lines[NR] = $0 } END { gsub(/./, "=", longest); print "+=" longest "=\+"; n = length(longest); for(i = 1; i <= NR; ++i) { printf("| %s %*s\n", lines[i], n - length(lines[i]) + 1, "|"); } print "+\=" longest "=+" }' 2> .tmp;
}
#########################
## Function for select script
function readConditionForSelect {
        
        ############################
        ## to show avilable columns
        echo "table columns are : "
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
            printInfo "please enter a valid value"
            read -p "condition on which coloumn number : " conditionIndex 
            checkInt $conditionIndex
        done 


        ##############################################
        ## check data type of condition value
        read -p "Enter a condition value of type (${coloumnsTypes[conditionIndex]}) : " conditionValue;
        if [ ${coloumnsTypes[conditionIndex]} == "int" ]
            then
            checkInt $conditionValue
            while [ $? != 0 ]
            do
                printInfo "please enter a valid value"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                checkInt $conditionValue
            done
        fi
        if [ $firstCondition == "true" ]
        then
            firstCondition="false"
            awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'"${conditionValue}"'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> .tmp1
        else
            cp ./.tmp1 ./.tmp2
            awk -F:  ' ( NR==1 || $"'$conditionIndex'"=="'"${conditionValue}"'" ) {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' .tmp2 > .tmp1
            rm ./.tmp2
        fi        
        echo "do you want use another condition?"
        loopBackOrNot
}

function loopBackOrNot {
    select option in "yes" "no"
    do 
	case $option in
		"yes" )
			readConditionForSelect
            break
			;;
        "no" )
            break
			;;
        * )
            printInfo "invalid choice"
            loopBackOrNot
            break
            ;;     
	esac
    done
}
#########################
#Start script
printInfo "\nConnected to \"$dbname\""
printFn "   Selecting Data from Table   "
printFn "Avilable tables: " "ls -1 ./databases/$dbname"

read -p "Enter table name to select from: " tableName

if [ $tableName ]
then
    if [ -a ./databases/$dbname/$tableName ]
        then
        coloumnsNomber=`awk -F: 'NR==1 {print NF}' ./databases/$dbname/$tableName`
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            #######################      name%string%
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

        ## to show header for table
        for (( i=1; i <= $coloumnsNomber; i++ ))
        do
            if [ $i -eq $coloumnsNomber ]
            then
                echo ${coloumnsNames[i]} >> ./.tmp1
            else
                echo -n ${coloumnsNames[i]}":" >> ./.tmp1
            fi
        done

        echo "Do you want to use conditions?"
        firstCondition="true"
        select option in "yes" "no"
        do 
        case $option in
            "yes" )
                readConditionForSelect
                break
                ;;
            "no" )
                awk -F:  ' NR!=1 {{for(i=1 ;i<=NF ;i++ ) {if (i==NF) print $i; else printf "%s",$i":"}}}' ./databases/$dbname/$tableName >> ./.tmp1
                break
                ;;
            * )
                printInfo "invalic choice"
                loopBackOrNot
                break
                ;;     
        esac
        done
        
    printFn "   $tableName table   "
    cat ./.tmp1 | column -s ":" -t > .printtmp
    printTable ".printtmp"
    
    x=`cat ./.tmp1 | wc -l | cut -f1 -d" "`
    if [ $x -eq 1 ]
    then
        printInfo " no data for this select command "
    else
        printInfo $(expr $x - 1)" rows was selected "
    fi  
    rm ./.tmp1

    else
        printInfo "there is no such table"
    fi
else
    printInfo "invalid input please enter a valid name"
fi

routeFromTable selectRecords.sh "Select from table .."