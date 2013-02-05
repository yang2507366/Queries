
function now(dateFormat)
    local dateFormatId = runtime::invokeClassMethod("NSDateFormatter", "new");
    runtime::invokeMethod(dateFormatId, "autorelease");
    runtime::invokeMethod(dateFormatId, "setDateFormat:", dateFormat);
    
    local dateId = runtime::invokeClassMethod("NSDate", "new");
    runtime::invokeMethod(dateId, "auturelease");
    
    local dateString = runtime::invokeMethod(dateFormatId, "stringFromDate:", dateId);
    print(dateString);
end