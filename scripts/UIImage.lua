require "Object"
require "AppBundle"

UIImage = {};
UIImage.__index = UIImage;
setmetatable(UIImage, Object);

function UIImage:imageNamed(imgName)
    local imgId = runtime::invokeClassMethod("UIImage", "imageNamed:", imgName);
    return self:get(imgId);
end

function UIImage:imageWithData(data)
    local imgId = runtime::invokeClassMethod("UIImage", "imageWithData:", data:id());
    return self:get(imgId);
end

function UIImage:imageWithResName(resName)
    local ab = AppBundle:get();
    local data = ab:dataFromResource(resName);
    if data then
        return self:imageWithData(ab:dataFromResource(resName));
    end
    return nil;
end

function UIImage:get(imgId)
    local img = Object:new(imgId);
    setmetatable(img, self);
    
    return img;
end

function UIImage:size()
    local imgSize = runtime::invokeMethod(self:id(), "size");
    
end