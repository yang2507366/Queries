--http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/测试用例
require "UIKit"
require "System"
require "Utils"

GoogleTranslateViewController = {};
GoogleTranslateViewController.__index = GoogleTranslateViewController;
setmetatable(GoogleTranslateViewController, UIViewController);

function GoogleTranslateViewController:viewDidLoad()
    
end


function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local gtVC = GoogleTranslateViewController:createWithTitle("Google翻译"):retain();
    relatedVC:navigationController():pushViewController(gtVC, true);
    function gtVC:viewDidPop()
        gtVC:release();
    end
    ap_release();
end
