import ViewControllerEventProxy.lua;

local ViewController = {};
ViewController.__index = ViewController;

function ViewController:new(title)
    if title == nil then
        title = "无标题";
    end
    
    local objectId = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    
    local vc = ObjectCreate(objectId);
    setmetatable(vc, ViewController);

    vc.title = title;
    
    _global_view_did_load_event_table[vc.id] = vc;
    _global_view_will_appear_event_table[vc.id] = vc;
    _global_view_did_pop_event_table[vc.id] = vc;

    return vc;
end

-- events
function ViewController:viewDidLoad()
end

function ViewController:viewWillAppear()
end

function ViewController:viewDidPop()
    
end

-- instance methods
function ViewController:setAsRootViewController()
    ui::setRootViewController(self.id);
end

function ViewController:addSubview(subview)
    ui::addSubviewToViewController(subview.id, self.id);
end

function ViewController:navigationItem()
    local nid = runtime::invokeMethod(self.id, "navigationItem");
    local ni = NavigationItem:new(nid);
    return ni;
end

function ViewController:navigationController()
    local ncid = runtime::invokeMethod(self.id, "navigationController");
    local nc = NavigationController:get(ncid);
    return nc;
end
