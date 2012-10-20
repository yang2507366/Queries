function sendHttpRequest(urlString)
    requestId = http_request(scriptId(), urlString, "httpCallback");
    print("requestId:"..requestId);
    --http_request_cancel(requestId);
end

function httpCallback(responseStr, errStr)
    ui_alert("", "", responseStr);
    --print("response:"..responseStr);
    --print("error:"..errStr);
end

function scriptId()
    return "test.lua";
end

function initUIComponents()
    vcId = ui_root_view_controller_id();
    newButtonId = ui_create_button(scriptId(), "button lua", "buttonTapped");
    ui_add_subview_to_view_controller(newButtonId, vcId);
    ui_set_view_frame(newButtonId, "100, 20, 200, 50");
end

function buttonTapped(viewId)
    --print("button tapped:"..viewId);
    ui_alert(scriptId(), "title", "msg", "alertCallback");
    x, y, width, height = ui_get_view_frame(viewId);
    if y > 300 then
        y = 20;
    end
    local newFrame = x..", "..(y+10)..", "..width..", "..height;
    ui_set_view_frame(viewId, newFrame);
    print(newFrame);
end

function alertCallback()
    http_request(scriptId(), "http://dict.hujiang.com", "httpCallback");
end
