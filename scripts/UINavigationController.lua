require "UIViewController"

UINavigationController = UIViewController:new();
UINavigationController.__index = UINavigationController;
setmetatable(UINavigationController, UIViewController);

function UINavigationController:createWithRootViewController(rootVc)
    if rootVc ~= nil then
        local ncId = ui::createNavigationController(rootVc:id());
        local nc = UIViewController:new(ncId);
        setmetatable(nc, self);
        
        return nc;
    end
    return nil;
end

function UINavigationController:pushViewController(vc, animated)
    print(vc);
    ui::pushViewControllerToNavigationController(vc:id(), self:id(), animated);
end