viewController = "viewController";
button = "button";
textField = "";

function main()
    viewController = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    print("viewController:"..viewController);
    ui_set_root_view_controller(_lua_self, viewController);
    print("get main");
end

function viewDidLoad()
    button = ui_create_button(_lua_self, "get_dict_main", "205, 10, 110, 40", "onButtonTapped");
    print(viewController);
    ui_add_subview_to_view_controller(_lua_self, button, viewController);
    print("get viewDidLoad");
    textField = ui_createTextField(_lua_self, "10, 10, 180, 40");
    ui_add_subview_to_view_controller(_lua_self, textField, viewController);
end

-- events
function onButtonTapped()
    print("onButtonTapped");
end