require "UIView"

UITextField = {};
UITextField.__index = UITextField;
setmetatable(UITextField, UIView);

function UITextField:create()
    local textFieldId = ui::createTextField();
end

function UITextField:get(textFieldId)
    local textField = UIView:new(textFieldId);
    setmetatable(textField, self);
    
    return textField;
end