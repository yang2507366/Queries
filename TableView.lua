import TableViewEventProxy.lua;

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
    local tableView = {};
    setmetatable(tableView, TableView);
    tableView.x = x;
    tableView.y = y;
    tableView.width = width;
    tableView.height = height;
    
    tableView.objectId = ui::createTableView(x..", "..y..", "..width..", "..height, 
        "_global_tableView_numberOfRows", 
        "_global_tableView_cellForRowAtIndex", 
        "_global_tableView_didSelectCell");
    tableView_numberOfRows[tableView.objectId] = tableView;
    tableView_cellForRowAtIndex[tableView.objectId] = tableView;
    tableView_didSelectCell[tableView.objectId] = tableView;

    return tableView;
end

function TableView:numberOfRows()
    return 0;
end

function TableView:cellForRowAtIndex(rowIndex)

end

function TableView:didSelectRowAtIndex(rowIndex)
    
end

function TableView:setRowHeight(rowHeight)
    runtime::invokeMethod(self.objectId, "setRowHeight:", "100.0f");
end

function TableView:reloadData()
    runtime::invokeMethod(self.objectId, "reloadData");
end