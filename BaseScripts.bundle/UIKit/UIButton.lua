require "UIView"
require "UILabel"
require "AppContext"

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
    runtime::invokeClassMethod("Button", "remove:", self:id());
    UIView.dealloc(self);
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

function UIButton_tapped(buttonId)
    local button = UIButtonEventProxyTable[buttonId];
    if button then
        button:tapped()
    end
end