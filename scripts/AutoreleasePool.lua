require "Utils"

AutoreleasePool = {};
AutoreleasePool.__index = AutoreleasePool;

function AutoreleasePool:new()
    local pool = {};
    
    setmetatable(pool, self);
    
    return pool;
end

function AutoreleasePool:add(object)
--    print("add:"..tostring(self)..", "..object:id());
    table.insert(self, object);
end

function AutoreleasePool:drain()
    for i = 1, #self do
--        print("drain:"..tostring(self)..", "..self[i]:id());
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

function print_pool_list()
    print("---------print_pool_list");
    for i = 1, #_pool_list do
        print("pool "..i.." :"..tostring(_pool_list[i]));
    end
    print("*********print_pool_list");
end

-- add object to top most pool
function _autorelease_pool_addObject(object)
    local lastPool = _autorelease_pool_currentPool();
    if lastPool ~= nil then
        lastPool:add(object);
        return true;
    end
    return false;
end

-- add new pool to stack
function autorelease_pool_new()
    local newPool = AutoreleasePool:new();
    _pool_list[#_pool_list + 1] = newPool;
    
--    print_pool_list();
    
    return newPool;
end

-- drain top most pool
function autorelease_pool_drain()
    local lastPool = _autorelease_pool_currentPool();
    lastPool:drain();
    
    _pool_list[#_pool_list] = nil;
    
--    print_pool_list();
end