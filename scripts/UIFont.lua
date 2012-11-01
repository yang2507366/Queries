require "Object"

UIFont = {};
UIFont.__index = UIFont;
setmetatable(UIFont, Object);

-- constructor
function UIFont:createWithFontSize(fontSize)
    local fontId = runtime::invokeClassMethod("UIFont", "systemFontOfSize:", fontSize);
    
    return self:get(fontId);
end

function UIFont:createWithBoldFontSize(fontSize)
    local fontId = runtime::invokeClassMethod("UIFont", "boldSystemFontOfSize:", fontSize);
    
    return self:get(fontId);
end

function UIFont:get(fontId)
    local font = Object:new(fontId);
    setmetatable(font, self);
    
    return font:autorelease();
end

-- instance methods
function UIFont:lineHeight()
    return runtime::invokeMethod(self:id(), "lineHeight");
end