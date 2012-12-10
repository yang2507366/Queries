require "UIView"
require "AppContext"

UIWebView = {};
UIWebView.__index = UIWebView;
setmetatable(UIWebView, UIView);

function UIWebView:create()
    local webViewId = runtime::invokeClassMethod("LIWebView", "create:", AppContext.current());
    
    return self:get(webViewId);
end

function UIWebView:get(webViewId)
    local webView = UIView:new(webViewId);
    setmetatable(webView, self);
    
    UIWebViewEventProxyTable[webViewId] = webView;
    
    return webView;
end

function UIWebView:dealloc()
    UIWebViewEventProxyTable[self:id()] = nil;
    UIView.dealloc(self);
end

-- instance methods
function UIWebView:setDelegate(delegate)
    self.delegate = delegate;
    if delegate and delegate.shouldStartLoadWithRequest then
        runtime::invokeMethod(self:id(), "setShouldStartLoadWithRequest:", "UIWebView_shouldStartLoadWithRequest");
    else
        runtime::invokeMethod(self:id(), "setShouldStartLoadWithRequest:", "");
    end
    
    if delegate and delegate.didStartLoad then
        runtime::invokeMethod(self:id(), "setDidStartLoad:", "UIWebView_didStartLoad");
    else
        runtime::invokeMethod(self:id(), "setDidStartLoad:", "");
    end
    
    if delegate and delegate.didFinishLoad then
        runtime::invokeMethod(self:id(), "setDidFinishLoad:", "UIWebView_didFinishLoad");
    else
        runtime::invokeMethod(self:id(), "setDidFinishLoad:", "");
    end
    
    if delegate and delegate.didFailLoadWithError then
        runtime::invokeMethod(self:id(), "setDidFailLoadWithError:", "UIWebView_didFailLoadWithError");
    else
        runtime::invokeMethod(self:id(), "setDidFailLoadWithError:", "");
    end
end

function UIWebView:loadRequest(URLString)
    runtime::invokeMethod(self:id(), "loadURLString:", URLString);
end

UIWebViewEventProxyTable = {};

function UIWebView_shouldStartLoadWithRequest(webViewId, requestURLString, navigationType)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        ap_new();
        webView.delegate:shouldStartLoadWithRequest(webView, requestURLString, navigationType);
        ap_release();
    end
end

function UIWebView_didStartLoad(webViewId)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        ap_new();
        webView.delegate:didStartLoad(webView);
        ap_release();
    end
end

function UIWebView_didFinishLoad(webViewId)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        ap_new();
        webView.delegate:didFinishLoad(webView);
        ap_release();
    end
end

function UIWebView_didFailLoadWithError(weiViewId, errorString)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        ap_new();
        webView.delegate:didFailLoadWithError(webView, errorString);
        ap_release();
    end
end