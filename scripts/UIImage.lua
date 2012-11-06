require "Object"

UIImage = {};
UIImage.__index = UIImage;
setmetatable(UIImage, Object);

function UIImage:imageNamed(imgName)

end

function UIImage:imageWithData(data)

end

function UIImage:get(imgId)
    local img = Object:new(imgId);
    setmetatable(img, self);
    
    return img;
end

function UIImage:size()
    
end