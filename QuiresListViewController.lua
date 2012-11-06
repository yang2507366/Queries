require "System"
require "UIKit"
require "QueryMobileNumberViewController"
require "QueryPostcodeViewController"
require "GoogleTranslateViewController"
require "AppLoader"

kTitleSearchMobileNumber = "手机号码归属地";
kTitleSearchPostcode = "邮政编码";
kTitleGoogleTranslate = "Google翻译";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchPostcode, kTitleGoogleTranslate};

local QuiresListViewController = {};
QuiresListViewController.__index = QuiresListViewController;
setmetatable(QuiresListViewController, UIViewController);

local listTableView;
local currentNC;

function QuiresListViewController:viewDidLoad()
    ap_new();
    
    local globalSelf = self;
    
    listTableView = UITableView:create():retain();
    listTableView:setFrame(self:view():bounds());
    self:view():addSubview(listTableView);
    
    function listTableView:numberOfRows()
        return #kTitleList;
    end
    function listTableView:heightForRowAtIndex(rowIndex)
        return 72;
    end
    local identifier = "id_";
    function listTableView:cellForRowAtIndex(index)
        ap_new();
        local cell = self:dequeueReusableCellWithIdentifier(identifier);
        
        local label = nil;
        if cell == nil then
            cell = UITableViewCell:create(identifier);
            cell:textLabel():setFont(UIFont:createWithFontSize(16));
            
            label = UILabel:createWithText("");
            label:setTag(1001);
            local x, y, width, height = cell:contentView():bounds();
            label:setFrame(10, 0, width, 72);
            cell:contentView():addSubview(label);
            cell:setAccessoryType(UITableViewCellAccessoryDisclosureIndicator);
        else
            label = cell:contentView():viewWithTag(1001, UILabel);
        end
        cell:keep();-- 保持该对象不被释放
        
        label:setText(kTitleList[index + 1]);
        
        ap_release();
        return cell;
    end
    
    currentNC = self:navigationController():retain();
    function listTableView:didSelectCellAtIndex(rowIndex)
        ap_new();
        self:deselectRow(rowIndex);
        local index = rowIndex + 1;
        if kTitleList[index] == kTitleSearchMobileNumber then
            -- 手机号码
            local vc = QueryMobileNumberViewController:createWithTitle(kTitleSearchMobileNumber):retain();
            function vc:viewDidPop()
                vc:release();
            end
            currentNC:pushViewController(vc, true);
        elseif kTitleList[index] == kTitleSearchPostcode then
            -- 邮政编码
            local vc = QueryPostcodeViewController:createWithTitle(kTitleSearchPostcode):retain();
            function vc:viewDidPop()
                vc:release();
            end
            currentNC:pushViewController(vc, true);
        elseif kTitleList[index] == kTitleGoogleTranslate then
            -- google翻译
            if globalSelf.loader then
                globalSelf.loader:release();
            end
            globalSelf.loader = AppLoader:create():retain();
            globalSelf.loader:load("http://imyvoaspecial.googlecode.com/files/gt4.zip");
            globalSelf:setWaiting(true);
            function globalSelf.loader:complete(success, appId)
                globalSelf:setWaiting(false);
                app::runApp(appId, globalSelf:id());
            end
        end
        ap_release();
    end
    ap_release();
end


function main()
    ap_new();
    
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local quiresListVC = QuiresListViewController:createWithTitle("快捷查询"):retain();
    relatedVC:navigationController():pushViewController(quiresListVC, true);
    function quiresListVC:viewDidPop()
        UIViewController.viewDidPop(self);
        listTableView:release();
        currentNC:release();
        srelease(quiresListVC.loader);
        self:release();
    end
    
    ap_release();
end
