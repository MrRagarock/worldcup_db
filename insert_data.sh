#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL"TRUNCATE TABLE games, teams")"
#file=games.csv

cat games.csv | while IFS="," read  YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENTS_GOALS;
do
  #skip first line
  if [ $YEAR != "year" ]
  then
 # echo "winner $WINNER"
  #add to teams
    #check winner
    winTeamId=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #if it's empty
    if [ -z $winTeamId ]
    then
    #add
      echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")"
    fi
    winTeamId=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #check opponent
    oppTeamId=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #if it's empty
    if [ -z $oppTeamId ]
    then
    #add
      echo "$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")"
    fi
    oppTeamId=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  #add to games
    #check
    #echo "$winTeamId - $oppTeamId"
    gameId=$($PSQL "SELECT game_id FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE winner_id = $winTeamId AND opponent_id = $oppTeamId AND year = $YEAR")
    if [ -z $gameId ]
    then
    echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $winTeamId, $oppTeamId, $WINNER_GOALS, $OPPONENTS_GOALS)")"
    fi
  fi
done

