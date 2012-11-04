require "Object"

AppLoader = {};
AppLoader.__index = AppLoader;
setmetatable(AppLoader, Object);

function AppLoader:create()
    local appId = tostring(math::random());
    local tmp = Object:new(appId);
    setmetatable(tmp, self);
    
    eventProxyTable_appLoader[appId] = tmp;
    
    return tmp;
end

function AppLoader:load(urlString)
    app::loadApp(self:id(), urlString, "eventProxy_appProcessing", "eventProxy_appLoadComplete");
end

-- event
function AppLoader:complete(success, appId)
    
end

function AppLoader:processing(loadedLength, amountLength)
    
end

function AppLoader:cancel()
    
end

-- event proxy
eventProxyTable_appLoader = {};
function eventProxy_appLoadComplete(appLoaderId, success, appId)
    local bsuccess = false;
    if success then
        if tonumber(success) == 1 then
            bsuccess = true;
        end
    end
    eventProxyTable_appLoader[appLoaderId]:complete(bsuccess, appId);
end

function eventProxy_appProcessing(appLoaderId, loadedLength, amountLength)
    eventProxyTable_appLoader[appLoaderId]:processing(loadedLength, amountLength);
end