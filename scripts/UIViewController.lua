require "Object"

UIViewController = Object:new();

function UIViewController:createWithTitle(title)
	self.__index = self;
	
	if title == nil then
		title = "Untitled";
	end
	
	local vcId = ui::createViewController(title);
	local vc = Object:new(vcId);
	setmetatable(vc, self);
	
	return vc;
end

function UIViewController:new()
	self.__index = self;
	
	local vc = Object:new();
	setmetatable(vc, self);
	
	return vc;
	
end