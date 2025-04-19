--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with Cairo;
private with Gtk.Label;

with Slides_As_Code.Cairo_Slides;
with Slides_As_Code.Contexts;
with Slides_As_Code.Slides;

package Slides_As_Code.Markdown_Slides is

   type Markdown_Slide is new Slides_As_Code.Slides.Slide
     with private;

private

   type Markdown_Slide is new Cairo_Slides.Cairo_Slide with record
      Heading   : Gtk.Label.Gtk_Label;
      Paragraph : Gtk.Label.Gtk_Label;
   end record;

   overriding procedure Construct
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

   overriding procedure Draw
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context);

end Slides_As_Code.Markdown_Slides;
