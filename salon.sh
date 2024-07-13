#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"



MAIN_MENU() {
  if [[ $1 ]]
  then
    #echo -e "\n$1"
    TIP_INFO=$1
  else
    TIP_INFO="Welcome to My Salon, how can I help you?"
  fi

  
  # get available services
  AVAILABLE_services=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # if no services available
  if [[ -z $AVAILABLE_services ]]
  then
    # send to main menu
    MAIN_MENU "Sorry, we don't have any services available right now."
  else
    # display available services
    #echo "Welcome to My Salon, how can I help you?" 
    echo "$TIP_INFO"
    #echo -e "\nHere are the services we have available:"
    echo "$AVAILABLE_services" | while read service_id BAR NAME
    do
      echo "$service_id) $NAME"
    done

    # ask for services to cut
    #echo -e "\nWelcome to My Salon, how can I help you?" 
    #echo -e "\nWhich one would you like to choose?"
    read SERVICE_ID_SELECTED


    # if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]$ ]]
    then
      # send to main menu
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      # get service availability
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

      # if not available
      if [[ -z $SERVICE_NAME ]]
      then
        # send to main menu
        MAIN_MENU "That service is not available."
      else
        # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME

          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi

        # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

        # get service appointment
        SERVICE_TIME=$($PSQL "SELECT time FROM appointments WHERE customer_id=$CUSTOMER_ID")

        # if time doesn't exist
        if [[ -z $SERVICE_TIME ]]
        then
          #set appointment time
          echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
          read SERVICE_TIME
          # insert service appointment
          INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
          # if the result doesn't exist
          if [[ -z $INSERT_APPOINTMENT_RESULT ]]
          then
            MAIN_MENU "The time in service is not available."
          else
            MAIN_MENU "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
          fi
        else
          echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        fi
      fi
    fi
  fi
}

APPOINTMENT_MENU() {
# send to main menu
  MAIN_MENU
}

EXIT() {
  echo -e "\nThank you for coming in.\n"
}

MAIN_MENU
