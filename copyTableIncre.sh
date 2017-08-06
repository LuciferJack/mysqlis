#!/bin/bash
#增量备份incre sync

copyTable(){

echo "copy table is '$COPY_USE'"
if [ "$COPY_USE" == "" ];then
   echo "copy table is null ,exit";exit;
fi



if [ "$COPY_USE" == "*" ];then
        echo "copy all table from $HOST  to $LOCAL_HOST ";
        COPY_USE="all table";
        STATUS='*';
fi


COPY_TABLE=$COPY_USE
LOCAL_TABLE=$COPY_USE


echo "copying db '$COPY_DB'  table  '$COPY_TABLE'  to my local '$LOCAL_HOST' db '$LOCAL_DB' table '$LOCAL_TABLE'  dump"


if [ "$STATUS" == "*" ];then
        COPY_TABLE='';
        LOCAL_TABLE='';
fi

#test
#nlp_rank_poi_online `source_from` = 't_column_resource' AND `rank_type` = '1' AND `m_status` = '1' ;
if [ ! -z "$WHERE_COND" ];then
        #--where="1 limit 1000000"
        #WHERE `rank_type` = '1' AND `source_from` = 't_column_resource'"
        #PROTOTYPE="$WHERE_COND";
        COND=`echo "$WHERE_COND" | sed "s/'/\"/g"`
        echo -e "new cond is $COND  \r\n"
        COND=`echo "$COND" | sed "s/\\\`//g"`
        echo -e "new cond is $COND  \r\n"
        #保留双引号
        #WHERE_COND='""'$WHERE_COND'""';
        WHERE_COND="$COND";
        echo -e "the where cond is $WHERE_COND\r\n"
        mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB -e "delete from $LOCAL_TABLE where ""$WHERE_COND"
        echo -e "delete from $LOCAL_HOST $LOCAL_PORT $LOCAL_DB $LOCAL_TABLE $WHERE_COND finish \r\n"
fi

#不能有空格
SUBFFIX="  --no-create-info "

if [ ! -z "$WHERE_COND" ];then
    set -x
    mysqldump  --user=$USER  --password=$PASS  -h$HOST  -P$PORT --force $OPT --log-error=$ERROR \
            $COPY_DB  $COPY_TABLE  --where="$WHERE_COND"  $SUBFFIX | mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB
            #$COPY_DB $COPY_TABLE  $WHERE_BASE"$WHERE_COND"  $SUBFFIX >ljx.sql
    set +x
    else
    set -x
    mysqldump  --user=$USER  --password=$PASS  -h$HOST  -P$PORT --force $OPT --log-error=$ERROR \
            $COPY_DB $COPY_TABLE  | mysql -u$LOCAL_USER -p$LOCAL_PASS  -h$LOCAL_HOST -P$LOCAL_PORT $LOCAL_DB
    set +x
fi

}
