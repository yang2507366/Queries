require "AppContext"
require "UIViewController"
require "CommonUtils"

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