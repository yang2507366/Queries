require "UIKit"
require "Net"

MobileNumberViewController = {};
MobileNumberViewController.__index = MobileNumberViewController;
setmetatable(MobileNumberViewController, UIViewController);

local button;
local textField;
local closeKeyboardBtn;

function MobileNumberViewController:dealloc()
    textField:release();
    closeKeyboardBtn:release();
    button:release();
    UIViewController.dealloc(self);
end

function MobileNumberViewController:viewDidLoad()
    ap_new();
    
    local bself = self;
    
    local containerView = UIView:create();
    containerView:setFrame(self:view():bounds());
    containerView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
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
    
    closeKeyboardBtn = UIBarButtonItem:create("关闭"):retain();
    closeKeyboardBtn:setStyle(UIBarButtonItemStyleDone);
    function closeKeyboardBtn:tapped()
        textField:resignFirstResponder();
    end
    local textFieldDelegate = {};
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
    textField:setDelegate(textFieldDelegate);
    button = UIButton:create("查询"):retain();
    function button:tapped()
        ap_new();
        
        local number = textField:text();
        if ustring::length(number) ~= 11 then
            ui::alert("请输入正确的手机号码");
            textField:becomeFirstResponder();
            ap_release();
            return;
        end
        textField:resignFirstResponder();
        bself:setWaiting(true);
        
        httpRequest = HTTPRequest:start("http://wap.ip138.com/sim_search.asp?mobile="..number);
        function httpRequest:response(responseString, errorString)
            ap_new();
            bself:setWaiting(false);
            if ustring::length(errorString) == 0 then
                anylyzeResponse(responseString, number);
            else
                ui::alert("网络连接错误");
            end
            ap_release();
        end
        ap_release();
    end
    button:setFrame(10, 90, width - 20, 40);
    button:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(button);
    
    local gridView = UIGridView:create():retain();
    gridView:setFrame(0, 100, 320, 200);
    self:view():addSubview(gridView);
    local gridViewDelegate = {};
    function gridViewDelegate:numberOfItemsInGridView()
        return 10;
    end
    
    function gridViewDelegate:configureViewAtIndex(gridView, view, index)
        
    end
    
    gridView:setDelegate(gridViewDelegate);
    
    ap_release();
end

function anylyzeResponse(str, number)
    ap_new();
--    po(str);
    local beginIndex = ustring::find(str, "归属地：");
    if beginIndex ~= -1 then
        local endIndex = ustring::find(str, "<br/>", beginIndex);
        if endIndex ~= -1 then
            ui::alert(ustring::substring(str, beginIndex + 4, endIndex));
            return;
        end
    end
    ui::alert("没有找到号码:"..number.."的相关信息");
    ap_release();
end