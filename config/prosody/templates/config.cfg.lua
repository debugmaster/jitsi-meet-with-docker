-- Plugins path gets uncommented during jitsi-meet-tokens package install - that's where token plugin is located
plugin_paths = { "/usr/lib/prosody-plugins" }

admins = {
    "{{ key "component/focus/auth/user" }}@auth.{{ key "config/hostname" }}"
}

VirtualHost "{{ key "config/hostname" }}"

    authentication = "anonymous"
    -- Properties below are modified by jitsi-meet-tokens package config
    -- and authentication above is switched to "token"
    --app_id="app_id"
    --app_secret="app_secret"

    ssl = {
        key = "/etc/prosody/certs/localhost.key";
        certificate = "/etc/prosody/certs/localhost.crt";
    }

    modules_enabled = {
        "bosh";
        "pubsub";
        "ping";
    }

Component "conference.{{ key "config/hostname" }}" "muc"
    modules_enabled = {
        --"token_verification"
    }

VirtualHost "auth.{{ key "config/hostname" }}"
    authentication = "internal_plain"

Component "{{ key "component/focus/auth/user" }}.{{ key "config/hostname" }}"
    component_secret = "{{ key "component/focus/secret" }}"

{{ range ls "component/videobridges" }}
Component "{{ .Key }}.{{ key "config/hostname" }}"
    component_secret = "{{ .Value }}"
{{ end }}
