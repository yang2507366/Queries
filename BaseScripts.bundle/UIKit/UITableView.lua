require "UIView"
require "AppContext"
require "UITableViewCell"
require "UITableViewDataSource"
require "UITableViewDelegate"
require "NSIndexPath"

UITableView = {};
UITableView.__index = UITableView;
setmetatable(UITableView, UIView);

-- constant
UITableViewStylePlain = 0;
UITableViewStyleGrouped = 1;

UITableViewCellEditingStyleNone = 0;
UITableViewCellEditingStyleDelete = 1;
UITableViewCellEditingStyleInsert = 2;

-- constructor
function UITableView:createWithStyle(style)
    if style == nil then
        style = UITableViewStylePlain;
    end
    local tableViewId = runtime::invokeClassMethod("LITableView", "create", AppContext.current());
    local tableView = self:get(tableViewId);
    
    return tableView;
end

function UITableView:create()
    return UITableView:createWithStyle(UITableViewStylePlain);
end

function UITableView:get(tableViewId)
    local tableView = UIView:new(tableViewId);
    setmetatable(tableView, self);
    UITableViewEventProxyTable[tableViewId] = tableView;
    
    return tableView;
end

-- deconstructor
function UITableView:dealloc()
    UIView.dealloc(self);
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
        runtime::invokeMethod(self:id(), "setCanEditRowAtIndexPath:", "UITableViewDataSource_canEditRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setCanEditRowAtIndexPath:", "");
    end
    
    if dataSource.canMoveRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setCanMoveRowAtIndexPath:", "UITableViewDataSource_canMoveRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setCanMoveRowAtIndexPath:", "");
    end
    
    if dataSource.sectionIndexTitles then
        runtime::invokeMethod(self:id(), "setSectionIndexTitles:", "UITableViewDataSource_sectionIndexTitles");
    else
        runtime::invokeMethod(self:id(), "setSectionIndexTitles:", "");
    end
    
    if dataSource.sectionForSectionIndexTitle then
        runtime::invokeMethod(self:id(), "setSectionForSectionIndexTitle:", "UITableViewDataSource_sectionForSectionIndexTitle");
    else
        runtime::invokeMethod(self:id(), "setSectionForSectionIndexTitle:", "");
    end
    
    if dataSource.commitEditingStyle then
        runtime::invokeMethod(self:id(), "setCommitEditingStyle:", "UITableViewDataSource_commitEditingStyle");
    else
        runtime::invokeMethod(self:id(), "setCommitEditingStyle:", "");
    end
    
    if dataSource.moveRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setMoveRowAtIndexPath:", "UITableViewDataSource_moveRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setMoveRowAtIndexPath:", "");
    end
end

function UITableView:setDelegate(delegate)
    self.delegate = delegate;
    
    if delegate.willDisplayCell then
        runtime::invokeMethod(self:id(), "setWillDisplayCell:", "UITableViewDelegate_willDisplayCell");
    else
        runtime::invokeMethod(self:id(), "setWillDisplayCell:", "");
    end
    
    if delegate.willDisplayHeaderView then
        runtime::invokeMethod(self:id(), "setWillDisplayHeaderView:", "UITableViewDelegate_willDisplayHeaderView");
    else
        runtime::invokeMethod(self:id(), "setWillDisplayHeaderView:", "");
    end
    
    if delegate.willDisplayFooterView then
        runtime::invokeMethod(self:id(), "setWillDisplayFooterView:", "UITableViewDelegate_willDisplayFooterView");
        else
        runtime::invokeMethod(self:id(), "setWillDisplayFooterView:", "");
    end
    
    if delegate.willDisplayCell then
        runtime::invokeMethod(self:id(), "setDidEndDisplayingCell:", "UITableViewDelegate_didEndDisplayingCell");
        else
        runtime::invokeMethod(self:id(), "setDidEndDisplayingCell:", "");
    end
    
    if delegate.didEndDisplayingHeaderView then
        runtime::invokeMethod(self:id(), "setDidEndDisplayingHeaderView:", "UITableViewDelegate_didEndDisplayingHeaderView");
        else
        runtime::invokeMethod(self:id(), "setDidEndDisplayingHeaderView:", "");
    end
    
    if delegate.didEndDisplayingFooterView then
        runtime::invokeMethod(self:id(), "setDidEndDisplayingFooterView:", "UITableViewDelegate_didEndDisplayingFooterView");
        else
        runtime::invokeMethod(self:id(), "setDidEndDisplayingFooterView:", "");
    end
    
    if delegate.heightForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setHeightForRowAtIndexPath:", "UITableViewDelegate_heightForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setHeightForRowAtIndexPath:", "");
    end
    
    if delegate.heightForHeaderInSection then
        runtime::invokeMethod(self:id(), "setHeightForHeaderInSection:", "UITableViewDelegate_heightForHeaderInSection");
    else
        runtime::invokeMethod(self:id(), "setHeightForHeaderInSection:", "");
    end
    
    if delegate.heightForFooterInSection then
        runtime::invokeMethod(self:id(), "setHeightForFooterInSection:", "UITableViewDelegate_heightForFooterInSection");
    else
        runtime::invokeMethod(self:id(), "setHeightForFooterInSection:", "");
    end
    
    if delegate.viewForHeaderInSection then
        runtime::invokeMethod(self:id(), "setViewForHeaderInSection:", "UITableViewDelegate_viewForHeaderInSection");
    else
        runtime::invokeMethod(self:id(), "setViewForHeaderInSection:", "");
    end
    
    if delegate.viewForFooterInSection then
        runtime::invokeMethod(self:id(), "setViewForFooterInSection:", "UITableViewDelegate_viewForFooterInSection");
    else
        runtime::invokeMethod(self:id(), "setViewForFooterInSection:", "");
    end
    
    if delegate.accessoryButtonTappedForRowWithIndexPath then
        runtime::invokeMethod(self:id(), "setAccessoryButtonTappedForRowWithIndexPath:",
                              "UITableViewDelegate_accessoryButtonTappedForRowWithIndexPath");
    else
        runtime::invokeMethod(self:id(), "setAccessoryButtonTappedForRowWithIndexPath:","");
    end
    
    if delegate.shouldHighlightRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setShouldHighlightRowAtIndexPath:", "UITableViewDelegate_shouldHighlightRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setShouldHighlightRowAtIndexPath:", "");
    end
    
    if delegate.didHighlightRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setDidHighlightRowAtIndexPath:", "UITableViewDelegate_didHighlightRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setDidHighlightRowAtIndexPath:", "");
    end
    
    if delegate.didUnhighlightRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setDidUnhighlightRowAtIndexPath:", "UITableViewDelegate_didUnhighlightRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setDidUnhighlightRowAtIndexPath:", "");
    end
    
    if delegate.willSelectRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setWillSelectRowAtIndexPath:", "UITableViewDelegate_willSelectRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setWillSelectRowAtIndexPath:", "");
    end
    
    if delegate.willDeselectRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setWillDeselectRowAtIndexPath:", "UITableViewDelegate_willDeselectRowAtIndexPath");
        else
        runtime::invokeMethod(self:id(), "setWillDeselectRowAtIndexPath:", "");
    end
    
    if delegate.didSelectRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setDidSelectRowAtIndexPath:", "UITableViewDelegate_didSelectRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setDidSelectRowAtIndexPath:", "");
    end
    
    if delegate.didDeselectRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setDidDeselectRowAtIndexPath:", "UITableViewDelegate_didDeselectRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setDidDeselectRowAtIndexPath:", "");
    end
    
    if delegate.editingStyleForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setEditingStyleForRowAtIndexPath:", "UITableViewDelegate_editingStyleForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setEditingStyleForRowAtIndexPath:", "");
    end
    
    if delegate.titleForDeleteConfirmationButtonForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setTitleForDeleteConfirmationButtonForRowAtIndexPath:", "UITableViewDelegate_titleForDeleteConfirmationButtonForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setTitleForDeleteConfirmationButtonForRowAtIndexPath:", "");
    end
    
    if delegate.shouldIndentWhileEditingRowAtIndexPath then
       runtime::invokeMethod(self:id(), "setShouldIndentWhileEditingRowAtIndexPath:", "UITableViewDelegate_shouldIndentWhileEditingRowAtIndexPath");
    else
       runtime::invokeMethod(self:id(), "setShouldIndentWhileEditingRowAtIndexPath:", "");
    end
    
    if delegate.willBeginEditingRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setWillBeginEditingRowAtIndexPath:", "UITableViewDelegate_willBeginEditingRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setWillBeginEditingRowAtIndexPath:", "");
    end
    
    if delegate.didEndEditingRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setDidEndEditingRowAtIndexPath:", "UITableViewDelegate_didEndEditingRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setDidEndEditingRowAtIndexPath:", "");
    end
    
    if delegate.targetIndexPathForMoveFromRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setTargetIndexPathForMoveFromRowAtIndexPath:", "UITableViewDelegate_targetIndexPathForMoveFromRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setTargetIndexPathForMoveFromRowAtIndexPath:", "");
    end
    
    if delegate.indentationLevelForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setIndentationLevelForRowAtIndexPath:", "UITableViewDelegate_indentationLevelForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setIndentationLevelForRowAtIndexPath:", "");
    end
    
    if delegate.shouldShowMenuForRowAtIndexPath then
        runtime::invokeMethod(self:id(), "setShouldShowMenuForRowAtIndexPath:", "UITableViewDelegate_shouldShowMenuForRowAtIndexPath");
    else
        runtime::invokeMethod(self:id(), "setShouldShowMenuForRowAtIndexPath:", "");
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

function UITableView:setEditing(editing)
    runtime::invokeMethod(self:id(), "setEditing:", toObjCBool(editing));
end

function UITableView:reloadData()
    runtime::invokeMethod(self:id(), "reloadData");
end

function UITableView:deselectRowAtIndexPath(indexPath)
    runtime::invokeMethod(self:id(), "deselectRowAtIndexPath:animated:", indexPath:id(), toObjCBool(true));
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

-- dataSource
function UITableViewDataSource_numberOfRowsInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    if tb and tb.dataSource then
        ap_new();
        local rows = tb.dataSource:numberOfRowsInSection(tb, tonumber(section));
        ap_release();
        return rows;
    end
end

function UITableViewDataSource_cellForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId):keep();
        local cellId = tb.dataSource:cellForRowAtIndexPath(tb, indexPath):id();
        ap_release();
        return cellId;
    end
end

function UITableViewDataSource_numberOfSections(tableViewId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local sections = tb.dataSource:numberOfSections(tb);
        ap_release();
        return sections;
    end
end

function UITableViewDataSource_titleForHeaderInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local title = tb.dataSource:titleForHeaderInSection(tb, tonumber(section));
        ap_release();
        return title;
    end
end

function UITableViewDataSource_titleForFooterInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local title = tb.dataSource:titleForFooterInSection(tb, tonumber(section));
        ap_release();
        return title;
    end
end

function UITableViewDataSource_canEditRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId);
        local can = toObjCBool(tb.dataSource:canEditRowAtIndexPath(tb, indexPath));
        ap_release();
        return can;
    end
end

function UITableViewDataSource_canMoveRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId);
        local can = toObjCBool(tb.dataSource:canMoveRowAtIndexPath(tb, indexPath));
        ap_release();
        return can;
    end
end

function UITableViewDataSource_sectionIndexTitles(tableViewId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local titlesId = tb.dataSource:sectionIndexTitles(tb):id();
        ap_release();
        return titlesId;
    end
end

function UITableViewDataSource_sectionForSectionIndexTitle(tableViewId, title, index)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local section = tb.dataSource:sectionForSectionIndexTitle(tb, title, tonumber(index));
        ap_release();
        return section;
    end
end

function UITableViewDataSource_commitEditingStyle(tableViewId, editingStyle, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local indexPath = NSIndexPath:get(indexPathId);
        tb.dataSource:commitEditingStyle(tb, tonumber(editingStyle), indexPath);
        ap_release();
    end
end

function UITableViewDataSource_moveRowAtIndexPath(tableViewId, sourceIndexPathId, destinationIndexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.dataSource then
        ap_new();
        local sourceIndexPath = NSIndexPath:get(sourceIndexPathId);
        local destinationIndexPath = NSIndexPath:get(destinationIndexPathId);
        tb.dataSource:moveRowAtIndexPath(tb, sourceIndexPath, destinationIndexPath);
        ap_release();
    end
end

-- delegate
function UITableViewDelegate_willDisplayCell(tableViewId, cellId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:willDisplayCell(tb, UITableViewCell:get(cellId), NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_willDisplayHeaderView(tableViewId, viewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:willDisplayHeaderView(tb, UIView:get(viewId), section);
        ap_release();
    end
end

function UITableViewDelegate_willDisplayFooterView(tableViewId, viewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:willDisplayFooterView(tb, UIView:get(viewId), section);
        ap_release();
    end
end

function UITableViewDelegate_didEndDisplayingCell(tableViewId, cellId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didEndDisplayingCell(tb, UITableViewCell:get(cellId), NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_didEndDisplayingHeaderView(tableViewId, viewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didEndDisplayingHeaderView(tb, UIView:get(viewId), section);
        ap_release();
    end
end

function UITableViewDelegate_didEndDisplayingFooterView(tableViewId, viewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didEndDisplayingFooterView(tb, UIView:get(viewId), section);
        ap_release();
    end
end

function UITableViewDelegate_heightForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local height = tb.delegate:heightForRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
        return height;
    end
end

function UITableViewDelegate_heightForHeaderInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local height = tb.delegate:heightForHeaderInSection(tb, section);
        ap_release();
        return height;
    end
end

function UITableViewDelegate_heightForFooterInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local height = tb.delegate:heightForFooterInSection(tb, section);
        ap_release();
        return height;
    end
end

function UITableViewDelegate_viewForHeaderInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local view = tb.delegate:viewForHeaderInSection(tb, section);
        local viewId = "";
        if view and view.id then
            viewId = view:id();
        end
        ap_release();
        return viewId;
    end
end

function UITableViewDelegate_viewForFooterInSection(tableViewId, section)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local view = tb.delegate:viewForFooterInSection(tb, section);
        local viewId = "";
        if view and view.id then
            viewId = view:id();
        end
        ap_release();
        return viewId;
    end
end

function UITableViewDelegate_accessoryButtonTappedForRowWithIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:accessoryButtonTappedForRowWithIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_shouldHighlightRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local should = toObjCBool(tb.delegate:shouldHighlightRowAtIndexPath(tb, NSIndexPath:get(indexPathId)));
        ap_release();
        return should;
    end
end

function UITableViewDelegate_didHighlightRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didHighlightRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_didUnhighlightRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didUnhighlightRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_willSelectRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local newIndexPath = tb.delegate:willSelectRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        local newIndexPathId = "";
        if newIndexPath and newIndexPath.id then
            newIndexPathId = newIndexPath:id();
        end
        ap_release();
        return newIndexPathId;
    end
end

function UITableViewDelegate_willDeselectRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local newIndexPath = tb.delegate:willDeselectRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        local newIndexPathId = "";
        if newIndexPath and newIndexPath.id then
            newIndexPathId = newIndexPath:id();
        end
        ap_release();
        return newIndexPathId;
    end
end

function UITableViewDelegate_didSelectRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didSelectRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_didDeselectRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didDeselectRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_editingStyleForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local style = tb.delegate:editingStyleForRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
        return style;
    end
end

function UITableViewDelegate_titleForDeleteConfirmationButtonForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local title = tb.delegate:titleForDeleteConfirmationButtonForRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
        return title;
    end
end

function UITableViewDelegate_shouldIndentWhileEditingRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local should = toObjCBool(tb.delegate:shouldIndentWhileEditingRowAtIndexPath(tb, NSIndexPath:get(indexPathId)));
        ap_release();
        return should;
    end
end

function UITableViewDelegate_willBeginEditingRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:willBeginEditingRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_didEndEditingRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        tb.delegate:didEndEditingRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
    end
end

function UITableViewDelegate_targetIndexPathForMoveFromRowAtIndexPath(tableViewId, sourceIndexPathId, destinationIndexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local resultIndexPath = tb.delegate:targetIndexPathForMoveFromRowAtIndexPath(tb, NSIndexPath:get(sourceIndexPathId),
                                                                                     NSIndexPath:get(destinationIndexPathId));
        local resultIndexPathId = "";
        if resultIndexPath and resultIndexPath.id then
            resultIndexPathId = resultIndexPath:id();
        end
        ap_release();
        return resultIndexPathId;
    end
end

function UITableViewDelegate_indentationLevelForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local level = tb.delegate:indentationLevelForRowAtIndexPath(tb, NSIndexPath:get(indexPathId));
        ap_release();
        return level;
    end
end

function UITableViewDelegate_shouldShowMenuForRowAtIndexPath(tableViewId, indexPathId)
    local tb = UITableViewEventProxyTable[tableViewId];
    
    if tb and tb.delegate then
        ap_new();
        local should = toObjCBool(tb.delegate:shouldShowMenuForRowAtIndexPath(tb, NSIndexPath:get(indexPathId)));
        ap_release();
        return should;
    end
end
