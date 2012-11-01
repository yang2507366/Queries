require "UIKit"
require "QueryMobileNumberViewController"

kTitleSearchMobileNumber = "搜索手机号码";
kTitleSearchWord = "搜索单词";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchWord};

QuiresListViewController = {};
QuiresListViewController.__index = QuiresListViewController;
setmetatable(QuiresListViewController, UIViewController);

function QuiresListViewController:viewDidLoad()
    listTableView = UITableView:create():retain();
    listTableView:setFrame(self:view():bounds());
    self:view():addSubview(listTableView);
    
    function listTableView:numberOfRows()
        return #kTitleList;
    end
    
    local identifier = "id_";
    function listTableView:cellForRowAtIndex(index)
        ap_new();
        local cell = self:dequeueReusableCellWithIdentifier(identifier);
        if cell == nil then
            cell = UITableViewCell:create(identifier):retain();
        end
        cell:textLabel():setText(kTitleList[index + 1]);
        
        ap_release();
        return cell:autorelease();
    end
    
    local currentNC = self:navigationController():retain();
    function listTableView:didSelectCellAtIndex(rowIndex)
        self:deselectRow(rowIndex);
        local index = rowIndex + 1;
        if kTitleList[index] == kTitleSearchMobileNumber then
            po(kTitleSearchMobileNumber);
            
            local vc = QueryMobileNumberViewController:createWithTitle(kTitleSearchMobileNumber);
            function vc:viewDidPop()
                vc:release();
            end
            
            currentNC:pushViewController(vc, true);
        elseif kTitleList[index] == kTitleSearchWord then
            po(kTitleSearchWord);
        end
    end
end