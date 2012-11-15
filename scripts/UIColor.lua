require "Object"

UIColor = {};
UIColor.__index = UIColor;
setmetatable(UIColor, Object);

-- constructor
function UIColor:create(red, green, blue, alpha)
    if not alpha then
        alpha = 1;
    end
    local colorId = runtime::invokeClassMethod("UIColor", "colorWithRed:green:blue:alpha:",
                                               tostring(red / 255), tostring(green / 255), tostring(blue / 255), tostring(alpha));
    local color = self:get(colorId);
    
    return color;
end

function UIColor:get(colorId)
    local color = Object:new(colorId);
    setmetatable(color, self);
    
    return color;
end