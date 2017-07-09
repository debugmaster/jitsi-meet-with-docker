module:set_global();

local configmanager = require "core.configmanager";
local hostmanager = require"core.hostmanager";

local function reload()

        --- Check if host / component configuration is active
        --- @param h hostname / component name
        local function is_new(h)
                return h ~= "*" and not hosts[h]; -- If a host is not defined in hosts and it is not global, then it is new
        end

        --- Search for new components that are not activated
        for h, c in pairs(configmanager.getconfig()) do
            if is_new(h) then
                hostmanager.activate(h, c);
            end
        end

        --- Search for active components that are not enabled in the configmanager anymore
        local enabled = {};
        for h in pairs(configmanager.getconfig()) do
            enabled[h] = true; -- Set true if it is defined in the configuration file
        end
        for h, c in pairs(hosts) do
            if not enabled[h] then -- Deactivate if not present in the configuration file
                hostmanager.deactivate(h,c);
            end
        end
end

module:hook("config-reloaded", reload);
