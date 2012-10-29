require "Animal"
require "Human"
require "Man"
require "UIViewController"

function main()
	local a = Animal:createWithId("pig");
	a:speak();
	local h = Human:createWithId("USA");
	h:speak();
    h:run();
	local m = Man:createWithId("Man");
	m:speak();
end