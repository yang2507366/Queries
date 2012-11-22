require "UIKit"
require "Net"

PostcodeViewController = {};
PostcodeViewController.__index = PostcodeViewController;
setmetatable(PostcodeViewController, UIViewController);

local addressField;
local postcodeField;
local addressButton;
local postcodeButton;
local closeKeyboardBtn;

function PostcodeViewController:dealloc()
    addressField:release();
    postcodeField:release();
    addressButton:release();
    postcodeButton:release();
    closeKeyboardBtn:release();
    UIViewController.dealloc(self);
end

function PostcodeViewController:viewDidLoad()
    ap_new();
    local bself = self;
    local x, y, width, height = self:view():bounds();
    
    local addressLabel = UILabel:create("根据地名查邮编");
    addressLabel:setFrame(10, 5, 200, 15);
    self:view():addSubview(addressLabel);
    
    local postcodeLabel = UILabel:create("根据邮编查地名");
    postcodeLabel:setFrame(10, 130, 200, 15);
    self:view():addSubview(postcodeLabel);
    
    addressField = UITextField:create():retain();
    addressField:setFrame(10, 25, width - 20, 40);
    addressField:setClearButtonMode(1);
    addressField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(addressField);
    
    postcodeField = UITextField:create():retain();
    postcodeField:setFrame(10, 150, width - 20, 40);
    postcodeField:setClearButtonMode(1);
    postcodeField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(postcodeField);
    
    closeKeyboardBtn = UIBarButtonItem:create("关闭"):retain();
    closeKeyboardBtn:setStyle(UIBarButtonItemStyleDone);
    function closeKeyboardBtn:tapped()
        addressField:resignFirstResponder();
        postcodeField:resignFirstResponder();
    end
    local textFieldDelegate = {};
    function textFieldDelegate:shouldBeginEditing(tf)
        ap_new();
        if tf:equals(postcodeField) then
            local tx, ty, tw, th = bself:view():frame();
            local anim = UIAnimation:create();
            function anim:animation()
                bself:view():setFrame(tx, ty - 50, tw, th);
            end
            anim:start();
        end
        ap_release();
        return true;
    end
    function textFieldDelegate:shouldEndEditing(tf)
        ap_new();
        if tf:equals(postcodeField) then
            local tx, ty, tw, th = bself:view():frame();
            local anim = UIAnimation:create();
            function anim:animation()
            bself:view():setFrame(tx, ty + 50, tw, th);
        end
        anim:start();
    end
ap_release();
        return true;
    end
    function textFieldDelegate:didBeginEditing()
        ap_new();
        bself:navigationItem():setRightBarButtonItem(closeKeyboardBtn);
        ap_release();
    end
    function textFieldDelegate:didEndEditing()
        ap_new();
        bself:navigationItem():setRightBarButtonItem(nil);
        ap_release();
    end
    addressField:setDelegate(textFieldDelegate);
    postcodeField:setDelegate(textFieldDelegate);
    
    addressButton = UIButton:create("查询"):retain();
    function addressButton:tapped()
        
    end
    addressButton:setFrame(10, 75, width - 20, 40);
    self:view():addSubview(addressButton);
    
    postcodeButton = UIButton:create("查询"):retain();
    function postcodeButton:tapped()
        
    end
    postcodeButton:setFrame(10, 200, width - 20, 40);
    self:view():addSubview(postcodeButton);
    
    ap_release();
end