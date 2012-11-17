require "UIView"
require "UILabel"
require "System"

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
function UIButton:create(title)
    return UIButton:create(title, UIButtonTypeRoundedRect);
end

function UIButton:create(title, buttonType)
    if title == nil then
        title = "Untitled";
    end
    if buttonType == nil then
        buttonType = UIButtonTypeRoundedRect;
    end
    local buttonId = runtime::invokeClassMethod("Button", "create:type:", System.id());
    local button = UIButton:get(buttonId);
    
    button:setTitle(title);
    
    return button;
end

function UIButton:get(buttonId)
    local button = UIView:new(buttonId);
    setmetatable(button, self);
    
    UIButtonEventProxyTable[buttonId] = button;
    
    return button;
end

-- deconstructor
function UIButton:dealloc()
    UIButtonEventProxyTable[self:id()] = nil;
end

-- instance methods
function UIButton:setTitle(title, state)
    if state == nil then
        state = UIControlStateNormal;
    end
    runtime::invokeMethod(self:id(), "setTitle:forState:", title, state);
end

function UIButton:titleLabel()
    local labelId = runtime::invokeMethod(self:id(), "titleLabel");
    return UILabel:get(labelId);
end

-- events
function UIButton:tapped()
    
end

-- event proxy
UIButtonEventProxyTable = {};

function event_proxy_button_tapped(buttonId)
    UIButtonEventProxyTable[buttonId]:tapped();
end