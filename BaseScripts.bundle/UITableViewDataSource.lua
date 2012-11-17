require "Object"

UITableViewDataSource = {};
UITableViewDataSource.__index = UITableViewDataSource;
setmetatable(UITableViewDataSource, Object);

function UITableViewDataSource:numberOfRowsInSection(section)
    return nil;
end

function UITableViewDataSource:cellForRowAtIndexPath(indexPath)
    return nil;
end

function UITableViewDataSource:numberOfSections()
    return nil;
end

function UITableViewDataSource:titleForHeaderInSection(section)
    return nil;
end

function UITableViewDataSource:titleForFooterInSection(section)
    return nil;
end

function UITableViewDataSource:canEditRowAtIndexPath(indexPath)
    return nil;
end

function UITableViewDataSource:canMoveRowAtIndexPath(indexPath)
    return nil;
end

function UITableViewDataSource:sectionIndexTitles()
    return nil;
end

function UITableViewDataSource:sectionForSectionIndexTitle(title, index)
    return nil;
end

function UITableViewDataSource:commitEditingStyle(editingStyle, indexPath)
    return nil;
end

function UITableViewDataSource:moveRowAtIndexPath(sourceIndexPath, destinationIndexPath)
    return nil;
end