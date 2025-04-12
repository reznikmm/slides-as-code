--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Window;

package Slides_As_Code.Contexts.Windows is

   function Get_Window
     (Self : in out Context'Class) return Gtk.Window.Gtk_Window;

end Slides_As_Code.Contexts.Windows;
