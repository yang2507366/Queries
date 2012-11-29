require "UIView"
require "UIFont"
require "AppContext"

UILabel = {};
UILabel.__index = UILabel;
setmetatable(UILabel, UIView);

-- constructor
function UILabel:create(text)
    if text == nil then
        text = "";
    end
    local labelId = runtime::invokeClassMethod("LILabel", "create:", AppContext.current());
    local label = UILabel:get(labelId);
    label:setText(text);
    
    return label;
end

function UILabel:get(labelId)
    local label = UIView:get(labelId);
    setmetatable(label, self);
    
    return label;
end

-- instance methods
function UILabel:setText(text)
    runtime::invokeMethod(self:id(), "setText:", text);
end

function UILabel:text()
    local strId = runtime::invokeMethod(self:id(), "text");
    return strId;
end

function UILabel:setFont(font)
    runtime::invokeMethod(self:id(), "setFont:", font:id());
end

function UILabel:font()
    local fontId = runtime::invokeMethod(self:id(), "font");
    
    return UIFont:get(fontId);
end

function UILabel:setNumberOfLines(numberOfLines)
    runtime::invokeMethod(self:id(), "setNumberOfLines:", numberOfLines);
end

function UILabel:setTextColor(color)
    runtime::invokeMethod(self:id(), "setTextColor:", color:id());
end

function UILabel:textColor()
    return UIColor:get(runtime::invokeMethod(self:id(), "textColor"));
end