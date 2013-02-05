require "UIView"
require "AppContext"

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
    UIView.dealloc(self);
end

function UIScrollView:setContentInset(top, left, bottom, right)
    local inset = top..","..left..","..bottom..","..right;
    runtime::invokeMethod(self:id(), "setContentInset:", inset);
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