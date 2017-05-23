var=`grep public_dns terraform.tfstate | awk -F ":" 'NR==1 {print $2}' | sed s/\"//g | sed s/\,//g`
echo $var
var2=ubuntu@${var}
var3=$(echo $var2 | tr -d ' ')
echo $var3
scp -i /opt/jenkins-scripts/AWS_KEY/mandeepingpoc.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $var3:/var/lib/go-agent/config/guid.txt  .
