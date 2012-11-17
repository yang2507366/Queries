require "Object"

UIBarButtonItem = {};
UIBarButtonItem.__index = UIBarButtonItem;
setmetatable(UIBarButtonItem, Object);

UIBarButtonItemStylePlain = 0;
UIBarButtonItemStyleBordered = 1;
UIBarButtonItemStyleDone = 2;

-- constructor
function UIBarButtonItem:create(title)
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

-- deconstructor
function UIBarButtonItem:dealloc()
    event_table_barButtonItem_tapped[self:id()] = nil;
end

-- instance methods
function UIBarButtonItem:setTitle(title)
    runtime::invokeMethod(self:id(), "setTitle:", title);
end

function UIBarButtonItem:setStyle(style)
    runtime::invokeMethod(self:id(), "setStyle:", style);
end

function UIBarButtonItem:style()
    return tonumber(runtime::invokeMethod(self:id(), "style"));
end

-- event
function UIBarButtonItem:tapped()
    
end

-- event proxy
event_table_barButtonItem_tapped = {};

function event_function_barButtonItem_tapped(btnId)
    event_table_barButtonItem_tapped[btnId]:tapped();
end