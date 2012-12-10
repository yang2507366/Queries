require "UIKit"

DictionaryViewController = {};
DictionaryViewController.__index = DictionaryViewController;
setmetatable(DictionaryViewController, UIViewController);

function DictionaryViewController:dealloc()
    self.webView:release();
    UIView.dealloc(self);
end

function DictionaryViewController:viewDidLoad()
    local bself = self;
    self.webView = UIWebView:create():retain();
    self.webView:setFrame(self:view():bounds());
    self.webView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
    self:view():addSubview(self.webView);
    
    local webViewDelegate = {};
    function webViewDelegate:didStartLoad()
        print("start load");
    end
    function webViewDelegate:didFinishLoad()
        print("finish");
    end
    function webViewDelegate:shouldStartLoadWithRequest(webView, URLString, navigationType)
        print(URLString, navigationType);
    end
    function webViewDelegate:didFailLoadWithError(webView, errorString)
        print(errorString);
    end
    self.webView:setDelegate(webViewDelegate);
    
    self.webView:loadRequest("http://3g.dict.cn");
end