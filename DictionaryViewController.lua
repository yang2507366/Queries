require "System"
require "UIKit"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:createWithTitle("在线词典"):retain();
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    function dictVC:viewDidLoad()
        
    end
    function dictVC:viewDidPop()
        super:viewDidPop();
        self:release();
    end
    ap_release();
end