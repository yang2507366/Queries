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
    srelease(tableView);
    srelease(button);
    srelease(textField);
    srelease(httpRequest);
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
    
    textField = UITextField:create():retain();
    textField:setFrame(10, 40, width - 20, 40);
    textField:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    textField:setClearButtonMode(UITextFieldViewModeWhileEditing);
    tmpView:addSubview(textField);
    
    button = UIButton:createWithTitle("搜索"):retain();
    button:setFrame(10, 95, width - 20, 40);
    button:setAutoresizingMask(UIViewAutoresizingFlexibleWidth);
    tmpView:addSubview(button);
    function button:tapped()
        local number = textField:text();
        if ustring::length(number) ~= 11 then
            ui::alert("请输入正确的手机号码");
            return;
        end
        httpRequest = HTTPRequest:start("http://wap.ip138.com/sim_search.asp?mobile="..number);
        
        function httpRequest:response(responseString, errorString)
            if ustring::length(errorString) == 0 then
                anylyzeResponse(responseString);
            else
                ui::alert("网络连接错误");
            end
        end
    end
    
    tableView = UITableView:create():retain();
    tableView:setFrame(self:view():bounds());
    self:view():addSubview(tableView);
    tableView:setTableHeaderView(tmpView);
    tableView:setSeparatorStyle(UITableViewCellSeparatorStyleNone);
    ap_release();
end

function anylyzeResponse(str)
    local beginIndex = ustring::find(str, "归属地：");
    if beginIndex ~= -1 then
        local endIndex = ustring::find(str, "<br/>", beginIndex);
        if endIndex ~= -1 then
            print(beginIndex..", "..endIndex);
            ui::alert(ustring::substring(str, beginIndex + 4, endIndex));
            return;
        end
    end
    ui::alert("数据解析出错");
end