#/bin/bash
source /mnt/usr/logs/blacklist/blacklist.conf
#获取每秒请求同一个path请求数量大于upperlimit的ip
getAlikePath()
{
    cat ${logfile}  | awk -v st=${start_time} -v et=${stop_time} '{t=substr($6,RSTART+14,21);if(t>=st && t<=et) {print $0}}' | awk '{t=substr($6,RSTART+9,10);{print $1"|"t"|"$10}}' | sort | uniq -c | sort -nr > ${temporary}
     cat ${temporary} | awk '{if($1>'${upperlimit}') {print  $2"&"$1} }' | sort -u >> ${alikepathfile}"_"${now}

}
#获取数据加入内名单
addBlackList()
{
    getAlikePath
    alinkpath=`cat ${alikepathfile}"_"${now} | awk -v st=${yhm_start_time}  -v et=${yhm_end_time}  '{split($1,data,"|")}{if(st<data[2] && et>data[2]){print data[1]}}' | sort -u | uniq`
    for ip in ${alinkpath}
    do
        echo "date[${now}]reason[ip出现次数过高]ip[${ip}]" >> ${bloacklog}
        echo ${password} | sudo -S ipset add blackip ${ip}
        echo ${ip}
    done
}
addBlackList