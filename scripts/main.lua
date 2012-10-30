require "AutoreleasePool"
require "Object"
require "Utils"
require "UIViewController"
require "UINavigationController"
require "UIView"
require "UIColor"

function main()
    local vc = UIViewController:createWithTitle("title");
    local nc = UINavigationController:createWithRootViewController(vc);
    local vc2 = UIViewController:createWithTitle("vc2");
    function vc2:viewDidLoad()
        autorelease_pool_new("vc2:viewDidLoad");
        local view = UIView:create();
        view:setFrame(0, 0, 200, 200);
        vc2:view():addSubview(view);
        vc2:view():setBackgroundColor(UIColor:createWithRGB(255, 0, 0):autorelease());
        view:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleHeight, UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleBottomMargin));
        
        autorelease_pool_drain();
    end
    nc:pushViewController(vc2, "YES");
    
    nc:setAsRootViewController();
end