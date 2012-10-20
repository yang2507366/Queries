function sendHttpRequest(urlString)
    requestId = http_request(scriptId(), urlString, "httpCallback");
    print("requestId:"..requestId);
    http_request_cancel(requestId);
end

function httpCallback(responseStr, errStr)
    print("response:"..responseStr);
    print("error:"..errStr);
end

function scriptId()
    return "test.lua";
end