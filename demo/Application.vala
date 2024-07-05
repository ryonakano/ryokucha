/*
 * SPDX-License-Identifier: LGPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 Ryo Nakano <ryonakaknock3@gmail.com>
 */

public class Application : Gtk.Application {
    private MainWindow window;

    public Application () {
        Object (
            application_id: "io.github.ryonakano.ryokucha.demo",
#if HAS_GLIB_2_74
            flags: ApplicationFlags.DEFAULT_FLAGS
#else
            flags: ApplicationFlags.FLAGS_NONE
#endif
        );
    }

    protected override void activate () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow ();
        window.set_application (this);

        window.present ();
    }

    public static int main (string[] args) {
        var app = new Application ();
        return app.run ();
    }
}
