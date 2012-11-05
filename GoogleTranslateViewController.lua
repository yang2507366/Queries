--http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/测试用例
require "UIKit"
require "System"
require "Utils"

GoogleTranslateViewController = {};
GoogleTranslateViewController.__index = GoogleTranslateViewController;
setmetatable(GoogleTranslateViewController, UIViewController);

local cnTextView;
local closeKeyboardBtn;

function GoogleTranslateViewController:dealloc()
    cnTextView:release();
end

function GoogleTranslateViewController:viewDidLoad()
    ap_new();
    
    local globalSelf = self;
    
    closeKeyboardBtn = UIBarButtonItem:createWithTitle("关闭"):retain();
    
    cnTextView = UITextView:create():retain();
    cnTextView:setFrame(5, 5, 310, 120);
    cnTextView:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    cnTextView:setBackgroundColor(UIColor:createWithRGB(255, 0, 0));
    self:view():addSubview(cnTextView);
    function cnTextView:didBeginEditing()
        ap_new();
        globalSelf:navigationItem():setRightBarButtonItem(closeKeyboardBtn);
        
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
