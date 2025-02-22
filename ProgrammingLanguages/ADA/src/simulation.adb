with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Simulation is

   -----GLOBAL VARIABLES----

   Number_Of_Fishermen: constant Integer := 5;
   Number_Of_Coolers: constant Integer := 3;
   Number_Of_Traders: constant Integer := 2;


   subtype Fisherman_Type is Integer range 1 .. Number_Of_Fishermen;
   subtype Cooler_Type is Integer range 1 .. Number_Of_Coolers;
   subtype Trader_Type is Integer range 1 .. Number_Of_Traders;

   -- Each Fisherman is assigned a type of seafood that he catches
   Seafood_Name: constant array (Fisherman_Type) of String(1 .. 7)
     := ("Fish   " , "Crab   ", "Lobster", "Shrimp ", "Oyster ");

   -- Each Cooler is a collection of seafood
   Cooler_Name: constant array (Cooler_Type) of String(1 .. 7)
     := ("Cooler1", "Cooler2", "Cooler3");

   ----TASK DECLARATIONS----

   -- Fisherman catches seafood
   task type Fisherman is
      entry Start(Seafood: in Fisherman_Type; Catch_Time: in Integer);
   end Fisherman;

   task type Cat is
      entry Start;
   end Cat;

   -- Trader takes an arbitrary cooler of seafood from the buffer
   -- The cooler's contents are randomly chosen
   task type Trader is
      entry Start(Trader_Number: in Trader_Type; Purchase_Time: in Integer);
   end Trader;

   -- Buffer receives seafood from Fishermen and delivers coolers to Traders
   task type Buffer is
      -- Accept seafood to the storage (provided there is a room for it)
      entry Store(Seafood: in Fisherman_Type; Number: in Integer);
      -- Deliver a cooler (provided there is enough seafood)
      entry Deliver(Cooler: in Cooler_Type; Number: out Integer);
      entry Cat_In_Storage(Seafood: in Fisherman_Type);
   end Buffer;

   F: array (1 .. Number_Of_Fishermen) of Fisherman;
   T: array (1 .. Number_Of_Traders) of Trader;
   B: Buffer;
   C: Cat;


   ----TASK DEFINITIONS----

   task body Cat is
      subtype Wait_Time_Range is Integer range 7 .. 12;
      package Random_Wait is new Ada.Numerics.Discrete_Random(Wait_Time_Range);
      package Random_Fisherman is new Ada.Numerics.Discrete_Random(Fisherman_Type);

      G: Random_Wait.Generator;
      GF: Random_Fisherman.Generator;
      Entered: Boolean;

      Random_Time: Duration;
      Seafood_To_Remove: Fisherman_Type;
   begin
      accept Start do
         Random_Wait.Reset(G);
         Random_Fisherman.Reset(GF);
      end Start;

      Put_Line(ESC & "[95m" & "C: Started wandering around the storage" & ESC & "[0m");
      loop
         Entered := false;
         Random_Time := Duration(Random_Wait.Random(G));
         select
            delay Random_Time;
            Put_Line(ESC & "[95m" & "C: Is near the storage" & ESC & "[0m");
            Entered := true;
         then abort
            delay Duration(10.0);
            Put_Line(ESC & "[95m" & "C: Gets into the storage" & ESC & "[0m");
            Put_Line(ESC & "[95m" & "C: Runs out of the storage, beacuse has seen a mouse outside" & ESC & "[0m");
         end select;
         if Entered = true then
            Seafood_To_Remove := Random_Fisherman.Random(GF);
            B.Cat_In_Storage(Seafood_To_Remove);
            Put_Line(ESC & "[95m" & "C: Gets into the storage" & ESC & "[0m");
            Put_Line(ESC & "[95m" & "C: Ate all the " & Seafood_Name(Seafood_To_Remove) &  " and ran out of the storage" & ESC & "[0m");
         end if;
      end loop;
   end Cat;

   task body Fisherman is
      subtype Catch_Time_Range is Integer range 1 .. 3;
      package Random_Catch is new Ada.Numerics.Discrete_Random(Catch_Time_Range);
      G: Random_Catch.Generator;
      Fisherman_Type_Number: Integer;
      Seafood_Number: Integer;
      Catch: Integer;
      Random_Time: Duration;
   begin
      accept Start(Seafood: in Fisherman_Type; Catch_Time: in Integer) do
         -- Start random number generator
         Random_Catch.Reset(G);
         Seafood_Number := 1;
         Fisherman_Type_Number := Seafood;
         Catch := Catch_Time;
      end Start;
      Put_Line(ESC & "[93m" & "F: Fisherman catching " & Seafood_Name(Fisherman_Type_Number) & ESC & "[0m");
      loop
         Random_Time := Duration(Random_Catch.Random(G));
         delay Random_Time;
         Put_Line(ESC & "[93m" & "F: Caught " & Seafood_Name(Fisherman_Type_Number)
                  & " number "  & Integer'Image(Seafood_Number) & ESC & "[0m");
         loop
            select
               B.Store(Fisherman_Type_Number, Seafood_Number);
               Seafood_Number := Seafood_Number + 1;
               exit;
            else
                  Put_Line(ESC & "[93m" & "F: " & Seafood_Name(Fisherman_Type_Number) & " is ready to be stored, but buffer is occupied at the moment.");
               delay Duration(2.0);
            end select;
         end loop;
      end loop;
   end Fisherman;

   -- Trader Task Body --
   task body Trader is
      subtype Purchase_Time_Range is Integer range 3 .. 6;
      package Random_Purchase is new Ada.Numerics.Discrete_Random(Purchase_Time_Range);

      -- Each trader picks a random cooler from the buffer
      package Random_Cooler is new Ada.Numerics.Discrete_Random(Cooler_Type);

      G: Random_Purchase.Generator;
      GC: Random_Cooler.Generator;
      Trader_Nb: Trader_Type;
      Cooler_Number: Integer;
      Purchase: Integer;
      Cooler_Type_Number: Integer;
      Trader_Name: constant array (1 .. Number_Of_Traders) of String(1 .. 7)
        := ("Trader1", "Trader2");
   begin
      accept Start(Trader_Number: in Trader_Type; Purchase_Time: in Integer) do
         Random_Purchase.Reset(G);
         Random_Cooler.Reset(GC);
         Trader_Nb := Trader_Number;
         Purchase := Purchase_Time;
      end Start;
      Put_Line(ESC & "[96m" & "T: Trader " & Trader_Name(Trader_Nb) & " started" & ESC & "[0m");
      loop
         delay Duration(Random_Purchase.Random(G)); -- Simulate time between purchases
         Cooler_Type_Number := Random_Cooler.Random(GC);
         -- Take a cooler for the trader
         B.Deliver(Cooler_Type_Number, Cooler_Number);
         if (Cooler_Number /= 0) then
            Put_Line(ESC & "[96m" & "T: " & Trader_Name(Trader_Nb) & " took " & Cooler_Name(Cooler_Type_Number) &
                       " number " & Integer'Image(Cooler_Number) & " out of all" & ESC & "[0m");
         else
            Put_Line(ESC & "[96m" & "T: " & Trader_Name(Trader_Nb) & " didn't take any cooler, beacuse his order wasn't ready" & ESC & "[0m");
         end if;
      end loop;
   end Trader;

   -- Buffer Task Body --
   task body Buffer is
      Storage_Capacity: constant Integer := 30;
      type Storage_Type is array (Fisherman_Type) of Integer;
      Storage: Storage_Type := (0, 0, 0, 0, 0);
      Cooler_Content: array (Cooler_Type, Fisherman_Type) of Integer
        := ((2, 1, 2, 0, 2),
            (1, 2, 0, 1, 0),
            (3, 2, 2, 0, 1));
      Max_Cooler_Content: array (Fisherman_Type) of Integer;
      Cooler_Number: array (Cooler_Type) of Integer := (1, 1, 1);
      In_Storage: Integer := 0;
      freshnessOfSeafood : Integer := 0;

      procedure Setup_Variables is
      begin
         for W in Fisherman_Type loop
            Max_Cooler_Content(W) := 0;
            for Z in Cooler_Type loop
               if Cooler_Content(Z, W) > Max_Cooler_Content(W) then
                  Max_Cooler_Content(W) := Cooler_Content(Z, W);
               end if;
            end loop;
         end loop;
      end Setup_Variables;

      function Can_Store(Seafood: Fisherman_Type) return Boolean is
      begin
         if In_Storage >= Storage_Capacity then
            return False;
         else
            return True;
         end if;
      end Can_Store;

      function Can_Deliver(Cooler: Cooler_Type) return Boolean is
      begin
         for W in Fisherman_Type loop
            if Storage(W) < Cooler_Content(Cooler, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;

      procedure Storage_Contents is
      begin
         for W in Fisherman_Type loop
            Put_Line(ESC & "[90m" & "|   Storage contents: " & Integer'Image(Storage(W)) & " "
                     & Seafood_Name(W) & ESC & "[0m");
         end loop;
         Put_Line(ESC & "[90m" & "|   Total seafood in storage: " & Integer'Image(In_Storage) & ESC & "[0m");
      end Storage_Contents;

      procedure Product_destruction(Seafood: Fisherman_Type) is
      begin
         In_Storage := In_Storage - Storage(Seafood);
         Storage(Seafood) := 0;
      end Product_destruction;


   begin
      Put_Line(ESC & "[91m" & "Wholesaler: started working" & ESC & "[0m");
      Setup_Variables;
      loop
         select
            accept Store(Seafood: in Fisherman_Type; Number: in Integer) do
               if Can_Store(Seafood) then
                  Put_Line(ESC & "[91m" & "Wholesaler: Stored " & Seafood_Name(Seafood) & " number " &
                             Integer'Image(Number) & ESC & "[0m");
                  Storage(Seafood) := Storage(Seafood) + 1;
                  In_Storage := In_Storage + 1;

                  for W in Fisherman_Type loop
                     if Storage(W) >= 8 then
                        Storage(W) := Storage(W) - 2;
                        In_Storage := In_Storage - 2;
                        Put_Line(ESC & "[91m" & "Wholesaler: There is too much " & Seafood_Name(W) & ", 2 of them got thrown away");
                     end if;
                  end loop;
               else
                  Put_Line(ESC & "[91m" & "Wholesaler: Storage full, Fisherman realese " & Seafood_Name(Seafood) & ESC & "[0m");
               end if;
            end Store;
            Storage_Contents;
         or
            accept Deliver(Cooler: in Cooler_Type; Number: out Integer) do
               if Can_Deliver(Cooler) then
                  Put_Line(ESC & "[91m" & "Wholesaler: Delivered cooler " & Cooler_Name(Cooler) & " number " &
                             Integer'Image(Cooler_Number(Cooler)) & ESC & "[0m");
                  for W in Fisherman_Type loop
                     Storage(W) := Storage(W) - Cooler_Content(Cooler, W);
                     In_Storage := In_Storage - Cooler_Content(Cooler, W);
                  end loop;
                  Number := Cooler_Number(Cooler);
                  Cooler_Number(Cooler) := Cooler_Number(Cooler) + 1;
               else
                  if In_Storage >= 30 then
                     freshnessOfSeafood := freshnessOfSeafood + 1;
                  end if;
                  if freshnessOfSeafood >= 3 then
                     freshnessOfSeafood := 0;
                     Put_Line(ESC & "[91m" & "Wholesaler: Some of seafood got rotten and poisoned everything");
                     for W in Fisherman_Type loop
                        Storage(W) := 0;
                     end loop;
                     In_Storage := 0;
                  else
                     Put_Line(ESC & "[91m" & "Wholesaler: Not enough seafood for " & Cooler_Name(Cooler) & " to be sold" & ESC & "[0m");
                     Number := 0;
                  end if;
               end if;
            end Deliver;
         or
            accept Cat_In_Storage(Seafood: in Fisherman_Type) do
               Product_destruction(Seafood);
            end Cat_In_Storage;

         end select;
      end loop;
   end Buffer;

   --- "MAIN" FOR SIMULATION ---
begin
   for I in 1 .. Number_Of_Fishermen loop
      F(I).Start(I, 10);
   end loop;
   for J in 1 .. Number_Of_Traders loop
      T(J).Start(J, 12);
   end loop;
   C.Start;
end Simulation;
