require "Lang"
require "UIKit"

function main()
    ap_new();
    local rootVC = UIViewController:create("Quires"):retain();
    function rootVC:viewDidPop()
        self:release();
    end
    rootVC:pushToRelatedViewController();
    ap_release();
end