--http://translate.google.cn/?hl=zh-CN&tab=wT#zh-CN/en/测试用例
require "UIKit"
require "System"
require "Utils"

GoogleTranslateViewController = {};
GoogleTranslateViewController.__index = GoogleTranslateViewController;
setmetatable(GoogleTranslateViewController, UIViewController);

function GoogleTranslateViewController:viewDidLoad()
    ui::alert("test");
end

function main()
    
end