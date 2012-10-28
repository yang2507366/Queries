function po(object)
    if object.id then
        utils::printObject(object.id);
    else
        utils::printObject(object);
    end
end

function pd(object)
    if object.id then
        utils::printObjectDescription(object.id);
    else
        utils::printObjectDescription(object);
    end
end
