viewController = nil;
button = nil;
webView = nil;
shouldLoad = nil;

function main()
    viewController = ios::ui::createViewController("title", "viewDidLoad", "", true);
    ios::runtime::invokeObjectProperty_set(viewController, "title", "中文标题");
    ios::nslog("viewController:"..viewController);
    ios::ui::setRootViewController(ios::ui::createNavigationController(viewController));
end

function viewDidLoad()
    ios::nslog("viewDidLoad:"..viewController);
    button = ios::ui::createButton("点击跳转"..viewController, "20, 20, 200, 40", "onButtonTapped");
    ios::ui::addSubviewToViewController(button, viewController);

    webView = ios::ui::createWebView("10 ,100, 320, 320", "webViewShouldStart", "webViewDidLoad");
    ios::ui::addSubviewToViewController(webView, viewController);
    ios::ui::webViewLoadURL(webView, "http://www.baidu.com");
end


-- events
function onButtonTapped()
    local viewId = ios::runtime::getPropertyOfObject(viewController, "view");
    x, y, width, height = ios::ui::getViewFrame(viewId);
    ios::nslog(x..", "..y..", "..width..", "..height);
    ios::ui::setViewFrame(webView, x..", "..y..", "..width..", "..height);
    --ios::script::runScriptWithId("main.lua");
    ios::runtime::recycleCurrentScript();
end

function alertDone()
    ios::ui::alert("..");
end

function webViewShouldStart()
    if shouldLoad ~= nil then
        return "0";
    end
    shouldLoad = "";
    return "1";
end

function webViewDidLoad()
--    ios::ui::alert("webViewDidLoad");
end