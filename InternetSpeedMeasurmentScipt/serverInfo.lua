local curl = require("cURL")
local socket = require("socket")
local cjson = require("cjson")   

local serverInfo = {}

function serverInfo.FilterServerListByCityName(servers, city)
    local filteredServers = {}
    for _, server in ipairs(servers) do
        if string.lower(server.city) == string.lower(city) then
            print(cjson.encode({addedServer = server}))
            table.insert(filteredServers, server)
        end
    end
    return filteredServers
end

function serverInfo.MeasureLatencyToServer(host)
    local easy = curl.easy{
        httpheader = {"User-Agent: curl/7.81.0", "Accept: */*", "Cache-Control: no-cache"},
        customrequest = "HEAD",
        url = host,
        noprogress = true,
        nobody = true,
        port = 8080, 
        timeout = 5
    }
    local sucess, result = pcall(function()
        easy:perform()
        local latency = easy:getinfo(curl.INFO_TOTAL_TIME)
        easy:close() 
        return latency end)

    if not sucess then
        return "Connection to server timed out"
    else
        return result
    end
end

function serverInfo.GetBestServer()
    local locationData = cjson.decode(serverInfo.GetGeoLocationData())
    local city = locationData.city
    print(cjson.encode({status = "Filtering server list"}))
    local servers = serverInfo.FilterServerListByCityName(cjson.decode(serverInfo.DownloadServerListFileData()), city)
    if servers == nil then
        error("There are no nearby servers in your city")
    end
    local bestServer = nil
    for _, server in ipairs(servers) do
        print(cjson.encode({ measuringServer = server.host}))
        local latency = serverInfo.MeasureLatencyToServer(server.host)
        print(cjson.encode({ latency = latency}))
        if bestServer == nil or latency < bestServer.latency then
            bestServer = { latency = latency, server = server }
        end
    end
    return cjson.encode(bestServer)
end


function serverInfo.GetGeoLocationData(ip)
    if not ip then
        ip = serverInfo.GetIpAdress()
    end
    local url = "http://ipinfo.io/" .. ip .. "/json"
    local data=""
    local easy = curl.easy{
        url = url,
        writefunction = function(chunk) data = data .. chunk end
    }

    local sucess, result = pcall(function()
        easy:perform()
        easy:close() end)
    if not sucess then
        return error("Failed to get geolocation data:")
    end
    return data
end


function serverInfo.DownloadServerListFileData()
    local serverUrl = "http://localhost/speedtest_server_list.json"
    local data=""
    status, easy = pcall(curl.easy, {
        url = serverUrl,
        writefunction = function(chunk) data = data .. chunk end
    })
    if not status then
        return error("Failed to download server list file:")
    end
    easy:perform()
    easy:close()
    return data
end

function serverInfo.GetIpAdress()
    local url = "http://ipinfo.io/ip"
    local ip = ""
    local easy = curl.easy{
        url = url,
        writefunction = function(chunk) ip = ip .. chunk end,            
    }

    local sucess, result = pcall(function()easy:perform()
    easy:close() end)

    if not sucess then
        return error("Failed to connect to external api")
    end

    return ip
end

return serverInfo
