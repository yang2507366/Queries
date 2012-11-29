require "Lang"
require "UIKit"
require "Utils"

GeocoderViewController = {};
GeocoderViewController.__index = GeocoderViewController;
setmetatable(GeocoderViewController, UIViewController);

local locationMgr;
local locationLabel;
local addressLabel;
local geocoder;

function GeocoderViewController:dealloc()
    locationMgr:release();
    locationLabel:release();
    addressLabel:release();
    if geocoder then
        geocoder:release();
    end
    UIViewController.dealloc(self);
end

function GeocoderViewController:viewDidLoad()
    ap_new();
    
    local bself = self;
    
    local x, y, width, height = self:view():bounds();
    
    locationLabel = UILabel:create("正在定位中.."):retain();
    locationLabel:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    locationLabel:setFrame(0, 20, width, 20);
    locationLabel:setTextAlignment(1);
    locationLabel:setFont(UIFont:create(16, false));
    self:view():addSubview(locationLabel);
    
    addressLabel = UILabel:create(""):retain();
    addressLabel:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    addressLabel:setFrame(0, 50, width, 20);
    addressLabel:setTextAlignment(1);
    addressLabel:setFont(UIFont:create(16, false));
    self:view():addSubview(addressLabel);
    
    locationMgr = LocationManager:create():retain();
    function locationMgr:didUpdateToLocation(latitude, longitude)
        bself:setWaiting(false);
        locationLabel:setText("经度:"..latitude.."，纬度:"..longitude);
        if geocoder then
            geocoder:release();
        end
        ap_new();
        geocoder = Geocoder:create():retain();
        function geocoder:didSuccess(locality, address)
            if locality and address then
                addressLabel:setText(locality..", "..address);
            end
        end
        function geocoder:didError()
            print("error");
        end
        geocoder:geocode(latitude, longitude);
        ap_release();
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