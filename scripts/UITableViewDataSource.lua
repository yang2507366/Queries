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