require "UIViewController"

UINavigationController = {};
UINavigationController.__index = UINavigationController;
setmetatable(UINavigationController, UIViewController);

-- constructor
function UINavigationController:create(rootVc)
    if rootVc ~= nil then
        local ncId = ui::createNavigationController(rootVc:id());
        local nc = self:get(ncId);
        
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
    ui::pushViewControllerToNavigationController(vc:id(), self:id(), animated);
end