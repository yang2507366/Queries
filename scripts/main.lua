require "AutoreleasePool"
require "Object"
require "Utils"
require "UIViewController"
require "UINavigationController"
require "UIView"
require "UIColor"
require "UILabel"
require "UIFont"
require "UIBarButtonItem"
require "UIButton"
require "UITableView"
require "UITableViewCell"

function main()
    ap_new();
    local vc = UIViewController:createWithTitle("title");
    local nc = UINavigationController:createWithRootViewController(vc);
    local vc2 = UIViewController:createWithTitle("vc2");
    function vc2:viewDidLoad()
        ap_new();
        local view = UIView:create();
        view:setFrame(0, 0, 200, 200);
        vc2:view():addSubview(view);
        vc2:view():setBackgroundColor(UIColor:createWithRGB(255, 255, 0):autorelease());
        view:setAutoresizingMask(math::operator_or(UIViewAutoresizingFlexibleHeight, UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleBottomMargin));
        
        local label = UILabel:new("label1"):autorelease();
        local font = UIFont:createWithFontSize(20);
        label:setFont(font);
        vc2:view():addSubview(label);
        
        local label2 = UILabel:new("label2122111212233243242332rj32rm32om23rmowomioiewriewrewmremweowrmowemewr4ewew"):autorelease();
--        label2:setAutoresizingMask(view:autoresizingMask());
        label2:setFrame(0, 40, 200, label2:heightOfText(200));
        label2:setNumberOfLines(0);
        vc2:view():addSubview(label2);
        
        local naviItem = vc2:navigationItem();
        local barBtn = UIBarButtonItem:createWithTitle("button");
        naviItem:setRightBarButtonItem(barBtn);
        function barBtn:tapped()
            print("uittonItem");
        end
        
        label2:setBackgroundColor(UIColor:createWithRGB(0, 255, 0):autorelease());
        
        local button = UIButton:create("BUTTON", UIButtonTypeRoundRect);
        button:setFrame(100, 200, 100, 40);
        button:setBackgroundColor(label2:backgroundColor());
        button:titleLabel():setFont(UIFont:createWithFontSize(12):autorelease());
        vc2:view():addSubview(button);
        
        ap_release();
    end
    function vc:viewDidLoad()
        local tableView = UITableView:create();
        tableView:setFrame(vc:view():bounds());
        vc:view():addSubview(tableView);
        
        function tableView:heightOfRowAtIndex()
            return 100;
        end
        
        function tableView:numberOfRows()
            return 100;
        end
        
        function tableView:cellForRowAtIndex(rowIndex)
            ap_new();
            local cell = tableView:dequeueReusableCellWithIdentifier("id_d");
            if cell == nil then
                cell = UITableViewCell:create("id_d");
            else
                print("resuable cell:"..cell:id());
            end
            cell:textLabel():setText("row - "..rowIndex);
            print(cell:textLabel():text());
            ap_release();
            return cell;
        end
        
        function tableView:didSelectCellAtIndex(rowIndex)
            tableView:deselectRow(rowIndex);
            nc:pushViewController(vc2, "YES");
        end
    end
    
    nc:setAsRootViewController();
    ap_release();
end