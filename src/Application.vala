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
        var label = new Gtk.Label ("Hello World Again!");
        
        
        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = "Emoji Clip"
        };
        
        main_window.add (label);
        main_window.show_all ();
    }
    
    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
