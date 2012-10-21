function main()
    print("get_dict_main");
   newVc = ui_create_view_controller(_lua_self, "title", "viewDidLoad", "");
    ui_set_root_view_controller(newVc);
end

function viewDidLoad(viewController)
    print("viewDidLoad:"..viewController);
    button = ui_create_button(_lua_self, "test2", "btnTapped");
    ui_add_subview_to_view_controller(button, viewController);
end

function btnTapped(btn)
    print("btnTapped:"..btn);
end