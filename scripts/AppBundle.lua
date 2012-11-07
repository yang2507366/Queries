require "Object"

AppBundle = {};
AppBundle.__index = AppBundle;
setmetatable(AppBundle, Object);

function AppBundle:get(appId)
    appId = app::getAppBundle(appId);
    local app = Object:new(appId);
    setmetatable(app, self);
    
    return app;
end

function AppBundle:bundleId()
    local bid = runtime::invokeMethod(self:id(), "bundleId");
    
    return bid;
end

function AppBundle:getResource(resName)
    
end