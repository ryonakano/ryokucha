/*
 * SPDX-License-Identifier: LGPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 Ryo Nakano <ryonakaknock3@gmail.com>
 */

public class MainWindow : Gtk.ApplicationWindow {
    public MainWindow () {
        Object (
            title: "Ryokucha Demo",
            default_width: 300,
            default_height: 250
        );
    }

    construct {
        var label = new Gtk.Label ("DropDownText:") {
            halign = Gtk.Align.END
        };

        var dropdown = new Ryokucha.DropDownText ();
        dropdown.append ("foo", "Foo");
        dropdown.append ("bar", "Bar");
        dropdown.append ("baz", "Baz");

        var grid = new Gtk.Grid () {
            vexpand = true,
            hexpand = true,
            halign = Gtk.Align.START,
            column_spacing = 6,
            margin_top = 12,
            margin_bottom = 12,
            margin_start = 12,
            margin_end = 12
        };
        grid.attach (label, 0, 0);
        grid.attach (dropdown, 1, 0);

        child = grid;
    }
}
