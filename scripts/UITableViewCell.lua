require "UIView"
require "UILabel"

UITableViewCell = {};
UITableViewCell.__index = UITableViewCell;
setmetatable(UITableViewCell, UIView);

-- constructor
function UITableViewCell:create(reuseIdentifier)
    if reuseIdentifier == nil then
        return nil;
    end
    local cellId = runtime::createObject("UITableViewCell", "initWithStyle:reuseIdentifier:", "1", self.reuseIdentifier);
    
    return self:get(cellId);
end

function UITableViewCell:get(cellId)
    local cell = UIView:new(cellId);
    setmetatable(cell, self);
    
    return cell;
end

-- instance methods
function UITableViewCell:textLabel()
    local labelId = runtime::invokeMethod(self:id(), "textLabel");
    return UILabel:get(labelId):autorelease();
end