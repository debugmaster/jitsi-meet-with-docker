-- Plugins path gets uncommented during jitsi-meet-tokens package install - that's where token plugin is located
plugin_paths = { "/usr/lib/prosody-plugins" }

VirtualHost "{{ key "config/host" }}"
        -- enabled = false -- Remove this line to enable this host
        authentication = "token"
        -- Properties below are modified by jitsi-meet-tokens package config
        -- and authentication above is switched to "token"
        app_id="app_id"
        app_secret="app_secret"
        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        ssl = {
                key = "/etc/prosody/certs/example.camilo.fm.key";
                certificate = "/etc/prosody/certs/example.camilo.fm.crt";
        }
        -- we need bosh
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
        }

Component "conference.{{ key "config/host" }}" "muc_events"
    modules_enabled = { "token_verification" }

admins = { "focus@auth.{{ key "config/host" }}" }

Component "jitsi-videobridge.{{ key "config/host" }}"
    component_secret = "uAgHm0Z2"

VirtualHost "auth.{{ key "config/host" }}"
    authentication = "internal_plain"

Component "focus.{{ key "config/host" }}"
    component_secret = "{{ key "component/focus/secret" }}"
