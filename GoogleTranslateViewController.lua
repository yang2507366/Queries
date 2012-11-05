--http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/测试用例
require "UIKit"
require "System"
require "Utils"
require "Network"
require "NSMutableArray"
require "NSMutableDictionary"

GoogleTranslateViewController = {};
GoogleTranslateViewController.__index = GoogleTranslateViewController;
setmetatable(GoogleTranslateViewController, UIViewController);

local cnTextView;
local enTextView;
local closeKeyboardBtn;
local translateBtn;

function GoogleTranslateViewController:dealloc()
    cnTextView:release();
    enTextView:release();
    closeKeyboardBtn:release();
    translateBtn:release();
end

function GoogleTranslateViewController:viewDidLoad()
    ap_new();
    local globalSelf = self;
    
    closeKeyboardBtn = UIBarButtonItem:createWithTitle("关闭"):retain();
    closeKeyboardBtn:setStyle(UIBarButtonItemStyleDone);
    
    local cnLabel = UILabel:createWithText("输入需要翻译的中文:");
    cnLabel:setFrame(5, 5, 200, cnLabel:font():lineHeight());
    self:view():addSubview(cnLabel);
    
    cnTextView = UITextView:create():retain();
    cnTextView:setFrame(5, 25, 310, 90);
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
        enTextView:resignFirstResponder();
    end
    
    enTextView = UITextView:create():retain();
    enTextView:setFrame(5, 165, 310, 170);
    enTextView:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth));
    enTextView:setBackgroundColor(UIColor:createWithRGB(245, 245, 245));
    self:view():addSubview(enTextView);
    function enTextView:didBeginEditing()
        ap_new();
        globalSelf:navigationItem():setRightBarButtonItem(closeKeyboardBtn, true);
        
        ap_release();
    end
    function enTextView:didEndEditing()
        ap_new();
        
        globalSelf:navigationItem():setRightBarButtonItem(nil);
        
        ap_release();
    end
    
    translateBtn = UIButton:createWithTitle("翻译"):retain();
    translateBtn:setFrame(5, 120, 310, 40);
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
        cnTextView:resignFirstResponder();
        globalSelf:setWaiting(true);
        local urlString = "http://translate.google.com/translate_t#";
        local params = NSMutableDictionary:create();
        print("dictions:"..params:id());
        params:setObjectForKey("hl", "en");
        params:setObjectForKey("UTF-8", "ie");
        params:setObjectForKey("zh-CN", "sl");
        params:setObjectForKey("en", "tl");
        params:setObjectForKey(cnText, "text");
        local req = HTTPRequest:post(urlString, params);
        function req:response(responseString, errorString)
--            po("response:"..responseString);
            globalSelf:setWaiting(false);
            local beginIndex = ustring::find(responseString, "result_box");
            if beginIndex ~= -1 then
                local endIndex = ustring::find(responseString, "</span>", beginIndex + 10);
                if endIndex ~= -1 then
                    beginIndex = ustring::find(responseString, ">", endIndex, true);
                    if beginIndex ~= -1 then
                        print(ustring::substring(responseString, beginIndex + 1, endIndex));
                        enTextView:setText(ustring::substring(responseString, beginIndex + 1, endIndex));
                        return;
                    end
                end
            end
            ui::alert("翻译失败，数据错误");
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
    
--[[    local mdict = NSMutableDictionary:create();
    mdict:setObjectForKey("test", "key1");
    mdict:setObjectForKey("test2", "key2");
    local ma = mdict:allKeys();
    print(ma:count());
    print(ma:objectAtIndex(0));]]
    
    ap_release();
end
