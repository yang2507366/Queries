require "Object"
require "ViewControllerEventProxy"

ViewController = Object:new();

function ViewController:createWithTitle(title)
	self.__index = self;
	if title == nil then
        title = "无标题";
    end
    
    local vcId = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    
    local tmpVc = Object:new();
    setmetatable(tmpVc, self);
    
    self:setId(vcId);
    self.title = title;
    
    _global_view_did_load_event_table[self:id()] = self;
    _global_view_will_appear_event_table[self:id()] = self;
    _global_view_did_pop_event_table[self:id()] = self;

    return tmpVc;
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
    ui::setRootViewController(self:id());
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

function ViewController:test()
	print("test:"..self:id());
end