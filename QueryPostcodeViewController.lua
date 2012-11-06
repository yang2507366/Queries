require "UIKit"
require "System"
require "Network"

QueryPostcodeViewController = {};
QueryPostcodeViewController.__index = QueryPostcodeViewController;
setmetatable(QueryPostcodeViewController, UIViewController);

kUseAddress = "根据地名查询邮编";
kUsePostcode = "根据邮编查询地名";--http://wap.ip138.com/post_search.asp?zip=342500&action=zip2area

local addressButton;
local postcodeButton;

function QueryPostcodeViewController:dealloc()
    self.addressTextField:release();
    self.postcodeField:release();
    self.tableView:release();
    addressButton:release();
    postcodeButton:release();
end

function QueryPostcodeViewController:viewDidLoad()
    ap_new();
    local globalSelf = self;
    local x, y, width, height = self:view():bounds();
    local cview = UIView:create();
    cview:setFrame(0, 0, width, height - 120);
    cview:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth));
--    cview:setBackgroundColor(UIColor:createWithRGB(255, 0, 0));
    local label = UILabel:createWithText(kUseAddress);
    label:setFrame(10, 10, 200, label:font():lineHeight());
    cview:addSubview(label);
    
    local addressTextField = UITextField:create();
    addressTextField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    addressTextField:setFrame(10, 40, width - 20, 40);
    addressTextField:setClearButtonMode(1);
    cview:addSubview(addressTextField);
    self.addressTextField = addressTextField:retain();
    
    x, y, width, height = addressTextField:frame();
    addressButton = UIButton:createWithTitle("查询"):retain();
    addressButton:setFrame(x, y + height + 10, width, height);
    addressButton:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    cview:addSubview(addressButton);
    function addressButton:tapped()
        ap_new();
        local city = addressTextField:text();
        if ustring::length(city) == 0 then
            ui::alert("请输入需要查询的地名");
            addressTextField:becomeFirstResponder();
            ap_release();
            return;
        end
        addressTextField:resignFirstResponder();
        globalSelf:setWaiting(true);
        local urlString = "http://wap.ip138.com/post_search.asp?area="..ustring::encodeURL(city).."&action=area2zip";
        local req = HTTPRequest:start(urlString);
        function req:response(responseString, errorString)
            ap_new();
            globalSelf:setWaiting(false);
            local result = analyzeResponseString(responseString);
            if result then
                ui::alert(result);
            else
                ui::alert("没有找到相关地名："..city);
            end
            ap_release();
        end
        ap_release();
    end
    
    x, y, width, height = self:view():bounds();
    
    label = UILabel:createWithText(kUsePostcode);
    label:setFrame(10, 150, 200, label:font():lineHeight());
    cview:addSubview(label);
    
    local postcodeField = UITextField:create();
    postcodeField:setFrame(10, 180, width - 20, 40);
    postcodeField:setClearButtonMode(1);
    postcodeField:setKeyboardType(UIKeyboardTypeNumberPad);
    postcodeField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    cview:addSubview(postcodeField);
    self.postcodeField = postcodeField:retain();
    local anim = UIAnimation:create();
    function postcodeField:shouldBeginEditing()
        ap_new();
        function anim:animation()
            local x, y, width, height = globalSelf.tableView:frame();
            y = y - 100;
            globalSelf.tableView:setFrame(x, y, width, height);
        end
        anim:start();
        ap_release();
        return true;
    end
    function postcodeField:shouldEndEditing()
        ap_new();
        function anim:animation()
            local x, y, width, height = globalSelf.tableView:frame();
            y = y + 100;
            globalSelf.tableView:setFrame(x, y, width, height);
        end
        anim:start();
        ap_release();
        return true;
    end
    
    postcodeButton = UIButton:createWithTitle("查询"):retain();
    postcodeButton:setFrame(10, 230, width - 20, 40);
    postcodeButton:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    cview:addSubview(postcodeButton);
    function postcodeButton:tapped()
        if ustring::length(globalSelf.postcodeField:text()) == 0 then
            ui::alert("请输入需要查询的邮政编码");
            globalSelf.postcodeField:becomeFirstResponder();
            return;
        end
        postcodeField:resignFirstResponder();
        globalSelf:setWaiting(true);
        local postcode = globalSelf.postcodeField:text();
        local urlString = "http://wap.ip138.com/post_search.asp?zip="..postcode.."&action=zip2area";
        local httpReq = HTTPRequest:start(urlString);
        function httpReq:response(responseString, errorString)
            ap_new();
            globalSelf:setWaiting(false);
            local result = analyzeResponseString(responseString);
            if result then
                ui::alert(result);
                else
                ui::alert("没有找到相关邮编："..postcode);
            end
            ap_release();
        end
    end
    
    local tmpTableView = UITableView:create();
    tmpTableView:setFrame(self:view():bounds());
    tmpTableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    tmpTableView:setTableHeaderView(cview);
    self:view():addSubview(tmpTableView);
    self.tableView = tmpTableView:retain();
    
    ap_release();
end

function analyzeResponseString(responseString)
    print("response:"..responseString);
    local beginIndex = ustring::find(responseString, "邮编：");
    if beginIndex ~= -1 then
        beginIndex = ustring::find(responseString, "<div>", beginIndex, true);
        if beginIndex ~= -1 then
            local endIndex = ustring::find(responseString, "<br/>", beginIndex);
            if endIndex ~= -1 then
                return ustring::substring(responseString, beginIndex + 5, endIndex);
            end
        end
    end
    return nil;
end
