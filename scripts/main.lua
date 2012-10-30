require "AutoreleasePool"
require "Object"
require "Utils"
require "UIViewController"
require "UINavigationController"
require "UIView"
require "UIColor"
require "UILabel"
require "UIFont"

function main()
    ap_new();
    local vc = UIViewController:createWithTitle("title");
    local nc = UINavigationController:createWithRootViewController(vc);
    local vc2 = UIViewController:createWithTitle("vc2");
    function vc2:viewDidLoad()
        ap_new();
        local view = UIView:create();
        view:setFrame(0, 0, 200, 200);
        vc2:view():addSubview(view);
        vc2:view():setBackgroundColor(UIColor:createWithRGB(255, 255, 0):autorelease());
        view:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleHeight, UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleBottomMargin));
        
        local label = UILabel:new("label1"):autorelease();
        local font = UIFont:createWithFontSize(20);
        label:setFont(font);
        vc2:view():addSubview(label);
        
        local label2 = UILabel:new("label2"):autorelease();
        label2:setFrame(0, 40, 200, 17);
        vc2:view():addSubview(label2);
        label2:setFont(label:font());
        label2:setBackgroundColor(UIColor:createWithRGB(0, 255, 0):autorelease());
        
        print(label2:font():lineHeight());
        print(label2:bounds());
        
        ap_release();
    end
    nc:pushViewController(vc2, "YES");
    
    nc:setAsRootViewController();
    ap_release();
end