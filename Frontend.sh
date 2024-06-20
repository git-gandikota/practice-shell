#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing default frontend content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading our frontend content"

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "Navigating to html folder"

unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping frontend code"

cp /home/ec2-user/practice-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Connecting to expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"