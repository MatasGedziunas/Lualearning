local cjson = require("cjson")   

local speedTests = require("speedTests")
local serverInfo = require("serverInfo")
print(speedTests.MeasureUploadSpeed("hrtspeedtest.afghan-wireless.com:8080"))
-- SETING UP CLI
local argparse = require "argparse"
local parser = argparse()
parser:command_target("command")
parser:command("location", "Get information about your geographical location")
parser:command("dspeed", "Get information about your download speed"):argument("host", "Provide a server from which to receive data and measure the speed"):args(1)
parser:command("uspeed", "Get information about your upload speed"):argument("receiver", "Provide a server to which to send data and measure the speed"):args(1)
parser:command("file", "Get the server list file information")
parser:command("server", "Get the best server for your location")
parser:command("test", "Perform the entire test")


local args = parser:parse()
if args.command == "location" then
    local geoLocationData = serverInfo.GetGeoLocationData()
    print(geoLocationData)
elseif args.command == "dspeed" then
    print(cjson.encode({download_speed = speedTests.MeasureDownloadSpeed(args.host)}))
elseif args.command == "uspeed" then
    print(cjson.encode({upload_speed = speedTests.MeasureUploadSpeed(args.receiver)}))
elseif args.command == "file" then
    print(serverInfo.DownloadServerListFileData())
elseif args.command == "server" then
    print(serverInfo.GetBestServer())
elseif args.command == "test" then
    local geoLocationData = serverInfo.GetGeoLocationData()
    print(cjson.encode({download_speed = speedTests.MeasureDownloadSpeed(args.host)}))
    print(cjson.encode({upload_speed = speedTests.MeasureUploadSpeed(args.receiver)}))
    print(geoLocationData)
    print(serverInfo.DownloadServerListFileData())
    print(serverInfo.GetBestServer())
else
    print("Unknown command:", args.command)
end





