viewController = nil;
titleList = {"手机号码查询", "Google翻译"};

function main()
    viewController = ui::createViewController("查查查", "viewDidLoad", "", true);
    ui::setRootViewController(ui::createNavigationController(viewController));
end

function viewDidLoad()
    navigationItem = obj::propertyOfObject(viewController, "navigationItem");
    rightItem = ui::createBarButtonItem("更新", "rightBarButtonItemTapped");
    obj::invokeMethodSetObject(navigationItem, "setRightBarButtonItem", rightItem);
    ui::addSubviewToViewController(ui::createTableView(
        ui::getViewBounds(obj::propertyOfObject(viewController, "view")), "numberOfRows", "wrapCell", "didSelectCell"), viewController);
end

function numberOfRows()
    return "2";
end

function wrapCell(cellId, index)
    textLabel = obj::propertyOfObject(cellId, "textLabel");
    local label = ui::viewForTag(cellId, 1001);
    if label == "" then
        label = obj::createObjectWithClassName("UILabel");
        obj::invokePropertySet(label, "tag", "1001");
        contentView = obj::propertyOfObject(cellId, "contentView");
        ui::setViewFrame(label, "10, 10, 200, 20");
        ui::addSubview(contentView, label);
    end
    nindex = tonumber(index) + 1;
    obj::invokePropertySet(label, "text", titleList[nindex]);
end

function didSelectCell(index)
    NSLog(titleList[tonumber(index) + 1]);
end

function rightBarButtonItemTapped()
    print("rightBarButtonItemTapped");
end