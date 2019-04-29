package = "gateway"
version = "0.1.0-0"
source = {
  url = ""
}
description = {
  summary = "The gateway plugins for Kong.",
  license = "UNLICENSED"
}
dependencies = {
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.header-echo.handler"] = "kong/plugins/header-echo/handler.lua",
      ["kong.plugins.header-echo.schema"] = "kong/plugins/header-echo/schema.lua",
      ["kong.plugins.hello-world.handler"] = "kong/plugins/hello-world/handler.lua",
      ["kong.plugins.hello-world.schema"] = "kong/plugins/hello-world/schema.lua",

      ["kong.plugins.key-auth-redis.handler"] = "kong/plugins/key-auth-redis/handler.lua",
      ["kong.plugins.key-auth-redis.schema"] = "kong/plugins/key-auth-redis/schema.lua",
   }
}
