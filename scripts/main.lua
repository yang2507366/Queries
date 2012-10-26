import VC.lua;

function main()
    local tmpVC = VC:new();
    function tmpVC:viewDidLoad(vcId)
        NSLog("viewController:"..vcId);
    end
    tmpVC:setAsRootViewController();
end