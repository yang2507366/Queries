require "UIView"
require "UIFont"

UILabel = {};
UILabel.__index = UILabel;
setmetatable(UILabel, UIView);

-- constructor
function UILabel:createWithTitle(title)
    if title == nil then
        title = "";
    end
    local labelId = ui::createLabel(title, "0, 0, 200, 17");
    return UILabel:get(labelId);
end

function UILabel:get(labelId)
    local label = UIView:get(labelId);
    setmetatable(label, self);
    
    return label:autorelease();
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

function UILabel:heightOfText(width)
    local height = ui::heightOfLabelText(self:id(), width);
    
    return height;
end

function UILabel:setNumberOfLines(numberOfLines)
    runtime::invokeMethod(self:id(), "setNumberOfLines:", numberOfLines);
end