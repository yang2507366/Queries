require "CommonUtils"
require "NSData"

StringUtils = {};

function StringUtils.appendingPathComponent(path, component)
    return runtime::invokeClassMethod("LIStringUtils", "appendingPath:component:", path, component);
end

function StringUtils.md5(str)
    return runtime::invokeClassMethod("CodeUtils", "md5ForString", str);
end

function StringUtils.removeUnicodeCharsFromString(str)
    return runtime::invokeClassMethod("CodeUtils", "removeAllUnicode:", str);
end

function StringUtils.trim(str)
    return runtime::invokeClassMethod("LIStringUtils", "trim:", str);
end

function StringUtils.hasPrefix(str, prefix)
    return toLuaBool(runtime::invokeClassMethod("LIStringUtils", "string:hasPrefix:", str, prefix));
end

function StringUtils.length(str)
    return tonumber(runtime::invokeClassMethod("LIStringUtils", "length:", str));
end

function StringUtils.equals(str1, str2)
    return toLuaBool(runtime::invokeClassMethod("LIStringUtils", "equals:with:", str1, str2));
end

function StringUtils.toString(str)
    if str.id then
        str = str:id();
    end
    return runtime::invokeClassMethod("LIStringUtils", "objectToString:", str);
end

function StringUtils.UTF8StringFromData(data)
    return runtime::invokeClassMethod("LIStringUtils", "UTF8StringFromData:", data:id());
end

function StringUtils.dataFromUTF8String(str)
    local dataId = runtime::invokeClassMethod("LIStringUtils", "dataFromUTF8String:", str);
    return NSData:get(dataId);
end

function StringUtils.find(str, matching, fromIndex, reverse)
    if fromIndex == nil then
        fromIndex = 0;
    end
    if reverse == nil then
        reverse = false;
    end
    return tonumber(runtime::invokeClassMethod("LIStringUtils", "find:matching:fromIndex:reverse", str, matching, fromIndex, toObjCBool(reverse)));
end

function StringUtils.substring(str, beginIndex, endIndex)
    return runtime::invokeClassMethod("LIStringUtils", "substring:beginIndex:endIndex:", str, beginIndex, endIndex);
end
