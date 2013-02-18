require "UIView"
require "AppContext"
require "CommonUtils"

UIScrollView = {};
UIScrollView.__index = UIScrollView;
setmetatable(UIScrollView, UIView);

function UIScrollView:get(objId)
    local obj = UIView:new(objId);
    setmetatable(obj, self);
    
    UIScrollViewEventProxyTable[objId] = obj;
    
    return obj;
end

function UIScrollView:dealloc()
    runtime::invokeClassMethod("LIScrollViewDelegateProxy", "removeDelegateWithHash:", self:hash());
    super:dealloc();
end

function UIScrollView:setContentInset(top, left, bottom, right)
    local inset = top..","..left..","..bottom..","..right;
    runtime::invokeMethod(self:id(), "setContentInset:", inset);
end

function UIScrollView:setScrollIndicatorInsets(top, left, bottom, right)
    local inset = top..","..left..","..bottom..","..right;
    runtime::invokeMethod(self:id(), "setScrollIndicatorInsets:", inset);
end

function UIScrollView:contentOffset()
    local offset = runtime::invokeMethod(self:id(), "contentOffset");
    local offsetTable = stringSplit(offset, ",");
    return unpack(stringTableToNumberTable(offsetTable));
end

function UIScrollView:scrollsToTop()
    return runtime::invokeMethod(self:id(), "scrollsToTop");
end

function UIScrollView:setScrollsToTop(scrollsToTop)
    runtime::invokeMethod(self:id(), "setScrollsToTop:", toObjCBool(scrollsToTop));
end

function UIScrollView:setDelegate(delegate)
    self.delegate = delegate;
    
    local sharedDelegate = runtime::invokeClassMethod("LIScrollViewDelegateProxy", "sharedInstance");
    runtime::invokeClassMethod("LIScrollViewDelegateProxy", "setScrollViewHash:scrollViewObjId:appId:", self:hash(), "_"..self:id(), AppContext.current());
    runtime::invokeClassMethod("LIScrollViewDelegateProxy", "setScrollViewDidScrollFunc", "UIScrollViewEventProxyTable_scrollViewDidScroll");
    runtime::invokeMethod(self:id(), "setDelegate:", sharedDelegate);
end

UIScrollViewEventProxyTable = {};

function UIScrollViewEventProxyTable_scrollViewDidScroll(scrollViewId)
    local scrollView = UIScrollViewEventProxyTable[scrollViewId];
    if scrollView and scrollView.delegate then
        scrollView.delegate:scrollViewDidScroll(scrollView);
    end
end