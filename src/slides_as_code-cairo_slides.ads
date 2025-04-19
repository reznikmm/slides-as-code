--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Cairo;
with Gtk.Box;

with Slides_As_Code.Base_Slides;
with Slides_As_Code.Contexts;

package Slides_As_Code.Cairo_Slides is

   type Cairo_Slide is new Slides_As_Code.Base_Slides.Base_Slide with private;

   not overriding procedure Draw
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context);

private

   type Cairo_Slide is new Slides_As_Code.Base_Slides.Base_Slide with record
      VBox  : Gtk.Box.Gtk_Vbox;
   end record;

   overriding procedure Construct
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

end Slides_As_Code.Cairo_Slides;
