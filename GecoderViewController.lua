require "Lang"
--[[
function main(args)
    ap_new();
    if args ~= nil then
        if isObjCObject(args) then
            local obj = Object:new(args);
            setmetatable(obj, Object);
            ui::alert(obj:objCDescription());
            else
            ui::alert(args);
        end
    end
    ap_release();
end]]