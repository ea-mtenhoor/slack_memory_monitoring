#!/bin/bash

cd /root/monitoring
slackUrl="https://hooks.slack.com/services/EXAMPLE/EXAMPLE/example234example" #app_name, #challen
totalMem="$(free -g | grep Mem | awk '{print $2}')"
freeMem="$(free -g | grep Mem | awk '{print $3}')"
percentMem=`echo "result = ($freeMem/$totalMem)*100; scale=0; result / 1" | bc -l`
bufferZone=4
warningPoint=80
criticalPoint=95

#State: okay=1  warning=2  critical=3

if [ $percentMem -lt $warningPoint ]; then currentState=1; fi
if [ $percentMem -ge $warningPoint ]; then currentState=2; fi
if [ $percentMem -ge $criticalPoint ]; then currentState=3; fi

bufferPercent=$(($percentMem + $bufferZone))
if [ $bufferPercent -lt $warningPoint ]; then bufferState=1; fi
if [ $bufferPercent -ge $warningPoint ]; then bufferState=2; fi
if [ $bufferPercent -ge $criticalPoint ]; then bufferState=3; fi

if [ -f previousState ]; then
        previousState=`cat previousState`
else
        previousState=1
fi

if [ $currentState -gt $previousState ]; then
        case "$currentState" in
                2)
                        echo $currentState > previousState
                        curl -X POST -H 'Content-type: application/json' --data '{"attachments": [{"text":"WARNING! Memory usage high! '"$percentMem%"' <!here>","color":"warning"}]}' $slackUrl > /dev/null 2>&1
                        ;;
                3)
                        echo $currentState > previousState
                        curl -X POST -H 'Content-type: application/json' --data '{"attachments": [{"text":"CRITICAL! Memory usage very high! '"$percentMem%"' <!here>","color":"danger"}]}' $slackUrl > /dev/null 2>&1
                        ;;
        esac
fi

if [ $bufferState -lt $previousState ]; then
        case "$currentState" in
                1)
                        echo $currentState > previousState
                        curl -X POST -H 'Content-type: application/json' --data '{"attachments": [{"text":"RECOVERED: Memory usage normal. '"$percentMem%"'","color":"good"}]}' $slackUrl > /dev/null 2>&1
                        ;;
                2)
                        echo $currentState > previousState
                        curl -X POST -H 'Content-type: application/json' --data '{"attachments": [{"text":"WARNING! Memory usage high! '"$percentMem%"'","color":"warning"}]}' $slackUrl > /dev/null 2>&1
                        ;;
        esac
fi

if [ ! -z "$1" ]; then
	echo pwd = `pwd`
        echo totalMem = $totalMem
        echo freeMem = $freeMem
        echo percentMem = $percentMem
        echo bufferZone = $bufferZone
        echo bufferPercent = $bufferPercent
        echo warningPoint = $warningPoint
        echo criticalPoint = $criticalPoint
        echo currentState = $currentState
        echo bufferState = $bufferState
        echo previousState = $previousState
fi
