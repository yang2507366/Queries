require "Object"

UIFont = {};
UIFont.__index = UIFont;
setmetatable(UIFont, Object);

-- constructor
function UIFont:create(fontSize, bold--[[option]])
    local fontId = nil;
    if bold ~= nil and bold then
        fontId = runtime::invokeClassMethod("UIFont", "boldSystemFontOfSize:", fontSize);
    else
        fontId = runtime::invokeClassMethod("UIFont", "systemFontOfSize:", fontSize);
    end
    
    return self:get(fontId);
end

function UIFont:get(fontId)
    local font = Object:new(fontId);
    setmetatable(font, self);
    
    return font;
end

-- instance methods
function UIFont:lineHeight()
    return tonumber(runtime::invokeMethod(self:id(), "lineHeight"));
end