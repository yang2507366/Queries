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

-- instance methods
function AppLoader:load(urlString)
    app::loadApp(self:id(), urlString, "eventProxy_appProcessing", "eventProxy_appLoadComplete");
end

function AppLoader:runWithRelatedViewController(relatedVC)
    app::runApp(self:id(), relatedVC:id());
end

-- event
function AppLoader:complete(success, appId)
    
end

function AppLoader:processing(loadedLength, amountLength)
    
end

function AppLoader:cancel()
    
end

-- global functions
function runAppWithRelatedViewController(appId, relatedVC)
    app::runApp(appId, relatedVC:id());
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