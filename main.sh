#!/bin/bash

## function to let u back to menu according to yes or no

##		  			Start script	    			##


clear
echo "   Welcome ENG Sherine to our Database system 🤍 🤍 " 
echo  "Developed by Ahmed EmadEldin"

## to create databases if it is not exist ##
if [ -d databases ]
	then
	echo -n ""
else
	echo "This is your first time, Hope you enjoy it"
	mkdir ./databases
fi

PS3="Select one of options : "


function printInfo
{
	echo -e "$1"
}

function menuMessage
{
	echo -e "choose [y] to go back to main menu or choose [n] to try again :"
}


function printFn
{
    echo -e "$1" > .printtmp
    $2 >> .printtmp
	cat .printtmp 2> .tmp;
}

function isValidName
{
	if [[ $1 =~ ^[A-Za-z]+$ ]] 
	then
		#true "valid Name the contain only characters"
		return 0
	else 
		#conatin special char or number
		printInfo "Invalid name"
		printInfo "DB name can't be \"empty\" or cantaining numbers, spaces or special characters"
		return 1 
	fi
}



function menuBack
{
	case $1 in 
		[Yy][Ee][Ss] )	
			echo -n "Back to Main Menu .."
			
			printFn "  DBMS Main Menu   "
			mainMenu
			;;
		[Yy])
			echo -n "Back to Main Menu .."
			
			printFn "   DBMS Main Menu    "
			mainMenu
			;;
		[Nn][Oo] )
			;;
		[Nn] )
			;;
		* )
			printInfo "Not valid input please try again and enter y or n "
			read answer
			menuBack $answer
	esac
}

function mainMenu {
echo "Please select one of the following options"
select option in "Create DB" "Drop DB" "Connect to DB" "List DB" "Exit"
do 
	case $option in
		"Create DB" )
			echo -n "creating a new Db .."
				
			. ./DBScripts/createDB.sh $name
			;;
        "Drop DB" )
			echo -n "Dropping Database .."
			
            . ./DBScripts/dropDB.sh
            ;;
        "Connect to DB" )
			echo -n "Loading Databases .."
			. ./DBSelectionMenu.sh
            ;;
		"List DB" )
		    ls  ./databases
	        ;;
		"Exit" )
			echo -e "\n See you later ... 👋"
			exit
            ;;
		* )
			printInfo "not valid input, please Try again"
			sleep .3
			echo -n "loading again .."
			
			mainMenu
			;;
	esac
done
}






mainMenu

