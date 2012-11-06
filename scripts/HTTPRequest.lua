require "Object"

HTTPRequest = {};
HTTPRequest.__index = HTTPRequest;
setmetatable(HTTPRequest, Object);

HTTPRequestEncodingDefault  = "Default";
HTTPRequestEncodingUTF8     = "UTF8";
HTTPRequestEncodingGBK      = "GBK";

-- constructor
function HTTPRequest:start(URLString, encoding)
    local requestId = http::request(URLString, "event_http_request_response", encoding);
    local request = Object:new(requestId);
    setmetatable(request, self);
    
    event_proxy_http_request[requestId] = request;
    
    return request;
end

function HTTPRequest:post(URLString, params, encoding)
    if params == nil then
        params = "";
    end
    if params.id then
        params = params:id();
    end
    local requestId = http::post(URLString, params, "event_http_request_response", encoding);
    local req = Object:new(requestId);
    setmetatable(req, self);
    
    event_proxy_http_request[requestId] = req;
    
    return req;
end

-- instance method
function HTTPRequest:cancel()
    http::cancel(self:id());
end

function HTTPRequest:release()
    
end

-- event
function HTTPRequest:response(responseString, errorString)
    
end

-- event proxy
event_proxy_http_request = {};

function event_http_request_response(httpId, responseString, errorString)
    event_proxy_http_request[httpId]:response(responseString, errorString);
end