import test.lua;

function main()
    print("main");
    --sendHttpRequest("http://dict.cn");
    --initUIComponents();
    --ui_alert("", "title", "test中文");
    newVc = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    ui_set_root_view_controller(newVc);
end

function viewDidLoad(viewController)
    print("viewDidLoad:"..viewController);
    button = ui_create_button(_lua_self, "按钮", "btnTapped");
    ui_add_subview_to_view_controller(button, viewController);
end

function btnTapped(btn)
    print("btnTapped:"..btn);
end