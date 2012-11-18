require "UIView"
require "UITextFieldDelegate"

UITextField = {};
UITextField.__index = UITextField;
setmetatable(UITextField, UIView);

-- constant
UITextFieldViewModeNever = 0;
UITextFieldViewModeWhileEditing = 1;
UITextFieldViewModeUnlessEditing = 2;
UITextFieldViewModeAlways = 3;

UIKeyboardTypeDefault                   = 0; -- Default type for the current input method.
UIKeyboardTypeASCIICapable              = 1; -- Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
UIKeyboardTypeNumbersAndPunctuation     = 2; -- Numbers and assorted punctuation.
UIKeyboardTypeURL                       = 3; -- A type optimized for URL entry (shows . / .com prominently).
UIKeyboardTypeNumberPad                 = 4; -- A number pad (0-9). Suitable for PIN entry.
UIKeyboardTypePhonePad                  = 5; -- A phone pad (1-9, *, 0, #, with letters under the numbers).
UIKeyboardTypeNamePhonePad              = 6; -- A type optimized for entering a person's name or phone number.
UIKeyboardTypeEmailAddress              = 7; -- A type optimized for multiple email address entry (shows space @ . prominently).
UIKeyboardTypeDecimalPad                = 8; -- A number pad with a decimal point.
UIKeyboardTypeTwitter                   = 9;


-- constructor
function UITextField:create()
    local textFieldId = ui::createTextField();
    
    return self:get(textFieldId);
end

function UITextField:get(textFieldId)
    local textField = UIView:new(textFieldId);
    setmetatable(textField, self);
    
    UITextFieldEventProxyTable[textFieldId] = textField;
    
    return textField;
end

-- deconstructor
function UITextField:dealloc()
    UITextFieldEventProxyTable[self:id()] = nil;
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

function UITextField:setKeyboardType(ktype)
    runtime::invokeMethod(self:id(), "setKeyboardType:", ktype);
end

function UITextField:keyboardType()
    return tonumber(runtime::invokeMethod(self:id(), "keyboardType"));
end

-- event
function UITextField:shouldBeginEditing()
    return "YES";
end

function UITextField:didBeginEditing()
    
end

function UITextField:shouldEndEditing()
    return true;
end

function UITextField:didEndEditing()
    
end

function UITextField:shouldChangeCharactersInRange(location, length)
    return true;
end

-- event proxy
UITextFieldEventProxyTable = {};

function epf_textFieldShouldBeginEditing(textFieldId)
    local b = UITextFieldEventProxyTable[textFieldId]:shouldBeginEditing();
    if b then
        return "YES";
    else
        return "NO";
    end
end

function epf_textFieldDidBeginEditing(textFieldId)
    UITextFieldEventProxyTable[textFieldId]:didBeginEditing();
end

function epf_textFieldShouldEndEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField then
        local b = textField:shouldEndEditing();
        if b then
            return "YES";
        else
            return "NO";
        end
    end
    return "YES";
end

function epf_textFieldDidEndEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField then
        textField:didEndEditing();
    end
end

function epf_shouldChangeCharactersInRange(textFieldId, location, length)
    local b = UITextFieldEventProxyTable[textFieldId]:shouldChangeCharactersInRange(tonumber(location), tonumber(length));
    if b then
        return "YES";
    else
        return "NO";
    end
end
