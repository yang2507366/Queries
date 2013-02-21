AppContext = {};

function AppContext.current()
    return __app_id__();
end

function AppContext.destory(appId--[[optional]])
    if not appId then
        appId = AppContext.current();
    end
    runtime::invokeClassMethod("LuaAppManager", "destoryAppWithAppId:", appId);
end