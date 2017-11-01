#!/bin/bash
. copyTableIncre.sh

# The following database will be DELETED first:
STATUS=''

HOST='localhost'
PORT=8899
COPY_DB=marry
COPY_TABLE=$COPY_USE
USER=root
PASS="******"
ERROR=./mysql_error.log
OPT=" --single-transaction  "

LOCAL_HOST='10.99.***.***'
LOCAL_DB=poi
LOCAL_PORT=8899
LOCAL_TABLE=$COPY_USE
LOCAL_USER=root
LOCAL_PASS="******"


WHERE_COND=''
COPY_USE=''

BC=$'\e[4m'
EC=$'\e[0m'

while true; do
        read -p "Do you wish to copy table from ${BC}$HOST $PORT${EC} to ${BC}$LOCAL_HOST $LOCAL_PORT${EC}? (y or n)" yn
    case $yn in
            [Yy]* )echo -e "Please enter \e[4mtablename\e[0m as  input: : (\e[31m\e[1m*\e[0m\e[0m) is copy all source table to destination !";
                read input_variable where_input;
                echo "You entered: $input_variable  $where_input";
                COPY_USE=$input_variable;
                WHERE_COND=$where_input;
                echo $COPY_USE;
                echo $WHERE_COND;
                copyTable;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

