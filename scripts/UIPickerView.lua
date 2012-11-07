require "System"
require "UIView"

UIPickerView = {};
UIPickerView.__index = UIPickerView;
setmetatable(UIPickerView, UIView);

function UIPickerView:create()
    local pvId = runtime::invokeClassMethod("PickerViewImpl", "createWithAppId:numOfComponents:numOfRowsInComponent:widthForComponent:rowHeightForComponent:titleForRowForComponent:attributedTitleForRowForComponent:viewForRowForComponentReuseView:didSelectRowInComponent:",
                                            app_id(),
                                            "UIPickerView_numberOfComponents",
                                            "UIPickerView_numOfRowsInComponent",
                                            "UIPickerView_widthForComponent",
                                            "UIPickerView_rowHeightForComponent",
                                            "UIPickerView_titleForRowForComponent",
                                            "UIPickerView_attributedTitleForRowForComponent",
                                            "UIPickerView_viewForRowForComponentReusingView",
                                            "UIPickerView_didSelectRowInComponent");
    local pv = UIPickerView:get(pvId);
    eventProxyTable_pickerView[pvId] = pv;
    return pv;
end

function UIPickerView:get(pvId)
    local pv = UIView:new(pvId);
    setmetatable(pv, self);
    
    return pv;
end

-- delegate methods
function UIPickerView:numberOfComponents()
    return 1;
end

function UIPickerView:numberOfRowsInComponent(component)
    return 10;
end

function UIPickerView:widthForComponent(component)
    return 200;
end

function UIPickerView:rowHeightForComponent(component)
    return 44;
end

function UIPickerView:titleForRowForComponent(row, component)
    print(row, component);
    return "title";
end

function UIPickerView:attributedTitleForRowForComponent(row, component)
    return nil;
end

function UIPickerView:viewForRowForComponentReusingView(row, component, reusingView)
    return nil;
end

function UIPickerView:didSelectRowInComponent(row, component)
    
end
    
-- event proxy
eventProxyTable_pickerView = {};
function UIPickerView_numberOfComponents(pvId)
    print(pvId);
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:numberOfComponents();
    end
    return 0;
end

function UIPickerView_numOfRowsInComponent(pvId, component)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:numberOfRowsInComponent(component);
    end
    return 0;
end

function UIPickerView_widthForComponent(pvId, component)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:widthForComponent(component);
    end
    return 0;
end

function UIPickerView_rowHeightForComponent(pvId, component)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:rowHeightForComponent(component);
    end
    return 0;
end

function UIPickerView_titleForRowForComponent(pvId, row, component)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:titleForRowForComponent(row, component);
    end
    return "";
end

function UIPickerView_attributedTitleForRowForComponent(pvId, row, component)
    return nil;
end

function UIPickerView_viewForRowForComponentReusingView(pvId, row, component, reusingView)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        if string.len(reusingView) ~= 0 then
            reusingView = UIView:get(reusingView);
        end
        return pv:viewForRowForComponentReusingView(row, component, reusingView);
    end
    return nil;
end

function UIPickerView_didSelectRowInComponent(pvId, row, component)
    local pv = eventProxyTable_pickerView[pvId];
    if pv then
        return pv:didSelectRowInComponent(row, component);
    end
end







