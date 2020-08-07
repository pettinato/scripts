#!/bin/sh

# When using AWS MFA command line access needs the MFA code on a daily basis.
# This script can help to automate the process of setting the AWS Environment Variables.
# Note: Only works for a single Terminal Session at a time.

# Assumes
# 1. This script is run with "source aws_sts_helper.sh"
# 2. jq is installed (brew install jq)
# 3. AWSIAMROLE is set in .bash_profile
#    It comes from AWS Console -> "My Security Credentials" -> "Multi-factor authentication (MFA)" -> "Assigned MFA device"

# Prompt for MFA
echo "Enter MFA Code:"
read varname

# Turn these off
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

# Run AWS Token Command
value=$(aws sts get-session-token --serial-number $AWSIAMROLE --token-code $varname)

echo "Set environment variables"
export AWS_ACCESS_KEY_ID=$(echo $value | jq '.Credentials.AccessKeyId' | sed 's/"//g')
export AWS_SECRET_ACCESS_KEY=$(echo $value | jq '.Credentials.SecretAccessKey' | sed 's/"//g')
export AWS_SESSION_TOKEN=$(echo $value | jq '.Credentials.SessionToken' | sed 's/"//g')
