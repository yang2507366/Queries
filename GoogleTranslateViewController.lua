--http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/测试用例
require "UIKit"
require "System"
require "Utils"
require "Network"

GoogleTranslateViewController = {};
GoogleTranslateViewController.__index = GoogleTranslateViewController;
setmetatable(GoogleTranslateViewController, UIViewController);

local cnTextView;
local closeKeyboardBtn;
local translateBtn;

function GoogleTranslateViewController:dealloc()
    cnTextView:release();
    closeKeyboardBtn:release();
    translateBtn:release();
end

function GoogleTranslateViewController:viewDidLoad()
    ap_new();
    local globalSelf = self;
    
    closeKeyboardBtn = UIBarButtonItem:createWithTitle("关闭"):retain();
    closeKeyboardBtn:setStyle(UIBarButtonItemStyleDone);
    print(closeKeyboardBtn);
    
    local cnLabel = UILabel:createWithText("输入需要翻译的中文:");
    cnLabel:setFrame(5, 5, 200, cnLabel:font():lineHeight());
    self:view():addSubview(cnLabel);
    
    cnTextView = UITextView:create():retain();
    cnTextView:setFrame(5, 25, 310, 170);
    cnTextView:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth));
    cnTextView:setBackgroundColor(UIColor:createWithRGB(235, 235, 235));
    self:view():addSubview(cnTextView);
    function cnTextView:didBeginEditing()
        ap_new();
        globalSelf:navigationItem():setRightBarButtonItem(closeKeyboardBtn, true);
        
        ap_release();
    end
    function cnTextView:didEndEditing()
        ap_new();
        
        globalSelf:navigationItem():setRightBarButtonItem(nil);
        
        ap_release();
    end
    function closeKeyboardBtn:tapped()
        cnTextView:resignFirstResponder();
    end
    
    translateBtn = UIButton:createWithTitle("翻译"):retain();
    translateBtn:setFrame(5, 200, 310, 40);
    translateBtn:setAutoresizingMask(cnTextView:autoresizingMask());
    self:view():addSubview(translateBtn);
    function translateBtn:tapped()
        ap_new();
        local cnText = cnTextView:text();
        if ustring::length(cnText) == 0 then
            ui::alert("请输入需要翻译的中文");
            cnTextView:becomeFirstResponder();
            return;
        end
        local urlString = "http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/"..ustring::encodeURL(cnTextView:text());
        local req = HTTPRequest:start(urlString);
        function req:response(responseString, errorString)
            
        end
        ap_release();
    end
    
    ap_release();
end


function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local gtVC = GoogleTranslateViewController:createWithTitle("Google翻译"):retain();
    relatedVC:navigationController():pushViewController(gtVC, true);
    function gtVC:viewDidPop()
        gtVC:release();
    end
    ap_release();
end
