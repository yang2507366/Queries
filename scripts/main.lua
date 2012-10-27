import UIKit.lua;

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
    end
    function tableView:cellForRowAtIndex(rowIndex)
        
    end
    tmpVC:addSubview(tableView);
    tableView:setRowHeight(100);
    tableView:reloadData();
end