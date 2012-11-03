require "Object"
require "UIView"
require "UINavigationItem"
require "System"

UIViewController = {};
UIViewController.__index = UIViewController;
setmetatable(UIViewController, Object);

-- constructor
function UIViewController:createWithTitle(title)
    if title == nil then
        title = "Untitled";
    end
    local vcId = ui::createViewController(title, "_global_viewDidLoad", "_global_viewWillAppear", "_global_viewDidPop");
    local vc = self:get(vcId);
    
    _global_view_did_load_event_table[vcId] = vc;
    _global_view_will_appear_event_table[vcId] = vc;
    _global_view_did_pop_event_table[vcId] = vc;
    
    return vc;
end

function UIViewController:get(vcId)
    local vc = Object:new(vcId);
    setmetatable(vc, self);
    
    return vc;
end

-- instance methods
function UIViewController:setAsRootViewController()
    local vcId = self:id();
    if vcId then
        ui::setRootViewController(vcId);
    end
end

function UIViewController:view()
    local viewId = runtime::invokeMethod(self:id(), "view");

    return UIView:get(viewId);
end

function UIViewController:navigationItem()
    local naviItemId = runtime::invokeMethod(self:id(), "navigationItem");
    return UINavigationItem:get(naviItemId);
end

function UIViewController:navigationController()
    local ncId = runtime::invokeMethod(self:id(), "navigationController");
    return UINavigationController:get(ncId);
end

function UIViewController:setWaiting(waiting)
    ap_new();
    if waiting then
        runtime::invokeClassMethod("Waiting", "showWaiting:inView:", "YES", self:view():id());
        else
        runtime::invokeClassMethod("Waiting", "showWaiting:inView:", "NO", self:view():id());
    end
    ap_release();
end

function UIViewController:setLoading(loading)
    ap_new();
    if loading then
        runtime::invokeClassMethod("Waiting", "showLoading:inView:", "YES", self:view():id());
    else
        runtime::invokeClassMethod("Waiting", "showLoading:inView:", "NO", self:view():id());
    end
    ap_release();
end

-- event
function UIViewController:viewDidLoad()
    
end

function UIViewController:viewWillAppear()
    
end

function UIViewController:viewDidPop()
    
end

-- event proxy
_global_view_did_load_event_table = {};
_global_view_will_appear_event_table = {};
_global_view_did_pop_event_table = {};

function _global_viewDidLoad(vcId)
    _global_view_did_load_event_table[vcId]:viewDidLoad(vcId);
end

function _global_viewWillAppear(vcId)
    _global_view_will_appear_event_table[vcId]:viewWillAppear(vcId);
end

function _global_viewDidPop(vcId)
    _global_view_did_pop_event_table[vcId]:viewDidPop(vcId);
end