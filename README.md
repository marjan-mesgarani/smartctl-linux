# smartctl-linux
A utility for extracting and formatting important S.M.A.R.T statistics from physical disks on Linux in JSON format for further analysis in monitoring tools.
This utility can be used on HPE, SuperMicro, rackmount servers, etc. which are runnung a Linux OS.


# Dependencies
  - [smartmontools](https://github.com/smartmontools)
  - A data collector of your choice if necessary ([Telegraf](https://github.com/influxdata/telegraf) in this case)
  - A database to store the collected data, preferably time-series databases for further visualization and analysis ([InfluxDB](https://www.influxdata.com), [Prometheus](https://prometheus.io), etc.).

# Getting Started
## Installing the Dependencies
Since the script will be using the smartctl command as the main component, we should install the smartmontools package if not already installed:
```
$ sudo apt install smartmontools

# Make sure the service is started and enabled using the below commands:
$ systemctl status smartd.service
$ systemctl start smartd.service
$ systemctl enable smartd.service
```
Note that you might need to use other package managers to install smartontools based on your OS distribution.
## Deploying the Script
As we'll be using the **`/opt`** directory as our working directory, download the [**`smart.sh`**](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/smart.sh) script to this directory (or make a file with the same name in this directory and copy the contents from the repository to it):
```
$ sudo wget https://github.com/marjan-mesgarani/smartctl-linux/blob/main/smart.sh -P /opt/
```
For more security, we need to set the file permissions as below (so only the owner of the file, which is the root user, can make changes to the script):
```
$ sudo chmod 350 /opt/smart.sh
$ sudo chmod +t /opt/smart.sh
```
At last, we need to create a directory to store the last date and time in which the smartd agent has logged the disk S.M.A.R.T data, so we wouldn't be collecting old or duplicated data.
```
$ sudo mkdir /opt/smart-log-time
```
## Automating the Sctipt Execution
To automate the execution of script for producing the result file repeatedly and in specific intervals, we can create a CronJob for it. In this case, we'll set the intervals to half an hour. Note that since the smartctl command used in the script requires root privileges and for security aspects, we should use "sudo" when running crontab. (You can use [this](https://crontab.guru) website to help you with setting the time for your CronJob.)
```
$ sudo crontab -e
# S.M.A.R.T
15,45 * * * * sudo /opt/smart.sh
```

# Output
Sample outputs of **/opt/result.txt** is placed in sample **`results`** folder of this repo [here](https://github.com/marjan-mesgarani/smartctl-linux/tree/main/sample%20results). Alternatively, you can check them through below links for ATA/SATA disks and SCSI/SAS disks:
- [ATA/SATA](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/sample%20results/SATA.txt)
- [SCSI/SAS](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/sample%20results/SAS.txt)

# Collecting, Storing, and Visualizing the Data
To keep track of the disks' status, we can collect the produced data above using data collection tools and then store them in a database (preferably time-series databases, to keep a history over time).

In our case, we used TIG (Telegraf/InfluxDB/Grafana) which is a push-based monitoring stack and TPG (Telegraf/Prometheus/Grafana) which is a pull-based stack. Similarly, you can use any other tools to process the output JSON data and visualize it.
## Data Collection Using Telegraf
If you don't have Telegraf installed already, you can install it using the below commands and then enable its service to auto-start. Note that you might need to use other package managers based on your OS distribution.
```
$ sudo apt install telegraf
$ sudo systemctl enable telegraf.service
$ sudo systemctl restart telegraf.service
$ systemctl status telegraf.service
```
Then we need to configure telegraf service to collect and process the data from result.txt file. To do so, we can copy the configuration file named telegraf.conf placed [here](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/telegraf-smart/telegraf.conf) to the **`/etc/telegraf`** directory if we're installing Telegraf for the first time.

If you already have Telegraf installed, then:
- if you want to place the configuration file beside other configuration files, you just need to copy the `"[[inputs.file]]"` and `"[[processors.enum]]"` plugins to your desired .conf file.
- if you want to create another service/unit file to separate service or storage, you can do the following:
```
# Create a directory for the service:
$ sudo mkdir -p /opt/telegraf-smart/telegraf.d

# Create the unit file:
$ sudo nano /etc/systemd/system/telegraf-smart.service
# Add below content to the file and save it
####################################################################################################
[Unit]
Description=Telegraf Data Collecting Agent
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
EnvironmentFile=-/etc/default/telegraf
User=telegraf
ExecStart=/usr/bin/telegraf -config /opt/telegraf-smart/telegraf.conf -config-directory /opt/telegraf-smart/telegraf.d $TELEGRAF_OPTS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
####################################################################################################

$ sudo systemctl daemon-reload
$ sudo systemctl enable telegraf-smart.service
$ sudo systemctl restart telegraf-smart.service
$ sudo systemctl status telegraf-smart.service
```
  Then copy the telegraf.conf file from [here](https://github.com/marjan-mesgarani/smartctl-linux/blob/main/telegraf-smart/telegraf.conf) to **`/opt/telegraf-smart/`** directory.

You can edit this file and change **`"name_override = "smart_hvXX""`** to a suitable name based on your server.
## Data Storage
To store the collected data, we can use Telegraf's output plugins which support a variety of databases. To do so, using the previously mentioned monitoring stacks, we can proceed with rhe following methods:
- Store the data to [InfluxDB](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/influxdb):
```
[[outputs.influxdb]]
  urls = ["http://127.0.0.1:8086"]
  database = "smart-linux"
  skip_database_creation = true
  username = "telegraf"
  password = "XXXXXXXX"
```
- Publish the data on a desired port of the server for pull-based databases to read and store them ([Prometheus](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/prometheus_client) in this scenario):
```
[[outputs.prometheus_client]]
  listen = ":9229"
  metric_version = 2
  collectors_exclude = ["gocollector", "process"]
```
## Data Visualization
A sample Grafana dashboard for the collected and stored data:

![smart](https://github.com/marjan-mesgarani/smartctl-linux/assets/96178946/35d7e566-7ff3-416f-a88e-ab5493aebe92)
