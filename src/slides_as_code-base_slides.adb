--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Label;
with Gtk.Stack;
with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Base_Slides is

   ----------
   -- Show --
   ----------

   overriding procedure Show
     (Self    : Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Text   : String := Context.Current_Slide_Index'Image & " /" &
        Context.Total_Slides'Image;

      Label  : Gtk.Label.Gtk_Label;
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Slides_As_Code.Contexts.Windows.Get_Stack (Context);
   begin
      Gtk.Label.Gtk_New (Label, "Hello Word! " & Text);
      Gtk.Stack.Add (Stack, Label);
      Gtk.Label.Show (Label);
   end Show;

end Slides_As_Code.Base_Slides;
