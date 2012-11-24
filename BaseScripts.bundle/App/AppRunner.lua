require "Object"

function AppRunner.run(appId, relatedVC, params)
    app::runApp(appId, relatedVC:id());
end