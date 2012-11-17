require "Object"
require "UIView"
require "UIFont"
require "Utils"

UITextView = {};
UITextView.__index = UITextView;
setmetatable(UITextView, UIView);

-- constructor
function UITextView:create()
    local tvId = ui::createTextView("UITextView_shouldBeginEditing",
                                    "UITextView_shouldEndEditing",
                                    "UITextView_textViewDidBeginEditing",
                                    "UITextView_textViewDidEndEditing",
                                    "UITextView_shouldChangeTextInRange",
                                    "UITextView_didChange",
                                    "UITextView_textViewDidChangeSelection");
    return UITextView:get(tvId);
end

function UITextView:get(tvId)
    local tv = UIView:new(tvId);
    setmetatable(tv, self);
    
    eventProxyTable_textView[tvId] = tv;
    
    return tv;
end

-- deconstructor
function UITextView:dealloc()
    eventProxyTable_textView[self:id()] = nil;
end

-- instance methods
function UITextView:setText(text)
    runtime::invokeMethod(self:id(), "setText:", text);
end

function UITextView:text()
    return runtime::invokeMethod(self:id(), "text");
end

function UITextView:setFont(font)
    runtime::invokeMethod(self:id(), "setFont:", font:id());
end

function UITextView:font()
    local fontId = runtime::invokeMethod(self:id(), "font");
    return UIFont:get(fontId);
end

function UITextView:setEditable(editable)
    runtime::invokeMethod(self:id(), "setEditable:", toObjCBool(editable));
end

function UITextView:editable()
    local b = runtime::invokeMethod(self:id(), "isEditable");
    return toLuaBool(b);
end

-- events
function UITextView:shouldBeginEditing()
    return true;
end

function UITextView:shouldEndEditing()
    return true;
end

function UITextView:didBeginEditing()

end

function UITextView:didEndEditing()

end

function UITextView:shouldChangeTextInRange(location, length, replacementText)
    return true;
end

function UITextView:didChange()

end

function UITextView:didChangeSelection()
    
end

-- event proxy
eventProxyTable_textView = {};
function UITextView_shouldBeginEditing(tvId)
    return toObjCBool(eventProxyTable_textView[tvId]:shouldBeginEditing());
end

function UITextView_shouldEndEditing(tvId)
    local tv = eventProxyTable_textView[tvId];
    if tv then
        return toObjCBool(tv:shouldEndEditing());
    end
    return toObjCBool(true);
end

function UITextView_textViewDidBeginEditing(tvId)
    eventProxyTable_textView[tvId]:didBeginEditing();
end

function UITextView_textViewDidEndEditing(tvId)
    local tv = eventProxyTable_textView[tvId];
    if tv then
        tv:didEndEditing();
    end
end

function UITextView_shouldChangeTextInRange(tvId, location, length, replacementText)
    return toObjCBool(eventProxyTable_textView[tvId]:shouldChangeTextInRange(tonumber(location), tonumber(length), replacementText));
end

function UITextView_didChange(tvId)
    eventProxyTable_textView[tvId]:didChange();
end

function UITextView_textViewDidChangeSelection(tvId)
    eventProxyTable_textView[tvId]:didChangeSelection();
end