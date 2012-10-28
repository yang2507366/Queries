
NavigationItem = {};
NavigationItem.__index = NavigationItem;

function NavigationItem:new(nid)
    if nid == nil then
        nid = runtime::createObject("UINavigationItem", "initWithTitle:", "");
    end

    local ni = ObjectCreate(nid);
    setmetatable(ni, NavigationItem);
    
    return ni;
end

-- instance methods
function NavigationItem:setTitle(title)
    runtime::invokeMethod(self.id, "setTitle:", title);
end

function NavigationItem:rightBarButtonItem()
    local ri = runtime::invokeMethod(self.id, "rightBarButtonItem");
    local bi = BarButtonItem:new(ri);
    return bi;
end

function NavigationItem:setRightBarButtonItem(btnItem)
    runtime::invokeMethod(self.id, "setRightBarButtonItem:", btnItem.id);
end