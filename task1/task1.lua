local cjson = require("cjson")   

local speedTests = require("speedTests")
local serverInfo = require("serverInfo")
-- SETING UP CLI
local argparse = require "argparse"
local parser = argparse()
parser:command_target("command")
parser:command("location", "Get information about your geographical location")
parser:command("dspeed", "Get information about your download speed"):argument("host", "Provide a server from which to measure the speed"):args(1)
parser:command("uspeed", "Get information about your upload speed"):argument("host", "Provide a server from which to measure the speed"):args(1)
parser:command("file", "Get the server list file information")
parser:command("server", "Get the best server for your location")
parser:command("test", "Perform the entire test")


local args = parser:parse()
if args.command == "location" or args.command == "test" then
    local geoLocationData = serverInfo.GetGeoLocationData()
    print(geoLocationData)
elseif args.command == "dspeed" or args.command == "test" then
    print(cjson.encode({download_speed = speedTests.MeasureDownloadSpeed(args.host)}))
elseif args.command == "uspeed" or args.command == "test" then
    print(cjson.encode({upload_speed = speedTests.MeasureUploadSpeed(args.host)}))
elseif args.command == "file" or args.command == "test" then
    print(serverInfo.DownloadServerListFileData())
elseif args.command == "server" or args.command == "test" then
    print(serverInfo.GetBestServer())
else
    print("Unknown command:", args.command)
end





