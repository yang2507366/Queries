local TableViewCell = {};
TableViewCell.__index = TableViewCell;

TableViewCell.reuseIdentifier = "";

function TableViewCell:new(reuseIdentifier)
    if reuseIdentifier ~= nil then
        self.reuseIdentifier = reuseIdentifier;
    end
    local cellId = runtime::createObject("UITableViewCell", "initWithStyle:reuseIdentifier:", "1", self.reuseIdentifier);
    local cell = ObjectCreate(cellId);
    setmetatable(cell, TableViewCell);
    
    return cell;
end

function TableViewCell:reusable(cellId)
    if cellId == nil then
        return nil;
    end
    local cell = ObjectCreate(cellId);
    setmetatable(cell, TableViewCell);
    
    return cell;
end