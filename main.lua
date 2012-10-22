viewController = nil;
button = nil;
webView = nil;

function main()
    viewController = ios::ui::createViewController("title", "viewDidLoad", "", true);
    print("viewController:"..viewController);
    ios::ui::setRootViewController(ios::ui::createNavigationController(viewController));
end

function viewDidLoad()
    button = ios::ui::createButton("点击跳转"..viewController, "20, 20, 200, 40", "onButtonTapped");
    ios::ui::addSubviewToViewController(button, viewController);
    ios::ui::alert("警告", "当前控制器id:"..viewController, "alertDone");
    
    webView = ios::ui::createWebView("10 ,100, 320, 320", "", "webViewDidLoad");
    ios::ui::addSubviewToViewController(webView, viewController);
    ios::ui::webViewLoadURL(webView, "http://www.baidu.com");
end

-- events
function onButtonTapped()
    ios::script::runScriptWithId("main.lua");
    ios::runtime::recycleCurrentScript();
end

function alertDone()
    ios::ui::alert("..");
end

function webViewDidLoad()
    ios::ui::alert("webViewDidLoad");
end