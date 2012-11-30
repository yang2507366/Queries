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
                bself:view():setFrame(tx, ty - 100, tw, th);
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
                bself:view():setFrame(tx, ty + 100, tw, th);
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
        ap_new();
        local city = addressField:text();
        if ustring::length(city) == 0 then
            ui::alert("请输入需要查询的地名");
            addressField:becomeFirstResponder();
            ap_release();
            return;
        end
        addressField:resignFirstResponder();
        bself:setWaiting(true);
        local urlString = "http://wap.ip138.com/post_search.asp?area="..ustring::encodeURL(city).."&action=area2zip";
        local req = HTTPRequest:start(urlString);
        function req:response(responseString, errorString)
            ap_new();
            bself:setWaiting(false);
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
    addressButton:setFrame(10, 75, width - 20, 40);
    addressButton:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(addressButton);
    
    postcodeButton = UIButton:create("查询"):retain();
    function postcodeButton:tapped()
        if ustring::length(postcodeField:text()) == 0 then
            ui::alert("请输入需要查询的邮政编码");
            bself.postcodeField:becomeFirstResponder();
            return;
        end
        postcodeField:resignFirstResponder();
        bself:setWaiting(true);
        local postcode = postcodeField:text();
        local urlString = "http://wap.ip138.com/post_search.asp?zip="..postcode.."&action=zip2area";
        local httpReq = HTTPRequest:start(urlString);
        function httpReq:response(responseString, errorString)
            ap_new();
            bself:setWaiting(false);
            local result = analyzeResponseString(responseString);
            if result then
                ui::alert(result);
            else
                ui::alert("没有找到相关邮编："..postcode);
            end
            ap_release();
        end
    end
    postcodeButton:setFrame(10, 200, width - 20, 40);
    postcodeButton:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(postcodeButton);
    
    ap_release();
end

function analyzeResponseString(responseString)
--    print("response:"..responseString);
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