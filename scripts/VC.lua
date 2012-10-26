_global_event_table = {};

VC = {};
VC.__index = VC;
function VC:new(title)
    local tmpVC = {};
    setmetatable(tmpVC, VC);
    if title == nil then
        title = "Untitled";
    end
    tmpVC.title = title;
    tmpVC.ios_viewController = ui::createViewController(title, "_global_viewDidLoad", "", true);
    _global_event_table[tmpVC.ios_viewController] = tmpVC;
    return tmpVC;
end

function VC:viewDidLoad(vcId)
end

function VC:setAsRootViewController()
    ui::setRootViewController(ui::createNavigationController(self.ios_viewController));
end

function _global_viewDidLoad(vcId)
    _global_event_table[vcId]:viewDidLoad(vcId);
end