require "Object"

AppLoader = {};
AppLoader.__index = AppLoader;
setmetatable(AppLoader, Object);

function AppLoader:create()
    local appId = tostring(math::random());
    local tmp = Object:new(appId);
    setmetatable(tmp, self);
    
    AppLoaderEventProxyTable[appId] = tmp;
    
    return tmp;
end

function AppLoader:dealloc()
    AppLoaderEventProxyTable[self:id()] = nil;
    Object.dealloc(self);
end

-- instance methods
function AppLoader:load(urlString)
    app::loadApp(self:id(), urlString, "AppLoader_appProcessing", "AppLoader_appLoadComplete");
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
    app::cancelLoadApp(self:id());
end

-- global functions
function runAppWithRelatedViewController(appId, relatedVC)
    app::runApp(appId, relatedVC:id());
end

-- event proxy
AppLoaderEventProxyTable = {};
function AppLoader_appLoadComplete(appLoaderId, success, appId)
    local bsuccess = false;
    if success then
        if tonumber(success) == 1 then
            bsuccess = true;
        end
    end
    ap_new();
    local targetLoader = AppLoaderEventProxyTable[appLoaderId];
    targetLoader:complete(bsuccess, appId);
    targetLoader:dealloc();
    ap_release();
end

function AppLoader_appProcessing(appLoaderId, loadedLength, amountLength)
    ap_new();
    AppLoaderEventProxyTable[appLoaderId]:processing(loadedLength, amountLength);
    ap_release();
end