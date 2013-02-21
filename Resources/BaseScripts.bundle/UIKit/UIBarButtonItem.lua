require "Object"

UIBarButtonItem = {};
UIBarButtonItem.__index = UIBarButtonItem;
setmetatable(UIBarButtonItem, Object);

UIBarButtonItemStylePlain = 0;
UIBarButtonItemStyleBordered = 1;
UIBarButtonItemStyleDone = 2;

-- constructor
function UIBarButtonItem:create(title--[[option]])
    if title == nil then
        title = "Untitled";
    end
    local buttonItemId = runtime::invokeClassMethod("LIBarButtonItem", "create", AppContext.current());
    local buttonItem = self:get(buttonItemId);
    
    buttonItem:setTitle(title);
    
    return buttonItem;
end

function UIBarButtonItem:createWithSystemItem(systemItem)
    local objId = runtime::invokeClassMethod("LIBarButtonItem", "createWithAppId:systemItem:", AppContext.current(), systemItem);
    return self:get(objId);
end

function UIBarButtonItem:createWithImage(img)
    local objId = runtime::invokeClassMethod("LIBarButtonItem", "createWithAppId:image:", AppContext.current(), img:id());
    return self:get(objId);
end

function UIBarButtonItem:get(buttonItemId)
    local buttonItem = Object:new(buttonItemId);
    setmetatable(buttonItem, self);
    
    UIBarButtonItemEventProxyTable[buttonItemId] = buttonItem;
    runtime::invokeMethod(buttonItemId, "setTapped:", "UIBarButtonItem_tapped");
    
    return buttonItem;
end

-- deconstructor
function UIBarButtonItem:dealloc()
    runtime::invokeMethod(self:id(), "setTapped:", "");
    UIBarButtonItemEventProxyTable[self:id()] = nil;
    super:dealloc();
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

function UIBarButtonItem:setEnabled(enabled)
    runtime::invokeMethod(self:id(), "setEnabled:", toObjCBool(enabled));
end

function UIBarButtonItem:enabled()
    return toLuaBool(runtime::invokeMethod(self:id(), "enabled"));
end

-- event
function UIBarButtonItem:tapped()
end

-- event proxy
UIBarButtonItemEventProxyTable = {};

function UIBarButtonItem_tapped(btnId)
    UIBarButtonItemEventProxyTable[btnId]:tapped();
end