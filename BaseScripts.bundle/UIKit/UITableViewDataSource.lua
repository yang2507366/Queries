require "Object"

UITableViewDataSource = {};

function UITableViewDataSource:numberOfRowsInSection(tableView, section)
end

function UITableViewDataSource:cellForRowAtIndexPath(tableView, indexPath)
end

function UITableViewDataSource:numberOfSections(tableView)
end

function UITableViewDataSource:titleForHeaderInSection(tableView, section)
end

function UITableViewDataSource:titleForFooterInSection(tableView, section)
end

function UITableViewDataSource:canEditRowAtIndexPath(tableView, indexPath)
end

function UITableViewDataSource:canMoveRowAtIndexPath(tableView, indexPath)
end

function UITableViewDataSource:sectionIndexTitles(tableView)
end

function UITableViewDataSource:sectionForSectionIndexTitle(tableView, title, index)
end

function UITableViewDataSource:commitEditingStyle(tableView, editingStyle, indexPath)
end

function UITableViewDataSource:moveRowAtIndexPath(tableView, sourceIndexPath, destinationIndexPath)
end