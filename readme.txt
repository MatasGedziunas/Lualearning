To run any .lua files use : lua your_file.lua 

Internet speed measurement script : 

To use this script type : lua main.lua <command> {arguments}

List of commands: 
Measure download speed: lua main.lua dspeed {host} ; 
example: dspeed speedtest.rackray.eu:8080 ;
host is the server from which you will receive data and measure the download speed.

Measure upload speed: lua main.lua uspeed {receiver} ;
example: lua main.lua uspeed speedtest.rackray.eu:8080 ;
receiver is the server from which you will receive data and measure the upload speed ;

Download server list file : lua main.lua file 
prints all data about the servers in terminal

Find the best server for your location : lua main.lua server

Find your geographical location using a third-party API : lua main.lua location
lists data about your geographical location.
format example: 
{
  "ip": "88.119.152.93",
  "hostname": "88-119-152-93.static.zebra.lt",
  "city": "Vilnius",
  "region": "Vilnius",
  "country": "LT",
  "loc": "54.6892,25.2798",
  "org": "AS8764 Telia Lietuva, AB",
  "postal": "01001",
  "timezone": "Europe/Vilnius",
  "readme": "https://ipinfo.io/missingauth"
}

Automatically perform the whole test : lua main.lua test
runs all commands

Dependencies/libraries used: 
lua-curl - used to make http requests to other servers.
socket - used to accurately measure the time between http requests and responses.
cjson - used to encode and decode json data
argparse - for command line interface communication with user