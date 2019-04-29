local utils = require "kong.tools.utils"
local typedefs = require "kong.db.schema.typedefs"
local function check_user(anonymous)
  if anonymous == "" or utils.is_valid_uuid(anonymous) then
    return true
  end

  return false, "the anonymous user must be empty or a valid uuid"
end

local function check_keys(keys)
  for _, key in ipairs(keys) do
    local res, err = utils.validate_header_name(key, false)

    if not res then
      return false, "'" .. key .. "' is illegal: " .. err
    end
  end

  return true
end

local function default_key_names(t)
  if not t.key_names then
    return { "apikey" }
  end
end

return {
  name = "key-auth-redis",
  fields = {
    { consumer = typedefs.no_consumer },
    { run_on = typedefs.run_on_first },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { key_names = {
              type = "array",
              required = true,
              elements = typedefs.header_name,
              default = { "apikey" },
          }, },
          { redis_host = { type = "string", default = "172.20.10.3" }, },
          { redis_port = { type = "number", default = 6379 }, },
          { redis_password = { type = "string" }, },
          { redis_timeout = { type = "number", default = 2000 }, },
          { redis_connctions = {type = "number", default = 1000}, },
          { fault_tolerant = { type = "boolean", default = true }, },
          { redis_database = { type = "number", default = 0 }, },
        },
    }, },
  },
  -- fields = {
  --   { config = {
  --       type = "record",
  --       fields = {
  --         { routes = {
  --           type = "array",
  --           required = true,
  --           default = {},
  --           elements = {
  --             type = "record",
  --             required = true,
  --             fields = {
  --               name = { type = "string", default = "", required = false },
  --               otherProp = { type = "string", default = "", required = false },
  --             },
  --           },
  --         }, },
  --       },
  --   }, },
  -- },
}
