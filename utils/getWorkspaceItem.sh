#!/bin/bash
set -e -x

source azure-oss-demos-ci/utils/pretty-echo.sh

echo "token:" $token

getWorkspaceItemStatus() {

  local token=$1
  local workspace_name=$2
  local resource_group=$3
  local subscription_id=$4
  local provisioningState=$5

  MESSAGE="Creating hte worksapce Workspace " ; simple_blue_echo

  CURL_COMMAND=" -H 'Host: management.azure.com' -H 'Content-Type: application/json' -H 'Authorization: Bearer OAUTH-TOKEN' -X GET  https://management.azure.com/subscriptions/SUBSCRIPTION-ID/resourcegroups/RESOURCE-GROUP-NAME/providers/Microsoft.OperationalInsights/workspaces/OMS-WORKSPACE-NAME?api-version=2015-11-01-preview"

  NEW_CURL_COMMAND=$(sed  "s@OAUTH-TOKEN@${token}@g" <<< $CURL_COMMAND)
  NEW_CURL_COMMAND=$(sed  "s@OMS-WORKSPACE-NAME@${workspace_name}@g" <<< $NEW_CURL_COMMAND)
  NEW_CURL_COMMAND=$(sed  "s@RESOURCE-GROUP-NAME@${resource_group}@g" <<< $NEW_CURL_COMMAND)
  NEW_CURL_COMMAND=$(sed  "s@SUBSCRIPTION-ID@${subscription_id}@g" <<< $NEW_CURL_COMMAND)

  echo $NEW_CURL_COMMAND

  #Check if we got a 200 back
  result=$(eval curl $NEW_CURL_COMMAND)
  echo result
  if [[ $result == *"error"* ]]; then
    echo $result
    exit 1
  else
    #Get the state
    workspace_state=$(jq .properties.provisioningState <<< $result)
    echo "provisioningState:" $workspace_state
    TRIMMED_RESULT="${workspace_state%\"}"
    TRIMMED_RESULT="${TRIMMED_RESULT#\"}"
    eval $provisioningState="'$TRIMMED_RESULT'"
  fi

}



