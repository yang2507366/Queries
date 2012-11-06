require "System"
require "UIKit"
require "App"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:createWithTitle("在线词典"):retain();
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    function dictVC:viewDidLoad()
        
    end
    function dictVC:viewDidPop()
        UIViewController.viewDidPop(self);
        self:release();
    end
    
    local app = App:get();
    app:bundleId();
    
    ap_release();
end
