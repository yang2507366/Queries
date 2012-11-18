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
    function dictVC:viewDidLoad()
        ap_new();
        local btn = UIButton:create():retain();
        btn:setFrame(10, 20, 80, 40);
        function btn:tapped()
            print("btntapped");
        end
        dictVC:view():addSubview(btn);
        ap_release();
    end
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    ap_release();
end
