#!/bin/bash

resource_input=$1
app_port=$2

app_name=`echo $resource_input | tr '[:lower:]' '[:upper:]'`

existingApp=`curl http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps -H "Content-Type:application/json" -H "Accept:application/json" | jq '.applications.application[] | .instance[] | select(.app == '\"$app_name\"' and .status == "UP") | "http://ec2-52-27-69-178.us-west-2.compute.amazonaws.com:8761/eureka/apps/"+.app+"/"+.instanceId+"/status?value=DOWN"' | tr -d '\"'`
echo "Existing App URL = $existingApp"

existAppInstanceId=`curl http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps -H "Content-Type:application/json" -H "Accept:application/json" | jq '.applications.application[] | .instance[] | select(.app == '\"$app_name\"' and .status == "UP") | .instanceId' | tr -d '\"'`


sleep 30

endFirst=$((SECONDS+140))

echo "Please Wait!..... Pinging green $app_name app url to check whether it has registered with Eureka or not."

while [ $SECONDS -lt $endFirst ]; do



newAppStatus=`curl -s http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps -H "Content-Type:application/json" -H "Accept:application/json" | jq '.applications.application[] | .instance[] | select(.app == '\"$app_name\"' and .instanceId != '\"$existAppInstanceId\"' and .status == "OUT_OF_SERVICE") | .status' | tr -d '\"'`


newAppInstanceId=`curl -s http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps -H "Content-Type:application/json" -H "Accept:application/json" | jq '.applications.application[] | .instance[] | select(.app == '\"$app_name\"' and .instanceId != '\"$existAppInstanceId\"' and .status == "OUT_OF_SERVICE") | .instanceId' | tr -d '\"'`



if [ "$newAppStatus" == "OUT_OF_SERVICE" ]; then
    
    echo "Bringing UP green $app_name app url"
    
    curl -X PUT http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps/$app_name/$newAppInstanceId/status?value=UP
    sleep 1
    endSecond=$((SECONDS+60))
    
    echo "Please wait .... Checking whether green $app_name app is UP or not..."

    while [ $SECONDS -lt $endSecond ]; do
     
    confirmNewAppStatus=`curl -s http://ec2-34-212-100-111.us-west-2.compute.amazonaws.com:8761/eureka/apps/$app_name -H "Content-Type:application/json" -H "Accept:application/json" | jq '.application.instance[] | select(.instanceId == '\"$newAppInstanceId\"') | .status' | tr -d '\"'` 
    
	if [ "$confirmNewAppStatus" == "UP" ]; then
	
		echo "Successfully verified that green $app_name app is UP"
                
                echo "Please wait... Bringing DOWN blue $app_name app url"
    		curl -X PUT $existingApp
    			if [ $? -eq 0 ]; then
     			
     				echo "Blue $app_name app url is DOWN"
     				exit 0
    			else
     				echo "Error: Unable to make Blue $app_name app url DOWN"
     				exit 1
    			fi
	 	
        fi
    done
fi
done
