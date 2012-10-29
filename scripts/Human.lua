require "TestObject"

Human = Animal:new();

function Human:createWithId(aid)
	self.__index = self;
	
	local tmp = Animal:createWithId(aid);
	setmetatable(tmp, self);
	return tmp;
end

function Human:speak()
	print("human speak:"..self:id());
end

function Human:run()
	print("human run:"..self:id());
end