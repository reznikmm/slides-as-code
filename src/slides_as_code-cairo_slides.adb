--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Glib;
with Gtk.Drawing_Area;
with Gtk.Handlers;
with Gtk.Stack;
with Gtk.Style_Context;
with Gtk.Widget;
with Pango.Layout;

with Slides_As_Code.Contexts.Windows;
with Slides_As_Code.Slides;

package body Slides_As_Code.Cairo_Slides is

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
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);

      Name : constant String := Self.Name (Context);
      Area : constant Context_Drawing_Area := new Context_Drawing_Area_Record;
   begin
      Gtk.Box.Gtk_New_Vbox (Self.VBox);
      Gtk.Box.Set_Name (Self.VBox, Name);
      Gtk.Box.Show (Self.VBox);
      Gtk.Stack.Add_Named (Stack, Self.VBox, Name);

      Area.Context := Context'Unchecked_Access;
      Gtk.Drawing_Area.Initialize (Area);
      Show (Area);
      Gtk.Box.Add (Self.VBox, Area);

      Event_Cb.Connect
        (Area,
         Gtk.Widget.Signal_Draw,
         Event_Cb.To_Marshaller (Redraw'Access));
   end Construct;

   ----------
   -- Draw --
   ----------

   not overriding procedure Draw
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context)
   is
      use type Glib.Gdouble;
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);

      Layout : constant Pango.Layout.Pango_Layout :=
        Stack.Create_Pango_Layout ("Hello");

      Style  : constant Gtk.Style_Context.Gtk_Style_Context :=
        Gtk.Style_Context.Get_Style_Context (Stack);
   begin
      Cairo.Save (CC);
      Gtk.Style_Context.Render_Background
        (Style, CC, 0.0, 0.0, 1024.0, 720.0);
      --  Cairo.Restore (CC);

      --  Cairo.Save (CC);
      Cairo.Set_Source_Rgb (CC, 0.13, 0.26, 0.39);
      Cairo.Select_Font_Face
        (CC,
         "sans-serif",
         Cairo.Cairo_Font_Slant_Normal,
         Cairo.Cairo_Font_Weight_Bold);
      Cairo.Set_Font_Size (CC, 46.6);
      Cairo.Translate (CC, 80.0, 300.0);  --  doesn't work?
      Cairo.Show_Text (CC, "Slide 2");

      Cairo.Rotate (CC, 45.0);
      Gtk.Style_Context.Render_Layout
        (Style, CC, 10.0, 10.0, Layout);
      Cairo.Restore (CC);

      Cairo.Save (CC);
      Cairo.Translate (CC, 600.0, 0.0);
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

      Layout.Unref;
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

end Slides_As_Code.Cairo_Slides;
