require "UIView"
require "System"
require "UITableViewCell"
require "UITableViewDataSource"
require "NSIndexPath"

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
    local tableViewId = runtime::invokeClassMethod("TableView", "create", System.id());
    local tableView = self:get(tableViewId);
    
    return tableView;
end

function UITableView:create()
    return UITableView:createWithStyle();
end

function UITableView:get(tableViewId)
    local tableView = UIView:new(tableViewId);
    setmetatable(tableView, self);
    UITableViewEventProxyTable[tableViewId] = tableView;
    
    return tableView;
end

-- deconstructor
function UITableView:dealloc()
end

-- instance method
function UITableView:setDataSource(dataSource)
    self.dataSource = dataSource;
    
    if dataSource.numberOfRowsInSection then
        runtime::invokeMethod(self:id(), "setNumberOfRowsInSection:", "UITableViewDataSource_numberOfRowsInSection");
    else
        runtime::invokeMethod(self:id(), "setNumberOfRowsInSection:", "");
    end
    
    if dataSource.cellForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setCellForRowAtIndexPath:", "UITableViewDataSource_cellForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setCellForRowAtIndexPath:", "");
    end
    
    if dataSource.numberOfSections then
        runtime::invokeMethod(self:id(), "setNumberOfSections:", "UITableViewDataSource_numberOfSections");
    else
        runtime::invokeMethod(self:id(), "setNumberOfSections:", "");
    end
    
    if dataSource.titleForHeaderInSection then
        runtime::invokeMethod(self:id(), "setTitleForHeaderInSection:", "UITableViewDataSource_titleForHeaderInSection");
    else
        runtime::invokeMethod(self:id(), "setTitleForHeaderInSection:", "");
    end
    
    if dataSource.titleForFooterInSection then
        runtime::invokeMethod(self:id(), "setTitleForFooterInSection:", "UITableViewDataSource_titleForFooterInSection");
    else
        runtime::invokeMethod(self:id(), "setTitleForFooterInSection:", "");
    end
    
    if dataSource.canEditRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setCanEditRowAtIndexPath", "UITableViewDataSource_canEditRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setCanEditRowAtIndexPath", "");
    end
end

function UITableView:dequeueReusableCellWithIdentifier(identifier)
    local cellId = runtime::invokeMethod(self:id(), "dequeueReusableCellWithIdentifier:", identifier);
    if string.len(cellId) == 0 then
        return nil;
    end
    local cell = UITableViewCell:get(cellId);
    
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

-- event proxy
UITableViewEventProxyTable = {};

function UITableViewDataSource_numberOfRowsInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    if tb and tb.dataSource then
        return tb.dataSource:numberOfRowsInSection(tonumber(section));
    end
end

function UITableViewDataSource_cellForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId):keep();
        ap_release();
        return tb.dataSource:cellForRowAtIndexPath(indexPath):id();
    end
end

function UITableViewDataSource_numberOfSections(tableViewId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        return tb.dataSource:numberOfSections();
    end
end

function UITableViewDataSource_titleForHeaderInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        return tb.dataSource:titleForHeaderInSection(tonumber(section));
    end
end

function UITableViewDataSource_titleForFooterInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        return tb.dataSource:titleForFooterInSection(tonumber(section));
    end
end

function UITableViewDataSource_canEditRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId):keep();
        ap_release();
        return toObjCBool(tb.dataSource:canEditRowAtIndexPath(indexPath));
    end
end
