local speedTests = require("speedTests")
local serverInfo = require("serverInfo")
local cjson = require("cjson")

local lu = require("luaunit")

local fastTestServer = "speedtest.rackray.eu:8080"
local notWorkingServer = "hrtspeedtest.afghan-wireless.com:8080" -- sometimes works

TestDownloadServerListFileData = {}
    function TestDownloadServerListFileData:testNotNil()
        local actual = serverInfo.DownloadServerListFileData()
        local expected = "aaa"
        lu.assertNotNil(actual)
    end

local servers = cjson.decode(serverInfo.DownloadServerListFileData())

TestGetIpAdress = {}
    function TestGetIpAdress:testNotNil()
        lu.assertNotNil(serverInfo.GetIpAdress())
    end

TestGetGeoLocationData = {}
    function TestGetGeoLocationData:testNotNil()
        lu.assertNotNil(serverInfo.GetGeoLocationData())
    end

TestMeasureDownloadSpeed = {}
    function TestMeasureDownloadSpeed:testNotNil()
        local actual = speedTests.MeasureDownloadSpeed(fastTestServer)
        lu.assertNotNil(actual)
    end 

    function TestMeasureDownloadSpeed:testConnectionTimeout()
        lu.assertError(speedTests.MeasureDownloadSpeed, notWorkingServer)
    end

    function TestMeasureDownloadSpeed:testEmptyHostError()
        lu.assertErrorMsgContains("missing URL", speedTests.MeasureDownloadSpeed)
    end

    function TestMeasureDownloadSpeed:testInvalidHostError()
        lu.assertErrorMsgContains("URL using bad/illegal format", speedTests.MeasureDownloadSpeed)
    end

TestMeasureUploadSpeed = {}

    function TestMeasureUploadSpeed:testNotNil()
        local actual = speedTests.MeasureUploadSpeed(fastTestServer)
        lu.assertNotNil(actual)
    end 

    function TestMeasureUploadSpeed:testConnectionTimeout()
        lu.assertError(speedTests.MeasureUploadSpeed, notWorkingServer)
    end

    function TestMeasureUploadSpeed:testEmptyHostError()
        lu.assertErrorMsgContains("missing URL", speedTests.MeasureUploadSpeed)
    end

    function TestMeasureUploadSpeed:testInvalidHostError()
        lu.assertErrorMsgContains("URL using bad/illegal format", speedTests.MeasureUploadSpeed)
    end

TestFilterServerListByCityName = {}
    function TestFilterServerListByCityName:testSimpleCase()
        local city = "Vilnius"
        local actual = serverInfo.FilterServerListByCityName(servers, city)
        lu.assertNotNil(actual)
    end

    function TestFilterServerListByCityName:testNoSuchServerNames()
        local city = "ppppppp"
        local actual = serverInfo.FilterServerListByCityName(servers, city)
        lu.assertEquals(actual, {})
    end

TestMeasureLatencyToServer = {}
    function TestMeasureLatencyToServer:testNotNil()
        lu.assertNotNil(serverInfo.MeasureLatencyToServer(fastTestServer))
    end

    function TestMeasureLatencyToServer:testConnectionTimeout()
        lu.assertEquals(serverInfo.MeasureLatencyToServer(notWorkingServer), "Connection to server timed out") 
    end

    function TestMeasureLatencyToServer:testEmptyHostError()
        lu.assertEquals(serverInfo.MeasureLatencyToServer(), "Connection to server timed out") 
    end

    function TestMeasureLatencyToServer:testInvalidHostError()
        lu.assertEquals(serverInfo.MeasureLatencyToServer("aaaaaa"), "Connection to server timed out") 
    end

TestGetBestServer = {}
    function TestGetBestServer:testNotNil()
        lu.assertNotNil(serverInfo.GetBestServer())
    end

os.exit(lu.LuaUnit.run())
