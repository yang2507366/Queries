require "AppContext"
require "UIViewController"
require "CommonUtils"
require "UINavigationBar"
require "UIToolbar"

UINavigationController = {};
UINavigationController.__index = UINavigationController;
setmetatable(UINavigationController, UIViewController);

-- constructor
function UINavigationController:create(rootVc--[[option]])
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
function UINavigationController:pushViewController(vc, animated--[[option]])
    if animated == nil then
        animated = true;
    end
    runtime::invokeMethod(self:id(), "pushViewController:animated:", vc:id(), toObjCBool(animated));
end

function UINavigationController:toolbarHidden()
    return toLuaBool(runtime::invokeMethod(self:id(), "toolbarHidden"));
end

function UINavigationController:setToolbarHidden(hidden, animated)
    runtime::invokeMethod(self:id(), "setToolbarHidden:animated:", toObjCBool(hidden), toObjCBool(animated));
end

function UINavigationController:navigationBarHidden()
    return toLuaBool(runtime::invokeMethod(self:id(), "navigationBarHidden"));
end

function UINavigationController:setNavigationBarHidden(hidden, animated)
    runtime::invokeMethod(self:id(), "setNavigationBarHidden:animated", toObjCBool(hidden), toObjCBool(animated));
end

function UINavigationController:navigationBar()
    return UINavigationBar:get(runtime::invokeMethod(self:id(), "navigationBar"));
end

function UINavigationController:toolbar()
    return UIToolbar:get(runtime::invokeMethod(self:id(), "toolbar"));
end
