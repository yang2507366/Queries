require "Object"

Animal = Object:new();

function Animal:new()
	self.__index = self;

	local tmp = Object:new();
	setmetatable(tmp, self);
	
	return tmp;
end

function Animal:createWithId(aid)
    self.__index = self;
    
    local tmp = Object:new(aid);
    setmetatable(tmp, self);
    
    return tmp;
end

function Animal:speak()
	print("animal:"..self:id());
end