# smartctl-linux
A utility for extracting and formatting important S.M.A.R.T statistics from physical disks on Linux in JSON format for further analysis in monitoring tools.
This utility can be used on HPE, SuperMicro, rackmount servers, etc. which are runnung a Linux OS.


# Dependencies
  - [smartmontools](https://github.com/smartmontools)
  - A data collector of your choice if necessary ([Telegraf](https://github.com/influxdata/telegraf) in this case)
  - A database to store the collected data, preferably time-series databases for further visualization and analysis ([InfluxDB](https://www.influxdata.com), [Prometheus](https://prometheus.io), etc)

# Getting Started
## Installing the Dependencies
Since the script will be using the smartctl command as the main component, we should install the smartmontools package if not already installed:
```
sudo apt install smartmontools

# Make sure the service is started and enabled using the below commands:
systemctl status smartd.service
systemctl start smartd.service
systemctl enable smartd.service
```
Note that you might need to use other package managers to install smartontools based on your OS distribution.
## Deploying the Script
As we'll be using the **`/opt`** directory as our working directory, download the [**`smart.sh`**](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/smart.sh) script to this directory (or make a file with the same name in this directory and copy the contents from the repository to it):
```
sudo wget https://github.com/marjan-mesgarani/smartctl-linux/blob/main/smart.sh -P /opt/
```
For more security, we need to set the file permissions as below (so only the owner of the file, which is the root user, can make changes to the script):
```
sudo chmod 350 /opt/smart.sh
sudo chmod +t /opt/smart.sh
```
At last, we need to create a directory to store the last date and time in which the smartd agent has logged the disk S.M.A.R.T data, so we wouldn't be collecting old or duplicated data.
```
sudo mkdir /opt/smart-log-time
```
## Automating the Sctipt Execution
To automate the execution of script for producing the result file repeatedly and in specific intervals, we can create a CronJob for it. In this case, we'll set the intervals to half an hour. Note that since the smartctl command used in the script requires root privileges and for security aspects, we should use "sudo" when running crontab. (You can use [this](https://crontab.guru) website to help you with setting the time for your CronJob.)
```
sudo crontab -e
# S.M.A.R.T
15,45 * * * * sudo /opt/smart.sh
```
