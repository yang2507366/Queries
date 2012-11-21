require "UIKit"

MobileNumberViewController = {};
MobileNumberViewController.__index = MobileNumberViewController;
setmetatable(MobileNumberViewController, UIViewController);

local tableView;
local button;
local textField;

function MobileNumberViewController:dealloc()
    textField:release();
    UIViewController.dealloc(self);
end

function MobileNumberViewController:viewDidLoad()
    ap_new();
    local containerView = UIView:create();
    containerView:setFrame(self:view():bounds());
    self:view():addSubview(containerView);
    containerView:setBackgroundColor(UIColor:create(255,255,255));
    
    local tmpLabel = UILabel:create("手机号码：");
    tmpLabel:setFrame(10, 10, 200, 20);
    self:view():addSubview(tmpLabel);
    
    local x, y, width, height = self:view():frame();
    textField = UITextField:create():retain();
    textField:setFrame(10, 40, width - 20, 40);
    textField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    textField:setClearButtonMode(UITextFieldViewModeWhileEditing);
    textField:setKeyboardType(UIKeyboardTypeNumberPad);
    containerView:addSubview(textField);
    
    ap_release();
end