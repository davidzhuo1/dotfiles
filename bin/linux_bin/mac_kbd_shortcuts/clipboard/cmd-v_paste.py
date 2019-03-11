t = window.get_active_title()
if t.find("dz") == -1:
    keyboard.send_keys("<ctrl>+v")
else:
    keyboard.send_keys("<ctrl>+<shift>+v")