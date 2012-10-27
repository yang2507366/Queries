_global_view_did_load_event_table = {};
_global_view_will_appear_event_table = {};
_global_view_did_pop_event_table = {};

function _global_viewDidLoad(vcId)
    _global_view_did_load_event_table[vcId]:viewDidLoad(vcId);
end

function _global_viewWillAppear(vcId)
    _global_view_will_appear_event_table[vcId]:viewWillAppear(vcId);
end

function _global_viewDidPop(vcId)
    _global_view_did_pop_event_table[vcId]:viewDidPop(vcId);
end
