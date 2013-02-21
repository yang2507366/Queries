require "Object"
require "AppContext"
require "CommonUtils"

UIPopoverController = {};
UIPopoverController.__index = UIPopoverController;
setmetatable(UIPopoverController, Object);

function UIPopoverController:create(vc)
    local objId = runtime::invokeClassMethod("LIPopoverController", "create:contentViewController:", AppContext.current(), vc:id());
    return self:get(objId);
end

function UIPopoverController:get(objId)
    local obj = Object:new(objId);
    setmetatable(obj, self);
    
    UIPopoverControllerEventProxyTable[objId] = obj;
    runtime::invokeMethod(objId, "setShouldDismiss:", "UIPopoverController_shouldDismiss");
    runtime::invokeMethod(objId, "setDidDismiss:", "UIPopoverController_didDismiss");
    
    return obj;
end

function UIPopoverController:dealloc()
    UIPopoverControllerEventProxyTable[self:id()] = nil;
    super:dealloc();
end

function UIPopoverController:dismiss(animated--[[option]])
    runtime::invokeMethod(self:id(), "dismissPopoverAnimated:", toObjCBool(animated));
end

function UIPopoverController:presentFromBarButtonItem(barButtonItem, arrowDirection, animated--[[option]])
    runtime::invokeMethod(self:id(), "presentPopoverFromBarButtonItem:permittedArrowDirections:animated:", barButtonItem:id(), arrowDirection, toObjCBool(animated));
end

function UIPopoverController:popoverContentSize()
    return unpack(stringSplit(runtime::invokeMethod(self:id(), "popoverContentSize"), ","));
end

function UIPopoverController:setPopoverContentSize(width, height)
    runtime::invokeMethod(self:id(), "setPopoverContentSize:", width..","..height);
end

function UIPopoverController:shouldDismiss()
    return true;
end

function UIPopoverController:didDismiss()

end

function UIPopoverController:popoverVisible()
    return toLuaBool(runtime::invokeMethod(self:id(), "isPopoverVisible"));
end

UIPopoverControllerEventProxyTable = {};

function UIPopoverController_shouldDismiss(objId)
    local obj = UIPopoverControllerEventProxyTable[objId];
    if obj then
        return toObjCBool(obj:shouldDismiss());
    end
    return toObjCBool(true);
end

function UIPopoverController_didDismiss(objId)
    local obj = UIPopoverControllerEventProxyTable[objId];
    if obj then
        obj:didDismiss();
    end
end