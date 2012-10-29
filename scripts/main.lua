require "TestObject"
require "TestSubObject"
require "TestSubSubObject"

function main()
	local a = Animal:createWithId("pig");
	a:speak();
	
	local h = Human:createWithId("USA");
	h:speak();
	
	local m = Man:createWithId("Man");
	m:speak();
end