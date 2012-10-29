function recycle()
    runtime::recycleCurrentScript();
end

function releaseById(objectId)
    runtime::recycleObjectById(objectId);
end