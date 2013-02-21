require "UIView"
require "UILabel"
require "AppContext"
require "CommonUtils"

UIButton = {};
UIButton.__index = UIButton;
setmetatable(UIButton, UIView);

-- button types
UIButtonTypeCustom = 0;
UIButtonTypeRoundedRect = 1;
UIButtonTypeDetailDisclosure = 2;
UIButtonTypeInfoLight = 3;
UIButtonTypeInfoDark = 4;
UIButtonTypeContactAdd = 5;

-- constructor
function UIButton:create(title--[[option]], buttonType--[[option]])
    if title == nil then
        title = "";
    end
    if buttonType == nil then
        buttonType = UIButtonTypeRoundedRect;
    end
    local buttonId = runtime::invokeClassMethod("LIButton", "create:type:", AppContext.current(), buttonType);
    local button = UIButton:get(buttonId);
    
    button:setTitle(title);
    
    return button;
end

function UIButton:get(buttonId)
    local button = UIView:new(buttonId);
    setmetatable(button, self);
    
    UIButtonEventProxyTable[buttonId] = button;
    runtime::invokeClassMethod("LIButton", "attachTappedEvent:func:", buttonId, "UIButton_tapped");
    
    return button;
end

-- deconstructor
function UIButton:dealloc()
    UIButtonEventProxyTable[self:id()] = nil;
    runtime::invokeClassMethod("LIButton", "remove:", self:id());
    super:dealloc();
end

-- instance methods
function UIButton:setTitle(title, state--[[option]])
    if state == nil then
        state = UIControlStateNormal;
    end
    runtime::invokeMethod(self:id(), "setTitle:forState:", title, state);
end

function UIButton:titleLabel()
    local labelId = runtime::invokeMethod(self:id(), "titleLabel");
    return UILabel:get(labelId);
end

function UIButton:setEnabled(enabled)
    runtime::invokeMethod(self:id(), "setEnabled:", toObjCBool(enabled));
end

function UIButton:enabled()
    return toLuaBool(runtime::invokeMethod(self:id(), "enabled"));
end

function UIButton:setImage(img, state--[[option]])
    if not state then
        state = 0;
    end
    runtime::invokeMethod(self:id(), "setImage:forState:", img:id(), state);
end

function UIButton:imageForState(state)
    return UIImage:get(runtime::invokeMethod(self:id(), "imageForState:", state));
end

function UIButton:currentImage()
    return UIImage:get(runtime::invokeMethod(self:id(), "currentImage"));
end

function UIButton:imageEdgeInsets()
    return unpack(stringTableToNumberTable(stringSplit(runtime::invokeMethod(self:id(), "imageEdgeInsets"), ",")))
end

function UIButton:setImageEdgeInsets(top, left, bottom, right)
    runtime::invokeMethod(self:id(), "setImageEdgeInsets:", top..","..left..","..bottom..","..right);
end

-- events
function UIButton:tapped()
end

-- event proxy
UIButtonEventProxyTable = {};

function UIButton_tapped(buttonId)
    local button = UIButtonEventProxyTable[buttonId];
    if button then
        button:tapped()
    end
end