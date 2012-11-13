require "UIViewController"
require "UINavigationController"
require "UITableView"
require "UITableViewDataSource"
require "CommonUtils"
require "UITableViewCell"
require "UILabel"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:createWithTitle("在线词典"):retain();
    relatedVC:navigationController():pushViewController(dictVC, true);

    function dictVC:viewDidLoad()
        ap_new();
        
        local tableView = UITableView:create();
        tableView:setFrame(self:view():bounds());
        tableView:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
        self:view():addSubview(tableView);
        
        local dataSource = {};
        function dataSource:numberOfRowsInSection(section)
            return 10;
        end
        
        function dataSource:numberOfSections()
            return 10;
        end
        
        function dataSource:cellForRowAtIndexPath(indexPath)
            ap_new();
            local cell = tableView:dequeueReusableCellWithIdentifier("id");
            if not cell then
                cell = UITableViewCell:create("id");
            end
            cell:keep();
            cell:textLabel():setText(indexPath:section()..", "..indexPath:row());
            ap_release();
            return cell;
        end
        
        function dataSource:titleForHeaderInSection(section)
            return "section header "..section;
        end
        
        function dataSource:titleForFooterInSection(section)
            return "section footer "..section;
        end
        
        function dataSource:canEditRowAtIndexPath(indexPath)
            return true;
        end
        
        tableView:setDataSource(dataSource);
        
        ap_release();
    end
    
    
    ap_release();
end
