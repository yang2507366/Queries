require "Object"

UIColor = Object:new();
UIColor.__index = UIColor;
setmetatable(UIColor, Object);

function UIColor:createWithRGBA(red, green, blue, alpha)
    local colorId = runtime::invokeClassMethod("UIColor", "colorWithRed:green:blue:alpha:",
                                               tostring(red / 255), tostring(green / 255), tostring(blue / 255), tostring(alpha));
    local color = Object:new(colorId);
    setmetatable(color, self);
    
    return color;
end

function UIColor:createWithRGB(red, green, blue)
    return UIColor:createWithRGBA(red, green, blue, 1);
end