require "UIKit"
require "QueryMobileNumberViewController"
require "QueryPostcodeViewController"
require "GoogleTranslateViewController"

kTitleSearchMobileNumber = "手机号码归属地";
kTitleSearchPostcode = "邮政编码";
kTitleGoogleTranslate = "Google翻译";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchPostcode, kTitleGoogleTranslate};

QuiresListViewController = {};
QuiresListViewController.__index = QuiresListViewController;
setmetatable(QuiresListViewController, UIViewController);

function QuiresListViewController:viewDidLoad()
    ap_new();
    listTableView = UITableView:create():retain();
    listTableView:setFrame(self:view():bounds());
    self:view():addSubview(listTableView);
    
    function listTableView:numberOfRows()
        return #kTitleList;
    end
    function listTableView:heightOfRowAtIndex(rowIndex)
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
            
            label = UILabel:createWithTitle("");
            label:setTag(1001);
            local x, y, width, height = cell:contentView():bounds();
            label:setFrame(10, 0, width, 72);
            cell:contentView():addSubview(label);
            cell:setAccessoryType(UITableViewCellAccessoryDisclosureIndicator);
        else
            label = cell:contentView():viewWithTag(1001, UILabel);
        end
        cell:retain();
        
        label:setText(kTitleList[index + 1]);
        
        ap_release();
        return cell;
    end
    
    local currentNC = self:navigationController():retain();
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
            local vc = GoogleTranslateViewController:createWithTitle(kTitleGoogleTranslate):retain();
            function vc:viewDidPop()
                vc:release();
            end
            currentNC:pushViewController(vc, true);
        end
        ap_release();
    end
    ap_release();
end

function callbackFunc(buttonIndex, buttonTitle)
    print(buttonIndex..","..buttonTitle);
end