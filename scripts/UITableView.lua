require "UIView"
require "UITableViewCell"
require "Recyclable"

UITableView = {};
UITableView.__index = UITableView;
setmetatable(UITableView, UIView);

-- constant
UITableViewStylePlain = 0;
UITableViewStyleGrouped = 1;

-- constructor
function UITableView:createWithStyle(style)
    if style == nil then
        style = UITableViewStylePlain;
    end
    local tableViewId = ui::createTableView("0, 0, 0, 0",
                                            "event_proxy_tableView_numberOfRows",
                                            "event_proxy_tableView_cellForRowAtIndex",
                                            "event_proxy_tableView_didSelectCell",
                                            "event_proxy_tableView_heightForRow");
    local tableView = self:get(tableViewId);
    tableView_numberOfRows_proxy[tableViewId] = tableView;
    tableView_cellForRowAtIndex_proxy[tableViewId] = tableView;
    tableView_didSelectCell_proxy[tableViewId] = tableView;
    tableView_heightForRow_proxy[tableViewId] = tableView;
    
    return tableView;
end

function UITableView:get(tableViewId)
    local tableView = UIView:new(tableViewId);
    setmetatable(tableView, self);
    
    return tableView;
end

function UITableView:create()
    return UITableView:createWithStyle();
end

-- instance method
function UITableView:dequeueReusableCellWithIdentifier(identifier)
    print("destart");
    local cellId = runtime::invokeMethod(self:id(), "dequeueReusableCellWithIdentifier:", identifier);
    if string.len(cellId) == 0 then
        return nil;
    end
    local cell = UITableViewCell:get(cellId);
    print("dequeue:"..cell:id());
    
    return cell;
end

function UITableView:reloadData()
    runtime::invokeMethod(self:id(), "reloadData");
end

function UITableView:deselectRow(rowIndex)
    local indexPathId = runtime::invokeClassMethod("NSIndexPath", "indexPathForRow:inSection:", rowIndex, 0);
    runtime::invokeMethod(self:id(), "deselectRowAtIndexPath:animated:", indexPathId, "YES");
    releaseObjectById(indexPathId);
end

function UITableView:tableHeaderView()
    local viewId = runtime::invokeMethod(self:id(), "tableHeaderView");
    return UIView:get(viewId):autorelease();
end

function UITableView:setTableHeaderView(view)
    runtime::invokeMethod(self:id(), "setTableHeaderView:", view:id());
end

function UITableView:setSeparatorStyle(style)
    runtime::invokeMethod(self:id(), "setSeparatorStyle:", style);
end

-- event
function UITableView:numberOfRows()
    return 0;
end

function UITableView:cellForRowAtIndex(rowIndex)
    return nil;
end

function UITableView:didSelectCellAtIndex(rowIndex)
    
end

function UITableView:heightOfRowAtIndex(rowIndex)
    return 44;
end

-- event proxy
tableView_numberOfRows_proxy = {};
tableView_cellForRowAtIndex_proxy = {};
tableView_didSelectCell_proxy = {};
tableView_heightForRow_proxy = {};

function event_proxy_tableView_numberOfRows(tableViewId)
    return tableView_numberOfRows_proxy[tableViewId]:numberOfRows();
end

function event_proxy_tableView_cellForRowAtIndex(tableViewId, rowIndex)
    return tableView_cellForRowAtIndex_proxy[tableViewId]:cellForRowAtIndex(rowIndex):id();
end

function event_proxy_tableView_didSelectCell(tableViewId, rowIndex)
    tableView_didSelectCell_proxy[tableViewId]:didSelectCellAtIndex(rowIndex);
end

function event_proxy_tableView_heightForRow(tableViewId, rowIndex)
    return tableView_heightForRow_proxy[tableViewId]:heightOfRowAtIndex(rowIndex);
end