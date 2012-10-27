NavigationController = {};
NavigationController.__index = NavigationController;

function NavigationController:new(viewController)
    if viewController.objectId == nil then
        return nil;
    end
    local nc = {};
    setmetatable(nc, NavigationController);
    nc.objectId = ui::createNavigationController(viewController.objectId);
    return nc;
end

function NavigationController:setAsRootViewController()
    ui::setRootViewController(self.objectId);
end