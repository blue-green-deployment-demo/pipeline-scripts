sudo echo "deb https://download.gocd.io /" | sudo tee /etc/apt/sources.list.d/gocd.list
sudo curl https://download.gocd.io/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install go-agent
sudo sed -i -e 's,127.0.0.1,ec2-35-163-220-196.us-west-2.compute.amazonaws.com,g' /etc/default/go-agent
sudo chmod -R 777 /var/lib/go-agent
sudo /etc/init.d/go-agent restart
