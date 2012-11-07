require "System"
require "UIKit"
require "AppBundle"
require "UIImage"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:createWithTitle("在线词典"):retain();
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    function dictVC:viewDidLoad()
        ap_new();
        local img = UIImage:imageNamed("google_translate.jpg");
        img:size();
        
        local imgView = UIImageView:createWithImage(img);
        imgView:setFrame(10, 10, 100, 100);
        self:view():addSubview(imgView);
        ap_release();
    end
    function dictVC:viewDidPop()
        UIViewController.viewDidPop(self);
        self:release();
    end
    
    local app = AppBundle:get();
    app:bundleId();
    
    
    ap_release();
end
