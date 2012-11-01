require "System"
require "UIKit"
require "Network"

--http://wap.ip138.com/sim_search.asp?mobile=18607072318

QueryMobileNumberViewController = {};
QueryMobileNumberViewController.__index = QueryMobileNumberViewController;
setmetatable(QueryMobileNumberViewController, UIViewController);

local tableView;
local button;
local textField;
local httpRequest;

function QueryMobileNumberViewController:dealloc()
    tableView:release();
    button:release();
    textField:release();
    httpRequest:cancel(); httpRequest:release();
end

function QueryMobileNumberViewController:viewDidLoad()
    ap_new();
    local x, y, width, height = self:view():bounds();
    local tmpView = UIView:create():autorelease();
    tmpView:setFrame(x, y, width, 150);
    tmpView:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth));
    
    local label = UILabel:createWithTitle("手机号码："):autorelease();
    label:setFrame(10, 10, 80, label:font():lineHeight());
    tmpView:addSubview(label);
    
    textField = UITextField:create();
    textField:setFrame(10, 40, width - 20, 40);
    textField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    textField:setClearButtonMode(UITextFieldViewModeWhileEditing);
    tmpView:addSubview(textField);
    
    button = UIButton:createWithTitle("搜索");
    button:setFrame(10, 95, width - 20, 40);
    button:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    tmpView:addSubview(button);
    function button:tapped()
        textField:resignFirstResponder();
        httpRequest = HTTPRequest:start("http://wap.ip138.com/sim_search.asp?mobile=18607072318"):retain();
        
        function httpRequest:response(responseString, errorString)
            print(responseString);
        end
    end
    
    tableView = UITableView:create();
    tableView:setFrame(self:view():bounds());
    self:view():addSubview(tableView);
    tableView:setTableHeaderView(tmpView);
    tableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    ap_release();
end