require "UIViewController"
require "AppContext"
require "NSArray"

UITabBarControllerDelegate = {};

function UITabBarControllerDelegate:shouldSelectViewController(tabBarController)
    return true;
end

function UITabBarControllerDelegate:didSelectViewController(tabBarController)
end

UITabBarController = {};
UITabBarController.__index = UITabBarController;
setmetatable(UITabBarController, UIViewController);

function UITabBarController:create()
    local objId = runtime::invokeClassMethod("LITabBarController", "create:", AppContext.current());
    return self:get(objId);
end

function UITabBarController:get(objId)
    local obj = UIViewController:new(objId);
    setmetatable(obj, self);
    UITabBarControllerEventProxyTable[objId] = obj;
    
    return obj;
end

function UITabBarController:delloc()
    UITabBarControllerEventProxyTable[self:id()] = nil;
    UIViewController.dealloc(self);
end

function UITabBarController:setDelegate(delegate)
    self.delegate = delegate;
    
    if delegate and delegate.shouldSelectViewController then
        runtime::invokeMethod(self:id(), "setShouldSelectViewController:", "UITabBarController_shouldSelectViewController");
    else
        runtime::invokeMethod(self:id(), "setShouldSelectViewController:", "");
    end
    
    if delegate and delegate.didSelectViewController then
        runtime::invokeMethod(self:id(), "setDidSelectViewController:", "UITabBarController_didSelectViewController");
    else
        runtime::invokeMethod(self:id(), "setDidSelectViewController:", "");
    end
end

function UITabBarController:setViewControllers(viewControllers)
    runtime::invokeMethod(self:id(), "setViewControllers:", viewControllers:id());
end

function UITabBarController:viewControllers()
    local vcsId = runtime::invokeMethod(self:id(), "viewControllers");
    if string.len(vcsId) ~= 0 then
        return NSArray:get(vcsId);
    end
end

function UITabBarController:setSelectedIndex(selectedIndex)
    runtime::invokeMethod(self:id(), "setSelectedIndex:", selectedIndex);
end

function UITabBarController:selectedIndex()
    return tonumber(runtime::invokeMethod(self:id(), "selectedIndex"));
end

UITabBarControllerEventProxyTable = {};

function UITabBarController_shouldSelectViewController(objId)
    local obj = UITabBarControllerEventProxyTable[objId];
    if obj and obj.delegate then
        return toObjCBool(obj.delegate:shouldSelectViewController(obj));
    end
end

function UITabBarController_didSelectViewController(objId)
    local obj = UITabBarControllerEventProxyTable[objId];
    if obj and obj.delegate then
        toObjCBool(obj.delegate:didSelectViewController(obj));
    end
end