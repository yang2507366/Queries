FileUtils = {};

function FileUtils.documentPath()
    return runtime::invokeClassMethod("CommonUtils", "documentPath");
end

function FileUtils.libraryPath()
    return runtime::invokeClassMethod("CommonUtils", "libraryPath");
end

function FileUtils.tempPath()
    return runtime::invokeClassMethod("CommonUtils", "tmpPath");
end

function FileUtils.homePath()
    return runtime::invokeClassMethod("CommonUtils", "homePath");
end

function FileUtils.move(srcPath, desPath)
    local fileMgrId = runtime::invokeClassMethod("NSFileManager", "defaultManager");
    runtime::invokeMethod(fileMgrId, "moveItemAtPath:toPath:error:", srcPath, desPath);
    runtime::releaseObject(fileMgrId);
end

function FileUtils.createDirectory(path, intermediate)
    if not intermediate then
        intermediate = false;
    end
    local fileMgrId = runtime::invokeClassMethod("NSFileManager", "defaultManager");
    runtime::invokeMethod(fileMgrId, "createDirectoryAtPath:withIntermediateDirectories:attributes:error:", path, toObjCBool(intermediate));
    runtime::releaseObject(fileMgrId);
end

function FileUtils.exists(path)
    local fileMgrId = runtime::invokeClassMethod("NSFileManager", "defaultManager");
    local exists = toLuaBool(runtime::invokeMethod(fileMgrId, "fileExistsAtPath:", path));
    runtime::releaseObject(fileMgrId);
    return exists;
end

function FileUtils.readString(path)
    return runtime::invokeClassMethod("LIFileUtils", "readString:", path);
end

function FileUtils.mainBundlePath()
    local mainBundle = runtime::invokeClassMethod("NSBundle", "mainBundle");
    local path = runtime::invokeMethod(mainBundle, "bundlePath");
    runtime::releaseObject(mainBundle);
    return path;
end
