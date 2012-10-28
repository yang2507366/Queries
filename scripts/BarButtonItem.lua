import BarButtonItemEventProxy.lua;

BarButtonItem = {};
BarButtonItem.__index = BarButtonItem;

function BarButtonItem:new(btnId)
    if btnId == nil then
        btnId = ui::createBarButtonItem("", "event_function_barButtonItem_tapped");
    end
    local btnItem = ObjectCreate(btnId);
    setmetatable(btnItem, BarButtonItem);

    event_table_barButtonItem_tapped[btnItem.id] = btnItem;
    
    return btnItem;
end

function BarButtonItem:setTitle(title)
    runtime::invokeMethod(self.id, "setTitle:", title);
end

function BarButtonItem:setStyle(style)
	runtime::invokeMethod(self.id, "setStyle:", style);
end

function BarButtonItem:tapped()
    
end