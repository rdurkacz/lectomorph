//markers in value (english) field
//  $aaa |$bbb  # $ccc |$ddd
//       ^continuation
//              ^distinct meaning

// dictpage.txt -> dictpage.txt via stdin stdout

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

ifstream ifs("/dev/stdin");
ofstream ofs("/dev/stdout");

string line;

string c_val; //current accumulating value
string p_key, p_key_fa; //previous key

string val;
string key; string key_fa;
string kind, codes, kac;

void input()  //line
{
  const int index= line.find("$");
  key= line.substr(0, index);
  key_fa= key;
  codes= key_fa.substr(index -6, 5);
    key_fa[index -6]= 'Z'; //age char removed
    key_fa[index -5]= 'Z'; //area char removed
    key_fa[index -4]= 'Z'; //geo char
    key_fa[index -3]= 'Z'; //key with frequency char removed
    key_fa[index -2]= 'Z'; //source char removed
  val= line.substr(index);
  //
  if (line[0] =='s') {
    kind= key_fa.substr(index -8, 1);
    key_fa[index -8]= 'Z'; //kind char removed
  }
  else if (line[0] =='v') {
    kind= key.substr(index -10, 3);
    key_fa[index -8]= 'Z'; //kind chars removed
    key_fa[index -9]= 'Z';
    key_fa[index -10]= 'Z';
  }
  else kind= "";   
  kac= string ("(") +kind +" " +codes +string(")");
}

void routineM()  //distinct meanings
{
  while (true) {
    getline (ifs, line);
    if (line =="") ofs <<endl;
    break;
  }
  input(); //line

  p_key= key;                     //initiate
  p_key_fa= key_fa;
  c_val= val;

  while (true) {
    getline (ifs, line);
    if (line =="") {
      if (ifs.eof()) break; //finalise();
      ofs <<endl;
      continue;
    }
    input();

    //join definitions with markers (#)
    if (val ==c_val) {            //same values
      if (key ==p_key) {            
        c_val= "#S " +c_val;           // same key -strange
      }
      else if (key_fa ==p_key_fa) {    //similar key -same lexeme
                                            //accumulate
        c_val = c_val +" #dM also " +kac +";";
      }
      else {                           //keys are completely different
        cout <<p_key <<c_val <<endl;        //finalise.
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        c_val= val;
      }
    }
    else {                        //different values
      if (key ==p_key) {               //same key -distinct lexeme (maybe)
        cout <<p_key <<"#dD) " +c_val <<endl; //finalise.
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        c_val= "#dD1 " +val;
      }
      else if (key_fa ==p_key_fa)      //similar key -possibly distinct lexeme
        c_val= c_val +" #dR " +kac +" " +val;         //accumulate R-review
      else {                           //keys are completely different
        cout <<p_key <<c_val <<endl;        //finalise
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        c_val= val;
      }
    }
  }

  cout <<p_key <<c_val <<endl;  //finalise.
}

int main()
{
  setlocale(LC_CTYPE, "");

  routineM();
  //distinct meanings. key is the same (except XXXXX notes) but english differs.
 
  //alternate parts. define key as lemma and type fields.
  //find cases where the key is the same, and the definition the same, but parts differ
  return 0;
}
