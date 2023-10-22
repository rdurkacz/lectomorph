if false;
then
  echo false

gnatmake dictpage1
awk '{print substr($0, 0, 110) "$" substr($0, 111);}' <DICTLINE.GEN >dictline.txt #insert $ marker
fi

mv DICTPAGE.OUT DICTPAGE.OUT.prev
dictpage1 # <DICTLINE.IN (link to dictline.txt) >DICTPAGE.OUT

mv dictpage.txt dictpage.txt.prev
awk '{caseno= $2; $2= ""; print caseno, $0}' <DICTPAGE.OUT |grep -v '^\$' |grep -v '^-' \
  |grep -v NBadditional >dictpage.txt
dos2unix dictpage.txt
cp dictpage.txt dictpage.txt.pre

experiment/dE <dictpage.txt |experiment/dM1 >temp        #combine english definitions
mv temp dictpage.txt

rm -r dp.prev; mv dp dp.prev; mkdir dp
awk '{file= "dp/" $1; $1= ""; print >> file}' <dictpage.txt

mv lexid.txt lexid.txt.prev
mv eng.txt eng.txt.prev

#produce lexeme list split into lexeme fields and eng definition field
#move lexid.txt 3rd field XXXXX to last place

rm -f lexid.txt
echo "## verbs v conjugation (1 2 3 4)" >>lexid.txt
for f in dp/v, dp/v2, dp/v5, dp/v72,
do
  echo "#$f"
  #                       con 1        var    1     kind    DEP  XXXXX
  awk '{print $1 "-v" $8, "con: " $8, "var: " $10, "kind: " $12, $13; 
        print $1 "-v" $8, $13, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#for f in dp/v99   Aramaic

echo "## nouns n declension (1 2 3 4 5) gender (m f n)" >>lexid.txt
#kind should be treated as part of eng def
#s24 and s21 should be same category, also s22 and s24n
for f in dp/s* #not N98, N99, N17, N18, N26, N27, N28, N29
do
  echo "#$f"                 decl:   gen:    kind:    XXXXX
  awk '{print $1 "-s" $6 $8, $5, $6, $7, $8, $9, $10, $11;
        print $1 "-s" $6 $8, "A B", $11, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

echo "## prepositions e case(Acc Gen Dat aBl)" >>lexid.txt
echo "#e" >>lexid.txt
awk '{print $1 "-e" $5, $5, $6;
      print $1 "-e" $5, "A B C D E F G", $6, $0 >>"eng0.txt";  #7   was A
    }' <dp/e >>lexid.txt
echo >>lexid.txt


echo "## adjectives a declension (1 3)" >>lexid.txt
#OX3     m f n  -us -a -um    -er -ra -rum
for f in dp/a+1*                             # a+13 a+14 a+15  -> dp/a1*
do
  echo "#$f"
  #             DUMMY field inserted                     XXXXX
  awk '{print $1 "-a1", "decl: 1 var: " $8 " kind: POS", $9;
        print $1 "-a1", " A B C D", $9, $0 >>"eng0.txt";  # 4 + 10 = 14 preceding fields to lose
      }' <$f
  echo
done >>lexid.txt

#     m f n  -is -is -e
#for f in dp/a+3, dp/a+32, dp/a+33,   #now as dp/a31, 2, 3
#do
#  echo "#$f"
  #             DUMMY field inserted                     XXXXX
#  awk '{print $1 "-a3", "decl: 3 var: " $8 " kind: POS, $9";
#        print $1 "-a3", " A B C D", $0 >>"eng0.txt";
#      }' <$f
#  echo
#done >>lexid.txt

#     m f n  -is -is -e
for f in dp/a+36,
do
  echo "#$f"
  awk '{print $1 "-a3", "decl: 3 var: normal kind: POS", $6;
        print $1 "-a3", " A B C D E F G", $6, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#     m f n  -ior -ior -ius        decl may be immaterial
for f in dp/aCOMP,
do
  echo "#$f"
  awk '{print $1 "-a", "decl: ? var: normal kind: COMP", $6;
        print $1 "-a", " A B C D E F G", $6, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#     m f n  -us -a -um            decl may be immaterial
for f in dp/aSUPER, dp/a+2G,
do
  echo "#$f"
  awk '{print $1 "-a", "decl: ? var: normal kind: SUPER", $6;
        print $1 "-a", " A B C D E F G", $6, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#     m f n  unisex
for f in dp/a+23,
do
  echo "#$f"
  awk '{print $1 "-Ga", "decl: 0 var: normal kind: POS", $6;   #greek
        print $1 "-Ga", " A B C D E", $6, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#OX2
for f in dp/a+99,
do
  echo "#$f"
  awk '{print $1 "-a0", "decl: 0 var: normal kind: POS", $5;      #undeclined
        print $1 "-a0", " A B C D E F G H", $5, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

#OX4
for f in dp/a1*                         #includes former dp/a+11,
#m f n   -us -a -um  -er -ra -rum
do
  echo "#$f"
  awk ' $4 =="POS" {print $1 "-a1", "decl: 1 var: " $8 " kind: POS", $9;}
        $4 !="POS" {print $1 "-a1", "decl: 1 var: " $8 " kind: nor", $9;}
        {print $1 "-a1", " A B C D", $9, $0 >>"eng0.txt";}' <$f
  echo
done >>lexid.txt

for f in dp/a31,     dp/a32, dp/a33,             #including former a+31, 2, 3
#        -ens -entis  -is -e   -er -is -e
do
  echo "#$f"
  awk ' $4 =="POS" {print $1 "-a3", "decl: 3 var: " $8 " kind: POS", $9;}
        $4 !="POS" {print $1 "-a3", "decl: 3 var: " $8 " kind: nor", $9;}
        {print $1 "-a1", " A B C D", $9, $0 >>"eng0.txt";}' <$f
  echo
done >>lexid.txt

echo "##" numbers 9 >>lexid.txt
for f in dp/cX1*
do
  echo "#$f"
  awk '{print $1 "-9", $8;
        print $1 "-9", " A B C D E", $8, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

for f in dp/cX2,
do
  echo "#$f"
  awk '{print $1 "-9", $7;
        print $1 "-9", " A B C D E F", $7, $0 >>"eng0.txt";
      }' <$f
  echo
done >>lexid.txt

echo "##" pronouns o >>lexid.txt
for f in dp/o*
do
  echo "#$f"
  awk '{print $1 "-o", $6;
        print $1 "-o", "A", $6, $0 >>"eng1.txt";  #7
      }' <$f
  echo
done >>lexid.txt

#echo "##" adverbs @ >>lexid.txt
#for f in dp/@COX,     #adverbs now in @
#do
#  echo "#$f"
#  awk '{print $1 "-@", $6;
#        print $1 "-@", "A", $0 >>"eng1.txt";  # 7 -6
#      }' <$f
#  echo
#done >>lexid.txt

adv.sh
#for f in dp/@,  #adverbs, conjunctions, interjections, numbers

echo "#@adv" >>lexid.txt
awk '{print $1 "-@", $6;
      print $1 "-@", "A", $6, $0 >>"eng1.txt";
    }' <@adv >>lexid.txt
echo >>lexid.txt

echo "#@conj" >>lexid.txt
awk '{print $1 "-&", $6;
      print $1 "-&", "A", $6, $0 >>"eng1.txt";
    }' <@conj >>lexid.txt
echo >>lexid.txt

echo "#@interj" >>lexid.txt
awk '{print $1 "-!", $6;
      print $1 "-!", "A", $6, $0 >>"eng1.txt";
    }' <@interj >>lexid.txt
echo >>lexid.txt

echo "#@num" >>lexid.txt
awk '{print $1 "-9", $6;
      print $1 "-9", "A", $6, $0 >>"eng1.txt";
    }' <@num >>lexid.txt
echo >>lexid.txt

awk '{                   $2= ""; $3= ""; $4= ""; $5= ""; $6= ""; $7= ""; $8= ""; $9= "";
       $10= ""; $11= ""; $12= ""; $13= ""; $14= "";
       print;
}' <eng0.txt >eng.txt
rm eng0.txt

awk '{                   $2= ""; $3= ""; $4= ""; $5= ""; $6= ""; $7= ""; $8= "";
       print;
}' <eng1.txt >>eng.txt
rm eng1.txt

cp lexid.txt lexid.txt.0
cp eng.txt eng.txt.0
#need lexeme and eng fields together to find alternate parts cases
experiment/leM1  #lexid.txt eng.txt
mv lexid.txt.out lexid.txt
mv eng.txt.out eng.txt

mv lexid.uniq.txt lexid.uniq.txt.prev
#remove blank lines and comments
grep -v ^# lexid.txt | awk '{print $1}' |sort |uniq -c |sort -r >lexid.uniq.txt

exit
