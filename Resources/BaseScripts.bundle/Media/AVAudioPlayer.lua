require "Object"
require "AppContext"
require "CommonUtils"

AVAudioPlayer = {};
AVAudioPlayer.__index = AVAudioPlayer;
setmetatable(AVAudioPlayer, Object);

function AVAudioPlayer:create(URL)
    local objId = runtime::invokeClassMethod("LIAudioPlayer", "create:URL:", AppContext.current(), URL:id());
    if string.len(objId) == 0 then
        return nil;
    end
    return self:get(objId);
end

function AVAudioPlayer:get(objId)
    local obj = Object:new(objId);
    setmetatable(obj, self);
    AVAudioPlayerEventProxyTable[objId] = obj;
    runtime::invokeMethod(objId, "setAudioPlayerDidFinishPlaying:", "AVAudioPlayer_audioPlayerDidFinishPlaying");
    
    return obj;
end

function AVAudioPlayer:dealloc()
    AVAudioPlayerEventProxyTable[self:id()] = nil;
    Object.dealloc(self);
end

function AVAudioPlayer:play()
    runtime::invokeMethod(self:id(), "play");
end

function AVAudioPlayer:pause()
    runtime::invokeMethod(self:id(), "pause");
end

function AVAudioPlayer:stop()
    runtime::invokeMethod(self:id(), "stop");
end

function AVAudioPlayer:didFinishPlaying(successfully)
    
end

AVAudioPlayerEventProxyTable = {};

function AVAudioPlayer_audioPlayerDidFinishPlaying(objId, successfully)
    local obj = AVAudioPlayerEventProxyTable[objId];
    if obj then
        obj:didFinishPlaying(toLuaBool(successfully));
    end
end