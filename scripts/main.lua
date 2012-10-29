require "Object"
require "Utils"
require "UIViewController"
require "UINavigationController"
require "UIView"
require "UIColor"
require "AutoreleasePool"

function main()
    local vc = UIViewController:createWithTitle("title");
    local nc = UINavigationController:createWithRootViewController(vc);
    local vc2 = UIViewController:createWithTitle("vc2");
    function vc2:viewDidLoad()
        local view = UIView:create();
        view:setFrame(0, 0, 200, 200);
        view:setBackgroundColor(UIColor:createWithRGB(255, 255, 0):autorelease());
        vc2:view():setBackgroundColor(UIColor:createWithRGB(255, 0, 0):autorelease());
        vc2:view():addSubview(view);
        view:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleHeight, UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleBottomMargin));
    end
    nc:pushViewController(vc2, "YES");
    
    nc:setAsRootViewController();
    
    
    _autorelease_pool_newPool();
    
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    _autorelease_pool_newPool();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    UIColor:createWithRGB(255, 255, 0):autorelease();
    _autorelease_pool_drainPool();
    
    _autorelease_pool_drainPool();
end