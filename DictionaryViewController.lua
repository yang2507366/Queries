require "UIViewController"
require "UINavigationController"
require "UITableView"
require "UITableViewDataSource"
require "CommonUtils"
require "UITableViewCell"
require "UILabel"
require "NSMutableArray"

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
                cell:setAccessoryType(2);
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
            return "footer";
        end
        
        function dataSource:canEditRowAtIndexPath(indexPath)
            if indexPath:section() % 2 == 0 then
                return true;
            end
            return false;
        end
        
        function dataSource:canMoveRowAtIndexPath(indexPath)
            if indexPath:section() % 2 == 0 then
                return true;
            end
            return false;
        end
        
        function dataSource:moveRowAtIndexPath(sourceIndexPath, descIndexPath)
            print(sourceIndexPath:row()..", "..descIndexPath:row());
        end
        
        local titles = NSMutableArray:create():keep();
        titles:addObject("a");
        titles:addObject("b");
        titles:addObject("c");
        titles:addObject("d");
        titles:addObject("e");
        titles:addObject("f");
        function dataSource:sectionIndexTitles()
            return titles;
        end
        
        function dataSource:sectionForSectionIndexTitle(title, index)
            if index == 4 then
                return 4;
            end
            return 0;
        end
        
        function dataSource:commitEditingStyle(editingStyle, indexPath)
            print(editingStyle..","..indexPath:row());
        end
        
        local delegate = {};
        
        function delegate:willDisplayCell(cell, indexPath)
            print("WILL DISPLAY:"..cell:id()..","..indexPath:row());
        end
        
        function delegate:willDisplayHeaderView(view, section)
            print("header view:"..view:id()..","..section);
        end
        
        function delegate:willDisplayFooterView(view, section)
            print("footer view:"..view:id()..","..section);
        end
        
        function delegate:didEndDisplayingCell(cell, indexPath)
            print("END DISPLAY:"..cell:id()..","..indexPath:row());
        end
        
        function delegate:didEndDisplayingHeaderView(view, section)
            print("end header view:"..view:id()..","..section);            
        end
        
        function delegate:didEndDisplayingFooterView(view, section)
            print("end footer view:"..view:id()..","..section);
        end
        
        function delegate:heightForRowAtIndexPath(indexPath)
            return 100.0;
        end
        
        function delegate:heightForHeaderInSection(section)
            return 50.0;
        end
        
        function delegate:heightForFooterInSection(section)
            return 50.0;
        end
        
        function delegate:viewForHeaderInSection(section)
            ap_new();
            local label = UILabel:createWithText("section:"..section):keep();
            label:setBackgroundColor(UIColor:createWithRGB(0, 0, 0));
            label:setTextColor(UIColor:createWithRGB(255, 255, 255));
            ap_release();
            
            return label;
        end
        
        function delegate:viewForFooterInSection(section)
            ap_new();
            local label = UILabel:createWithText("footer:"..section):keep();
            label:setBackgroundColor(UIColor:createWithRGB(0, 0, 0));
            label:setTextColor(UIColor:createWithRGB(255, 255, 255));
            ap_release();
            
            return label;
        end
        
        function delegate:accessoryButtonTappedForRowWithIndexPath(indexPath)
            print(indexPath:section()..", "..indexPath:row());
        end
        
        function delegate:shouldHighlightRowAtIndexPath(indexPath)
            return true;
        end
        
        function delegate:didHighlightRowAtIndexPath(indexPath)
            print("did high:"..indexPath:row());
        end
        
        function delegate:didUnhighlightRowAtIndexPath(indexPath)
            print("un high:"..indexPath:row());
        end
        
        tableView:setDataSource(dataSource);
        tableView:setDelegate(delegate);
        tableView:setEditing(false);
        
        ap_release();
    end
    
    
    ap_release();
end
