--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

private with Ada.Containers.Vectors;

with Slides_As_Code.Slides;

private with Gtk.Stack;
private with Gtk.Window;

package Slides_As_Code.Contexts is

   type Context is tagged limited private;

   procedure Append
     (Self : in out Context'Class;
      Item : Slides.Slide_Access);

   procedure Show (Self : in out Context'Class);

   function Current_Slide (Self : Context'Class) return Slides.Slide_Access;

   function Current_Slide_Index (Self : Context'Class) return Positive;

   function Total_Slides (Self : Context'Class) return Natural;

private

   package Slide_Vectors is new Ada.Containers.Vectors
     (Positive, Slides.Slide_Access, Slides."=");

   type Context is tagged limited record
      Slides : Slide_Vectors.Vector;
      Index  : Positive;

      Stack  : Gtk.Stack.Gtk_Stack;
      Window : Gtk.Window.Gtk_Window;
   end record;

   function Current_Slide (Self : Context'Class) return Slides.Slide_Access is
     (Self.Slides (Self.Index));

   function Current_Slide_Index (Self : Context'Class) return Positive is
      (Self.Index);

   function Total_Slides (Self : Context'Class) return Natural is
      (Self.Slides.Last_Index);

end Slides_As_Code.Contexts;
