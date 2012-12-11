require "Object"
require "AppContext"
require "NSDictionary"

NotificationObserver = {};
NotificationObserver.__index = NotificationObserver;
setmetatable(NotificationObserver, Object);

function NotificationObserver:create()
    local noId = runtime::invokeClassMethod("LINotificationObserver", "create:", AppContext.current());
    return self:get(noId);
end

function NotificationObserver:get(noId)
    local no = Object:new(noId);
    setmetatable(no, self);
    NotificationObserverEventProxyTable[noId] = no;
    return no;
end

function NotificationObserver:observe(notificationName)
    self.notificationName = notificationName;
    runtime::invokeMethod(self:id(), "setNotificationName:func:", self.notificationName, "NotificationObserver_notification");
end

-- event
function NotificationObserver:receive(object, userInfo)
    
end

-- event proxy
NotificationObserverEventProxyTable = {};

function NotificationObserver_notification(noId, objectId, userInfoId)
    local no = NotificationObserverEventProxyTable[noId];
    if no then
        local object = nil;
        if string.len(objectId) ~= 0 then
            object = Object:new(objectId);
        end
        local userInfo = nil;
        if string.len(userInfoId) then
            userInfo = NSDictionary:get(userInfoId);
        end
        no:receive(object, userInfo);
    end
end