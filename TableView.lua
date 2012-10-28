import TableViewEventProxy.lua;
import TableViewCell.lua;

TableView = {};
TableView.__index = TableView;

function TableView:new(x, y, width, height)
    if x == nil then
        x = 0;
    end
    if y == nil then
        y = 0;
    end
    if width == nil then
        width = 320;
    end
    if height == nil then
        height = 460;
    end
    
    local tableViewId = ui::createTableView(x..", "..y..", "..width..", "..height, 
        "_global_tableView_numberOfRows", 
        "_global_tableView_cellForRowAtIndex", 
        "_global_tableView_didSelectCell", 
        "_global_tableView_heightForRow");
    
    local tableView = ObjectCreate(tableViewId);
    setmetatable(tableView, TableView);
    tableView.x = x;
    tableView.y = y;
    tableView.width = width;
    tableView.height = height;
    
    tableView_numberOfRows[tableView.id] = tableView;
    tableView_cellForRowAtIndex[tableView.id] = tableView;
    tableView_didSelectCell[tableView.id] = tableView;
    tableView_heightForRow[tableView.id] = tableView;

    return tableView;
end

function TableView:numberOfRows()
    return 0;
end

function TableView:cellForRowAtIndex(rowIndex)

end

function TableView:didSelectRowAtIndex(rowIndex)
    
end

function TableView:heightForRowAtIndex(rowIndex)
    return 44;
end

-- instance mtehods
function TableView:setRowHeight(rowHeight)
    runtime::invokeMethod(self.id, "setRowHeight:", "100.0f");
end

function TableView:reloadData()
    runtime::invokeMethod(self.id, "reloadData");
end

function TableView:dequeueReusableCellWithIdentifier(identifier)
    local cellId = runtime::invokeMethod(self.id, "dequeueReusableCellWithIdentifier", identifier);
    if string.len(cellId) == 0 then
        return nil;
    end
    
    local cell = TableViewCell:reusable(cellId);
    return cell;
end

function TableView:deselectRow(rowIndex)
    local indexPath = runtime::invokeClassMethod("NSIndexPath", "indexPathForRow:inSection:", rowIndex, 0);
    runtime::invokeMethod(self.id, "deselectRowAtIndexPath:animated:", indexPath, "YES");
    ObjectReleaseById(indexPath);
end



