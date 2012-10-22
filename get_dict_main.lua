viewController = "viewController";
button = "button";
textField = "";
label = nil;

function main()
    viewController = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    ui_set_root_view_controller(_lua_self, viewController);
end

function viewDidLoad()
    button = ui_create_button(_lua_self, "HTTP", "205, 10, 110, 40", "onButtonTapped");
    ui_add_subview_to_view_controller(_lua_self, button, viewController);

    textField = ui_createTextField(_lua_self, "10, 10, 180, 40");
    runtime_invokeOjectMethod_setValue(_lua_self, textField, "setText:", "text set by lua");
    ui_add_subview_to_view_controller(_lua_self, textField, viewController);

    label = ui_createLabel(_lua_self, "点击按钮", "10, 55, 120, 15");
    ui_add_subview_to_view_controller(_lua_self, label, viewController);
end

-- events
function onButtonTapped()
    runtime_invokeObjectMethod(_lua_self, textField, "resignFirstResponder");
    ui_alert(_lua_self, "", runtime_invokeObjectProperty_get(_lua_self, textField, "clearButtonMode")..", "..runtime_invokeObjectProperty_get(_lua_self, label, "text"), "");
    runtime_invokeObjectProperty_set(_lua_self, textField, "clearButtonMode", "3");
end