#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

N="\e[0m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R Failed $N"
        exit 1
    else
        echo -e "$2...$G Success $N"
    fi
}

check_root(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Hello you are not a super user. This script has to be run with root access. $N "
        exit 1
    else
        echo -e "$G Hey you are a super user, So the script is executing. $N"
    fi
}