--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Label;
with Gtk.Window;
with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Base_Slides is

   ----------
   -- Show --
   ----------

   overriding procedure Show
     (Self    : Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Label  : Gtk.Label.Gtk_Label;
      Window : constant Gtk.Window.Gtk_Window :=
        Slides_As_Code.Contexts.Windows.Get_Window (Context);
   begin
      Gtk.Label.Gtk_New (Label, "Hello Word.");
      Gtk.Window.Add (Window, Label);
      Gtk.Window.Show_All (Window);
   end Show;

end Slides_As_Code.Base_Slides;
