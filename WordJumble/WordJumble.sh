#!/bin/bash

#Simple word jumble game where a player has to try to get the correct word from the scrambled letters

#Player starts game, selects difficulty, tries to get the correct word, the game ends when they succeed

if ! dpkg -s figlet > /dev/null; then
	echo "figlet package is not installed, please run sudo apt install figlet"
fi

#Title
figlet "Welcome to  Word Jumble!"
figlet "~~~~~~~~~~~~~~~~~~"

#Get players name for the leaderboard, if they did not make the cut it doesn't get added
get_player_name() {
	read -p "Enter your name: " player_name
	echo $player_name
}

#Display the leaderboard
display_leaderboard() {
	echo "====LEADERBOARD===="
	local count=1
	while read -r line;do
}
