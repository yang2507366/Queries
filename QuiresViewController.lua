require "Lang"
require "UIKit"
require "Utils"
require "App"

require "MobileNumberViewController"
require "PostcodeViewController"
require "GecoderViewController"

kTitleSearchMobileNumber = "手机号码归属地";
kTitleSearchPostcode = "邮政编码";
kTitleGoogleTranslate = "Google翻译";
kTitleGecoder = "Geocoder";

kTitleList = {kTitleSearchMobileNumber, kTitleSearchPostcode, kTitleGoogleTranslate, kTitleGecoder};

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
        self.tableView:release();
        self:release();
        observer:release();
    end
    function rootVC:viewDidLoad()
        ap_new();
        self.tableView = UITableView:create():retain();
        self.tableView:setFrame(self:view():bounds());
        self.tableView:setAutoresizingMask(math::bor(UIViewAutoresizingFlexibleWidth, UIViewAutoresizingFlexibleHeight));
        self:view():addSubview(self.tableView);
        
        local tableViewDataSource = {};
        function tableViewDataSource:numberOfRowsInSection(tb, section)
            return #kTitleList;
        end
        local identifier = "id";
        function tableViewDataSource:cellForRowAtIndexPath(tb, indexPath)
            ap_new();
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
            ap_release();
            
            return cell;
        end
        self.tableView:setDataSource(tableViewDataSource);
        
        local tableViewDelegate = {};
        function tableViewDelegate:didSelectRowAtIndexPath(tb, indexPath)
            ap_new();
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
                local appLoader = AppLoader:create();
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
                appLoader:load("http://imyvoaspecial.googlecode.com/files/t2.1.zip");
            
                --[[local vc = TranslateViewController:create(kTitleGoogleTranslate):retain();
                function vc:viewDidPop()
                    self:release();
                end
                rootVC:navigationController():pushViewController(vc);]]
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
            ap_release();
        end
        function tableViewDelegate:heightForRowAtIndexPath(tb, indexPath)
            return 72.0;
        end
        self.tableView:setDelegate(tableViewDelegate);
        
        ap_release();
    end

    rootVC:pushToRelatedViewController();
    
    ap_release();
end
