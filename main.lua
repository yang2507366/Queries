viewController = nil;

function main()
    viewController = ui::createViewController("表", "viewDidLoad", "", true);
    ui::setRootViewController(ui::createNavigationController(viewController));
end

function viewDidLoad()
    navigationItem = obj::propertyOfObject(viewController, "navigationItem");
    obj::invokePropertySet(navigationItem, "title", "新标题");
    rightItem = obj::createBarButtonItem("更新", "");
    obj::invokePropertySet(navigationItem, "rightBarButtonItem", rightItem);
    ui::addSubviewToViewController(ui::createTableView(ui::getViewBounds(obj::propertyOfObject(viewController, "view")), "numberOfRows", "wrapCell", "didSelectCell"), viewController);
end

function numberOfRows()
    return "100";
end

function wrapCell(cellId, index)
    textLabel = obj::propertyOfObject(cellId, "textLabel");
    local label = ui::viewForTag(cellId, 1001);
    if label == "" then
        label = obj::createObjectWithClassName("UILabel");
        obj::invokePropertySet(label, "tag", "1001");
        contentView = obj::propertyOfObject(cellId, "contentView");
        ui::setViewFrame(label, "20, 10, 200, 20");
        ui::addSubview(contentView, label);
    end
    obj::invokePropertySet(label, "text", "行 - "..index + 1);
end

function didSelectCell(index)
    print("cell:"..index);
end