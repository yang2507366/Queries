require "UIKit"
require "QueryMobileNumberViewController"

kTitleSearchMobileNumber = "搜索手机号码";
kTitleSearchWord = "搜索单词";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchWord};

QuiresListViewController = {};
QuiresListViewController.__index = QuiresListViewController;
setmetatable(QuiresListViewController, UIViewController);

function QuiresListViewController:viewDidLoad()
    self.tableView = UITableView:create();
    self.tableView:setFrame(self:view():bounds());
    self:view():addSubview(self.tableView);
    
    function self.tableView:numberOfRows()
        return #kTitleList;
    end
    
    local identifier = "id_";
    function self.tableView:cellForRowAtIndex(index)
        ap_new();
        local cell = self:dequeueReusableCellWithIdentifier(identifier);
        if cell == nil then
            cell = UITableViewCell:create(identifier);
        end
        cell:textLabel():setText(kTitleList[index + 1]);
        
        ap_release();
        return cell;
    end
    
    local currentNC = self:navigationController();
    function self.tableView:didSelectCellAtIndex(rowIndex)
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