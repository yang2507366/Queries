function recycle()
    runtime::recycleCurrentScript();
end

function releaseObjectById(objectId)
    runtime::recycleObjectById(objectId);
end