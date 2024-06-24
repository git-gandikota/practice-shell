#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE

systemctl enable nginx &>>$LOGFILE

systemctl start nginx &>>$LOGFILE

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE

cd /usr/share/nginx/html &>>$LOGFILE


cp /home/ec2-user/shell-script-2/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE

systemctl restart nginx &>>$LOGFILE