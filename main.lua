import test.lua;

viewController = "viewController";
button = "button";

function main()
    viewController = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    print("viewController:"..viewController);
    ui_set_root_view_controller(_lua_self, viewController);
end

function viewDidLoad()
    button = ui_create_button(_lua_self, "点击跳转", "20, 20, 100, 40", "onButtonTapped");
    print(viewController);
    ui_add_subview_to_view_controller(_lua_self, button, viewController);
end

-- events
function onButtonTapped()
    print(button);
    runtime_recycle(_lua_self);
    script_run_script_id("get_dict_main.lua");
end