/*
 * SPDX-License-Identifier: LGPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 Ryo Nakano <ryonakaknock3@gmail.com>
 */

public class MainWindow : Gtk.ApplicationWindow {
    public MainWindow () {
    }

    construct {
        var label = new Gtk.Label ("Type:") {
            halign = Gtk.Align.END
        };

        var dropdown = new Gtk.ComboBoxText ();
        //var dropdown = new Ryokucha.DropDownText ();
        dropdown.insert (0, null, "Hoge");
        dropdown.insert (1, null, "Fuga");
        dropdown.insert (2, "hoge", "hoge");
        dropdown.insert (3, "hoge", "fuga");

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
