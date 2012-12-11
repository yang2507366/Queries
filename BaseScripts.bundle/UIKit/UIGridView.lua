require "UIView"
require "AppContext"
require "UIGridViewDelegate"

UIGridView = {};
UIGridView.__index = UIGridView;
setmetatable(UIGridView, UIView);

function UIGridView:create(numberOfColumns)
    local gridView = self:get(runtime::invokeClassMethod("LIGridView", "create:", AppContext.current()));
    if numberOfColumns == nil then
        numberOfColumns = 3;
    end
    gridView:setNumberOfColumns(numberOfColumns);
    return gridView;
end

function UIGridView:get(objId)
    local gridView = UIView:new(objId);
    setmetatable(gridView, self);
    UIGridViewEventProxyTable[objId] = gridView;
    
    return gridView;
end

function UIGridView:dealloc()
    self.delegate = nil;
    UIGridViewEventProxyTable[self:id()] = nil;
    UIView.dealloc(self);
end

function UIGridView:setNumberOfColumns(columns)
    runtime::invokeMethod(self:id(), "setNumberOfColumns:", columns);
end

function UIGridView:setDelegate(delegate)
    self.delegate = delegate;
    if delegate and delegate.numberOfItemsInGridView then
        runtime::invokeMethod(self:id(), "setNumberOfItemsInGridViewWrapper:", "UIGridView_numberOfItems");
    else
        runtime::invokeMethod(self:id(), "setNumberOfItemsInGridViewWrapper:", "");
    end
    
    if delegate and delegate.configureViewAtIndex then
        runtime::invokeMethod(self:id(), "setConfigureViewAtIndex:", "UIGridView_configureViewAtIndex");
    else
        runtime::invokeMethod(self:id(), "setConfigureViewAtIndex:", "");
    end
    
    if delegate and delegate.viewItemDidTappedAtIndex then
        runtime::invokeMethod(self:id(), "setViewItemDidTappedAtIndex:", "UIGridView_viewItemDidTappedAtIndex");
    else
        runtime::invokeMethod(self:id(), "setViewItemDidTappedAtIndex:", "");
    end
    
    runtime::invokeMethod(self:id(), "reloadData");
end

UIGridViewEventProxyTable = {};

function UIGridView_numberOfItems(gridViewId)
    local gridView = UIGridViewEventProxyTable[gridViewId];
    if gridView and gridView.delegate then
        return gridView.delegate:numberOfItemsInGridView(gridView);
    end
end

function UIGridView_configureViewAtIndex(gridViewId, viewId, index)
    local gridView = UIGridViewEventProxyTable[gridViewId];
    if gridView and gridView.delegate then
        local view = UIView:get(viewId);
        gridView.delegate:configureViewAtIndex(gridView, view, tonumber(index));
    end
end

function UIGridView_viewItemDidTappedAtIndex(gridViewId, index)
    local gridView = UIGridViewEventProxyTable[gridViewId];
    if gridView and gridView.delegate then
        gridView.delegate:viewItemDidTappedAtIndex(gridView, tonumber(index));
    end
end
