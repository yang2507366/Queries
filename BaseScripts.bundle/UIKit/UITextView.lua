require "Object"
require "UIView"
require "UIFont"
require "CommonUtils"
require "UITextViewDelegate"

UITextView = {};
UITextView.__index = UITextView;
setmetatable(UITextView, UIView);

-- constructor
function UITextView:create()
    local tvId = runtime::invokeClassMethod("LITextView", "create:", AppContext.current());
    return UITextView:get(tvId);
end

function UITextView:get(tvId)
    local tv = UIView:new(tvId);
    setmetatable(tv, self);
    
    UITextViewEventProxyTable[tvId] = tv;
    
    return tv;
end

-- deconstructor
function UITextView:dealloc()
    UITextViewEventProxyTable[self:id()] = nil;
    UIView.dealloc(self);
end

-- instance methods
function UITextView:setText(text)
    runtime::invokeMethod(self:id(), "setText:", text);
end

function UITextView:text()
    return runtime::invokeMethod(self:id(), "text");
end

function UITextView:setTextColor(color)
    runtime::invokeMethod(self:id(), "setTextColor:", color:id());
end

function UITextView:textColor()
    return UIColor:get(runtime::invokeMethod(self:id(), "textColor"));
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

function UITextView:setDelegate(delegate)
    self.delegate = delegate;
    
    if delegate.shouldBeginEditing then
        runtime::invokeMethod(self:id(), "setShouldBeginEditing:", "UITextView_shouldBeginEditing");
    else
        runtime::invokeMethod(self:id(), "setShouldBeginEditing:", "");
    end
    
    if delegate.shouldEndEditing then
        runtime::invokeMethod(self:id(), "setShouldEndEditing:", "UITextView_shouldEndEditing");
    else
        runtime::invokeMethod(self:id(), "setShouldEndEditing:", "");
    end
    
    if delegate.didBeginEditing then
        runtime::invokeMethod(self:id(), "setDidBeginEditing:", "UITextView_didBeginEditing");
    else
        runtime::invokeMethod(self:id(), "setDidBeginEditing:", "");
    end
    
    if delegate.didEndEditing then
        runtime::invokeMethod(self:id(), "setDidEndEditing:", "UITextView_didEndEditing");
    else
        runtime::invokeMethod(self:id(), "setDidEndEditing:", "");
    end
    
    if delegate.shouldChangeTextInRange then
        runtime::invokeMethod(self:id(), "setShouldChangeTextInRange:", "UITextView_shouldChangeTextInRange");
    else
        runtime::invokeMethod(self:id(), "setShouldChangeTextInRange:", "");
    end
    
    if delegate.didChange then
        runtime::invokeMethod(self:id(), "setDidChange:", "UITextView_didChange");
    else
        runtime::invokeMethod(self:id(), "setDidChange:", "");
    end
    
    if delegate.didChangeSelection then
        runtime::invokeMethod(self:id(), "setDidChangeSelection:", "UITextView_didChangeSelection");
    else
        runtime::invokeMethod(self:id(), "setDidChangeSelection:", "");
    end
    
    runtime::invokeMethod(self:id(), "updateDelegate");
end

-- event proxy
UITextViewEventProxyTable = {};
function UITextView_shouldBeginEditing(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        local should = toObjCBool(tv.delegate:shouldBeginEditing(tv));
        ap_release();
        return should;
    end
end

function UITextView_shouldEndEditing(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        local should = toObjCBool(tv.delegate:shouldEndEditing(tv));
        ap_release();
        return should;
    end
end

function UITextView_didBeginEditing(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        tv.delegate:didBeginEditing(tv);
        ap_release();
    end
end

function UITextView_didEndEditing(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        tv.delegate:didEndEditing(tv);
        ap_release();
    end
end

function UITextView_shouldChangeTextInRange(tvId, location, length, replacementText)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        local should = toObjCBool(tv.delegate:shouldChangeTextInRange(tv, tonumber(location), tonumber(length), replacementText));
        ap_release();
        return should;
    end
end

function UITextView_didChange(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        tv.delegate:didChange(tv);
        ap_release();
    end
end

function UITextView_didChangeSelection(tvId)
    local tv = UITextViewEventProxyTable[tvId];
    if tv and tv.delegate then
        ap_new();
        tv.delegate:didChangeSelection(tv);
        ap_release();
    end
end