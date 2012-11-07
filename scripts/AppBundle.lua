require "Object"

App = {};
App.__index = App;
setmetatable(App, Object);

function App:get(appId)
    appId = app::getApp(appId);
    local app = Object:new(appId);
    setmetatable(app, self);
    
    return app;
end

function App:bundleId()
    local bid = runtime::invokeMethod(self:id(), "bundleId");
    print(bid);
    return bid;
end

function App:getResource(resName)
    
end