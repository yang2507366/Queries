require "Utils"

AutoreleasePool = {};
AutoreleasePool.__index = AutoreleasePool;

function AutoreleasePool:new()
    local pool = {};
    
    _pool_list[#_pool_list] = pool;
    setmetatable(pool, self);
    
    return pool;
end

function AutoreleasePool:add(object)
    print("add:"..tostring(self)..", "..object:id());
    self[#self + 1] = object;
end

function AutoreleasePool:drain()
    for i = 1, #self do
        print("drain:"..tostring(self)..", "..self[i]:id());
        self[i]:release();
    end
end

-- *********** pool list
_pool_list = {};

-- get top most pool
function _autorelease_pool_currentPool()
    local lastPool = _pool_list[#_pool_list];
    
    return lastPool;
end

function _autorelease_pool_popCurrent()
    table.remove(_pool_list, #_pool_list);
end

-- add object to top most pool
function _autorelease_pool_addObject(object)
    local lastPool = _autorelease_pool_currentPool();
    lastPool:add(object);
end

-- add new pool to stack
function _autorelease_pool_newPool()
    local newPool = AutoreleasePool:new();
    _pool_list[#_pool_list + 1] = newPool;
    
    print("new..............");
    print_r(_pool_list);
    
    return newPool;
end

-- drain top most pool
function _autorelease_pool_drainPool()
    local lastPool = _autorelease_pool_currentPool();
    lastPool:drain();
    _autorelease_pool_popCurrent();
    
    print("drain..............");
    print_r(_pool_list);
end