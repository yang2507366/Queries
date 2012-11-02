require "System"
require "UIKit"
require "QuiresListViewController"

function main()
    ap_new();
    
    local quiresListVC = QuiresListViewController:createWithTitle("快捷查询"):retain();
    local nc = UINavigationController:createWithRootViewController(quiresListVC);
    nc:setAsRootViewController();
    
    ap_release();
end