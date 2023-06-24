#!/bin/bash

# A simple game in which you have to guess a random number

if ! dpkg -s figlet > /dev/null; then
	echo "figlet package is not installed, please run sudo apt install figlet"
	break
fi

# Title
figlet "Welcome to Guess the Number!"
figlet "~~~~~~~~~~~~~~~~~~"

# Function to generate a random number between 1 and the specified range
generate_random_number() {
  local range=$1
  echo $((1 + $RANDOM % $range))
}

# Function to prompt for and get the player's name
get_player_name() {
  read -p "Enter your name: " player_name
  echo $player_name
}

# Function to display the leaderboard
display_leaderboard() {
  echo "====LEADERBOARD===="
  local count=1
  while read -r line; do
    local name=$(echo "$line" | awk '{print $1}')
    local score=$(echo "$line" | awk '{print $2}')
    printf "%d. %s - %d guesses\n" "$count" "$name" "$score"
    ((count++))
  done < <(sort -n -k2 leaderboard.txt)
}

check_leaderboard() {
  local guesses=$1
  local score="$player_name $guesses"
  if [ ! -f leaderboard.txt ]; then
    touch leaderboard.txt
  fi
  local leaderboard_size=$(wc -l leaderboard.txt | awk '{print $1}')
  if [ $leaderboard_size -lt 3 ]; then
    echo "$score" >> leaderboard.txt
    echo "Congratulations, you made it onto the leaderboard!"
    return
  fi
  local worst_score=$(sort -n -k2 leaderboard.txt | tail -1 | awk '{print $2}')
  if [ $guesses -lt $worst_score ]; then
    sed -i "1i$score" leaderboard.txt
    echo "Congratulations, you made it onto the leaderboard!"
    if [ $leaderboard_size -eq 3 ]; then
      sed -i '4,$d' leaderboard.txt
    fi
  else
    echo "Sorry, you didn't make it onto the leaderboard."
  fi
  sort -nk 2 leaderboard.txt -o leaderboard.txt
}

# Prompt for and get player's name
player_name=$(get_player_name)

# Display leaderboard
display_leaderboard

# Prompt for difficulty level
echo "Select difficulty level:"
select level in "Baby" "Easy" "Normal" "Hard" "Chad"; do
  case $level in
    "Baby")
      range=5
      break
      ;;
    "Easy")
      range=10
      break
      ;;
    "Normal")
      range=100
      break
      ;;
    "Hard")
      range=1000
      break
      ;;
    "Chad")
      range=10000
      break
      ;;
    *)
      echo "Invalid option. Please select again."
      ;;
  esac
done

# Generate random number
secret_number=$(generate_random_number $range)

# Start game
echo "Guess a number between 1 and $range."

# Main game loop
guess_count=0
while true; do
  read -p "Enter your guess: " guess
  if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number."
    continue
  elif [ $guess -lt 1 ] || [ $guess -gt $range ]; then
    echo "Your guess must be between 1 and $range. Try again."
    continue
  fi
  ((guess_count++))
  if [ $guess -eq $secret_number ]; then
    echo "Congratulations, you guessed the secret number in $guess_count tries!"
    check_leaderboard $guess_count
    break
  elif [ $guess -lt $secret_number ]; then
    echo "Your guess is too low. Try again."
  else
    echo "Your guess is too high. Try again."
  fi
done

