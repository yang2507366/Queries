require "UIKit"

QueryMobileNumberViewController = {};
QueryMobileNumberViewController.__index = QueryMobileNumberViewController;
setmetatable(QueryMobileNumberViewController, UIViewController);

function QueryMobileNumberViewController:dealloc()
    
end

function QueryMobileNumberViewController:viewDidLoad()
    local x, y, width, height = self:view():bounds();
    local button = UIButton:createWithTitle("搜索");
    button:setFrame(width - 90, 10, 80, 40);
    button:setAutoresizingMask(UIViewAutoresizingFlexibleLeftMargin);
    self:view():addSubview(button);
    
    local label = UILabel:createWithTitle("手机");
    label:setFrame(10, 10, 80, 40);
    self:view():addSubview(label);
end