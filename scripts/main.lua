require "Object"
require "TableView"
require "ViewController"
require "NavigationController"

function main()
	local vc = ViewController:createWithTitle("title");
	local nc = NavigationController:createWithRootViewController(vc);
    nc:setAsRoot();
end