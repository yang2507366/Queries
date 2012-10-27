tableView_numberOfRows = {};
tableView_cellForRowAtIndex = {};
tableView_didSelectCell = {};

function _global_tableView_numberOfRows(tableViewId)
    return tableView_numberOfRows[tableViewId]:numberOfRows();
end

function _global_tableView_cellForRowAtIndex(tableViewId, rowIndex)
    tableView_cellForRowAtIndex[tableViewId]:cellForRowAtIndex(rowIndex);
end

function _global_tableView_didSelectCell(tableViewId, rowIndex)
    tableView_didSelectCell[tableViewId]:didSelectRowAtIndex(rowIndex);
end