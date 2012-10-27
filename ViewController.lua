import ViewControllerEventProxy.lua;

local ViewController = {};
ViewController.__index = ViewController;

function ViewController:new(title)
    local tmpVC = {};
    setmetatable(tmpVC, ViewController);
    if title == nil then
        title = "Untitled";
    end
    tmpVC.title = title;
    tmpVC.objectId = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    _global_view_did_load_event_table[tmpVC.objectId] = tmpVC;
    _global_view_will_appear_event_table[tmpVC.objectId] = tmpVC;
    _global_view_did_pop_event_table[tmpVC.objectId] = tmpVC;
    return tmpVC;
end

-- events
function ViewController:viewDidLoad()
end

function ViewController:viewWillAppear()
end

function ViewController:viewDidPop()
    
end

-- instance methods
function ViewController:id()
    return self.objectId;
end
function ViewController:setAsRootViewController()
    ui::setRootViewController(self:id());
end

function ViewController:addSubview(subview)
    ui::addSubviewToViewController(subview.objectId, self:id());
end
