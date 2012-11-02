require "UIKit"
require "System"
require "Network"

QueryPostcodeViewController = {};
QueryPostcodeViewController.__index = QueryPostcodeViewController;
setmetatable(QueryPostcodeViewController, UIViewController);

function QueryPostcodeViewController:dealloc()
    print("dealloc query postcode");
end

function QueryPostcodeViewController:viewDidLoad()
    ap_new();
    
    ap_release();
end