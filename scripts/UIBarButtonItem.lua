require "Object"

UIBarButtonItem = Object:new();
UIBarButtonItem.__index = UIBarButtonItem;
setmetatable(UIBarButtonItem, Object);

function UIBarButtonItem:createWithTitle(title)
    if title == nil then
        title = "Untitled";
    end
    local buttonItemId = ui::createBarButtonItem(title, "event_function_barButtonItem_tapped");
    local buttonItem = self:get(buttonItemId);
    
    event_table_barButtonItem_tapped[buttonItemId] = buttonItem;
    
    return buttonItem;
end

function UIBarButtonItem:get(buttonItemId)
    local buttonItem = Object:new(buttonItemId);
    setmetatable(buttonItem, self);
    
    return buttonItem;
end

function UIBarButtonItem:setTitle(title)
    runtime::invokeMethod(self.id, "setTitle:", title);
end

function UIBarButtonItem:tapped()
    
end

-- event proxy
event_table_barButtonItem_tapped = {};

function event_function_barButtonItem_tapped(btnId)
    event_table_barButtonItem_tapped[btnId]:tapped();
end