NavigationController = {};
NavigationController.__index = NavigationController;

function NavigationController:new(viewController)
    if viewController.id == nil then
        return nil;
    end
    local nc = ObjectCreate(ui::createNavigationController(viewController.id));
    setmetatable(nc, NavigationController);

    return nc;
end

function NavigationController:get(nid)
    if nid == nil then
        return nil;
    end
    local nc = ObjectCreate(nid);
    setmetatable(nc, NavigationController);
    
    return nc;
end

function NavigationController:setAsRootViewController()
    ui::setRootViewController(self.id);
end

function NavigationController:pushViewController(vc, animated)
    ui::pushViewControllerToNavigationController(vc.id, self.id, animated);
end