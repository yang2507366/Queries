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
    
    eventProxyTable_viewController[vcId] = vc;
    
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

-- private event
function UIViewController:p_viewDidPop()
    self:viewDidPop();
    eventProxyTable_viewController[self:id()] = nil;
end

-- event proxy

eventProxyTable_viewController = {};

function _global_viewDidLoad(vcId)
    eventProxyTable_viewController[vcId]:viewDidLoad();
end

function _global_viewWillAppear(vcId)
    eventProxyTable_viewController[vcId]:viewWillAppear();
end

function _global_viewDidPop(vcId)
    eventProxyTable_viewController[vcId]:p_viewDidPop();
end