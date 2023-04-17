#!/bin/bash
# Simple game selector for any bash games I make

echo "Select game please: "

items=("GuessNum"
"N/A"
"N/A")

# What game to play?
select item in "${items[@]}" Nevermind
do
	case $REPLY in
		1) echo "Selected game #$REPLY $item"; cd GuessNum/; ./GuessNum.sh;
			break;;
		2) echo "Selected game #$REPLY $item";
			break;;
		3) echo "Selected game #$REPLY $item";
			break;;
		$((${#items[@]}+1))) echo "Coward!"; break 2;;
		*) echo "Invalid response $REPLY"; break;;
        esac
done
