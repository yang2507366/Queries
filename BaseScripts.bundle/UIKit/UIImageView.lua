require "UIView"

UIImageView = {};
UIImageView.__index = UIImageView;
setmetatable(UIImageView, UIView);

function UIImageView:create()
    local imgViewId = runtime::createObject("UIImageView", "init");
    return self:get(imgViewId);
end

function UIImageView:createWithImage(image)
    local imgView = self:create();
    imgView:setImage(image);
    return imgView;
end

function UIImageView:get(imgViewId)
    local imgView = UIView:new(imgViewId);
    setmetatable(imgView, self);
    
    return imgView;
end

-- instance methods
function UIImageView:setImage(image)
    if image then
        runtime::invokeMethod(self:id(), "setImage:", image:id());
    else
        runtime::invokeMethod(self:id(), "setImage:", "");
    end
end

function UIImageView:image()
    local imgViewId = runtime::invokeMethod(self:id(), "image");
    if string.len(imgViewId) == 0 then
        return nil;
    end
    return UIImage:get(imgViewId);
end