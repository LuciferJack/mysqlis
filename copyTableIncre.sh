#!/bin/bash
#增量备份incre sync

copyTable(){

echo -e "\e[4mcopy table is \e[31m'$COPY_USE'\e[0m\e[0m"
if [ "$COPY_USE" == "" ];then
   echo "copy table is null ,exit";exit;
fi



if [ "$COPY_USE" == "*" ];then
        echo -e "\e[4mcopy all table from \e[31m$HOST\e[0m  to \e[31m$LOCAL_HOST\e[0m \e[0m";
        COPY_USE="all table";
        STATUS='*';
fi


COPY_TABLE=$COPY_USE
LOCAL_TABLE=$COPY_USE


echo -e "\e[4mcopying from host=\e[31m$HOST\e[0m  db=\e[31m'$COPY_DB'\e[0m  table=\e[31m'$COPY_TABLE'\e[0m  to  host=\e[31m$LOCAL_HOST\e[0m db=\e[31m'$LOCAL_DB'\e[0m table=\e[31m'$LOCAL_TABLE'\e[0m  dump process---\e[0m  \r\n"


if [ "$STATUS" == "*" ];then
        COPY_TABLE='';
        LOCAL_TABLE='';
fi


if [ ! -z "$WHERE_COND" ];then
        #--where="1 limit 1000000"
        #WHERE `rank_type` = '1' AND `source_from` = 't_column_resource'"
        COND=`echo "$WHERE_COND" | sed "s/'/\"/g"`
        COND=`echo "$COND" | sed "s/\\\`//g"`
        #保留双引号
        #WHERE_COND='""'$WHERE_COND'""';
        WHERE_COND="$COND";
        echo -e "the where mode : \e[1mforce update\e[0m and  cond is: \e[4m$WHERE_COND\r\n\e[0m"
        mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB  -e "delete from $LOCAL_TABLE where ""$WHERE_COND"
fi

#不能有空格
SUBFFIX="  --no-create-info "

if [ ! -z "$WHERE_COND" ];then
    set -o pipefail
    mysqldump  --user=$USER  --password=$PASS  -h$HOST  -P$PORT --force $OPT --log-error=$ERROR \
            $COPY_DB  $COPY_TABLE  --where="$WHERE_COND"  $SUBFFIX | mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB
	EXITCODE=$?
 	if [ $EXITCODE -ne 0 ] ; then 
      echo -e "\e[4m\r\nmysqldump failed with exit code $EXITCODE,pls see the file=$ERROR for detail \e[0m"
 	else
      echo -e "\e[4m\r\nmysqldump finished \e[1mok\e[0m \e[0m"
 	fi
else
    set -o pipefail
    mysqldump  --user=$USER  --password=$PASS  -h$HOST  -P$PORT --force $OPT --log-error=$ERROR \
            $COPY_DB $COPY_TABLE  | mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB  
	EXITCODE=$?
 	if [ $EXITCODE -ne 0 ] ; then 
      echo -e "\e[4m\r\nmysqldump failed with exit code $EXITCODE,pls see the file=$ERROR for detail \e[0m"
 	else
      echo -e "\e[4m\r\nmysqldump finished \e[1mok\e[0m \e[0m"
 	fi
fi

}
