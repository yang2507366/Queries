require "TestObject"

Human = Animal:new();

function Human:speak()
	print("human speak:"..self:id());
end