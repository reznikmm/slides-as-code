--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Glib;
with Gtk.Drawing_Area;
with Gtk.Handlers;
with Gtk.Stack;
with Gtk.Widget;

with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Cairo_Slides is

   Item_Name : constant String := "cairo";

   type Context_Access is access
     all Slides_As_Code.Contexts.Context'Class'Class with Storage_Size => 0;

   type Context_Drawing_Area_Record is
     new Gtk.Drawing_Area.Gtk_Drawing_Area_Record
   with record
      Context : Context_Access;
   end record;

   type Context_Drawing_Area is access all Context_Drawing_Area_Record'Class;

   package Event_Cb is new Gtk.Handlers.Return_Callback
     (Context_Drawing_Area_Record,
      Boolean);

   function Redraw
     (Self : access Context_Drawing_Area_Record'Class;
      CC   : Cairo.Cairo_Context) return Boolean;

   ---------------
   -- Construct --
   ---------------

   overriding procedure Construct
     (Self    : Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);
      Area  : Context_Drawing_Area :=
        Context_Drawing_Area (Gtk.Stack.Get_Child_By_Name (Stack, Item_Name));
   begin
      if Area = null then
         Area := new Context_Drawing_Area_Record;
         Area.Context := Context'Unchecked_Access;
         Gtk.Drawing_Area.Initialize (Area);
         Gtk.Stack.Add_Named (Stack, Area, Item_Name);
         Show (Area);

         Event_Cb.Connect
           (Area,
            Gtk.Widget.Signal_Draw,
            Event_Cb.To_Marshaller (Redraw'Access));
      end if;
   end Construct;

   ----------
   -- Draw --
   ----------

   not overriding procedure Draw
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context)
   is
      pragma Unreferenced (Context);
      use type Glib.Gdouble;
   begin
      Cairo.Save (CC);
      Cairo.Translate (CC, 10.0, 10.0);
      Cairo.Scale (CC, 5.0, 5.0);
      Cairo.Set_Font_Size (CC, 5.0);
      Cairo.Move_To (CC, 0.0, 0.0);
      Cairo.Line_To (CC, 30.0, 0.0);
      Cairo.Line_To (CC, 29.0, 1.0);
      Cairo.Move_To (CC, 25.0, 5.0);
      Cairo.Show_Text (CC, "X");
      Cairo.Move_To (CC, 0.0, 0.0);
      Cairo.Line_To (CC, 0.0, 30.0);
      Cairo.Line_To (CC, 1.0, 29.0);
      Cairo.Move_To (CC, 1.0, 30.0);
      Cairo.Show_Text (CC, "Y");
      Cairo.Move_To (CC, 1.0, 5.0);
      Cairo.Show_Text (CC, "0");
      Cairo.New_Sub_Path (CC);
      Cairo.Arc (CC, 10.0, 10.0, 10.0, 0.0, 3.14 / 2.0);
      Cairo.Line_To (CC, 11.0, 21.0);
      Cairo.Move_To (CC, 20.0, 10.0);
      Cairo.Show_Text (CC, "0");
      Cairo.Move_To (CC, 10.0, 25.0);
      Cairo.Show_Text (CC, "Pi/2");
      Cairo.Restore (CC);
      Cairo.Stroke (CC);
   end Draw;

   ------------
   -- Redraw --
   ------------

   function Redraw
     (Self : access Context_Drawing_Area_Record'Class;
      CC   : Cairo.Cairo_Context) return Boolean
   is
      Slide : constant Slides.Slide_Access := Self.Context.Current_Slide;
   begin
      if Slide.all in Cairo_Slide'Class then
         Cairo_Slide'Class (Slide.all).Draw (Self.Context.all, CC);
      end if;

      return False;
   end Redraw;

   ----------
   -- Show --
   ----------

   overriding procedure Show
     (Self    : Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);
   begin
      Gtk.Stack.Set_Visible_Child_Name (Stack, Item_Name);
   end Show;

end Slides_As_Code.Cairo_Slides;
