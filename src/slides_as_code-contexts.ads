--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with Ada.Containers.Vectors;

with Slides_As_Code.Slides;

private with Gtk.Window;

package Slides_As_Code.Contexts is

   type Context is tagged limited private;

   procedure Append
     (Self : in out Context'Class;
      Item : Slides.Slide_Access);

   procedure Show (Self : in out Context'Class);

private

   package Slide_Vectors is new Ada.Containers.Vectors
     (Positive, Slides.Slide_Access, Slides."=");

   type Context is tagged limited record
      Slides : Slide_Vectors.Vector;
      Index  : Positive;
      Window : Gtk.Window.Gtk_Window;
   end record;

end Slides_As_Code.Contexts;
