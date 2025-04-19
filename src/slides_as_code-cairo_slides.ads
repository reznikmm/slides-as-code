--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with Cairo;

with Slides_As_Code.Base_Slides;
with Slides_As_Code.Contexts;
with Slides_As_Code.Slides;

package Slides_As_Code.Cairo_Slides is

   type Cairo_Slide is new Slides_As_Code.Slides.Slide with private;

private

   type Cairo_Slide is new Slides_As_Code.Base_Slides.Base_Slide with record
      null;
   end record;

   overriding procedure Construct
     (Self    : Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

   not overriding procedure Draw
     (Self    : in out Cairo_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context);

end Slides_As_Code.Cairo_Slides;
