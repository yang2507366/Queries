require "Object"
require "ViewController"

NavigationController = ViewController:new();
NavigationController.__index = NavigationController;

function NavigationController:createWithRootViewController(rootVC)
	if rootVC then
		local ncId = ui::createNavigationController(rootVC:id());
		print(ncId);
		local nc = ViewController:new(ncId);
		setmetatable(nc, NavigationController);
		
		return nc;
	end
	return nil;
end