/*
 * SPDX-License-Identifier: MIT
 * SPDX-FileCopyrightText: 2021 Christopher Leggett <chris@leggett.dev>
*/

public class MyApp : Gtk.Application {
    public MyApp () {
        Object (
            application_id: "com.github.leggettc18.emojiclip",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate () {
    
        var quit_action = new SimpleAction ("quit", null);
        
        var main_window = new Gtk.ApplicationWindow (this) {
            height_request = 500,
            width_request = 400,
            title = "Emoji Clip",
            resizable = false,
        };

        add_action (quit_action);
        set_accels_for_action ("app.quit", {"Escape"});

        quit_action.activate.connect (() => {
            if (main_window != null) {
                main_window.destroy ();
            }
        });
    
        var grid = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END,
            row_spacing = 12,
        };

        
        var entry = new Gtk.Entry () {
            halign = Gtk.Align.CENTER,
            width_request = 0,
            height_request = 0,
        };
        entry.get_style_context ().add_class ("hidden");
        
        grid.add (entry);
        
        var title = new Gtk.Label (_("Select Emoji to Insert"));
        title.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

        var copy = new Gtk.Label (_("Selecting will copy the emoji to the clipboard and paste into any focused text input."));
        copy.max_width_chars = 50;
        copy.wrap = true;
        copy.get_style_context ().add_class ("copy-label");
        
        grid.add (title);
        grid.add (copy);
        
        main_window.add (grid);
        
        // CSS provider
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/leggettc18/emojiclip/Application.css");
        Gtk.StyleContext.add_provider_for_screen (
          Gdk.Screen.get_default (),
          provider,
          Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
        
        main_window.show_all ();
        
        entry.insert_emoji ();
        
        entry.changed.connect (() => {
            var clipboard = Gtk.Clipboard.get_for_display (entry.get_display (), Gdk.SELECTION_CLIPBOARD);
            clipboard.set_text (entry.text, -1);
            main_window.hide ();
            paste ();
            Timeout.add(500, () => {
                main_window.close();
                return false;
            });
        });
        
        entry.focus_in_event.connect (() => {
            Timeout.add(500, () => {
                main_window.close();
                return false;
            });
            return Gdk.EVENT_STOP;
        });

        main_window.focus_out_event.connect ((event) => {
            Timeout.add(500, () => {
                main_window.close();
                return false;
            });
            return Gdk.EVENT_STOP;
        });
    }
    
    // From Clipped: https://github.com/davidmhewitt/clipped/blob/edac68890c2a78357910f05bf44060c2aba5958e/src/ClipboardManager.vala
    private void paste () {
        perform_key_event ("<Control>v", true, 0);
        perform_key_event ("<Control>v", false, 0);
    }

    private static void perform_key_event (string accelerator, bool press, ulong delay) {
        uint keysym;
        Gdk.ModifierType modifiers;
        Gtk.accelerator_parse (accelerator, out keysym, out modifiers);
        unowned X.Display display = Gdk.X11.get_default_xdisplay ();
        int keycode = display.keysym_to_keycode (keysym);

        if (keycode != 0) {
            if (Gdk.ModifierType.CONTROL_MASK in modifiers) {
                int modcode = display.keysym_to_keycode (Gdk.Key.Control_L);
                XTest.fake_key_event (display, modcode, press, delay);
            }

            if (Gdk.ModifierType.SHIFT_MASK in modifiers) {
                int modcode = display.keysym_to_keycode (Gdk.Key.Shift_L);
                XTest.fake_key_event (display, modcode, press, delay);
            }

            XTest.fake_key_event (display, keycode, press, delay);
        }
    }
    
    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
