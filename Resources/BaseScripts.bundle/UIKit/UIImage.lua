require "Object"
require "AppBundle"

UIImage = {};
UIImage.__index = UIImage;
setmetatable(UIImage, Object);

function UIImage:imageNamed(imgName)
    local imgId = runtime::invokeClassMethod("UIImage", "imageNamed:", imgName);
    return UIImage:get(imgId);
end

function UIImage:imageWithData(data, scale--[[option]])
    if scale == nil then
        scale = 1.0;
    end
    local imgId = runtime::invokeClassMethod("UIImage", "imageWithData:scale:", data:id(), scale);
    return UIImage:get(imgId);
end

function UIImage:imageWithResName(resName, scale--[[option]])
    if scale == nil then
        local screen = Object:new(runtime::invokeClassMethod("UIScreen", "mainScreen"));
        local scaleString = runtime::invokeMethod(screen:id(), "scale");
        scale = tonumber(scaleString);
    end
    
    local ab = AppBundle:current();
    
    local beginIndex = string.find(resName, "@2x");
    if scale == 2.0 and beginIndex == nil then
        beginIndex = tonumber(ustring::find(resName, ".", ustring::length(resName) - 1, true));
        local newResName = resName;
        if beginIndex == -1 then
            newResName = resName.."@2x";
            else
            newResName = ustring::substring(resName, 0, beginIndex).."@2x"..ustring::substring(resName, beginIndex, ustring::length(resName));
        end
        if ab:resourceExists(newResName) then
            resName = newResName;
        else
            scale = 1.0;
        end
    end
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
    local size = runtime::invokeMethod(self:id(), "size");
    local sizeTable = stringSplit(size, ",");
    return unpack(stringTableToNumberTable(sizeTable));
end

function UIImage:stretchableImage(leftWidth, topCapHeight)
    local newImgId = runtime::invokeMethod(self:id(), "stretchableImageWithLeftCapWidth:topCapHeight:", leftWidth, topCapHeight);
    return UIImage:get(newImgId);
end
