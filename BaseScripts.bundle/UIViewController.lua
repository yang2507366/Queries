require "Object"
require "UIView"
require "UINavigationItem"
require "System"
require "CommonUtils"

UIViewController = {};
UIViewController.__index = UIViewController;
setmetatable(UIViewController, Object);

-- constructor
function UIViewController:create(title)
    if title == nil then
        title = "Untitled";
    end
    local vcId = runtime::invokeClassMethod("ViewController", "create:", System.id());
    local vc = self:get(vcId);
    vc:setTitle(title);
    
    return vc;
end

function UIViewController:get(vcId)
    local vc = Object:new(vcId);
    setmetatable(vc, self);
    
    UIViewControllerEventProxyTable[vcId] = vc;
    runtime::invokeMethod(vcId, "set_loadView", "UIViewController_loadView");
    runtime::invokeMethod(vcId, "set_viewDidLoad", "UIViewController_viewDidLoad");
    runtime::invokeMethod(vcId, "set_viewWillAppear", "UIViewController_viewWillAppear");
    runtime::invokeMethod(vcId, "set_viewDidAppear", "UIViewController_viewDidAppear");
    runtime::invokeMethod(vcId, "set_viewWillDisappear", "UIViewController_viewWillDisappear");
    runtime::invokeMethod(vcId, "set_viewDidDisappear", "UIViewController_viewDidDisappear");
    runtime::invokeMethod(vcId, "set_viewDidPop", "UIViewController_viewDidPop");
    runtime::invokeMethod(vcId, "set_didReceiveMemoryWarning", "UIViewController_didReceiveMemoryWarning");
    runtime::invokeMethod(vcId, "set_shouldAutorotate", "UIViewController_shouldAutorotate");
    runtime::invokeMethod(vcId, "set_supportedInterfaceOrientations", "UIViewController_supportedInterfaceOrientations");
    
    return vc;
end

function UIViewController:dealloc()
    UIViewControllerEventProxyTable[self:id()] = nil;
    Object.dealloc(self);
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

function UIViewController:setTitle(title)
    runtime::invokeMethod(self:id(), "setTitle:", title);
end

function UIViewController:title()
    return runtime::invokeMethod(self:id(), "title");
end

-- override methods
function UIViewController:loadView()
end

function UIViewController:viewDidLoad()
end

function UIViewController:viewWillAppear()
end

function UIViewController:viewDidAppear()
end

function UIViewController:viewWillDisappear()
end

function UIViewController:viewDidDisappear()
end

function UIViewController:didReceiveMemoryWarning()
end

function UIViewController:shouldAutorotate()
    return toObjCBool(true);
end

function UIViewController:supportedInterfaceOrientations()
    return 30;--UIInterfaceOrientationMaskAll
end

function UIViewController:viewDidPop()
end

-- event proxy

UIViewControllerEventProxyTable = {};

function UIViewController_loadView(vcId)
    UIViewControllerEventProxyTable[vcId]:loadView();
end

function UIViewController_viewDidLoad(vcId)
    UIViewControllerEventProxyTable[vcId]:viewDidLoad();
end

function UIViewController_viewWillAppear(vcId)
    UIViewControllerEventProxyTable[vcId]:viewWillAppear();
end

function UIViewController_viewDidAppear(vcId)
    UIViewControllerEventProxyTable[vcId]:viewDidAppear();
end

function UIViewController_viewWillDisappear(vcId)
    UIViewControllerEventProxyTable[vcId]:viewWillDisappear();
end

function UIViewController_viewDidDisappear(vcId)
    UIViewControllerEventProxyTable[vcId]:viewDidDisappear();
end

function UIViewController_didReceiveMemoryWarning(vcId)
    UIViewControllerEventProxyTable[vcId]:didReceiveMemoryWarning();
end

function UIViewController_shouldAutorotate(vcId)
    return toObjCBool(UIViewControllerEventProxyTable[vcId]:shouldAutorotate());
end

function UIViewController_supportedInterfaceOrientations(vcId)
    return UIViewControllerEventProxyTable[vcId]:supportedInterfaceOrientations();
end

function UIViewController_viewDidPop(vcId)
    UIViewControllerEventProxyTable[vcId]:viewDidPop();
end



