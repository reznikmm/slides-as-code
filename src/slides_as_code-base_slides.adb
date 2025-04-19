--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Gtk.Label;
with Gtk.Stack;
with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Base_Slides is

   ---------------
   -- Construct --
   ---------------

   overriding procedure Construct
     (Self    : in out Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Label : Gtk.Label.Gtk_Label;

      Text  : constant String :=
        Context.Current_Slide_Index'Image & " /" & Context.Total_Slides'Image;

      Name  : constant String := Self.Name (Context);

      Stack : constant Gtk.Stack.Gtk_Stack :=
        Slides_As_Code.Contexts.Windows.Get_Stack (Context);
   begin
      Gtk.Label.Gtk_New (Label, "Hello Word!" & Text);
      Gtk.Label.Show (Label);
      Gtk.Label.Set_Name (Label, Name);
      Gtk.Stack.Add_Named (Stack, Label, Name);
   end Construct;

   ----------
   -- Name --
   ----------

   function Name
     (Self    : Base_Slide'Class;
      Context : Slides_As_Code.Contexts.Context'Class) return String
   is
      pragma Unreferenced (Self);
      Name : constant String := Context.Current_Slide_Index'Image;
   begin
      return "slide-" & Name (2 .. Name'Last);
   end Name;

   ----------
   -- Show --
   ----------

   overriding procedure Show
     (Self    : Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);
   begin
      Gtk.Stack.Set_Visible_Child_Name (Stack, Self.Name (Context));
   end Show;

end Slides_As_Code.Base_Slides;
