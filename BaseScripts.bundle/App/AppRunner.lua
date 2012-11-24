require "Object"

AppRunner = {};

function AppRunner.run(appId, relatedVC, params)
    app::runApp(appId, relatedVC:id());
end