require "UIKit"
require "System"
require "Network"

QueryPostcodeViewController = {};
QueryPostcodeViewController.__index = QueryPostcodeViewController;
setmetatable(QueryPostcodeViewController, UIViewController);

kUseAddress = "根据地名查询邮编";

function QueryPostcodeViewController:dealloc()
    self.addressTextField:release();
end

function QueryPostcodeViewController:viewDidLoad()
    ap_new();
    local globalSelf = self;
    local x, y, width, height = self:view():bounds();
    local cview = UIView:create();
    cview:setFrame(0, 0, width, height - 70);
    cview:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
    local label = UILabel:createWithTitle(kUseAddress);
    label:setFrame(10, 10, 200, label:font():lineHeight());
    cview:addSubview(label);
    
    local addressTextField = UITextField:create();
    addressTextField:setFrame(10, 40, width - 20, 40);
    addressTextField:setClearButtonMode(1);
    cview:addSubview(addressTextField);
    self.addressTextField = addressTextField:retain();
    
    x, y, width, height = addressTextField:frame();
    local addressButton = UIButton:createWithTitle(kUseAddress);
    addressButton:setFrame(x, y + height + 10, width, height);
    cview:addSubview(addressButton);
    function addressButton:tapped()
        ap_new();
        local city = addressTextField:text();
        if ustring::length(city) == 0 then
            ui::alert("请输入需要查询的地名");
            addressTextField:becomeFirstResponder();
            return;
        end
        addressTextField:resignFirstResponder();
        globalSelf:setWaiting(true);
        local urlString = "http://wap.ip138.com/post_search.asp?area="..ustring::encodeURL(city).."&action=area2zip";
        local req = HTTPRequest:start(urlString);
        function req:response(responseString, errorString)
            ap_new();
            globalSelf:setWaiting(false);
            local beginIndex = ustring::find(responseString, "邮编：");
            if beginIndex ~= -1 then
                beginIndex = ustring::find(responseString, "<div>", beginIndex, true);
                if beginIndex ~= -1 then
                    local endIndex = ustring::find(responseString, "<br/>", beginIndex);
                    if endIndex ~= -1 then
                        ui::alert(ustring::substring(responseString, beginIndex + 5, endIndex));
                        return;
                    end
                end
            end
            ui::alert("没有找到相关地名："..city);
            ap_release();
        end
        ap_release();
    end
    
    local tmpTableView = UITableView:create();
    tmpTableView:setFrame(self:view():bounds());
    tmpTableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    tmpTableView:setTableHeaderView(cview);
    self:view():addSubview(tmpTableView);
    
    ap_release();
end