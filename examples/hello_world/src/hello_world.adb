--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slides_As_Code.Base_Slides;
with Slides_As_Code.Cairo_Slides;
with Slides_As_Code.Contexts;
with Slides_As_Code.Markdown_Slides;

procedure Hello_World is
   Context : Slides_As_Code.Contexts.Context;
   Slide_1 : aliased Slides_As_Code.Markdown_Slides.Markdown_Slide;
   Slide_2 : aliased Slides_As_Code.Cairo_Slides.Cairo_Slide;
   Slide_3 : aliased Slides_As_Code.Base_Slides.Base_Slide;
begin
   Context.Append (Slide_1'Unchecked_Access);
   Context.Append (Slide_2'Unchecked_Access);
   Context.Append (Slide_3'Unchecked_Access);
   Context.Show;
end Hello_World;
