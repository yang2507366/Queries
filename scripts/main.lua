import UIKit.lua;

function main()
    local tmpVC = ViewController:new();
    function tmpVC:viewDidLoad(vcId)
        NSLog("viewController:"..vcId);
    end
    local ncId = tmpVC:setAsRootViewController();
    
    local vc2 = ViewController:new();
    runtime::invokeMethod(ncId, "pushViewController:animated:", vc2:id(), "1");
end