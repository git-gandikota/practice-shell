#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%h-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

N="\e[0m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"

echo -e "$G Please enter DataBase password: $N"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R Failed $N"
        exit 1
    else
        echo -e "$2...$G Success $N"
    fi
}

if [ $USERID -ne 0 ]
    then
        echo -e "$R Hello you are not a super user. This script has to be run with root access. $N "
        exit 1
    else
        echo -e "$G Hey you are a super user, So the script is executing. $N"
    fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySql server."

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySql server."

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySql server."

mysql -h db.ramdaws.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "Setting up root password."
else
    echo -e "$G MySql root password was already settedup. $N "
fi

echo "This script was done by my own"