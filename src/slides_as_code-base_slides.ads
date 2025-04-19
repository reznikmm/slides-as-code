--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

limited with Slides_As_Code.Contexts;
with Slides_As_Code.Slides;

package Slides_As_Code.Base_Slides is

   type Base_Slide is new Slides_As_Code.Slides.Slide with private;

   function Name
     (Self    : Base_Slide'Class;
      Context : Slides_As_Code.Contexts.Context'Class) return String;

private

   type Base_Slide is new Slides_As_Code.Slides.Slide with record
      null;
   end record;

   overriding procedure Construct
     (Self    : in out Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

   overriding procedure Show
     (Self    : Base_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class);

end Slides_As_Code.Base_Slides;
