require "Object"

class(UIAlertView);

function UIAlertView:create(title, message, cancelButtonTitle, ...--[[other titles]])
    local obj = Object:new(tostring(math::random()));
    setmetatable(obj, self);
    
    UIAlertViewEventProxyTable[obj:id()] = obj;
    ui::dialog_c(title, message, cancelButtonTitle, "UIAlertView_dismiss", obj:id(), ...);
    
    return obj;
end

function UIAlertView:dealloc()
    UIAlertViewEventProxyTable[self:id()] = nil;
    super:dealloc();
end

function UIAlertView:dismiss(buttonIndex, buttonTitle)

end

UIAlertViewEventProxyTable = {};

function UIAlertView_dismiss(dialogId, buttonIndex, buttonTitle)
    local dialog = UIAlertViewEventProxyTable[dialogId];
    if dialog then
        dialog:dismiss(tonumber(buttonIndex), buttonTitle);
    end
end