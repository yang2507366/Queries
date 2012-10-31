require "Object"
require "UIColor"

UIView = {};
UIView.__index = UIView;
setmetatable(UIView, Object);

-- constants
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

-- instance methods
function UIView:create()
    local viewId = runtime::createObject("UIView", "init");
    return self:get(viewId);
end

function UIView:get(viewId)
    local view = Object:new(viewId);
    setmetatable(view, self);
    
    return view;
end

function UIView:setFrame(x, y, width, height)
    local frame = x..","..y..","..width..","..height;
    ui::setViewFrame(self:id(), frame);
end

function UIView:frame()
    local frame = ui:getViewFrame(self:id());
    return frame;
end

function UIView:bounds()
    local bds = ui::getViewBounds(self:id());
    
    return bds;
end

function UIView:setBackgroundColor(color)
	runtime::invokeMethod(self:id(), "setBackgroundColor:", color:id());
end

function UIView:backgroundColor()
    local colorId = runtime::invokeMethod(self:id(), "backgroundColor");
    return UIColor:get(colorId);
end

function UIView:addSubview(subview)
    ui::addSubview(self:id(), subview:id());
end

function UIView:setAutoresizingMask(mask)
    runtime::invokeMethod(self:id(), "setAutoresizingMask:", mask);
end

function UIView:autoresizingMask()
    return runtime::invokeMethod(self:id(), "autoresizingMask");
end
