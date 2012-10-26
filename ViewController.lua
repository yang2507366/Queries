import EventProxy.lua;

ViewController = {};
ViewController.__index = ViewController;

ViewController.title = "";

function ViewController:new(title)
    local tmpVC = {};
    setmetatable(tmpVC, ViewController);
    if title == nil then
        title = "Untitled";
    end
    tmpVC.title = title;
    tmpVC.ios_viewController = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    _global_view_did_load_event_table[tmpVC.ios_viewController] = tmpVC;
    _global_view_will_appear_event_table[tmpVC.ios_viewController] = tmpVC;
    _global_view_did_pop_event_table[tmpVC.ios_viewController] = tmpVC;
    return tmpVC;
end

-- events
function ViewController:viewDidLoad(vcId)
end

function ViewController:viewWillAppear(vcId)
end

function ViewController:viewDidPop(vcId)
    NSLog("ViewController:viewDidPop");
    self:recycle(vcId);
end

function ViewController:recycle(vcId)
    runtime::recycleCurrentScript();
end

-- instance methods
function ViewController:id()
    return self.ios_viewController;
end
function ViewController:setAsRootViewController()
    local ncId = ui::createNavigationController(self.ios_viewController);
    ui::setRootViewController(ncId);
    return ncId;
end
