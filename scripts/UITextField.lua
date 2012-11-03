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
    ui::attachTextFieldDelegate(textFieldId,
                                "epf_textFieldShouldBeginEditing",
                                "epf_textFieldDidBeginEditing",
                                "epf_textFieldShouldEndEditing",
                                "epf_textFieldDidEndEditing",
                                "epf_shouldChangeCharactersInRange");
    eventProxyTable_textField[textFieldId] = textField;
    
    return textField;
end

-- deconstructor
function UITextField:dealloc()
    eventProxyTable_textField[self:id()] = nil;
end

-- instance methods
function UITextField:setClearButtonMode(mode)
    runtime::invokeMethod(self:id(), "setClearButtonMode", mode);
end

function UITextField:text()
    return runtime::invokeMethod(self:id(), "text");
end

function UITextField:setText(str)
    runtime::invokeMethod(self:id(), str);
end

-- event
function UITextField:shouldBeginEditing()
    return "YES";
end

function UITextField:didBeginEditing()
    
end

function UITextField:shouldEndEditing()
    return "YES";
end

function UITextField:didEndEditing()
    
end

function UITextField:shouldChangeCharactersInRange(location, length)
    return "YES";
end

-- event proxy
eventProxyTable_textField = {};

function epf_textFieldShouldBeginEditing(textFieldId)
    return eventProxyTable_textField[textFieldId]:shouldBeginEditing();
end

function epf_textFieldDidBeginEditing(textFieldId)
    eventProxyTable_textField[textFieldId]:didBeginEditing();
end

function epf_textFieldShouldEndEditing(textFieldId)
    local textField = eventProxyTable_textField[textFieldId];
    if textField then
        return textField:shouldEndEditing();
    end
    return "YES";
end

function epf_textFieldDidEndEditing(textFieldId)
    local textField = eventProxyTable_textField[textFieldId];
    if textField then
        return textField:didEndEditing();
    end
end

function epf_shouldChangeCharactersInRange(textFieldId, location, length)
    return eventProxyTable_textField[textFieldId]:shouldChangeCharactersInRange(tonumber(location), tonumber(length));
end
