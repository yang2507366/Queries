require "Object"

UIDialog = {};
UIDialog.__index = UIDialog;
setmetatable(UIDialog, Object);

function UIDialog:create(title, message, cancelButtonTitle, ...)
    local obj = Object:new(tostring(math::random()));
    setmetatable(obj, self);
    
    UIDialogEventProxyTable[obj:id()] = obj;
    ui::dialog_c(title, message, cancelButtonTitle, "UIDialog_dismiss", obj:id(), ...);
    
    return obj;
end

function UIDialog:dealloc()
    UIDialogEventProxyTable[self:id()] = nil;
    super:dealloc();
end

function UIDialog:dismiss(buttonIndex, buttonTitle)

end

UIDialogEventProxyTable = {};

function UIDialog_dismiss(dialogId, buttonIndex, buttonTitle)
    local dialog = UIDialogEventProxyTable[dialogId];
    if dialog then
        dialog:dismiss(tonumber(buttonIndex), buttonTitle);
    end
end