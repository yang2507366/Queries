require "Object"
require "UIColor"
require "CommonUtils"
require "AppContext"

UIView = {};
UIView.__index = UIView;
setmetatable(UIView, Object);

-- constant
UIViewAutoresizingNone = 0;
UIViewAutoresizingFlexibleLeftMargin = 1;
UIViewAutoresizingFlexibleWidth = 2;
UIViewAutoresizingFlexibleRightMargin = 4;
UIViewAutoresizingFlexibleTopMargin = 8;
UIViewAutoresizingFlexibleHeight = 16;
UIViewAutoresizingFlexibleBottomMargin = 32;

UIControlStateNormal = 0;
UIControlStateHighlighted = 1;
UIControlStateDisabled = 2;
UIControlStateSelected = 4;
UIControlStateApplication = 0x00FF0000;
UIControlStateReserved = 0xFF000000;

-- constructor
function UIView:create()
    local viewId = runtime::invokeClassMethod("LIView", "create:", AppContext.current());
    return self:get(viewId);
end

function UIView:get(viewId)
    local view = Object:new(viewId);
    setmetatable(view, self);
    
    return view;
end

function UIView:dealloc()
    super:dealloc();
end

-- instance methods
function UIView:setFrame(x, y, width, height)
    local frame = x..","..y..","..width..","..height;
    runtime::invokeMethod(self:id(), "setFrame:", frame);
end

function UIView:frame()
    local frame = runtime::invokeMethod(self:id(), "frame");
    
    return unpack(stringTableToNumberTable(stringSplit(frame, ",")));
end

function UIView:bounds()
    local bounds = runtime::invokeMethod(self:id(), "bounds");
    
    return unpack(stringTableToNumberTable(stringSplit(bounds, ",")));
end

function UIView:setBackgroundColor(color)
	runtime::invokeMethod(self:id(), "setBackgroundColor:", color:id());
end

function UIView:backgroundColor()
    local colorId = runtime::invokeMethod(self:id(), "backgroundColor");
    return UIColor:get(colorId);
end

function UIView:addSubview(subview)
    runtime::invokeMethod(self:id(), "addSubview:", subview:id());
end

function UIView:setAutoresizingMask(mask)
    runtime::invokeMethod(self:id(), "setAutoresizingMask:", mask);
end

function UIView:autoresizingMask()
    return tonumber(runtime::invokeMethod(self:id(), "autoresizingMask"));
end

function UIView:resignFirstResponder()
    runtime::invokeMethod(self:id(), "resignFirstResponder");
end

function UIView:becomeFirstResponder()
    runtime::invokeMethod(self:id(), "becomeFirstResponder");
end

function UIView:viewWithTag(tag, viewType)
    local viewId = runtime::invokeMethod(self:id(), "viewWithTag:", tag);
    if isObjCObject(viewId) then
        local view = UIView:get(viewId);
        if viewType then
            setmetatable(view, viewType);
        end
        return view;
    end
    return nil;
end

function UIView:setTag(tag)
    runtime::invokeMethod(self:id(), "setTag:", tag);
end

function UIView:tag()
    local tag = runtime::invokeMethod(self:id(), "tag");
    return tonumber(tag);
end

function UIView:contentMode()
    return tonumber(runtime::invokeMethod(self:id(), "contentMode"));
end

function UIView:setContentMode(mode)
    runtime::invokeMethod(self:id(), "setContentMode:", mode);
end

function UIView:setUserInteractionEnabled(enabled)
    runtime::invokeMethod(self:id(), "setUserInteractionEnabled:", toObjCBool(enabled));
end

function UIView:userInteractionEnabled()
    local enabled = runtime::invokeMethod(self:id(), "userInteractionEnabled");
    return toLuaBool(enabled);
end

function UIView:setHidden(hidden)
    runtime::invokeMethod(self:id(), "setHidden:", toObjCBool(hidden));
end

function UIView:hidden()
    local hidden = runtime::invokeMethod(self:id(), "hidden");
    return toLuaBool(hidden);
end

function UIView:addGestureRecognizer(gr)
    runtime::invokeMethod(self:id(), "addGestureRecognizer:", gr:id());
end

function UIView:removeGestureRecognizer(gr)
    runtime::invokeMethod(self:id(), "removeGestureRecognizer:", gr:id());
end
