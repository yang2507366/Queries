require "Object"
require "UIView"
require "UINavigationItem"
require "AppContext"
require "CommonUtils"
require "NSArray"

UIViewController = {};
UIViewController.__index = UIViewController;
setmetatable(UIViewController, Object);

-- constructor
function UIViewController:create(title)
    if title == nil then
        title = "Untitled";
    end
    local vcId = runtime::invokeClassMethod("LIViewController", "create:", AppContext.current());
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

function UIViewController:relatedNavigationController()
    local relatedVCId = ui::getRelatedViewController();
    if string.len(relatedVCId) ~= 0 then
        return UINavigationController:get(relatedVCId);
    end
end

function UIViewController:pushToRelatedViewController()
    local relatedVCId = ui::getRelatedViewController();
    if string.len(relatedVCId) ~= 0 then
        UIViewController:get(relatedVCId):navigationController():pushViewController(self, true);
    end
end

function UIViewController:presentViewController(vc, animated)
    runtime::invokeMethod(self:id(), "presentViewController:animated:completion:", vc:id(), toObjCBool(animated));
end

function UIViewController:dismissViewController(animated)
    runtime::invokeMethod(self:id(), "dismissViewControllerAnimated:completion:", toObjCBool(animated));
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
    
    if waiting then
        runtime::invokeClassMethod("Waiting", "showWaiting:inView:", "YES", self:view():id());
    else
        runtime::invokeClassMethod("Waiting", "showWaiting:inView:", "NO", self:view():id());
    end
    
end

function UIViewController:setLoading(loading)
    
    if loading then
        runtime::invokeClassMethod("Waiting", "showLoading:inView:", "YES", self:view():id());
    else
        runtime::invokeClassMethod("Waiting", "showLoading:inView:", "NO", self:view():id());
    end
    
end

function UIViewController:setTitle(title)
    runtime::invokeMethod(self:id(), "setTitle:", title);
end

function UIViewController:title()
    return runtime::invokeMethod(self:id(), "title");
end

function UIViewController:setHidesBottomBarWhenPushed(hide)
    runtime::invokeMethod(self:id(), "setHidesBottomBarWhenPushed:", toObjCBool(hide));
end

function UIViewController:setToolbarItems(items)
    runtime::invokeMethod(self:id(), "setToolbarItems:", items:id());
end

function UIViewController:toolbarItems()
    local objId = runtime::invokeMethod(self:id(), "toolbarItems");
    if string.len(objId) ~= 0 then
        return NSArray:get(objId);
    end
end

function UIViewController:tabBarController()
    return UITabBarController:get(runtime::invokeMethod(self:id(), "tabBarController"));
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
    return false;
end

function UIViewController:supportedInterfaceOrientations()
    return 30;--UIInterfaceOrientationMaskAll
end

function UIViewController:viewDidPop()
end

function UIViewController:contentSizeForViewInPopover()
    return unpack(stringSplit(runtime::invokeMethod(self:id(), "contentSizeForViewInPopover")));
end

function UIViewController:setContentSizeForViewInPopover(width, height)
    runtime::invokeMethod(self:id(), "setContentSizeForViewInPopover:", width..","..height);
end

-- event proxy

UIViewControllerEventProxyTable = {};

function UIViewController_loadView(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:loadView();
        
    end
end

function UIViewController_viewDidLoad(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewDidLoad();
        
    end
end

function UIViewController_viewWillAppear(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewWillAppear();
        
    end
end

function UIViewController_viewDidAppear(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewDidAppear();
        
    end
end

function UIViewController_viewWillDisappear(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewWillDisappear();
        
    end
end

function UIViewController_viewDidDisappear(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewDidDisappear();
        
    end
end

function UIViewController_didReceiveMemoryWarning(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:didReceiveMemoryWarning();
        
    end
end

function UIViewController_shouldAutorotate(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        local should = toObjCBool(vc:shouldAutorotate());
        
        return should;
    end
end

function UIViewController_supportedInterfaceOrientations(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        local b = vc:supportedInterfaceOrientations();
        
        return b;
    end
end

function UIViewController_viewDidPop(vcId)
    local vc = UIViewControllerEventProxyTable[vcId];
    if vc then
        
        vc:viewDidPop();
        
    end
end



