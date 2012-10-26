import UIKit.lua;

function main()
    local tmpVC = ViewController:new();
    function tmpVC:viewDidLoad(vcId)
        NSLog("viewController:"..vcId);
    end
    function tmpVC:viewWillAppear(vcId)
        NSLog("viewWillAppear:"..vcId);
    end
    tmpVC:setAsRootViewController();
end