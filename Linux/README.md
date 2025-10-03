# Automated Data Processing Pipeline – DEC Launchpad Linux Task
This directory contains my solution for the DEC Launchpad Linux task, which involves setting up an automated data processing pipeline.
The project demonstrates concepts such as file manipulation, automation, permissions management, scheduling with cron, and logging in a Linux environment.

[Getting Started](#Getting-started)  
[Data Ingestionand Preprocessing](#Data-Ingestion-and-Preprocessing)  
[Automating with Cron](#Automating-with-Cron)  
[Monitoring Logs for  Errors](#Monitoring-logs-for-Errors)
[Managing Permissions](#Managing-Permissions)

## Getting Started
### 1. Set up the Environment

For this project, I used a Linux Virtual Machine (VM), but all commands are also executable in a local environment (e.g., Git Bash, WSL, etc).

### 2. Create the Project Directories

To ensure an organized file system, the following directory structure is created in the home directory:

```shell
mkdir -p ~/data_pipeline/{input,output,logs}
```

- ~ – home directory
- data_pipeline/ – parent directory
- input/, output/, logs/ – subdirectories  
  
## Data Ingestion and Preprocessing
### Step 1: Transfer the CSV File

If the data is stored locally, use scp to copy the file into the input directory on the remote server:
```shell
scp /home/my/local/path/sales_data.csv username@remote_host:~/data_pipeline/input
```
### Step 2: Create the Preprocessing Script

A bash script called preprocess.sh is created to clean and process the data.
```shell
vim preprocess.sh
```
- The following code is inserted into the script:

```shell
#!/bin/bash

set -euo pipefail

# Define file paths
input_file=~/data_pipeline/input/sales_data.csv
output_file=~/data_pipeline/output/cleaned_sales_data.csv
log_file=~/data_pipeline/logs/preprocess.log

{
    # Remove rows where status = "Failed" and drop the last column
    awk -F, '$6!="Failed" {OFS=","; print $1, $2, $3, $4, $5, $6}' "$input_file" > "$output_file"

    echo "The process completed successfully on $(date)"
} &>> "$log_file"
```
### Step 3: Make the Script Executable
```shell
chmod +x preprocess.sh
```
  - Check permissions to confirm script is executable:
```shell
ls -l preprocess.sh
```

## Automating with Cron

To run the preprocessing script every day at midnight (12:00 AM), add a cron job:
```shell
crontab -e
```
- Paste this line in the crontab editor:
```shell
# Run the data processing script every day at midnight
0 0 * * * ~/data_pipeline/preprocess.sh >> ~/data_pipeline/logs/cron.log
```

- To confirm that the  cron job is active:
```shell
crontab -l
```

## Monitoring Logs for Errors

To track errors, a monitoring script (monitor.sh) is created:
```shell
#!/bin/bash

# Define log file paths
pre_log=~/data_pipeline/logs/preprocess.log
cron_log=~/data_pipeline/logs/cron.log

# Search for error keywords
errors=$(grep -iE "error|failed" "$pre_log" "$cron_log")

if [ -n "$errors" ]; then
    echo "The following errors were found:"
    echo "$errors"
else
    echo "No errors found."
fi
```

- Schedule the monitoring script to run 5 minutes after the main pipeline (at 12:05 AM):
```shell
# Run the monitoring script 5 minutes after preprocessing
5 0 * * * ~/data_pipeline/monitor.sh >> ~/data_pipeline/logs/cron.log
```

## Managing Permissions

Ensure correct file permissions for your scripts and directories. For example:
```shell
chmod 700 ~/data_pipeline/monitor.sh
chmod 700 ~/data_pipeline/preprocess.sh
```

This ensures only the owner can read, write, and execute the scripts.

## Summary

Built a Linux-based data pipeline with organized directory structure.

Automated preprocessing using bash + awk.

Scheduled pipeline runs with cron.

Implemented logging and monitoring to detect errors.

Applied permission management for security.




