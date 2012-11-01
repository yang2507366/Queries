require "Object"

HTTPRequest = {};
HTTPRequest.__index = HTTPRequest;
setmetatable(HTTPRequest, Object);

-- constructor
function HTTPRequest:start(URLString)
    local requestId = http::request(URLString, "event_http_request_response");
    local request = Object:new(request);
    setmetatable(request, self);
    
    event_proxy_http_request[requestId] = request;
    
    return request:autorelease();
end

-- instance method
function HTTPRequest:cancel()
    http:cancel(self:id());
end

-- event
function HTTPRequest:response(responseString, errorString)
    
end

-- event proxy
event_proxy_http_request = {};

function event_http_request_response(httpId, responseString, errorString)
    event_proxy_http_request[httpId]:response(responseString, errorString);
end