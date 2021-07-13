#!/bin/bash

. config.conf

function send_teams {
    status=$1
    TITLE="WIFI Status"
    # Text.
    if [ $status -eq 1 ]; then
        MESSAGE="$MAIN_WIFI_SSID and $SECURITY_WIFI_SSID are ON, you can shut down $SECURITY_WIFI_SSID."
    else
        MESSAGE="$MAIN_WIFI_SSID and $SECURITY_WIFI_SSID are OFF, you can start up $SECURITY_WIFI_SSID and you have to fix $MAIN_WIFI_SSID."
    fi
    # Convert formating.
    JSON="{\"title\": \"${TITLE_MESSAGE}\", \"text\": \"${MESSAGE}\" }"
    # Post to Microsoft Teams.
    curl -H "Content-Type: application/json" -d "${JSON}" "${WEBHOOK_URL}" &>/dev/null

}

function send_status {
    if [ $1 -eq 1 ] && [ $2 -eq 1 ]; then
        send_teams 1 #Main Wifi and Security Wifi are working
    elif [ $1 -ne 1 ] && [ $2 -eq 4 ]; then
        send_teams 0 #Main Wifi and Security Wifi are not Working
    fi
}

function check_main_wifi {
    statusSecurity=$1
    echo -e "\033[1;33mStart checking $MAIN_WIFI_SSID STATUS\033[0m"
    if nmcli dev wifi | grep $MAIN_WIFI_SSID &>/dev/null; then #Check if Main Wifi is ON
        echo -e "\t\033[0;32m$MAIN_WIFI_SSID Founded\033[0m"
        nmcli device wifi connect $MAIN_WIFI_SSID &>/dev/null #Try connection to Main Wifi
        if [ $? == 0 ]; then
            echo -e "\t\033[0;32mConnected to $MAIN_WIFI_SSID\033[0m"
            curl www.google.com &>/dev/null #Try if Main Wifi can access to google.com
            if [ $? -eq 0 ]; then
                echo -e "\t\033[0;32m$MAIN_WIFI_SSID UP\033[0m"
                send_status 1 $statusSecurity #Update report with Main Wifi Working
            else
                echo -e "\t\033[0;31m$MAIN_WIFI_SSID DOWN\033[0m"
                send_status 2 $statusSecurity #Update report with Main Wifi Not Working
            fi
        else
            echo -e "\t\033[0;31mConnection to $MAIN_WIFI_SSID failed\033[0m"
            send_status 3 $statusSecurity #Update report with connection impossible to Main Wifi
        fi
    else
        echo -e "\t\033[0;31m$MAIN_WIFI_SSID Not Found\033[0m"
        send_status 4 $statusSecurity #Update report with Main Wifi OFF
    fi
}

while true; do
    date #Print Date
    echo -e "\033[1;33mStart test\033[0m"
    if nmcli dev wifi | grep $SECURITY_WIFI_SSID &>/dev/null; then #Check if Security Wifi is ON
        echo -e "\033[0;32m$SECURITY_WIFI_SSID Founded\033[0m"
        check_main_wifi 1 #Check Main Wifi status with Security Wifi ON
    else
        echo -e "\033[0;31m$SECURITY_WIFI_SSID Not Found\033[0m"
        check_main_wifi 4 #Check Main Wifi status with Security Wifi OFF
    fi
    echo -e "\033[1;33mTest done\033[0m"
    sleep ${DELAY}h #Wait X Hour
done
