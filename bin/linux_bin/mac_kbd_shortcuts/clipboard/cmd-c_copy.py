t = window.get_active_title()
if t.find("dz@milk:") == -1:
    keyboard.send_keys("<ctrl>+c")
else:
    keyboard.send_keys("<ctrl>+<shift>+c")