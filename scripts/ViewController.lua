require "Utils"
require "Object"
require "ViewControllerEventProxy"

ViewController = Object:new();
ViewController.__index = ViewController;

function ViewController:createWithTitle(title)
	if title == nil then
        title = "无标题";
    end
    
    local vcId = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    
    local vc = Object:new(vcId);
    setmetatable(vc, self);
    
    vc.title = title;
    
    dp(vc:id());
    _global_view_did_load_event_table[vc:id()] = vc;
    _global_view_will_appear_event_table[vc:id()] = vc;
    _global_view_did_pop_event_table[vc:id()] = vc;
    
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
function ViewController:setAsRoot()
    local objId = self:id();
    if objId ~= nil then
        ui::setRootViewController(objId);
    end
end

function ViewController:addSubview(subview)
    ui::addSubviewToViewController(subview.id, self.id);
end

function ViewController:navigationItem()
    local nid = runtime::invokeMethod(self:id(), "navigationItem");
    local ni = NavigationItem:new(nid);
    return ni;
end

function ViewController:navigationController()
    local ncid = runtime::invokeMethod(self:id(), "navigationController");
    local nc = NavigationController:get(ncid);
    return nc;
end