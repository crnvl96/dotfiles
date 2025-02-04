# pyright: reportUnknownMemberType=false,reportUnknownLambdaType=false,reportUnknownArgumentType=false

import os
import subprocess

from libqtile import bar, extension, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "wezterm"

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Floating"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "d", lazy.spawn("/home/crnvl96/.screenlayout/default.sh"), desc="Default screen layout"),
    Key([mod, "shift"], "f", lazy.spawn("/home/crnvl96/.screenlayout/hdmi.sh"), desc="Hdmi screen layout"),
    Key([mod, "shift"], "p", lazy.spawn("flameshot gui"), desc="Print"),
    Key(
        [mod],
        "p",
        lazy.run_extension(
            extension.DmenuRun(
                dmenu_command="dmenu_run",
                font="Berkeley Mono",
                fontsize="13",
                dmenu_prompt="",
            )
        ),
    ),
]


groups = [Group(i) for i in "123456789"]
for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

layouts = [
    layout.Columns(border_focus="#666666", border_normal="#333333", border_width=2, margin=4),
]

widget_defaults = dict(
    font="Berkeley Mono",
    fontsize=15,
    padding=3,
)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    font="Berkeley Mono",
                    fontsize=13,
                    margin_y=3,
                    margin_x=3,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    active="#ffffff",
                    inactive="#999999",
                    rounded=True,
                    highlight_method="line",
                    highlight_color="#666666",
                    this_current_screen_border="#666666",
                    this_screen_border="#555555",
                    other_current_screen_border="#444444",
                    other_screen_border="#333333",
                    disable_drag=True,
                ),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            background="#333333",
            opacity=0.9,
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        x11_drag_polling_rate=60,
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
    ],
    border_focus="#666666",
    border_normal="#333333",
    border_width=2,
)

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


@hook.subscribe.startup_once
def autostart():
    screenlayout = os.path.expanduser("~/.screenlayout/hdmi.sh")
    subprocess.run([screenlayout])
