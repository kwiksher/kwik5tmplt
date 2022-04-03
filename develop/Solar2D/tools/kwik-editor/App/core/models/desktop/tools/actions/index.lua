local name = ...
local path = name:gub("index", "")
--
M = {
    animation = require(path .. "actions.animation"),
    audio = require(path .. "actions.audio"),
    image = require(path .. "actions.image"),
    layer = require(path .. "actions.layer"),
    page = require(path .. "actions.page"),
    controls = {
        action = require(path .. "actions.action"),
        condition = require(path .. "actions.condition"),
        external = require(path .. "actions.external"),
        language = require(path .. "actions.language"),
        random = require(path .. "actions.random"),
        timer = require(path .. "actions.timer"),
        variables = require(path .. "actions.variables")
    },
    interactions = {
        button = require(path .. "actions.button"),
        app = require(path .. "actions.app"),
        canvas = require(path .. "actions.canvas"),
        screenshot = require(path .. "actions.screenshot"),
        purchase = require(path .. "actions.purchase")
    },
    replacements = {
        countdown = require(path .. "actions.countdown"),
        filter = require(path .. "actions.filter"),
        multiplier = require(path .. "actions.multiplier"),
        particles = require(path .. "actions.particles"),
        readme = require(path .. "actions.readme"),
        sprite = require(path .. "actions.sprite"),
        video = require(path .. "actions.video"),
        web = require(path .. "actions.web")
    },
    physics = require(path .. "actions.physics")
}
return M
