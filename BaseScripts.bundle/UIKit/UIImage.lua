require "Object"
require "AppBundle"

UIImage = {};
UIImage.__index = UIImage;
setmetatable(UIImage, Object);

function UIImage:imageNamed(imgName)
    local imgId = runtime::invokeClassMethod("UIImage", "imageNamed:", imgName);
    return UIImage:get(imgId);
end

function UIImage:imageWithData(data, scale)
    if scale == nil then
        scale = 1.0;
    end
    local imgId = runtime::invokeClassMethod("UIImage", "imageWithData:scale:", data:id(), scale);
    return UIImage:get(imgId);
end

function UIImage:imageWithResName(resName, scale)
    if not scale then
        local screenId = runtime::invokeClassMethod("UIScreen", "mainScreen");
        local scale = runtime::invokeMethod(screenId, "scale");
        scale = tonumber(scale);
    end
    local beginIndex = string.find(resName, "@2x");
    if scale == 2.0 and beginIndex == nil  then
        beginIndex = tonumber(ustring::find(resName, ".", ustring::length(resName) - 1, true));
        if beginIndex == -1 then
            resName = resName.."@2x";
        else
            resName = ustring::substring(resName, 0, beginIndex).."@2x"..ustring::substring(resName, beginIndex, ustring::length(resName));
        end
    end
    local ab = AppBundle:current();
    local data = ab:dataFromResource(resName);
    if data then
        return UIImage:imageWithData(data, scale);
    end
    return nil;
end

function UIImage:get(imgId)
    local img = Object:new(imgId);
    setmetatable(img, UIImage);
    
    return img;
end

function UIImage:size()
    local imgSize = runtime::invokeMethod(self:id(), "size");
    
end