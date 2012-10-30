require "Object"
require "ViewController"

NavigationController = ViewController:new();

function NavigationController:createWithRootViewController(rootVC)
	self.__index = self;
	if rootVC then
		local ncId = ui::createNavigationController(rootVC:id());
		
		local nc = ViewController:new(ncId);
		setmetatable(nc, self);
		
		return nc;
	end
	return nil;
end
