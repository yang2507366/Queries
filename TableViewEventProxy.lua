tableView_numberOfRows = {};
tableView_cellForRowAtIndex = {};
tableView_didSelectCell = {};
tableView_heightForRow = {};

function _global_tableView_numberOfRows(tableViewId)
    return tableView_numberOfRows[tableViewId]:numberOfRows();
end

function _global_tableView_cellForRowAtIndex(tableViewId, rowIndex)
    return tableView_cellForRowAtIndex[tableViewId]:cellForRowAtIndex(rowIndex);
end

function _global_tableView_didSelectCell(tableViewId, rowIndex)
    tableView_didSelectCell[tableViewId]:didSelectRowAtIndex(rowIndex);
end

function _global_tableView_heightForRow(tableViewId, rowIndex)
    return tableView_heightForRow[tableViewId]:heightForRowAtIndex(rowIndex);
end