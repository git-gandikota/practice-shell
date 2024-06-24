#!/bin/bash

#set -e

failure(){
    echo "Failed at $1: $2"
}
trap 'failure ${LINENO} $BASH_COMMAND"' ERR

USERID= $(id -u)
TIMESTAMP= $(date +%F-%H-%M-%S)
SCRIPT_NAME= $(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

N="\e[0m"
R="\e[32m"
G="\e[32m"
Y="\e[33m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R FAILED $N"
        exit 1
    else
        echo -e "$G SUCCESS $N"
    fi
}

check_root(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root access $N"
        exit 1
    else
        echo -e "$G Hey congrats your script started executing now $N"
    fi
}