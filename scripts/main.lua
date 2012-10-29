require "Object"
require "Utils"
require "UIViewController"
require "UINavigationController"
require "UIView"

function main()
    local vc = UIViewController:createWithTitle("title");
    local nc = UINavigationController:createWithRootViewController(vc);
    local vc2 = UIViewController:createWithTitle("vc2");
    function vc2:viewDidLoad()
        local view = UIView:create();
        view:setFrame(0, 0, 200, 200);
        view:setBackgroundColor(255, 0, 0, 1);
        vc2:view():setBackgroundColor(255, 255, 0, 1);
        vc2:view():addSubview(view);
        view:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleHeight, UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleBottomMargin));
    end
    nc:pushViewController(vc2, "YES");
    
    nc:setAsRootViewController();
    
end