require "UIView"
require "UILabel"

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
function UIButton:createWithTitle(title)
    return UIButton:create(title, UIButtonTypeRoundedRect);
end

function UIButton:create(title, buttonType)
    if title == nil then
        title = "Untitled";
    end
    if buttonType == nil then
        buttonType = UIButtonTypeRoundedRect;
    end
    local buttonId = ui::createButton(buttonType, "event_proxy_button_tapped");
    local button = UIButton:get(buttonId);
    button_tap_event_proxy[buttonId] = button;
    
    button:setTitle(title);
    
    return button;
end

function UIButton:get(buttonId)
    local button = UIView:new(buttonId);
    setmetatable(button, self);
    
    return button;
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
button_tap_event_proxy = {};

function event_proxy_button_tapped(buttonId)
    button_tap_event_proxy[buttonId]:tapped();
end