#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

insert_team() {
  team_name="$1"
  
  $PSQL "INSERT INTO teams (name) VALUES ('$team_name')"
}

insert_game() {
  year="$1"
  round="$2"
  winner="$3"
  opponent="$4"
  winner_goals="$5"
  opponent_goals="$6"

  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
}

tail -n +2 games.csv | while read line
do
  # Split the line into an array using IFS
  IFS=',' read -ra fields <<< "$line"

  # Assign variables from the array
  year="${fields[0]}"
  round="${fields[1]}"
  winner="${fields[2]}"
  opponent="${fields[3]}"
  winner_goals="${fields[4]}"
  opponent_goals="${fields[5]}"

  # Insert the winner and opponent teams if they don't already exist
  insert_team "$winner"
  insert_team "$opponent"

  # Insert the game
  insert_game $year "$round" "$winner" "$opponent" $winner_goals $opponent_goals
done
