--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Window;

package body Slides_As_Code.Contexts.Windows is

   function Get_Stack
     (Self : in out Context'Class) return Gtk.Stack.Gtk_Stack
   is
      use type Gtk.Window.Gtk_Window;
   begin
      if Self.Window = null then
         Gtk.Window.Gtk_New (Self.Window);
         Gtk.Window.Set_Default_Size
           (Window => Self.Window,
            Width  => 1024,
            Height => 720);
         Gtk.Stack.Gtk_New (Self.Stack);
         Gtk.Window.Add (Self.Window, Self.Stack);
         Gtk.Window.Set_Name (Self.Window, "slides-as-code");
         Gtk.Window.Show_All (Self.Window);
      end if;

      return Self.Stack;
   end Get_Stack;

end Slides_As_Code.Contexts.Windows;
