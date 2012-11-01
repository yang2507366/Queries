require "Object"

UIColor = {};
UIColor.__index = UIColor;
setmetatable(UIColor, Object);

-- constructor
function UIColor:createWithRGBA(red, green, blue, alpha)
    local colorId = runtime::invokeClassMethod("UIColor", "colorWithRed:green:blue:alpha:",
                                               tostring(red / 255), tostring(green / 255), tostring(blue / 255), tostring(alpha));
    local color = self:get(colorId);
    
    return color;
end

function UIColor:createWithRGB(red, green, blue)
    return UIColor:createWithRGBA(red, green, blue, 1);
end

function UIColor:get(colorId)
    local color = Object:new(colorId);
    setmetatable(color, self);
    
    return color:autorelease();
end