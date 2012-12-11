require "UIView"
require "UITextFieldDelegate"
require "AppContext"
require "CommonUtils"

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
    local textFieldId = runtime::invokeClassMethod("LITextField", "create:", AppContext.current());
    
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
    self:setDelegate(nil);
    UITextFieldEventProxyTable[self:id()] = nil;
    UIView.dealloc(self);
end

-- instance methods
function UITextField:setDelegate(delegate)
    self.delegate = delegate;
    
    if delegate and delegate.shouldBeginEditing then
        runtime::invokeMethod(self:id(), "setShouldBeginEditing:", "UITextFieldDelegate_shouldBeginEditing");
    else
        runtime::invokeMethod(self:id(), "setShouldBeginEditing:", "");
    end
    
    if delegate and delegate.didBeginEditing then
        runtime::invokeMethod(self:id(), "setDidBeginEditing:", "UITextFieldDelegate_didBeginEditing");
    else
        runtime::invokeMethod(self:id(), "setDidBeginEditing:", "");
    end
    
    if delegate and delegate.shouldEndEditing then
        runtime::invokeMethod(self:id(), "setShouldEndEditing:", "UITextFieldDelegate_shouldEndEditing");
    else
        runtime::invokeMethod(self:id(), "setShouldEndEditing:", "");
    end
    
    if delegate and delegate.didEndEditing then
        runtime::invokeMethod(self:id(), "setDidEndEditing:", "UITextFieldDelegate_didEndEditing");
    else
        runtime::invokeMethod(self:id(), "setDidEndEditing:", "");
    end
    
    if delegate and delegate.shouldChangeCharactersInRange then
        runtime::invokeMethod(self:id(), "setShouldChangeCharactersInRange:", "UITextFieldDelegate_shouldChangeCharactersInRange");
    else
        runtime::invokeMethod(self:id(), "setShouldChangeCharactersInRange:", "");
    end
    
    if delegate and delegate.shouldClear then
        runtime::invokeMethod(self:id(), "setShouldClear:", "UITextFieldDelegate_shouldClear");
    else
        runtime::invokeMethod(self:id(), "setShouldClear:", "");
    end
    
    if delegate and delegate.shouldReturn then
        runtime::invokeMethod(self:id(), "setShouldReturn:", "UITextFieldDelegate_shouldReturn");
    else
        runtime::invokeMethod(self:id(), "setShouldReturn:", "");
    end
    
    runtime::invokeMethod(self:id(), "updateDelegate");
end

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

function UITextField:setEnabled(enabled)
    runtime::invokeMethod(self:id(), "setEnabled:", toObjCBool(enabled));
end

function UITextField:enabled()
    return toLuaBool(runtime::invokeMethod(self:id(), "enabled"));
end

-- event proxy
UITextFieldEventProxyTable = {};

function UITextFieldDelegate_shouldBeginEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        local should = toObjCBool(textField.delegate:shouldBeginEditing(textField));
        
        return should;
    end
end

function UITextFieldDelegate_didBeginEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        textField.delegate:didBeginEditing(textField);
        
    end
end

function UITextFieldDelegate_shouldEndEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        local should = toObjCBool(textField.delegate:shouldEndEditing(textField));
        
        return should;
    end
end

function UITextFieldDelegate_didEndEditing(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        textField.delegate:didEndEditing(textField);
        
    end
end

function UITextFieldDelegate_shouldChangeCharactersInRange(textFieldId, location, length, replacementString)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        
        local should = toObjCBool(textField.delegate:shouldChangeCharactersInRange(textField, tonumber(location), tonumber(length), replacementString));
        
        
        return should;
    end
end

function UITextFieldDelegate_shouldClear(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        local should = toObjCBool(textField.delegate:shouldClear(textField));
        
        return should;
    end
end

function UITextFieldDelegate_shouldReturn(textFieldId)
    local textField = UITextFieldEventProxyTable[textFieldId];
    if textField and textField.delegate then
        
        local should = toObjCBool(textField.delegate:shouldReturn(textField));
        
        return should;
    end
end
