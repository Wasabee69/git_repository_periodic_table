#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else
if [[ $1 =~ ^[0-9]+$ ]]
then
RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
fi
if [[ -z $RESULT ]]
then
echo "I could not find that element in the database."
else
# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
$PSQL "SELECT elements.*, properties.* FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number=$RESULT" | while IFS='|' read -r ATOMIC_NUMBER1 SYMBOL NAME ATOMIC_NUMBER2 ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
do
NEW_TYPE=$($PSQL "SELECT type from types WHERE type_id=$TYPE_ID")
echo "The element with atomic number $ATOMIC_NUMBER1 is $NAME ($SYMBOL). It's a $NEW_TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
fi
fi