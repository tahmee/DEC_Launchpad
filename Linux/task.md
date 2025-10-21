# Overview
As a data engineer, you have been tasked to set up a data processing pipeline using Linux commands and bash scripts. This project would cover file manipulation, automation, permissions management, scheduling with cron, and logging.

---

## 1. Set Up the Environment
Connect to a Linux virtual machine (VM) using the credentials shared with you.
- Create directories for organizing the pipeline:
    - ~/data_pipeline/input
    - ~/data_pipeline/output
    - ~/data_pipeline/logs

---

## 2. Data Ingestion and Preprocessing
Simulate data ingestion by copying the dataset (`sales_data.csv`) into `~/data_pipeline/input/.`

- Write a script `preprocess.sh` to clean and prepare the data files. The script should:
    - Removes the `extra_col` column (last column).
    - Filters out rows where `status = Failed`.
    - Saves the cleaned version of the file into `~/data_pipeline/output/cleaned_sales_data.csv`.
    - Prints a success message and logs the action to `~/data_pipeline/logs/preprocess.log`.
    - Make `preprocess.sh` executable

## 3. Automate the Pipeline with Cron Jobs
- Set up a `cron job` to automate data processing.
- Schedule preprocess.sh to run every day at midnight (12AM)
- Confirm the cron job is active by listing the scheduled jobs on the server.

## 4. Logging and Monitoring
Redirect output and error logs to the logs folder to monitor the pipeline’s progress.
- Write a `monitor.sh` script that checks for errors in the logs and notifies you if any are found. This script should:
    - Search for errors (e.g., "ERROR" or "failed") in log files.
    - If errors are found, print them to the terminal or write to a summary log.
    - Schedule this monitoring script to run after each daily processing job by adding it to cron (e.g., 12:05 AM).

## 5. Permissions and Security
- Adjust permissions to secure files and directories:
- Set the input folder to be writable only by your user.
- Restrict access to logs so only authorized users can read them.

## Submission:
Submit a link to your GitHub repo containing your solution.

Submit using this form - https://forms.gle/zadQcmK8xBV8RRBd7

**Duration:** 7 days

**Deadline:** 03/10/2025
