require "AppContext"
require "UIViewController"
require "CommonUtils"
require "UINavigationBar"

UINavigationController = {};
UINavigationController.__index = UINavigationController;
setmetatable(UINavigationController, UIViewController);

-- constructor
function UINavigationController:create(rootVc)
    if rootVc ~= nil then
        local ncId = runtime::invokeClassMethod("LINavigationController", "create", AppContext.current());
        local nc = self:get(ncId);
        
        nc:pushViewController(rootVc, false);
        
        return nc;
    end
    return nil;
end

function UINavigationController:get(ncId)
    local nc = UIViewController:new(ncId);
    setmetatable(nc, self);
    
    return nc;
end

-- instance methods
function UINavigationController:pushViewController(vc, animated)
    if animated == nil then
        animated = true;
    end
    runtime::invokeMethod(self:id(), "pushViewController:animated:", vc:id(), toObjCBool(animated));
end

function UINavigationController:toolbarHidden()
    return toLuaBool(runtime::invokeMethod(self:id(), "toolbarHidden"));
end

function UINavigationController:setToolbarHidden(hidden)
    runtime::invokeMethod(self:id(), "setToolbarHidden:", toObjCBool(hidden));
end

function UINavigationController:navigationBarHidden()
    return toLuaBool(runtime::invokeMethod(self:id(), "navigationBarHidden"));
end

function UINavigationController:setNavigationBarHidden(hidden)
    runtime::invokeMethod(self:id(), "setNavigationBarHidden:", toObjCBool(hidden));
end

function UINavigationController:navigationBar()
    return UINavigationBar:get(runtime::invokeMethod(self:id(), "navigationBar"));
end
