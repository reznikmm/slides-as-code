--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Window;

package body Slides_As_Code.Contexts.Windows is

   function Get_Window
     (Self : in out Context'Class) return Gtk.Window.Gtk_Window
   is
      use type Gtk.Window.Gtk_Window;
   begin
      if Self.Window = null then
         Gtk.Window.Gtk_New (Self.Window);
         Gtk.Window.Set_Default_Size
           (Window => Self.Window,
            Width  => 1024,
            Height => 720);
      end if;

      return Self.Window;
   end Get_Window;

end Slides_As_Code.Contexts.Windows;
