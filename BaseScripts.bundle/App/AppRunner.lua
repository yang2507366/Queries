require "Object"

AppRunner = {};

function AppRunner.run(appId, params, relatedVC)
    if params.id then
        params = params:id();
    end
    app::runApp(appId, params, relatedVC:id());
end