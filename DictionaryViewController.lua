require "UIViewController"
require "UINavigationController"
require "UITableView"
require "UITableViewDataSource"
require "CommonUtils"
require "UITableViewCell"
require "UILabel"
require "NSMutableArray"
require "UIFont"
require "AppBundle"
require "UIButton"
require "UIBarButtonItem"
require "UILabel"
require "UITextField"
require "UITextView"
require "UIPickerView"
require "UIAnimation"

function main()
    ap_new();
    local relatedVC = UIViewController:get(ui::getRelatedViewController());
    local dictVC = UIViewController:create("在线词典"):retain();
    function dictVC:viewDidLoad()
        ap_new();
        --[[
        local tableView = UITableView:create():retain();
        tableView:setFrame(self:view():bounds());
        tableView:setAutoresizingMask(UIViewAutoresizingFlexibleHeight);
        self:view():addSubview(tableView);
        local tableViewDataSource = {};
        function tableViewDataSource:numberOfSections(tmpTableView)
            return 10;
        end
        function tableViewDataSource:numberOfRowsInSection(tmpTableView)
            return 10;
        end
        function tableViewDataSource:titleForHeaderInSection(tmpTableView, section)
            return "header-"..section;
        end
        local cellIdentfier = "c_id";
        function tableViewDataSource:cellForRowAtIndexPath(tmpTableView, indexPath)
            ap_new();
            setmetatable(tmpTableView, UITableView);
            local cell = tmpTableView:dequeueReusableCellWithIdentifier(cellIdentfier);
            if not cell then
                cell = UITableViewCell:create(cellIdentfier);
            end
            cell:keep();
            cell:textLabel():setText(indexPath:row());
            ap_release();
            return cell;
        end
        tableView:setDataSource(tableViewDataSource);
         ]]
        
        local pickerView = UIPickerView:create():retain();
        pickerView:setFrame(10, 10, 300, 300);
        pickerView:setShowsSelectionIndicator(true);
        local pickerViewDelegate = {};
        function pickerViewDelegate:titleForRowForComponent(pickerView, row, component)
            return "title-"..component..","..row;
        end
        local pickerViewDataSource = {};
        function pickerViewDataSource:numberOfComponents()
            return 2;
        end
        function pickerViewDataSource:numberOfRowsInComponent()
            return 10;
        end
        pickerView:setDataSource(pickerViewDataSource);
        pickerView:setDelegate(pickerViewDelegate);
        self:view():addSubview(pickerView);
        
        local anim = UIAnimation:create();
        function anim:animation()
            pickerView:setFrame(10, 200, 300, 300);
        end
        anim:start(2.0);
        
        ap_release();
    end
    
    function dictVC:viewDidPop()
        self:release();
    end
    relatedVC:navigationController():pushViewController(dictVC, true);
    
    ap_release();
end
