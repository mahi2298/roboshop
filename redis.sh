#!/bin/bash
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.logs"

mkdir -p $LOGS_FOLDER
echo "Script started execution at:: $(date)"
if [ $USERID -ne 0 ]
then
    echo "$R ERROR:: Please run the script with root user $N" | tee -a $LOG_FILE
    exit 1
else
    echo "You are running the script with root user" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo "$2 is .... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo "$2 is .... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling the redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling the redis"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing the redis"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling the redis"


sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
sed -i 's/protectedmode:yes/protectedmode:no/g' /etc/redis/redis.conf
systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting the redis"