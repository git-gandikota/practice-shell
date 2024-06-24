#!/bin/bash

source ./common.sh

check_root

echo -e "$G Please enter DataBase password: $N"
read -s mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE

dnf module enable nodejs:20 -y &>>$LOGFILE

dnf install nodejs -y &>>$LOGFILE

useradd expense &>>$LOGFILE

mkdir -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

cd /app &>>$LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE

npm install &>>$LOGFILE

cp /home/ec2-user/practice-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl start backend &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

mysql -h db.ramdaws.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE