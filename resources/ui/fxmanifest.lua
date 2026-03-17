fx_version "cerulean"
game "gta5"

author "FiveM Framework"
description "UI System"
version "1.0.0"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/style.css",
    "html/js/app.js"
}

shared_scripts {
    "config.lua",
    "shared.lua"
}

client_scripts {
    "client.lua"
}
