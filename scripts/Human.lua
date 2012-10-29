require "Animal"

Human = Animal:new();

function Human:speak()
	print("human speak:"..self:id());
end

function Human:run()
	print("human run:"..self:id());
end