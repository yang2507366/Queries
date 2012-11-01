require "UIView"

UITextField = {};
UITextField.__index = UITextField;
setmetatable(UITextField, UIView);

-- constant
UITextFieldViewModeNever = 0;
UITextFieldViewModeWhileEditing = 1;
UITextFieldViewModeUnlessEditing = 2;
UITextFieldViewModeAlways = 3;

-- constructor
function UITextField:create()
    local textFieldId = ui::createTextField();
    
    return self:get(textFieldId);
end

function UITextField:get(textFieldId)
    local textField = UIView:new(textFieldId);
    setmetatable(textField, self);
    
    return textField:autorelease();
end

function UITextField:setClearButtonMode(mode)
    runtime::invokeMethod(self:id(), "setClearButtonMode", mode);
end