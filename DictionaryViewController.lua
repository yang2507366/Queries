require "UIViewController"
require "UINavigationController"
require "UITableView"
require "UITableViewDataSource"
require "CommonUtils"
require "UITableViewCell"
require "UILabel"
require "NSMutableArray"
require "UIFont"
require "AppBundle"
require "UIButton"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:create("在线词典"):retain();
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    local vc = UIViewController:create("test"):keep();
    function vc:viewDidLoad()
        local btn = UIButton:create("title");
        btn:setFrame(10, 20, 80, 40);
        vc:view():addSubview(btn);
    end
    
    local nc = UINavigationController:create(vc);
    nc:setAsRootViewController();
    
    ap_release();
end
