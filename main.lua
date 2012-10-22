viewController = "viewController";
button = "button";

function main()
    viewController = ios::ui::createViewController("title", "viewDidLoad", "", true);
    print("viewController:"..viewController);
    ios::ui::setRootViewController(ios::ui::createNavigationController(viewController));
end

function viewDidLoad()
    button = ios::ui::createButton("点击跳转"..viewController, "20, 20, 200, 40", "onButtonTapped");
    ios::ui::addSubviewToViewController(button, viewController);
    ios::ui::alert("警告", "当前控制器id:"..viewController, "alertDone");
end

-- events
function onButtonTapped()
    ios::script::runScriptWithId("main.lua");
    ios::runtime::recycleCurrentScript();
end

function alertDone()
    ios::ui::alert("..");
end