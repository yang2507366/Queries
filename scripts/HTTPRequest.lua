require "Object"

HTTPRequest = {};
HTTPRequest.__index = HTTPRequest;
setmetatable(HTTPRequest, Object);

-- constructor
function HTTPRequest:start(URLString)
    local requestId = http::request(URLString, "event_http_request_response");
    local request = Object:new(requestId);
    setmetatable(request, self);
    
    event_proxy_http_request[requestId] = request;
    
    return request;
end

function HTTPRequest:post(URLString, params)
    local requestId = http::post(URLString, params:id(), "event_http_request_response");
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