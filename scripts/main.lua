import UIKit.lua;
import Object.lua;

function main()
    local tmpVC = ViewController:new();
    function tmpVC:viewDidLoad()
        NSLog("viewController");
    end
    function tmpVC:viewWillAppear(vcId)
        NSLog("viewWillAppear");
    end
    NavigationController:new(tmpVC):setAsRootViewController();

    local tableView = TableView:new();
    function tableView:numberOfRows()
        return 10;
    end
    function tableView:didSelectRowAtIndex(rowIndex)
        NSLog("rowIndex"..rowIndex);
        self:deselectRow(rowIndex);
    end
    local identifier = "id";
    function tableView:cellForRowAtIndex(rowIndex)
        local cell = self:dequeueReusableCellWithIdentifier(identifier);
        if cell == nil then
            cell = TableViewCell:new(identifier);
        end
        
        return cell.id;
    end
    function tableView:heightForRowAtIndex(rowIndex)
        if rowIndex % 2 == 0 then
            return 100;
        end
        return 40;
    end
    tmpVC:addSubview(tableView);
    tableView:setRowHeight(100);
    tableView:reloadData();
    tableView:deselectRow(0);
end