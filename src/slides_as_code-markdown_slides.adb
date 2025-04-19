--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Glib;
with Gtk.Stack;
with Gtk.Style_Context;
with Gtk.Box;

with Pango.Enums;
with Pango.Layout;

with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Markdown_Slides is

   overriding procedure Construct
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is
      VBox  : Gtk.Box.Gtk_Vbox;
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);
   begin
      Cairo_Slides.Cairo_Slide (Self).Construct (Context);
      VBox := Gtk.Box.Gtk_Vbox (Stack.Get_Visible_Child);

      Gtk.Label.Gtk_New (Self.Heading);
      Gtk.Style_Context.Get_Style_Context (Self.Heading).Add_Class ("heading");
      VBox.Add (Self.Heading);

      Gtk.Label.Gtk_New (Self.Paragraph);
      Gtk.Style_Context.Get_Style_Context (Self.Paragraph).Add_Class
        ("paragraph");
      VBox.Add (Self.Paragraph);
   end Construct;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);

      Header : constant Pango.Layout.Pango_Layout :=
        Self.Heading.Create_Pango_Layout ("Header");

      Para : constant Pango.Layout.Pango_Layout :=
        Self.Paragraph.Create_Pango_Layout ("Paragraph with some text");

      Style : Gtk.Style_Context.Gtk_Style_Context :=
        Gtk.Style_Context.Get_Style_Context (Stack);

      function Space
        (Layout : Pango.Layout.Pango_Layout) return Glib.Gdouble is
      begin
         return Glib.Gdouble
           (Pango.Enums.To_Pixels (Pango.Layout.Get_Baseline (Layout)));
      end Space;

      function Size (Layout : Pango.Layout.Pango_Layout) return Glib.Gdouble is
         Width  : Glib.Gint;
         Height : Glib.Gint;
      begin
         Pango.Layout.Get_Size (Layout, Width, Height);

         return Glib.Gdouble (Pango.Enums.To_Pixels (Height));
      end Size;

      use type Glib.Gdouble;

      Heigth : constant Glib.Gdouble :=
        Size (Header) + Space (Header) + Size (Para);

      First  : constant Glib.Gdouble := (720.0 - Heigth) / 2.0;
      Second : constant Glib.Gdouble := First + Size (Header) + Space (Header);
   begin
      Cairo.Save (CC);
      Gtk.Style_Context.Render_Background (Style, CC, 0.0, 0.0, 1024.0, 720.0);

      Style := Gtk.Style_Context.Get_Style_Context (Self.Heading);
      Gtk.Style_Context.Render_Layout (Style, CC, 80.0, First, Header);

      Style := Gtk.Style_Context.Get_Style_Context (Self.Paragraph);
      Gtk.Style_Context.Render_Layout (Style, CC, 80.0, Second, Para);

      Header.Unref;
      Para.Unref;
   end Draw;

end Slides_As_Code.Markdown_Slides;
