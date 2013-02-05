
function appDocumentPath()
    return runtime::invokeClassMethod("CommonUtils", "documentPath");
end

function appLibraryPath()
    return runtime::invokeClassMethod("CommonUtils", "libraryPath");
end

function appTempPath()
    return runtime::invokeClassMethod("CommonUtils", "tmpPath");
end

function appHomePath()
    return runtime::invokeClassMethod("CommonUtils", "homePath");
end