#!/bin/bash

source ./common.sh

check_root

echo -e "$G Please enter DataBase password: $N"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

mysql -h db.ramdaws.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
    echo -e "$G MySql root password was already settedup. $N "
fi

echo -e "$Y This script was done by my own $N"