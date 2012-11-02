require "UIKit"
require "System"
require "Network"

QueryPostcodeViewController = {};
QueryPostcodeViewController.__index = QueryPostcodeViewController;
setmetatable(QueryPostcodeViewController, UIViewController);

kUseAddress = "根据地名查询邮编";

function QueryPostcodeViewController:dealloc()
    print("dealloc query postcode");
    self.addressTextField:release();
end

function QueryPostcodeViewController:viewDidLoad()
    ap_new();
    
    local x, y, width, height = self:view():bounds();
    print(height);
    local cview = UIView:create();
    cview:setFrame(0, 0, width, height - 70);
    cview:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
    local label = UILabel:createWithTitle(kUseAddress);
    label:setFrame(10, 10, 200, label:font():lineHeight());
    cview:addSubview(label);
    
    local addressTextField = UITextField:create();
    addressTextField:setFrame(10, 40, width - 20, 40);
    cview:addSubview(addressTextField);
    self.addressTextField = addressTextField:retain();
    
    x, y, width, height = addressTextField:frame();
    local addressButton = UIButton:createWithTitle(kUseAddress);
    addressButton:setFrame(x, y + height + 10, width, height);
    cview:addSubview(addressButton);
    function addressButton:tapped()
        
    end
    
    local tmpTableView = UITableView:create();
    tmpTableView:setFrame(self:view():bounds());
    tmpTableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    tmpTableView:setTableHeaderView(cview);
    self:view():addSubview(tmpTableView);
    
    ap_release();
end