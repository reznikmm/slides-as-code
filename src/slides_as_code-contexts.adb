--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Glib;
with Glib.Main;
with Gtk.Main;

package body Slides_As_Code.Contexts is

   type Context_Access is access all Context'Class with Storage_Size => 0;

   package Context_Source is new Glib.Main.Generic_Sources (Context_Access);

   function Start_Presentation
     (Context : Context_Access) return Boolean;

   function Next_Slide
     (Context : Context_Access) return Boolean;

   ----------------
   -- Next_Slide --
   ----------------

   function Next_Slide
     (Context : Context_Access) return Boolean is
   begin
      if Context.Index = Context.Slides.Last_Index then
         Gtk.Main.Main_Quit;
         return False;

      else
         declare
            Slide : constant Slides_As_Code.Slides.Slide_Access :=
              Context.Slides (Context.Index + 1);
         begin
            Context.Index := Context.Index + 1;
            Slide.Show (Context.all);
         end;

         return True;
      end if;
   end Next_Slide;

   ------------------------
   -- Start_Presentation --
   ------------------------

   function Start_Presentation
     (Context : Context_Access) return Boolean
   is
      Ignore : Glib.Main.G_Source_Id;

      Slide : constant Slides_As_Code.Slides.Slide_Access :=
        Context.Slides (1);
   begin
      Context.Index := 1;
      Slide.Show (Context.all);

      Ignore := Context_Source.Timeout_Add
        (Interval => 50_000,
         Func     => Next_Slide'Access,
         Data     => Context);

      return False;
   end Start_Presentation;

   ------------
   -- Append --
   ------------

   procedure Append
     (Self : in out Context'Class;
      Item : Slides.Slide_Access) is
   begin
      Self.Slides.Append (Item);
   end Append;

   ----------
   -- Show --
   ----------

   procedure Show (Self : in out Context'Class) is
      Ignore : Glib.Main.G_Source_Id;
   begin
      Gtk.Main.Init;
      Self.Index := 1;

      for Slide of Self.Slides loop
         Slide.Construct (Self);
         Self.Index := Self.Index + 1;
      end loop;

      Ignore := Context_Source.Idle_Add
        (Start_Presentation'Access, Self'Unchecked_Access);

      Gtk.Main.Main;
   end Show;

end Slides_As_Code.Contexts;
