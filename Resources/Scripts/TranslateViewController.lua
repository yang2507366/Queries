require "UIKit"
require "Utils"
require "Net"

TranslateViewController = {};
TranslateViewController.__index = TranslateViewController;
setmetatable(TranslateViewController, UIViewController);

local cnTextView;
local enTextView;
local closeKeyboardBtn;
local translateBtn;

function TranslateViewController:dealloc()
    cnTextView:release();
    enTextView:release();
    closeKeyboardBtn:release();
    translateBtn:release();
    UIViewController.dealloc(self);
end

function TranslateViewController:viewDidLoad()
    local bself = self;
    
    local x, y, width, height = self:view():bounds();
    
    local cnLabel = UILabel:create("输入需要翻译的中文:");
    cnLabel:setFrame(5, 5, 200, cnLabel:font():lineHeight());
    self:view():addSubview(cnLabel);
    
    cnTextView = UITextView:create():retain();
    cnTextView:setFrame(5, 25, 310, 90);
    cnTextView:setFont(UIFont:create(14));
    cnTextView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth));
    cnTextView:setBackgroundColor(UIColor.clearColor());
    local bgFieldView = UITextField:create();
    bgFieldView:setFrame(cnTextView:frame());
    bgFieldView:setAutoresizingMask(cnTextView:autoresizingMask());
    bgFieldView:setUserInteractionEnabled(false);
    self:view():addSubview(bgFieldView);
    self:view():addSubview(cnTextView);
    
    closeKeyboardBtn = UIBarButtonItem:create("关闭"):retain();
    closeKeyboardBtn:setStyle(UIBarButtonItemStyleDone);
    function closeKeyboardBtn:tapped()
        cnTextView:resignFirstResponder();
        enTextView:resignFirstResponder();
    end
    
    enTextView = UITextView:create():retain();
    enTextView:setFrame(5, 165, 310, height - 205 - 5);
    enTextView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
    enTextView:setBackgroundColor(UIColor.clearColor());
    enTextView:setFont(UIFont:create(14));
    enTextView:setEditable(false);
    bgFieldView = UITextField:create();
    bgFieldView:setFrame(enTextView:frame());
    bgFieldView:setEnabled(false);
    bgFieldView:setAutoresizingMask(enTextView:autoresizingMask());
    bgFieldView:setUserInteractionEnabled(false);
    self:view():addSubview(bgFieldView);
    self:view():addSubview(enTextView);
    
    local textViewDelegate = {};
    function textViewDelegate:didBeginEditing()
        bself:navigationItem():setRightBarButtonItem(closeKeyboardBtn, true);
    end
    function textViewDelegate:didEndEditing()
        bself:navigationItem():setRightBarButtonItem(nil);
    end
    enTextView:setDelegate(textViewDelegate);
    cnTextView:setDelegate(textViewDelegate);
    
    translateBtn = UIButton:create("翻译"):retain();
    translateBtn:setFrame(5, 120, 310, 40);
    translateBtn:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    self:view():addSubview(translateBtn);
    function translateBtn:tapped()
        local cnText = cnTextView:text();
        if ustring::length(cnText) == 0 then
            ui::alert("请输入需要翻译的中文");
            cnTextView:becomeFirstResponder();
            return;
        end
        cnTextView:resignFirstResponder();
        bself:setWaiting(true);
        local urlString = "http://translate.google.com/translate_t#";
        local params = NSMutableDictionary:create();
        params:setObjectForKey("hl", "en");
        params:setObjectForKey("UTF-8", "ie");
        params:setObjectForKey("zh-CN", "sl");
        params:setObjectForKey("en", "tl");
        params:setObjectForKey(cnText, "text");
        local req = HTTPRequest:post(urlString, params, HTTPRequestEncodingGBK);
        function req:response(responseString, errorString)
--            po("response:"..responseString);
            bself:setWaiting(false);
            local beginIndex = ustring::find(responseString, "result_box");
            if beginIndex ~= -1 then
                local endIndex = ustring::find(responseString, "</span>", beginIndex + 10);
                if endIndex ~= -1 then
                    beginIndex = ustring::find(responseString, ">", endIndex, true);
                    if beginIndex ~= -1 then
                        print(ustring::substring(responseString, beginIndex + 1, endIndex));
                        enTextView:setText(filterTranslatedString(ustring::substring(responseString, beginIndex + 1, endIndex)));
                        return;
                    end
                end
            end
            ui::alert("翻译失败，数据错误");
        end
    end
end

function filterTranslatedString(str)
    str = ustring::replace(str, "&#39;", "'");
    return str;
end

function main()
    local vc = TranslateViewController:create("Google翻译"):retain();
    function vc:viewDidPop()
        self:release();
    end
    vc:pushToRelatedViewController();
end
