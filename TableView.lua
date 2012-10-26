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
    return tableView;
end

function TableView:numberOfRows()
    
end