#!/bin/bash
. copyTableIncre.sh

# The following database will be DELETED first:
STATUS=''

HOST='localhost'
PORT=8899
COPY_DB=marry
COPY_TABLE=$COPY_USE
USER=root
PASS="123456"
ERROR=/home/users/lujunxu/odp/log/mysql/duplicate_mysql_error.log
OPT=" --single-transaction  "

LOCAL_HOST='10.99.xxx.xx'
LOCAL_DB=poi
LOCAL_PORT=8899
LOCAL_TABLE=$COPY_USE
LOCAL_USER=root
LOCAL_PASS="work@nuomi"


WHERE_COND=''
COPY_USE=''

while true; do
        read -p "Do you wish to copy table from $HOST $PORT  to $LOCAL_HOST $LOCAL_PORT ? (y or n)" yn
    case $yn in
        [Yy]* )echo "Please enter tablename as  input: ";
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

