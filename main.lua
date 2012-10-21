import test.lua;

viewController = "viewController";
button = "button";

function main()
    viewController = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    print("viewController:"..viewController);
    ui_set_root_view_controller(viewController);
end

function viewDidLoad()
    button = ui_create_button(_lua_self, "点击跳转", "onButtonTapped");
    print(viewController);
    ui_add_subview_to_view_controller(button, viewController);
end

-- events
function onButtonTapped()
    print(button);
end