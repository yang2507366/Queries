require "Object"
require "AppContext"
require "CommonUtils"

UIGestureRecognizer = {};
UIGestureRecognizer.__index = UIGestureRecognizer;
setmetatable(UIGestureRecognizer, Object);

UITapGestureRecognizer = "UITapGestureRecognizer";
UIPinchGestureRecognizer = "UIPinchGestureRecognizer";
UIRotationGestureRecognizer = "UIRotationGestureRecognizer";
UISwipeGestureRecognizer = "UISwipeGestureRecognizer";
UIPanGestureRecognizer = "UIPanGestureRecognizer";
UILongPressGestureRecognizer = "UILongPressGestureRecognizer";

function UIGestureRecognizer:create(gestureRecognizerClassName)
    local objId = runtime::invokeClassMethod("LIGestureRecognizer", "create:className:", AppContext.current(), gestureRecognizerClassName);
    return self:get(objId);
end

function UIGestureRecognizer:get(objId)
    local obj = Object:new(objId);
    setmetatable(obj, self);
    runtime::invokeClassMethod("LIGestureRecognizer", "setCallbackFuncNameForGR:funcName:", objId, "UIGestureRecognizer_action");
    UIGestureRecognizerEventProxyTable[objId] = obj;
    return obj;
end

function UIGestureRecognizer:dealloc()
    UIGestureRecognizerEventProxyTable[self:id()] = nil;
    self:removeAssociatedObject();
    Object.dealloc(self);
end

-- instance methods
function UIGestureRecognizer:state()
    return tonumber(runtime::invokeMethod(self:id(), "state"));
end

function UIGestureRecognizer:view()
    local objId = runtime::invokeMethod(self:id(), "view");
    return UIView:get(objId);
end

function UIGestureRecognizer:locationInView(view)
    local point = runtime::invokeMethod(self:id(), "locationInView:", view:id());
    return unpack(stringTableToNumberTable(stringSplit(point, ",")));
end

-- event
function UIGestureRecognizer:action()
    
end

UIGestureRecognizerEventProxyTable = {};

function UIGestureRecognizer_action(grId)
    local obj = UIGestureRecognizerEventProxyTable[grId];
    if obj then
        obj:action();
    end
end