prosodyctl register \
    {{ key "component/focus/auth/user" }} \
    auth.{{ key "config/hostname" }} \
    {{ key "component/focus/auth/password" }}
