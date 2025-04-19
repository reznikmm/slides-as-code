--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

limited with Slides_As_Code.Contexts;

package Slides_As_Code.Slides is

   type Slide is limited interface;

   type Slide_Access is access all Slide'Class;

   not overriding procedure Construct
     (Self    : in out Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class) is null;

   not overriding procedure Show
     (Self    : Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class) is abstract;

end Slides_As_Code.Slides;
