require "Lang"
require "UIKit"
require "Utils"
require "App"

require "MobileNumberViewController"
require "PostcodeViewController"
require "TranslateViewController"
require "GecoderViewController"

kTitleSearchMobileNumber = "号码归属地";
kTitleSearchPostcode = "邮政编码";
kTitleGoogleTranslate = "Google翻译";
kTitleGecoder = "地理定位";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchPostcode, kTitleGoogleTranslate, kTitleGecoder};
local kImageList = nil;

function main()
    ap_new();
    
    local appBundle = AppBundle:current();
    local observer = NotificationObserver:create():retain();
    observer:observe("UIApplicationWillChangeStatusBarOrientationNotification");
    function observer:receive(object, userInfo)
        po(object);
        po(userInfo);
    end
    
    local rootVC = UIViewController:create("Quires"):retain();
    function rootVC:viewDidPop()
        kImageList:release();
        self.tableView:release();
        self.gridView:release();
        self:release();
        observer:release();
    end
    function rootVC:viewDidLoad()
        self.tableView = UITableView:create():retain();
        self.tableView:setFrame(self:view():bounds());
        self.tableView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
        self:view():addSubview(self.tableView);
        
        self.gridView = UIGridView:create():retain();
        self.gridView:setFrame(self:view():bounds());
        self.gridView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
        self:view():addSubview(self.gridView);
        local gridViewDelegate = {};
        function gridViewDelegate:numberOfItemsInGridView()
            return #kTitleList;
        end
        kImageList = NSMutableArray:create():retain();
        kImageList:addObject(UIImage:imageWithResName("phone.png"));
        kImageList:addObject(UIImage:imageWithResName("postcode.png"));
        kImageList:addObject(UIImage:imageWithResName("translate.png"));
        kImageList:addObject(UIImage:imageWithResName("gecode.png"));
        function gridViewDelegate:configureViewAtIndex(gridView, view, index)
            local x, y, width, height = view:bounds();
            
            local imageView = view:viewWithTag(1001, UIImageView);
            local titleLabel = view:viewWithTag(1002, UILabel);
            if not imageView then
                imageView = UIImageView:create();
                imageView:setTag(1001);
                imageView:setFrame(5, 5, width - 10, height - 20 - 10);
                imageView:setContentMode(4);
                view:addSubview(imageView);
            end
            if not titleLabel then
                titleLabel = UILabel:create();
                titleLabel:setTag(1002);
                titleLabel:setFrame(5, height - titleLabel:font():lineHeight() - 5, width - 10, titleLabel:font():lineHeight());
                titleLabel:setTextAlignment(1);
                view:addSubview(titleLabel);
            end
            if index < kImageList:count() then
                imageView:setImage(kImageList:objectAtIndex(index));
                titleLabel:setText(kTitleList[index + 1]);
            else
                imageView:setImage(nil);
                titleLabel:setText("");
            end
        end
        self.gridView:setDelegate(gridViewDelegate);
        
        local tableViewDataSource = {};
        function tableViewDataSource:numberOfRowsInSection(tb, section)
            return #kTitleList;
        end
        local identifier = "id";
        function tableViewDataSource:cellForRowAtIndexPath(tb, indexPath)
            local cell = tb:dequeueReusableCellWithIdentifier(identifier);
            if not cell then
                cell = UITableViewCell:create(identifier);
            end
            cell:keep();
            local targetTitle = kTitleList[indexPath:row() + 1];
            cell:textLabel():setText(targetTitle);
            local icon = nil;
            if targetTitle == kTitleGoogleTranslate then
                icon = UIImage:imageWithResName("translate.png");
            elseif targetTitle == kTitleSearchMobileNumber then
                icon = UIImage:imageWithResName("phone.png");
            elseif targetTitle == kTitleSearchPostcode then
                icon = UIImage:imageWithResName("postcode.png");
            elseif targetTitle == kTitleGecoder then
                icon = UIImage:imageWithResName("gecode.png");
            end
            cell:imageView():setImage(icon);
            
            return cell;
        end
        self.tableView:setDataSource(tableViewDataSource);
        
        local tableViewDelegate = {};
        function tableViewDelegate:didSelectRowAtIndexPath(tb, indexPath)
            tb:deselectRowAtIndexPath(indexPath);
            local selectedTitle = kTitleList[indexPath:row() + 1];
            if selectedTitle == kTitleSearchMobileNumber then
                local vc = MobileNumberViewController:create(kTitleSearchMobileNumber):retain();
                function vc:viewDidPop()
                    self:release();
                end
                rootVC:navigationController():pushViewController(vc);
            elseif selectedTitle == kTitleSearchPostcode then
                local vc = PostcodeViewController:create(kTitleSearchPostcode):retain();
                function vc:viewDidPop()
                    self:release();
                end
                rootVC:navigationController():pushViewController(vc);
            elseif selectedTitle == kTitleGoogleTranslate then
                --[[local appLoader = AppLoader:create();
                function appLoader:processing(loaded)
                    
                end
                function appLoader:complete(success, appId)
                    rootVC:setWaiting(false);
                    if success then
                        AppRunner.run(appId, nil, rootVC);
                    else
                        ui::alert("加载失败");
                    end
                end
                rootVC:setWaiting(true);
                appLoader:load("http://imyvoaspecial.googlecode.com/files/t2.1.zip");]]
            
                local vc = TranslateViewController:create(kTitleGoogleTranslate):retain();
                function vc:viewDidPop()
                    self:release();
                end
                rootVC:navigationController():pushViewController(vc);
            elseif selectedTitle == kTitleGecoder then
                --[[local appLoader = AppLoader:create();
                function appLoader:processing(loaded)
                    
                end
                function appLoader:complete(success, appId)
                    ap_new();
                    rootVC:setWaiting(false);
                    if success then
                        local dict = NSMutableDictionary:create();
                        dict:setObjectForKey("obj1", "key1");
                        dict:setObjectForKey("obj2", "key4");
                        dict:setObjectForKey("obj3", "ke5");
                        
                        AppRunner.run(appId, dict, rootVC);
                    else
                        ui::alert("加载失败");
                    end
                    ap_release();
                end
                rootVC:setWaiting(true);
                appLoader:load("http://imyvoaspecial.googlecode.com/files/gc1.1.zip");]]
            local vc = GeocoderViewController:create(kTitleGecoder):retain();
            function vc:viewDidPop()
                self:release();
            end
            rootVC:navigationController():pushViewController(vc);
            end
        end
        function tableViewDelegate:heightForRowAtIndexPath(tb, indexPath)
            return 72.0;
        end
        self.tableView:setDelegate(tableViewDelegate);
    end

    rootVC:pushToRelatedViewController();
    
    ap_release();
end
