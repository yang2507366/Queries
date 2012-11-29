require "Lang"
require "UIKit"
require "Utils"

GeocoderViewController = {};
GeocoderViewController.__index = GeocoderViewController;
setmetatable(GeocoderViewController, UIViewController);

local locationMgr;
local locationLabel;

function GeocoderViewController:dealloc()
    locationMgr:release();
    locationLabel:release();
    UIViewController.dealloc(self);
end

function GeocoderViewController:viewDidLoad()
    ap_new();
    
    local bself = self;
    
    local x, y, width, height = self:view():bounds();
    
    locationLabel = UILabel:create("正在定位中.."):retain();
    locationLabel:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    locationLabel:setFrame(0, 100, width, 20);
    locationLabel:setTextAlignment(1);
    locationLabel:setFont(UIFont:create(16, false));
    self:view():addSubview(locationLabel);
    
    locationMgr = LocationManager:create():retain();
    function locationMgr:didUpdateToLocation(latitude, longitude)
        bself:setWaiting(false);
        locationLabel:setText("经度:"..latitude.."，纬度:"..longitude);
    end
    function locationMgr:didFailWithError()
        bself:setWaiting(false);
        locationLabel:setText("定位出错了");
    end
    locationMgr:startUpdatingLocation();
    self:setWaiting(true);
    
    ap_release();
end

--[[function main(args)
    ap_new();
    
    ap_release();
end]]