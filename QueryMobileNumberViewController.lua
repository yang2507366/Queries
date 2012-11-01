require "System"
require "UIKit"

QueryMobileNumberViewController = {};
QueryMobileNumberViewController.__index = QueryMobileNumberViewController;
setmetatable(QueryMobileNumberViewController, UIViewController);

local tableView;
local button;
local textField;

function QueryMobileNumberViewController:dealloc()
    tableView:release();
    button:release();
    textField:release();
end

function QueryMobileNumberViewController:viewDidLoad()
    ap_new();
    local x, y, width, height = self:view():bounds();
    local tmpView = UIView:create():autorelease();
    tmpView:setFrame(x, y, width, 150);
    tmpView:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth));
    
    local label = UILabel:createWithTitle("手机号码:"):autorelease();
    label:setFrame(10, 10, 80, label:font():lineHeight());
    tmpView:addSubview(label);
    
    button = UIButton:createWithTitle("搜索"):retain();
    button:setFrame(10, 95, width - 20, 40);
    button:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    tmpView:addSubview(button);
    
    textField = UITextField:create():retain();
    textField:setFrame(10, 40, width - 20, 40);
    textField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    textField:setClearButtonMode(UITextFieldViewModeWhileEditing);
    tmpView:addSubview(textField);
    
    tableView = UITableView:create():retain();
    tableView:setFrame(self:view():bounds());
    self:view():addSubview(tableView);
    tableView:setTableHeaderView(tmpView);
    tableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    ap_release();
end