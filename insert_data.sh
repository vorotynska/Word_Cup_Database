#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
#read the games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#get winner team name
  if [[ $WINNER != "winner" ]]
then
TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
#if not found
    if [[ -z $TEAM1_NAME ]]
     then
#insert new name
   INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1_NAME == 'INSERT 01' ]]
        then
        echo Inserted into teams $WINNER
        fi
    fi
 fi
 #get opponent name
 if [[ $OPPONENT != "opponent" ]]
  then
  TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
   #if not found
    if [[ -z $TEAM2_NAME ]]
     then
#insert new name
   INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM2_NAME == 'INSERT 01' ]]
        then
        echo Inserted into teams $OPPONENT
        fi
    fi
  fi
#insert games table
if [[ YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ $INSERT_GAME == 'INSERT 0 1' ]]
        then
        echo Insered into games $YEAR, $ROUND, $WINNER_ID, $OPPONNT_ID, $WINNER_GOALS, $OPPONENT_GOALS
        fi
  fi
done
