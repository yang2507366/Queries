View = {};
View.__index = View;

function View:new(x, y, width, height)
	if x == nil then
		x = 0;
	end
	if y == nil then
		y = 0;
	end
	if width == nil then
		width = 200;
	end
	if height == nil then
		height = 200;
	end
	local viewId = runtime::createObject("UIView", "init");
	ui::setViewFrame(MakeFrame(x, y, width, height));
end

function View:get(viewId)
	local view = ObjectCreate(viewId);
	setmetatable(view, View);
	
	return view;
end

-- functions
function setViewBackgroundColor(view, red, green, blue, alpha)
	local color = runtime::invokeClassMethod("UIColor", "colorWithRed:green:blue:alpha:", tostring(red / 255), tostring(green / 255), tostring(blue / 255), tostring(alpha));
	runtime::invokeMethod(view.id, "setBackgroundColor:", color);
	ObjectRelease(color);
end

function MakeFrame(x, y, width, height)
	return x..","..y..","..width..","..height;
end