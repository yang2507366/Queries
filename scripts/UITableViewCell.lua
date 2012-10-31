require "UIView"
require "UILabel"

UITableViewCell = {};
UITableViewCell.__index = UITableViewCell;
setmetatable(UITableViewCell, UIView);

function UITableViewCell:create(reuseIdentifier)
    if reuseIdentifier == nil then
        return nil;
    end
    local cellId = runtime::createObject("UITableViewCell", "initWithStyle:reuseIdentifier:", "1", self.reuseIdentifier);
    
end

function UITableViewCell:get(cellId)
    local cell = UIView:new(cellId);
    setmetatable(cell, self);
    
    return cell;
end

function UITableViewCell:textLabel()
    local labelId = runtime::invokeMethod(self:id(), "textLabel");
    return UILabel:get(labelId);
end