--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Gtk.Stack;
with Gtk.Style;
with Gtk.Style_Context;
with Gtk.Box;

with Markdown.Block_Containers;
with Markdown.Blocks.Paragraphs;
with Markdown.Blocks;
--  with Markdown.Documents;
with Markdown.Parsers.Enable_GFM;

with Pango.Enums;

with VSS.Characters;
with VSS.Characters.Latin;
with VSS.Strings;
with VSS.Strings.Conversions;
with VSS.Text_Streams.File_Input;
with Slides_As_Code.Contexts.Windows;

package body Slides_As_Code.Markdown_Slides is

   Frame_Width : constant := 1024.0;
   Frame_Height : constant := 720.0;

   overriding procedure Construct
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class)
   is

      Parser : Markdown.Parsers.Markdown_Parser;

      procedure Parse;
      procedure Create_Blocks
        (VBox   : Gtk.Box.Gtk_Vbox;
         Parent : Markdown.Block_Containers.Block_Container'Class;
         Margin : Natural);
      procedure Spread_Blocks_Vertically;

      procedure Create_Blocks
        (VBox   : Gtk.Box.Gtk_Vbox;
         Parent : Markdown.Block_Containers.Block_Container'Class;
         Margin : Natural)
      is
         use type Gtk.Label.Gtk_Label;

         procedure Append (Block : in out Block_Record);
         procedure Create_Block (Block : Markdown.Blocks.Block);

         procedure Append
           (Block : in out Block_Record)
         is
            use type Glib.Gdouble;
            use type Glib.Gint;
            Border : Gtk.Style.Gtk_Border;
            Width  : Glib.Gint;
            Height : Glib.Gint;
            Style  : constant Gtk.Style_Context.Gtk_Style_Context :=
              Gtk.Style_Context.Get_Style_Context (Block.Label);
         begin
            Style.Get_Margin (0, Border);
            Block.X := Glib.Gdouble (Margin) + Glib.Gdouble (Border.Left);
            Width := Glib.Gint (Frame_Width) - Glib.Gint (Block.X);
            --  - Glib.Gint (Border.Right); ???

            Pango.Layout.Set_Width
              (Block.Layout, Pango.Enums.Pango_Scale * Width);

            Pango.Layout.Get_Size (Block.Layout, Width, Height);

            Block.Y := 0.0;
            Block.Height := Glib.Gdouble (Pango.Enums.To_Pixels (Height));
            Self.Blocks.Append (Block);
         end Append;

         procedure Create_Block (Block : Markdown.Blocks.Block) is
            Result : Block_Record;
         begin
            if Block.Is_ATX_Heading then
               declare
                  H : constant Markdown.Blocks.ATX_Headings.ATX_Heading :=
                    Block.To_ATX_Heading;
                  Label renames Self.Headings (H.Level);
               begin
                  if Label = null then
                     Gtk.Label.Gtk_New (Label);
                     Gtk.Style_Context.Get_Style_Context (Label).Add_Class
                       ("heading" & Integer'Image (-H.Level));
                     VBox.Add (Label);
                  end if;

                  Result.Label := Label;
                  Result.Layout := Label.Create_Pango_Layout
                    (VSS.Strings.Conversions.To_UTF_8_String
                       (H.Text.Plain_Text));
                  Append (Result);
               end;
            elsif Block.Is_Paragraph then
               declare
                  H : constant Markdown.Blocks.Paragraphs.Paragraph :=
                    Block.To_Paragraph;
                  Label renames Self.Paragraph;
               begin
                  if Label = null then
                     Gtk.Label.Gtk_New (Label);
                     Gtk.Style_Context.Get_Style_Context (Label).Add_Class
                       ("paragraph");
                     VBox.Add (Label);
                  end if;

                  Result.Label := Label;
                  Result.Layout := Label.Create_Pango_Layout
                    (VSS.Strings.Conversions.To_UTF_8_String
                       (H.Text.Plain_Text));
                  Result.X := Glib.Gdouble (Margin);
                  Append (Result);
               end;
            end if;
         end Create_Block;
      begin
         for Block of Parent loop
            Create_Block (Block);
         end loop;
      end Create_Blocks;

      procedure Spread_Blocks_Vertically is
         use type Glib.Gdouble;
         Total : Glib.Gdouble := Self.Blocks.First_Element.Height;
         Gap   : Glib.Gdouble;
         Next  : Glib.Gdouble := 0.0;
      begin
         for J in 2 .. Self.Blocks.Last_Index loop
            Total := Total + Self.Blocks (J).Height;
         end loop;

         --  Gap := Glib.Gdouble
         --    (Pango.Enums.To_Pixels (Pango.Layout.Get_Baseline (Layout)));

         Gap := Glib.Gdouble'Max
           ((Frame_Height - Total) /
               Glib.Gdouble (Self.Blocks.Last_Index - 1),
            0.0);

         for Block of Self.Blocks loop
            Block.Y := Next;
            Next := Next + Block.Height + Gap;
         end loop;
      end Spread_Blocks_Vertically;

      procedure Parse is
         use type VSS.Characters.Virtual_Character;

         Input  : VSS.Text_Streams.File_Input.File_Input_Text_Stream;
         Line   : VSS.Strings.Virtual_String;
         File  : constant VSS.Strings.Virtual_String :=
           VSS.Strings.Conversions.To_Virtual_String
             (Self.Name (Context) & ".md");
      begin
         Markdown.Parsers.Enable_GFM (Parser);
         Input.Open (File);

         while not Input.Is_End_Of_Stream loop
            declare
               Char : VSS.Characters.Virtual_Character;
               Ok   : Boolean := True;
            begin
               Input.Get (Char, Ok);

               if Char = VSS.Characters.Latin.Line_Feed then
                  Parser.Parse_Line (Line);
                  Line.Clear;
               else
                  Line.Append (Char);
               end if;
            end;
         end loop;

         Input.Close;
      end Parse;

      VBox  : Gtk.Box.Gtk_Vbox;
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);
   begin
      Cairo_Slides.Cairo_Slide (Self).Construct (Context);
      VBox := Gtk.Box.Gtk_Vbox (Stack.Get_Visible_Child);

      Parse;
      Create_Blocks (VBox, Parser.Document, 0);
      Spread_Blocks_Vertically;
   end Construct;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (Self    : in out Markdown_Slide;
      Context : in out Slides_As_Code.Contexts.Context'Class;
      CC      : Cairo.Cairo_Context)
   is
      Stack : constant Gtk.Stack.Gtk_Stack :=
        Contexts.Windows.Get_Stack (Context);

      Style : Gtk.Style_Context.Gtk_Style_Context :=
        Gtk.Style_Context.Get_Style_Context (Stack);

   begin
      Cairo.Save (CC);
      Gtk.Style_Context.Render_Background
        (Style, CC, 0.0, 0.0, Frame_Width, Frame_Height);

      for Block of Self.Blocks loop
         Style := Gtk.Style_Context.Get_Style_Context (Block.Label);
         Gtk.Style_Context.Render_Layout
           (Style, CC, Block.X, Block.Y, Block.Layout);
      end loop;
   end Draw;

end Slides_As_Code.Markdown_Slides;
