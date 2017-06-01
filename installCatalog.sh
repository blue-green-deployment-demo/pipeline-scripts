#!/bin/sh
curl -L "http://ec2-35-163-220-196.us-west-2.compute.amazonaws.com:8081/nexus/service/local/artifact/maven/redirect?r=snapshots&g=com.ms-example&a=catalog&v=0.0.1-SNAPSHOT" -o catalog-0.0.1-SNAPSHOT.jar
java -jar /catalog-0.0.1-SNAPSHOT.jar
