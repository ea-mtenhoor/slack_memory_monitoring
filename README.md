# slack_memory_monitoring
This script monitors memory utilization on a linux server, and sends notifications to a slack channel when thresholds are crossed.  The script will write out a file named previousState every time a threshold is crossed.

## Required software
This script requires `bc` and `smem`.

## Usage
It is recommended to run this script as a cronjob every minute.

`* * * * * /root/monitoring/check_memory_v2.sh`

## Variables
(in `config` file)

**slackURL**: Create an app in Slack, enable the webhooks functionality, add a webhook to a channel, copy/paste the URL to this variable.

**bufferZone**: Integer, probably between 0 and 9.  Default 4.  This is the number of percent that memory usage must decrease before the script will recognize that a state threshold has been crossed in the lower utilization direction.  For example, if bufferZone is 4 and warningPoint is 80, the script will not recover from the warning state until memory utilization is 75% or lower.

**warningPoint**: Integer.  Default 80.  The percent memory utilization at which warning state will be set, and a warning message will be sent to slack.

**criticalPoint**: Integer. Default 90.  The percent memory utilization at which critical state will be set, and a critical message will be sent to slack.
