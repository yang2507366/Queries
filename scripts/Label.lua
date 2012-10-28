Label = {};
Label.__index = Label;

function Label:new(title)
    if title == nil then
		title = "Label";
    end
    local labelId = ui::createLabel(title, "0, 0, 200, 17");
	
	return Label:get(labelId);
end

function Label:get(labelId)
    local label = ObjectCreate(labelId);
	setmetatable(label, Label);
	
	return label;
end

-- instance methods
function Label:setText(text)
	runtime::invokeMethod(self.id, "setText:", text);
end