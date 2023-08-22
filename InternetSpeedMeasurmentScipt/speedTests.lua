local curl = require("cURL")
local socket = require("socket")
local cjson = require("cjson")   

local speedTest = {}
local testTime = nil

local function DownloadProgressTracker(dltotal, dlnow, _, _)
    local elapsedTime = socket.gettime() - testTime
    local curr_speed = dlnow / elapsedTime / 1024 / 1024 * 8
    if curr_speed > 0 then
        print(cjson.encode({current_download_speed = curr_speed}))
    end
end

function speedTest.MeasureDownloadSpeed(url)
    local easy = curl.easy{
        url = url,
        httpheader = {
            "User-Agent: curl/7.81.0", "Accept: */*", "Cache-Control: no-cache"
        },
        [curl.OPT_IGNORE_CONTENT_LENGTH] = true,
        [curl.OPT_NOPROGRESS] = 0,
        [curl.OPT_PORT] = 8080,
        writefunction = function() end,
        progressfunction = function(...) return DownloadProgressTracker(...) end,
        timeout = 30
    }

    testTime = socket.gettime()

    local success, result = pcall(function()
        easy:perform()
        local dl_speed = easy:getinfo(curl.INFO_SPEED_DOWNLOAD) / 1024 / 1024 * 8
        easy:close()
        return dl_speed
    end)

    if not success then
        error("Can't connect to server:" .. result)
    else
        return result
    end
end

local function UploadProgressTracker(_, _, ulTotal, ulNow)
    local elapsedTime = socket.gettime() - testTime
    local curr_speed = ulNow / elapsedTime / 1024 / 1024 * 8
    if curr_speed > 0 then
        print(cjson.encode({current_upload_speed = curr_speed}))
    end
end

function speedTest.MeasureUploadSpeed(url)
    local easy = curl.easy{
        httpheader = {
            "User-Agent: curl/7.81.0", "Accept: */*", "Cache-Control: no-cache"
        },
        url = url,   
        port = 8080,     
        noprogress = false,
        post = true,
        writefunction = io.open("/dev/null", "r+"),
        progressfunction = UploadProgressTracker,
        httppost = curl.form({
            file = {file = "/dev/zero", type = "text/plain", name = "zeros"}
        }),
        timeout = 30
    }

    local success, result = pcall(function()
        testTime = socket.gettime()
        easy:perform()
        --print("Size upload:" .. easy:getinfo(curl.INFO_SIZE_UPLOAD) * 8 / 1024 / 1024)
        local ul_speed = easy:getinfo(curl.INFO_SPEED_UPLOAD) / 1024 / 1024 * 8
        easy:close()
        return ul_speed
    end)
   
    if not success then
        error("Error occurred during upload speed test:".. result)
    else
        return result
    end
end

return speedTest
