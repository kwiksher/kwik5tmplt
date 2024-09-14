M = {}

local http = require("socket.http")
local ltn12 = require("ltn12")

-- Set up the request URL
local url = "http://localhost:9090/hprint"

function M:post(code)
    -- Prepare the request body
    -- Set up the request headers
    local headers = {
      ["Content-Type"] = "application/lua",
      ["Content-Length"] = string.len(code)
    }
    -- ilua.detail.__custom_print(code)
    -- Prepare the response body
    local response_body = {}
    -- Make the POST request
    local res, httpCode, response_headers = http.request {
      url = url,
      method = "POST",
      headers = headers,
      source = ltn12.source.string(code),
      sink = ltn12.sink.table(response_body)
    }

    -- Check the response
    if httpCode ~= 200 then
      ilua.detail.__custom_print("Error: " .. httpCode)
    else
      ilua.detail.__custom_print("Response: " .. table.concat(response_body))
    end
end

g_data = {}
hprint = function(code) M:post(code) return true end
ilua.config.http_print = true