require "UIView"
require "UILabel"
require "UIImageView"

UITableViewCell = {};
UITableViewCell.__index = UITableViewCell;
setmetatable(UITableViewCell, UIView);

-- constant
UITableViewCellSeparatorStyleNone = 0;
UITableViewCellSeparatorStyleSingleLine = 1;
UITableViewCellSeparatorStyleSingleLineEtched = 2;

UITableViewCellAccessoryNone = 0;
UITableViewCellAccessoryDisclosureIndicator = 1;
UITableViewCellAccessoryDetailDisclosureButton = 2;
UITableViewCellAccessoryCheckmark = 3;

-- constructor
function UITableViewCell:create(reuseIdentifier)
    if reuseIdentifier == nil then
        return nil;
    end
    local cellId = runtime::createObject("UITableViewCell", "initWithStyle:reuseIdentifier:", "1", reuseIdentifier);
    
    return self:get(cellId);
end

function UITableViewCell:get(cellId)
    local cell = UIView:new(cellId);
    setmetatable(cell, self);
    
    return cell;
end

function UITableViewCell:dealloc()
    UIView.dealloc(self);
end

-- instance methods
function UITableViewCell:textLabel()
    local labelId = runtime::invokeMethod(self:id(), "textLabel");
    return UILabel:get(labelId);
end

function UITableViewCell:contentView()
    local viewId = runtime::invokeMethod(self:id(), "contentView");
    
    return UIView:get(viewId);
end

function UITableViewCell:imageView()
    local imageViewId = runtime::invokeMethod(self:id(), "imageView");
    return UIImageView:get(imageViewId);
end

function UITableViewCell:setAccessoryType(accessoryType)
    runtime::invokeMethod(self:id(), "setAccessoryType", accessoryType);
end

function UITableViewCell:accessoryType()
    return runtime::invokeMethod(self:id(), "accessoryType");
end