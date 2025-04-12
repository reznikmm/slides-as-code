--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Stack;

package Slides_As_Code.Contexts.Windows is

   function Get_Stack
     (Self : in out Context'Class) return Gtk.Stack.Gtk_Stack;

end Slides_As_Code.Contexts.Windows;
