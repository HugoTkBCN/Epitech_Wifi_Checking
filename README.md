# Check Epitech Barcelona Wifi Status
The idea was to have a script that checks the status of the wifi in Epitech Barcelona.  
The script will check if the security wifi is ON and then check if the main wifi is working.
## Cases
If "Security_Wifi" is ON and "Main_Wifi" is working -> "Security_Wifi" has to be shut down.  
If "Security_Wifi" is OFF and  "Main_Wifi" is not working -> "Security_Wifi" has to be started up and "Main_Wifi" has to be fixed.

## Run Command

```sh
chmod +x start.sh
./start.sh
```

## Config File
config.conf
```
MAIN_WIFI_SSID=<SSID_Main_Wifi>
SECURITY_WIFI_SSID=<SSID_Security_Wifi>
DELAY=<Delay_in_hour>
WEBHOOK_URL=<Teams_WebHook_url>
```

|  | description |
| ------ | ------ |
| MAIN_WIFI_SSID |  example -> "IONIS" |
| SECURE_WIFI_SSID |  example -> "Epitech_Guest" |
| DELAY | example -> 1 |
| WEBHOOK_URL | To get WebHook url -> https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhoo |

## Author

- [Hugo Lachkar](https://github.com/HugoTkBCN)
