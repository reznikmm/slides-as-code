--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with Ada.Containers.Vectors;
private with Cairo;
private with Glib;
private with Gtk.Label;
private with Pango.Layout;
private with Markdown.Blocks.ATX_Headings;

with Slides_As_Code.Cairo_Slides;
with Slides_As_Code.Contexts;
with Slides_As_Code.Slides;

package Slides_As_Code.Markdown_Slides is

   type Markdown_Slide is new Slides_As_Code.Slides.Slide
     with private;

private

   type Block_Record is record
      Label  : Gtk.Label.Gtk_Label;
      Layout : Pango.Layout.Pango_Layout;
      Height : Glib.Gdouble;
      X      : Glib.Gdouble;  --  Left margin
      Y      : Glib.Gdouble;
   end record;

   package Block_Vectors is new Ada.Containers.Vectors
     (Positive, Block_Record);

   type Label_Array is array (Positive range <>) of Gtk.Label.Gtk_Label;

   subtype Heading_Level is Markdown.Blocks.ATX_Headings.Heading_Level;

   type Markdown_Slide is new Cairo_Slides.Cairo_Slide with record
      Headings  : Label_Array (Heading_Level);
      Paragraph : Gtk.Label.Gtk_Label;
      Blocks    : Block_Vectors.Vector;
   end record;

   overriding procedure Construct
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

   overriding procedure Draw
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context);

end Slides_As_Code.Markdown_Slides;
