require "CommonUtils"

StringUtils = {};

function StringUtils.appendingPathComponent(path, component)
    return runtime::invokeClassMethod("LIStringUtils", "appendingPath:component:", path, component);
end

function StringUtils.md5(str)
    return runtime::invokeClassMethod("CodeUtils", "md5ForString", str);
end

function StringUtils.removeUnicode(str)
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