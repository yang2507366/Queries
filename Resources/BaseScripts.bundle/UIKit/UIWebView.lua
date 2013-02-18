require "UIView"
require "AppContext"
require "UIScrollView"
require "NSError"
require "NSURL"

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
    super:dealloc();
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

function UIWebView:loadURLString(URLString)
    runtime::invokeMethod(self:id(), "loadURLString:", URLString);
end

function UIWebView:loadHTMLString(HTMLString)
    runtime::invokeMethod(self:id(), "loadHTMLString:baseURL:", HTMLString);
end

function UIWebView:scalesPageToFit()
    return toLuaBool(runtime::invokeMethod(self:id(), "scalesPageToFit"));
end

function UIWebView:setScalesPageToFit(scale)
    runtime::invokeMethod(self:id(), "setScalesPageToFit:", toObjCBool(scale));
end

function UIWebView:goForward()
    runtime::invokeMethod(self:id(), "goForward");
end

function UIWebView:goBack()
    runtime::invokeMethod(self:id(), "goBack");
end

function UIWebView:canGoBack()
    return toLuaBool(runtime::invokeMethod(self:id(), "canGoBack"));
end

function UIWebView:canGoForward()
    return toLuaBool(runtime::invokeMethod(self:id(), "canGoForward"));
end

function UIWebView:scrollView()
    return UIScrollView:get(runtime::invokeMethod(self:id(), "getScrollView"));
end

function UIWebView:currentPageTitle()
    return runtime::invokeMethod(self:id(), "getPageTitle");
end

function UIWebView:disableContextMenu()
    runtime::invokeMethod(self:id(), "disableWebViewContextMenu");
end

function UIWebView:reload()
    runtime::invokeMethod(self:id(), "reload");
end

function UIWebView:stopLoading()
    runtime::invokeMethod(self:id(), "stopLoading");
end

function UIWebView:runScript(script)
    runtime::invokeMethod(self:id(), "stringByEvaluatingJavaScriptFromString:", script);
end

function UIWebView:currentDocumentURL()
    local request = runtime::invokeMethod(self:id(), "request");
    local URL = runtime::invokeMethod(request, "mainDocumentURL");
    runtime::releaseObject(request);
    
    return NSURL:get(URL);
end

function UIWebView:realWindowSize()
    return unpack(stringTableToNumberTable(stringSplit(runtime::invokeMethod(self:id(), "windowSize"), ",")));
end

function UIWebView:linkURLStringAtPoint(x, y)
    return runtime::invokeMethod(self:id(), "getALinkAtPoint:", x..","..y);
end

function UIWebView:scrollOffset()
    return unpack(stringTableToNumberTable(stringSplit(runtime::invokeMethod(self:id(), "scrollOffset"), ",")));
end

function UIWebView:HTMLElementsAtPoint(x, y)
    return runtime::invokeMethod(self:id(), "getHTMLElementsAtPoint:", x..","..y);
end

-- event proxy
UIWebViewEventProxyTable = {};

function UIWebView_shouldStartLoadWithRequest(webViewId, requestURLString, navigationType)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        local should = toObjCBool(webView.delegate:shouldStartLoadWithRequest(webView, requestURLString, navigationType));
        return should;
    end
end

function UIWebView_didStartLoad(webViewId)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        webView.delegate:didStartLoad(webView);
    end
end

function UIWebView_didFinishLoad(webViewId)
    local webView = UIWebViewEventProxyTable[webViewId];
    if webView and webView.delegate then
        webView.delegate:didFinishLoad(webView);
    end
end

function UIWebView_didFailLoadWithError(webViewId, errId)
    local webView = UIWebViewEventProxyTable[webViewId];
    local err = NSError:get(errId);
    if webView and webView.delegate then
        webView.delegate:didFailLoadWithError(webView, err);
    end
end