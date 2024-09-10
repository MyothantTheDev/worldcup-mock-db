#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo "Clear all database: $($PSQL "TRUNCATE teams, games")"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
    then

    #get winner id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    if [[ -z $WINNER_ID ]]
      then
      #insert new winner
      INSERT_WINNER_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
        echo "Inserted team: $WINNER"
      fi
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi

    #get opponent id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $OPPONENT_ID ]]
      then
      #insert new opponent
      INSERT_OPPONENT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
        echo "Inserted team: $OPPONENT"
      fi
      #get new opponent id
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi

    #insert games
    INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES ($YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")"
    echo "Inserted games: $WINNER($WINNER_ID) VS $OPPONENT($OPPONENT_ID) ROUND $ROUND"
  fi
done