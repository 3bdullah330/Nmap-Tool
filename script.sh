#!/bin/bash



# Make sure there is an argument
if [ "$#" -eq 0 ]; then
    echo "Please pass the IP of network as an argument.";
    return # Stop the program
fi



# Validate the input
IPv4_WITHOUT_CIDR_REGEX='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
IPv4_WITH_CIDR_REGEX='^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'

CURRENT_IP=$1

if [[ $CURRENT_IP =~ $IPv4_WITHOUT_CIDR_REGEX ]]; then
    echo "You forget the subnet => '/00'."
    return # Stop the program
elif ! [[ $CURRENT_IP =~ $IPv4_WITH_CIDR_REGEX ]]; then
    echo "Invalid Input."
    return # Stop the program
fi



# Scan the network and recored the IPs of the onlone hosts
THE_LIST_OF_IPs=`nmap "$CURRENT_IP" | grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}$'`


# Delete the 'hosts' dir if exist
# Then
# Create the 'hosts' dir
if test -d "./hosts";
then
    rm -r ./hosts
fi

if ! test -d "./hosts";
then
    mkdir hosts
fi



# Scan each IP and store the data in a file
NUMBER_OF_LINES=$(echo "$THE_LIST_OF_IPs" | wc -l)
for NUMBER_OF_CURRENT_LINE in {1.."$NUMBER_OF_LINES"}
do
    CURRENT_IP=`echo "$THE_LIST_OF_IPs" | head -"$NUMBER_OF_CURRENT_LINE" | tail -1`
    `nmap "$CURRENT_IP" > ./hosts/"$CURRENT_IP".txt`
done
