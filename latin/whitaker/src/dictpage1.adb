--dictpage.adb via another repository and modified
--deemphasise kind

   with TEXT_IO; 
   with STRINGS_PACKAGE; use STRINGS_PACKAGE;  
   with LATIN_FILE_NAMES; use LATIN_FILE_NAMES;
   with INFLECTIONS_PACKAGE; use INFLECTIONS_PACKAGE;
   with DICTIONARY_PACKAGE; use DICTIONARY_PACKAGE;
   with LINE_STUFF; use LINE_STUFF;
   use Text_IO;

with Ada.Integer_Text_IO;
procedure Dictpage1 is
   --  DICTLINE.IN -> DICTPAGE.OUT
   --  Takes DICTLINE form, puts # and dictionary form at beginning,
   --  a file that can be sorted to produce word order of paper dictionary

  function dictionary_form1(DE : DICTIONARY_ENTRY) return STRING is
      NULL_OX : constant STRING(1..24) := (others => ' ');
      --OX is the principal parts, calculated by this routine
      OX : array (1..4) of STRING (1..24) := (others => NULL_OX);
      FORM : STRING(1..150) := (others => ' ');                              --FORM
 
      ordinal: array (WHICH_TYPE range 1..9) of STRING(1..1) :=
        ("1", "2", "3", "4", "5", "6", "7", "8", "9");
      NOT_FOUND : exception;

      function add(STEM, INFL : STRING) return STRING is
      begin
        return HEAD(TRIM(STEM) & INFL, 24);
      end add;

      procedure FORMadd_up(FACTOR : STRING) is
      begin
        FORM := HEAD(TRIM(FORM) & TRIM(FACTOR), 150);
      end FORMadd_up;

      procedure FORMadd_to(FACTOR : STRING) is
      begin
        FORM := HEAD(TRIM(FORM) & FACTOR, 150);
      end FORMadd_to;

    begin
        if DE = NULL_DICTIONARY_ENTRY  then
          return "";
        end if;
        
        if (DE.PART.POFS = PREP)   then                             --species e
          return TRIM(DE.STEMS(1)) & " e pos: " & PART_OF_SPEECH_TYPE'IMAGE(DE.PART.POFS) & 
                  " case: " & CASE_TYPE'IMAGE(DE.PART.PREP.OBJ);
        end if;

        if DE.STEMS(2) = NULL_STEM_TYPE  and 
           DE.STEMS(3) = NULL_STEM_TYPE  and
           DE.STEMS(4) = NULL_STEM_TYPE       and not
           (((DE.PART.POFS = N)  and then (DE.PART.N.DECL.WHICH = 9))  or
            ((DE.PART.POFS = ADJ)  and then 
              ((DE.PART.ADJ.DECL.WHICH = 9) or
               (DE.PART.ADJ.CO = COMP or DE.PART.ADJ.CO = SUPER))   ) or  
            ((DE.PART.POFS = V)  and then (DE.PART.V.CON = (9, 8))) or  
            ((DE.PART.POFS = V)  and then (DE.PART.V.CON = (9, 9))))  
             then                                                   --species @ (mostly)
         return TRIM(DE.STEMS(1)) & " @, (COMP) (SUPER) pos: " & PART_OF_SPEECH_TYPE'IMAGE(DE.PART.POFS);  
          --  For UNIQUES, CONJ, INTERJ, ...    but mainly ADV
        end if;
        
        --all [categories for generating principal parts
        if DE.PART.POFS = N    then                                 --species s xxx N
          if DE.PART.N.DECL.WHICH = 1  then           --     1

            if DE.PART.N.DECL.VAR = 1  then           --      1
              OX(1) := add(DE.STEMS(1), "a s11");
              OX(2) := add(DE.STEMS(2), "ae");
            elsif DE.PART.N.DECL.VAR = 6  then
              OX(1) := add(DE.STEMS(1), "e gN16");    --g means Greek, don't use
              OX(2) := add(DE.STEMS(2), "es");
            elsif DE.PART.N.DECL.VAR = 7  then
              OX(1) := add(DE.STEMS(1), "es gN17");   --x means don't use
              OX(2) := add(DE.STEMS(2), "ae");
            elsif DE.PART.N.DECL.VAR = 8  then
              OX(1) := add(DE.STEMS(1), "as gN18");
              OX(2) := add(DE.STEMS(2), "ae");
            end if;
          elsif DE.PART.N.DECL.WHICH = 2  then        --     2
            if DE.PART.N.DECL.VAR = 1  then           --      1
              OX(1) := add(DE.STEMS(1), "us s21");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 2  then
              OX(1) := add(DE.STEMS(1), "um s22");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 3  then
              OX(1) := add(DE.STEMS(1), " s23");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 4  then
              if DE.PART.N.GENDER = N  then
                OX(1) := add(DE.STEMS(1), "um s22");   --try s22 for s24n re duplicates
              else
                OX(1) := add(DE.STEMS(1), "us s21");    --try s21 for s24 re duplicates
              end if;
              OX(2) := add(DE.STEMS(2), "(i)");
            elsif DE.PART.N.DECL.VAR = 5  then
              OX(1) := add(DE.STEMS(1), "us s25");
              OX(2) := add(DE.STEMS(2), "");
            elsif DE.PART.N.DECL.VAR = 6  then
              OX(1) := add(DE.STEMS(1), "os gN26");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 7  then
              OX(1) := add(DE.STEMS(1), "os gN27");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 8  then
              OX(1) := add(DE.STEMS(1), "on gN28");
              OX(2) := add(DE.STEMS(2), "i");
            elsif DE.PART.N.DECL.VAR = 9  then
              OX(1) := add(DE.STEMS(1), "us gN29");
              OX(2) := add(DE.STEMS(2), "i");
            end if;
          elsif DE.PART.N.DECL.WHICH = 3  then
            OX(1) := add(DE.STEMS(1), " s3");
            if (DE.PART.N.DECL.VAR = 7)  or
               (DE.PART.N.DECL.VAR = 9)  then
              OX(2) := add(DE.STEMS(2), "os/is");
            else
              OX(2) := add(DE.STEMS(2), "is");
            end if;
          elsif DE.PART.N.DECL.WHICH = 4  then
            if DE.PART.N.DECL.VAR = 1  then
              OX(1) := add(DE.STEMS(1), "us s41");
              OX(2) := add(DE.STEMS(2), "us");
            elsif DE.PART.N.DECL.VAR = 2  then
              OX(1) := add(DE.STEMS(1), "u s42");
              OX(2) := add(DE.STEMS(2), "us");
            elsif DE.PART.N.DECL.VAR = 3  then
              OX(1) := add(DE.STEMS(1), "us s43");
              OX(2) := add(DE.STEMS(2), "u");
            end if;
          elsif DE.PART.N.DECL.WHICH = 5  then
              OX(1) := add(DE.STEMS(1), "es s5");
              OX(2) := add(DE.STEMS(2), "ei");
          elsif DE.PART.N.DECL = (9, 8)  then
            OX(1) := add(DE.STEMS(1), ". xN98");
            OX(2) := add(NULL_OX, "abb.");
          elsif DE.PART.N.DECL = (9, 9)  then
            OX(1) := add(DE.STEMS(1), " xN99");
            OX(2) := add(NULL_OX, "undeclined");
          else
            raise NOT_FOUND;
          end if;     --  N

        elsif DE.PART.POFS = PRON    then                           --species o xxx
          if DE.PART.PRON.DECL.WHICH = 1  then
            raise NOT_FOUND;
          elsif DE.PART.PRON.DECL.WHICH = 3  then
            OX(1) := add(DE.STEMS(1), "ic o3");
            OX(2) := add(DE.STEMS(1), "aec");
            if DE.PART.PRON.DECL.VAR = 1  then
              OX(3) := add(DE.STEMS(1), "oc");
            elsif DE.PART.PRON.DECL.VAR = 2  then
              OX(3) := add(DE.STEMS(1), "uc");
            end if;
          elsif DE.PART.PRON.DECL.WHICH = 4  then
            if DE.PART.PRON.DECL.VAR = 1  then
              OX(1) := add(DE.STEMS(1), "s o41");
              OX(2) := add(DE.STEMS(2), "a");
              OX(3) := add(DE.STEMS(1), "d");
            elsif DE.PART.PRON.DECL.VAR = 2  then
              OX(1) := add(DE.STEMS(1), "dem o42");
              OX(2) := add(DE.STEMS(2), "adem");
              OX(3) := add(DE.STEMS(1), "dem");
            end if;
          elsif DE.PART.PRON.DECL.WHICH = 6  then
            OX(1) := add(DE.STEMS(1), "e o6");
            OX(2) := add(DE.STEMS(1), "a");
            if DE.PART.PRON.DECL.VAR = 1  then
              OX(3) := add(DE.STEMS(1), "ud");
            elsif DE.PART.PRON.DECL.VAR = 2  then
              OX(3) := add(DE.STEMS(1), "um");
            end if;
          elsif DE.PART.ADJ.DECL = (9, 8)  then
            OX(1) := add(DE.STEMS(1), ". a98");  --cA short for caseADJ
            OX(2) := add(NULL_OX, "abb.");
          elsif DE.PART.PRON.DECL = (9, 9)  then
            OX(1) := add(DE.STEMS(1), " a99");
            OX(2) := add(NULL_OX, "undeclined");
          else
            raise NOT_FOUND;
          end if;      --  PRON

        elsif DE.PART.POFS = ADJ  then           --xxx OX3            species a
          if DE.PART.ADJ.CO = COMP  then         --there may not be a positive or superlative form       
            OX(1) := add(DE.STEMS(1), "or aCOMP");   
            OX(2) := add(DE.STEMS(1), "or");   
            OX(3) := add(DE.STEMS(1), "us");  
          elsif DE.PART.ADJ.CO = SUPER  then     --there may not be a positive or comparative form
            OX(1) := add(DE.STEMS(1), "mus aSUPER");
            OX(2) := add(DE.STEMS(1), "ma");
            OX(3) := add(DE.STEMS(1), "mum");

          elsif DE.PART.ADJ.CO = POS  then       --there may not be a comparative or superlative form
            if DE.PART.ADJ.DECL.WHICH = 1  then         --1st/2nd decl
              if DE.PART.ADJ.DECL.VAR = 1  then
                OX(1) := add(DE.STEMS(1), "us a11");  --case ADJ POS 11 but keep with a11
                OX(2) := add(DE.STEMS(2), "a");
                OX(3) := add(DE.STEMS(2), "um POS");    --space filler POS to match a11

              elsif DE.PART.ADJ.DECL.VAR = 2  then
                OX(1) := add(DE.STEMS(1), " a12");                       --keep with a12
                OX(2) := add(DE.STEMS(2), "a");
                OX(3) := add(DE.STEMS(2), "um POS");
              elsif DE.PART.ADJ.DECL.VAR = 3  then
                OX(1) := add(DE.STEMS(1), "us a11");                     --keep with a11
                OX(2) := add(DE.STEMS(2), "a");
                OX(3) := add(DE.STEMS(2), "um_(gen_-ius) POS"); --"um (gen -ius)")
              elsif DE.PART.ADJ.DECL.VAR = 4  then
                OX(1) := add(DE.STEMS(1), " a+14");
                OX(2) := add(DE.STEMS(2), "a");
                OX(3) := add(DE.STEMS(2), "um POS");
              elsif DE.PART.ADJ.DECL.VAR = 5  then
                OX(1) := add(DE.STEMS(1), "us a+15");
                OX(2) := add(DE.STEMS(2), "a");
                OX(3) := add(DE.STEMS(2), "ud POS");
              else
                raise NOT_FOUND;
              end if;
            elsif DE.PART.ADJ.DECL.WHICH = 2  then --Greek
              if DE.PART.ADJ.DECL.VAR = 1  then
                OX(1) := add(NULL_OX, "- gA+21");                  --why.  g means Greek don't use it
                OX(2) := add(DE.STEMS(1), "e");
                OX(3) := add(NULL_OX, "-");
              elsif DE.PART.ADJ.DECL.VAR = 2  then
                OX(1) := add(NULL_OX, "- gA+22");                  --why -resulting strange line does not appear in DICTPAGE.RAW
                OX(2) := add(NULL_OX, "a");
                OX(3) := add(NULL_OX, "-");
              elsif DE.PART.ADJ.DECL.VAR = 3  then --Greek
                OX(1) := add(DE.STEMS(1), "es a+23");
                OX(2) := add(DE.STEMS(1), "es");
                OX(3) := add(DE.STEMS(1), "es");
              elsif DE.PART.ADJ.DECL.VAR = 6  then --Greek
                OX(1) := add(DE.STEMS(1), "os a+2G");
                OX(2) := add(DE.STEMS(1), "os");
                OX(3) := add(NULL_OX, "-");
              elsif DE.PART.ADJ.DECL.VAR = 7  then --Greek
                OX(1) := add(DE.STEMS(1), "os a+2G");
                OX(2) := add(NULL_OX, "-");
                OX(3) := add(NULL_OX, "-");
              elsif DE.PART.ADJ.DECL.VAR = 8  then --Greek
                OX(1) := add(NULL_OX, "- gA+28");                  --why
                OX(2) := add(NULL_OX, "-");
                OX(3) := add(DE.STEMS(2), "on");
              end if;

            elsif DE.PART.ADJ.DECL.WHICH = 3  then         --3rd decl  positive only
              if DE.PART.ADJ.DECL.VAR = 1  then
                OX(1) := add(DE.STEMS(1), " a31");     --case ADJ POS 3 var 1. A+31 is one char too long
                OX(2) := add(NULL_OX, "(gen.)");                           --keep with a31
                OX(3) := add(DE.STEMS(2), "is POS");
              elsif DE.PART.ADJ.DECL.VAR = 2  then
                OX(1) := add(DE.STEMS(1), "is a32");                       --keep with a32
                OX(2) := add(DE.STEMS(2), "is");
                OX(3) := add(DE.STEMS(2), "e POS");
              elsif DE.PART.ADJ.DECL.VAR = 3  then
                OX(1) := add(DE.STEMS(1), " a33");
                OX(2) := add(DE.STEMS(2), "is");
                OX(3) := add(DE.STEMS(2), "e POS");
              elsif DE.PART.ADJ.DECL.VAR = 6  then
                OX(1) := add(DE.STEMS(1), " a+36");
                OX(2) := add(NULL_OX, "(gen.)");
                OX(3) := add(DE.STEMS(2), "os");
              end if;

            elsif DE.PART.ADJ.DECL = (9, 8)  then           --OX2
              OX(1) := add(DE.STEMS(1), ". xA+98");           --abbreviations
              OX(2) := add(NULL_OX, "abb.");

            elsif DE.PART.ADJ.DECL = (9, 9)  then
              OX(1) := add(DE.STEMS(1), " a+99");
              OX(2) := add(NULL_OX, "undeclined");

            else
              raise NOT_FOUND;
            end if;      

          elsif DE.PART.ADJ.CO = X    then                   --OX4   normal. X means positive, comp and super together
            if DE.PART.ADJ.DECL.WHICH = 1  then            --1st/2nd decl
              if DE.PART.ADJ.DECL.VAR = 1  then
                OX(1) := add(DE.STEMS(1), "us a11");
                OX(2) := add(DE.STEMS(2), "a-um");         --"a -um"
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
              elsif DE.PART.ADJ.DECL.VAR = 2  then
                OX(1) := add(DE.STEMS(1), " a12");
                OX(2) := add(DE.STEMS(2), "a-um");
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
              end if;
            elsif DE.PART.ADJ.DECL.WHICH = 3  then         --3rd decl
              if DE.PART.ADJ.DECL.VAR = 1  then
                OX(1) := add(DE.STEMS(1), " a31");
                OX(2) := add(DE.STEMS(2), "is_(gen.)");
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
              elsif DE.PART.ADJ.DECL.VAR = 2  then
                OX(1) := add(DE.STEMS(1), "is a32");
                OX(2) := add(DE.STEMS(2), "e");
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
              elsif DE.PART.ADJ.DECL.VAR = 3  then
                OX(1) := add(DE.STEMS(1), " a33");
                OX(2) := add(DE.STEMS(2), "is_-e");
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
              end if;
            elsif DE.PART.ADJ.DECL.WHICH = 9  then         --none of these exist
                OX(1) := add(DE.STEMS(1), " ACOX9");
                OX(2) := add(NULL_OX, "undeclined");
                OX(3) := add(DE.STEMS(3), "or-or-us");
                OX(4) := add(DE.STEMS(4), "mus-a-um");
            else
              raise NOT_FOUND;
            end if;
          else
            raise NOT_FOUND;
          end if;

        elsif (DE.PART.POFS = ADV) and then (DE.PART.ADV.CO = X) then --species @ xxx
           OX(1) := add(DE.STEMS(1), " @");   --POS
           OX(2) := add(DE.STEMS(2), "");        --COMP
           OX(3) := add(DE.STEMS(3), "");        --SUPER

        elsif DE.PART.POFS = V    then                           --V  species v
          --if DE.PART.V.KIND = DEP  then                          -- DEP
          --elsif DE.PART.V.KIND = PERFDEF  then                   -- PERFDEF
          --elsif DE.PART.V.KIND = IMPERS  and then
          --elsif DE.PART.V.KIND = IMPERS  then                     -- IMPERS otherwise
          --else                                                 -- normal KIND

          --if DE.PART.V.KIND = ...
          --if DEP PERFDEF or IMPERS some inflections are hypothetical
            --  OX 1 lemma 1st person singular
            if DE.PART.V.CON.WHICH = 2  then                   --   2
                OX(1) := add(DE.STEMS(1), "eo v2");
              elsif DE.PART.V.CON.WHICH = 5  then                -- 5
                OX(1) := add(DE.STEMS(1), "um v5");
              elsif DE.PART.V.CON = (7, 2)  then                 -- 7 2
                OX(1) := add(DE.STEMS(1), "am v72");
              else                                               -- 1 or
                OX(1) := add(DE.STEMS(1), "o v");                -- 3 or
              end if;                                            -- 7 1
            --end if;
                                                                 -- (not DEP or PERFDEF)
            --  OX 2 infinitive
            if DE.PART.V.CON.WHICH = 1  then                     -- 1 
              OX(2) := add(DE.STEMS(2), "are");
            elsif DE.PART.V.CON.WHICH = 2  then                  -- 2
              OX(2) := add(DE.STEMS(2), "ere");
            elsif DE.PART.V.CON.WHICH = 3  then                  -- 3
              if DE.PART.V.CON.VAR = 2  then                     -- 3 2
                OX(2) := add(DE.STEMS(2), "re");
              elsif DE.PART.V.CON.VAR = 3  then                  -- 3 3
                OX(2) := add(DE.STEMS(2), "eri");
              elsif DE.PART.V.CON.VAR = 4  then                  -- 3 4
                OX(2) := add(DE.STEMS(2), "ire");
              else                                               -- 3 ...
                OX(2) := add(DE.STEMS(2), "ere");
              end if;
            elsif DE.PART.V.CON.WHICH = 5  then                  -- 5
              if DE.PART.V.CON.VAR = 1  then
                OX(2) := add(DE.STEMS(2), "esse");
              elsif DE.PART.V.CON.VAR = 2  then
                OX(2) := add(DE.STEMS(1), "e");  --  tricky, but it is 1
              end if;
            elsif DE.PART.V.CON.WHICH = 6  then                  -- 6
              if DE.PART.V.CON.VAR = 1  then
                OX(2) := add(DE.STEMS(2), "re");
              elsif DE.PART.V.CON.VAR = 2  then
                OX(2) := add(DE.STEMS(2), "le");
              end if;
            elsif DE.PART.V.CON.WHICH = 7  then                  -- 7
              if DE.PART.V.CON.VAR = 3  then                     -- 7 3
                OX(2) := add(DE.STEMS(2), "se");
              else 
                OX(2) := add(DE.STEMS(2), "(INF)");
              end if;
            elsif DE.PART.V.CON.WHICH = 8  then                  -- 8
              if DE.PART.V.CON.VAR = 1  then
                OX(2) := add(DE.STEMS(2), "are");
              elsif DE.PART.V.CON.VAR = 2  then
                OX(2) := add(DE.STEMS(2), "ere");
              elsif DE.PART.V.CON.VAR = 3  then
                OX(2) := add(DE.STEMS(2), "ere");
              elsif DE.PART.V.CON.VAR = 4  then
                OX(2) := add(DE.STEMS(2), "ire");
              else
                OX(2) := add(DE.STEMS(2), "ere");
              end if;
            elsif DE.PART.V.CON = (9, 8)  then
              OX(1) := add(DE.STEMS(1), ".");
              OX(2) := add(NULL_OX, "abb.");
            elsif DE.PART.V.CON = (9, 9)  then
              OX(1) := add(DE.STEMS(1), " v99");
              OX(2) := add(NULL_OX, "undeclined");
            end if;

            --  OX 3 & 4
            --if DE.PART.V.KIND = IMPERS  then
            --elsif DE.PART.V.KIND  = SEMIDEP  then    --  Finalization correction
            if DE.PART.V.CON = (5, 1)  then
              OX(3) := add(DE.STEMS(3), "i");
              OX(4) := add(DE.STEMS(4), "urus");
            elsif DE.PART.V.CON.WHICH = 8  then
              OX(3) := add("", "NBadditional");        --NB to filter out
              OX(4) := add("", "forms");
            elsif DE.PART.V.CON.WHICH = 9  then
              OX(3) := add(NULL_OX, "BLANK");  --  Flag for later use
              OX(4) := add(NULL_OX, "BLANK");  --  Flag for later use
            else
              OX(3) := add(DE.STEMS(3), "i");
              OX(4) := add(DE.STEMS(4), "us");
            end if;

          --end if;                                                --  On V KIND

          --regardless of KIND
          if DE.PART.V.CON = (6, 1)  then      --  Finalization correction
            OX(3) := add(OX(3), "(ii)");
          end if;
            
        elsif (DE.PART.POFS = NUM) and then (DE.PART.NUM.SORT = X)  then   --xxx
          if DE.PART.NUM.DECL.WHICH = 1  then
            if DE.PART.NUM.DECL.VAR = 1  then
              OX(1) := add(DE.STEMS(1), "us cX11 a-um");
              OX(2) := add(DE.STEMS(2), "us-a-um");
              OX(3) := add(DE.STEMS(3), "i-ae-a");
              OX(4) := add(DE.STEMS(4), "");
            elsif DE.PART.NUM.DECL.VAR = 2  then
              OX(1) := add(DE.STEMS(1), "o cX12 ae-o");
              OX(2) := add(DE.STEMS(2), "us-a-um");
              OX(3) := add(DE.STEMS(3), "i-ae-a");
              OX(4) := add(DE.STEMS(4), "");
            elsif DE.PART.NUM.DECL.VAR = 3  then
              OX(1) := add(DE.STEMS(1), "es cX13 es-ia");
              OX(2) := add(DE.STEMS(2), "us-a-um");
              OX(3) := add(DE.STEMS(3), "i-ae-a");
              OX(4) := add(DE.STEMS(4), "");
            elsif DE.PART.NUM.DECL.VAR = 4  then
              OX(1) := add(DE.STEMS(1), "i cX14 ae-a");
              OX(2) := add(DE.STEMS(2), "us-a-um");
              OX(3) := add(DE.STEMS(3), "i-ae-a");
              OX(4) := add(DE.STEMS(4), "ie(n)s");
            end if;
          elsif DE.PART.NUM.DECL.WHICH = 2  then
            OX(1) := add(DE.STEMS(1), " cX2");           --septem
            OX(2) := add(DE.STEMS(2), "us-a-um");
            OX(3) := add(DE.STEMS(3), "i-ae-a");
            OX(4) := add(DE.STEMS(4), "ie(n)s");
          end if;

        elsif (DE.PART.POFS = NUM) and then (DE.PART.NUM.SORT = CARD)  then   --xxx
          if DE.PART.NUM.DECL.WHICH = 1  then
            if DE.PART.NUM.DECL.VAR = 1  then
              OX(1) := add(DE.STEMS(1), "us s");
              OX(2) := add(DE.STEMS(1), "a");
              OX(3) := add(DE.STEMS(1), "um");
            elsif DE.PART.NUM.DECL.VAR = 2  then
              OX(1) := add(DE.STEMS(1), "o s");
              OX(2) := add(DE.STEMS(1), "ae");
              OX(3) := add(DE.STEMS(1), "o");
            elsif DE.PART.NUM.DECL.VAR = 3  then
              OX(1) := add(DE.STEMS(1), "es s");
              OX(2) := add(DE.STEMS(1), "es");
              OX(3) := add(DE.STEMS(1), "ia");
            elsif DE.PART.NUM.DECL.VAR = 4  then
              OX(1) := add(DE.STEMS(1), "i s");
              OX(2) := add(DE.STEMS(1), "ae");
              OX(3) := add(DE.STEMS(1), "a");
            end if;
          elsif DE.PART.NUM.DECL.WHICH = 2  then
              OX(1) := add(DE.STEMS(1), " cCARD2");
          end if;

        elsif (DE.PART.POFS = NUM) and then (DE.PART.NUM.SORT = ORD)  then   --xxx
          OX(1) := add(DE.STEMS(1), "us cORD");
          OX(2) := add(DE.STEMS(1), "a");
          OX(3) := add(DE.STEMS(1), "um");

        elsif (DE.PART.POFS = NUM) and then (DE.PART.NUM.SORT = DIST)  then  --xxx
          OX(1) := add(DE.STEMS(1), "i cDIST");
          OX(2) := add(DE.STEMS(1), "ae");
          OX(3) := add(DE.STEMS(1), "a");

        else
          OX(1) := add(DE.STEMS(1), " cX");
        end if;     -- On PART
        --categories]
        
        --  Now clean up and output Several flags have been set which modify OX's

        if OX(1)(1..3) = "zzz"  then
          FORMadd_up(" -1 ");                   --trace -
        elsif OX(1) /= NULL_OX  then
          FORMadd_up(TRIM(OX(1)));
        end if;
        if OX(2)(1..3) = "zzz"  then
          FORMadd_up(", -2 ");
        elsif OX(2) /= NULL_OX  then
          FORMadd_up(", " & TRIM(OX(2)));
        end if;
        if OX(3)(1..9) = "zzzis POS"  then       -- ad hoc case
          FORMadd_up(", -3  POS");
        elsif OX(3)(1..3) = "zzz"  then       -- -3 followed by -4 causes problem in case vIMPERS,
          FORMadd_up(", -3 ");
        elsif OX(3)(1..3) = "DEP"  then
          null;
        elsif OX(3)(1..7) = "PERFDEF"  then
          null;
        elsif OX(3)(1..5) = "BLANK"  then
          null;
        elsif OX(3) /= NULL_OX  then
          FORMadd_up(", " & TRIM(OX(3)));
        end if;
        if OX(4)(1..3) = "zzz"  then
          FORMadd_up(", -4 ");
        elsif OX(4)(1..5) = "BLANK"  then
          null;
        elsif OX(4) /= NULL_OX  then
          FORMadd_up(", " & TRIM(OX(4)));
        end if;
 
        FORMadd_to(" pos: " & PART_OF_SPEECH_TYPE'IMAGE(DE.PART.POFS)& " ");

        if DE.PART.POFS = N  then
          if DE.PART.N.DECL.WHICH in 1..5 and
             DE.PART.N.DECL.VAR  in 1..5 then
               FORMadd_to(" decl: " & ordinal(DE.PART.N.DECL.WHICH) & " ");
          else FORMadd_to(" decl: Gk");
           end if;         
          FORMadd_to(" gen: " & GENDER_TYPE'IMAGE(DE.PART.N.GENDER) & " ");
          FORMadd_to(" kind: " & NOUN_KIND_TYPE'IMAGE(DE.PART.N.KIND) & " ");
        end if;

        if (DE.PART.POFS = V)  then 
          if DE.PART.V.CON.WHICH in 1..3 then   --normal conjugations, incl 4th
            if DE.PART.V.CON.VAR = 1 then
              FORMadd_to(" con: " & ordinal(DE.PART.V.CON.WHICH) & " var: nor ");
            elsif  DE.PART.V.CON = (3, 4) then   --(CON.WHICH, CON.VAR)
              FORMadd_to(" con: 4 var: nor ");  --looks like 4th conjugation but W treats it as variant of 3rd
            else  --var: not 1
              FORMadd_to(" con: " & ordinal(DE.PART.V.CON.WHICH) & " var: nor ");  --W omitted default case
            end if;
          else  --strange conjugations
            FORMadd_to(" con: " & ordinal(DE.PART.V.CON.WHICH) & " var: " & ordinal(DE.PART.V.CON.VAR) & " "); --also omitted
          end if;         
          
          if  (DE.PART.V.KIND in GEN..PERFDEF)  then
            FORMadd_to(" kind: " & VERB_KIND_TYPE'IMAGE(DE.PART.V.KIND)(1..3) &" ");
            --                       VERB_KIND_TYPE truncated to 3 chars ^
          else
            FORMadd_to(" kind: " & "nor" & " ");   --else lost field
          end if;
        end if;

        if DE.PART.POFS = ADJ  then
          if DE.PART.ADJ.DECL.WHICH in 1..5 and
             DE.PART.ADJ.DECL.VAR  in 1..5 then
               FORMadd_to(" var: " & ordinal(DE.PART.ADJ.DECL.VAR) & " ");
           end if;         
        end if;

      return TRIM(FORM);
      
    exception
      when NOT_FOUND  =>
        return "";
      when others     =>
        return "";
    end dictionary_form1;

   use Text_IO;
   use Dictionary_Entry_IO;
   use Part_Entry_IO;
   use Age_Type_IO;
   use Area_Type_IO;
   use Geo_Type_IO;
   use Frequency_Type_IO;
   use Source_Type_IO;

   Start_Stem_1  : constant := 1;
   Start_Stem_2  : constant := Start_Stem_1 + Max_Stem_Size + 1;   -- + 18 + 1
   Start_Stem_3  : constant := Start_Stem_2 + Max_Stem_Size + 1;
   Start_Stem_4  : constant := Start_Stem_3 + Max_Stem_Size + 1;
   Start_Part    : constant := Start_Stem_4 + Max_Stem_Size + 1;

   Input, Output : Text_IO.File_Type;
   De : Dictionary_Entry;

   S : String (1 .. 400) := (others => ' ');
   Blank_Line : constant String (1 .. 400) := (others => ' ');
   L, Last : Integer := 0;
   J : constant Integer := 1;

begin
   Put_Line ("DICTLINE.IN -> DICTPAGE.OUT");
   Create (Output, Out_File, "DICTPAGE.OUT");
   Open (Input, In_File, "DICTLINE.IN");

   Over_Lines :
   while not End_Of_File (Input) loop
      S := Blank_Line;
      Get_Line (Input, S, Last);               -- length 185 into 400
      if Trim (S (1 .. Last)) /= ""  then   --  Rejecting blank lines
         Form_De :
         begin
            --number of stems depends on pofs
            De.Stems (1) := S (Start_Stem_1 .. Max_Stem_Size);
            De.Stems (2) := S (Start_Stem_2 .. Start_Stem_2 + Max_Stem_Size - 1);
            De.Stems (3) := S (Start_Stem_3 .. Start_Stem_3 + Max_Stem_Size - 1);
            De.Stems (4) := S (Start_Stem_4 .. Start_Stem_4 + Max_Stem_Size - 1);

            Get (S (Start_Part .. Last), De.Part, L);
            Get (S (L + 1 .. Last), De.Tran.Age, L);
            Get (S (L + 1 .. Last), De.Tran.Area, L);
            Get (S (L + 1 .. Last), De.Tran.Geo, L);
            Get (S (L + 1 .. Last), De.Tran.Freq, L);
            Get (S (L + 1 .. Last), De.Tran.Source, L);
            De.Mean := Head (S (L + 2 .. Last), MAX_MEANING_SIZE);  -- 74 into 90. junk at end
            --De.Mean := TRIM (De.Mean);   ??
         end Form_De;

         Put (Output, dictionary_form1 (De));

         put (Output, " ");
         Age_Type_IO.Put (Output, De.Tran.Age);      --looks like it simply prints the enum
         Area_Type_IO.Put (Output, De.Tran.Area);
         Geo_Type_IO.Put (Output, De.Tran.Geo);
         Frequency_Type_IO.Put (Output, De.Tran.Freq);
         Source_Type_IO.Put (Output, De.Tran.Source);
         put (Output, " ");

         Put_Line (Output, De.Mean);

      end if;
   end loop Over_Lines;

   Close (Output);
exception
   when Text_IO.Data_Error  =>
      null;
   when others =>
      Put_Line (S (1 .. Last));
      Ada.Integer_Text_IO.Put (J); New_Line;
      Close (Output);

end Dictpage1;
