-- Plugins path gets uncommented during jitsi-meet-tokens package install - that's where token plugin is located
plugin_paths = { "/usr/lib/prosody-plugins" }

admins = { "focus@auth.{{ key "config/hostname" }}" }

VirtualHost "{{ key "config/hostname" }}"
        -- enabled = false -- Remove this line to enable this host
        authentication = "anonymous"
        -- Properties below are modified by jitsi-meet-tokens package config
        -- and authentication above is switched to "token"
        --app_id="app_id"
        --app_secret="app_secret"
        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        ssl = {
            key = "/etc/prosody/certs/localhost.key";
            certificate = "/etc/prosody/certs/localhost.crt";
        }
        -- we need bosh
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
        }

Component "conference.{{ key "config/hostname" }}" "muc"
    --modules_enabled = { "token_verification" }

VirtualHost "auth.{{ key "config/hostname" }}"
    authentication = "internal_plain"

Component "focus.{{ key "config/hostname" }}"
    component_secret = "{{ key "component/focus/secret" }}"

Component "jitsi-videobridge.{{ key "config/hostname" }}"
    component_secret = "uAgHm0Z2"
