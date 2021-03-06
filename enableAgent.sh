#!/bin/bash -x

uuid=$1
resource_input=$2
agentDetails=`curl -k 'https://ec2-35-163-220-196.us-west-2.compute.amazonaws.com:8154/go/api/agents/'$uuid -H 'Accept: application/vnd.go.cd.v4+json'| jq '{ "hostname": .hostname, "agent_config_state" : "Enabled" , "resources": ['\"$resource_input\"'], "environments" : ["Deploy"] }'`
echo $agentDetails > agentdetailstoUpdate.json

curl -k 'https://ec2-35-163-220-196.us-west-2.compute.amazonaws.com:8154/go/api/agents/'$uuid -H 'Accept: application/vnd.go.cd.v4+json' -H 'Content-Type: application/json' -X PATCH --data @agentdetailstoUpdate.json
