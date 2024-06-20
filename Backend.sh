#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

N="\e[0m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"

echo -e "$R Please enter database root password. $N"
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
    echo -e "$R You are not a superuser, Please run this script with root access. $N"
    exit 1
else
    exho -e "$G Hey you are a superuser, The script started executing. $N"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default Nodejs."

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version."

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs."

id expense
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Adding expense user."
else
    echo -e "$G Expense user already added. $N"
fi

mkdir -p /app/* &>>$LOGFILE
VALIDATE $? "Creating App directory."

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code."

cd /app &>>$LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unzipping backend code."

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies."

cp /home/ec2-user/practice-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Connecting to backend.service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reloading."

systemctl start backend &>>$LOGFILE
VALIDATE $? "Starting backend."

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend."

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "installing MySql client."

mysql -h db.ramdaws.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema Loading."

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend."