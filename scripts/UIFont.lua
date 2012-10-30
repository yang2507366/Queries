require "Object"

UIFont = Object:new();
UIFont.__index = UIFont;
setmetatable(UIFont, Object);

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
    
    return font;
end

function UIFont:lineHeight()
    return runtime::invokeMethod(self:id(), "lineHeight");
end