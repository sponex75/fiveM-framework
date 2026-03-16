fx_version "cerulean"
game "gta5"

author "FiveM Framework"
description "Comprehensive FiveM Framework with multiple systems"
version "1.0.0"

shared_scripts {
    "@PolyZone/client.lua",
    "@PolyZone/circles.lua",
    "@PolyZone/combos.lua",
    "config/config.lua",
    "config/shared.lua"
}

client_scripts {
    "resources/base/client.lua",
    "resources/jobs/client.lua",
    "resources/inventory/client.lua",
    "resources/banking/client.lua",
    "resources/characters/client.lua",
    "resources/vehicles/client.lua",
    "resources/police/client.lua",
    "resources/npcs/client.lua",
    "resources/ui/client.lua",
}

server_scripts {
    "resources/base/server.lua",
    "resources/jobs/server.lua",
    "resources/inventory/server.lua",
    "resources/banking/server.lua",
    "resources/characters/server.lua",
    "resources/vehicles/server.lua",
    "resources/police/server.lua",
    "resources/npcs/server.lua",
}

ui_page "resources/ui/html/index.html"

files {
    "resources/ui/html/index.html",
    "resources/ui/html/css/style.css",
    "resources/ui/html/js/app.js",
}

dependencies {
    "PolyZone",
    "oxmysql",
}
