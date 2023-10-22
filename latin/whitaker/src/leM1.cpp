#include <iostream>
#include <fstream>
#include <string>
using namespace std;

//format of eng.txt entries
//lemma-species (14 spaces) codes $meaning;

//lexid.txt eng.txt -> lexid.txt.out eng.txt.out

//cases of distinct meaning, missed in dM1.cpp/dictpage.txt due to having
//different parts entries

ifstream ifs("lexid.txt"); //files are paired, this one may have blank lines
ifstream eng("eng.txt");

ofstream ofs("lexid.txt.out");
ofstream engout("eng.txt.out");

string key, key_fa; //key, blanked key
string lexid, c_lexid;
string p_key, p_key_fa; //previous key
string val;
string p_val; //previous value
string c_val; //accumulating value
string codes, c_codes;
string kind;
string kac;

void input()  //key
{
  key_fa= key;
  lexid= key_fa.substr(0, key_fa.find(' '));
  const int length= key_fa.length();
  codes= key_fa.substr(length -5, 5);
  key_fa[length -5]= 'Z';  //all XXXXX characters hidden
  key_fa[length -4]= 'Z';
  key_fa[length -3]= 'Z';
  key_fa[length -2]= 'Z';
  key_fa[length -1]= 'Z';
  if (key_fa[key_fa.find('-') +1] =='s') {        //ie lemma-species
    key_fa[length -7]= 'Z'; //kind char removed   //         ^s
    kind= key_fa.substr(length -7, 1);
  }
  else if (key_fa[key_fa.find('-') +1] =='v') {   //         ^v
    kind= key_fa.substr(length -9, 3);
    key_fa[length -7]= 'Z'; //kind chars removed
    key_fa[length -8]= 'Z';
    key_fa[length -9]= 'Z';
  }
  else if (key_fa[key_fa.find('-') +1] =='a') {   //         ^a
    kind= key_fa.substr(length -9, 3);
    key_fa[length -7]= 'Z';
    key_fa[length -8]= 'Z';
    key_fa[length -9]= 'Z';

    key_fa[length -17]= 'Z';  //var char blanked
  }
  else kind= "";
  kac= string ("(") +kind +" " +codes +string(")");
}

void input_val()
{
  int spaces= val.find("              ");
  string val_key= val.substr(0, spaces);
  string val_codes= val.substr(spaces +14, 5);
  val= val.substr(spaces +20);
}

void routineP()
{
	while (true) {
    getline (ifs, key);
    if (key =="") {if (ifs.eof()) return; ofs <<endl; continue;}
    if (key[0] =='#')  {ofs <<key <<endl; continue;}
    break;
  }
  input();
  getline (eng, val);
  input_val();

  p_key= key;                     //initiate
  p_key_fa= key_fa;
  p_val= val;
  c_val= val;
  c_codes= codes;
  c_lexid= lexid;

	while (true) {
		getline (ifs, key);
    if (key =="") { if (ifs.eof()) break; ofs <<endl; continue; }
    if (key[0] =='#') { ofs <<key <<endl; continue; }
    input();
    getline (eng, val);    //val includes key- kval: vval
    string vval= val.substr(val.find("$"));
    string kval= val.substr(0, val.find("$"));
    input_val();

    //join definitions with markers (#)
    if (val ==p_val) {            //same values
      if (key ==p_key)                 //same key therefore same lexeme, parts were different 
                      ;                     //discard
      else if (key_fa ==p_key_fa)      //similar key, same lexeme
        c_val= c_val +" #le also " +kac +" $...;";                  //accumulate the case
      else {                           //keys are completely different
        ofs <<p_key <<endl;                 //finalise.
        engout <<c_lexid <<" " <<c_codes <<" " <<c_val <<endl;
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        p_val= val;
        c_val= val;
        c_codes= codes;
        c_lexid= lexid;
      }
    }
    else if (vval[1] =='|') {      //continuation, combine values
      if (key ==p_key)                   //same key
        c_val= c_val +vval;                    //accumulate
      else if (key_fa ==p_key_fa) {      //similar key
        c_val= c_val +" " +kac +vval;                    //accumulate
      }
      else {            //should not happen
        ofs <<p_key <<endl;                 //finalise.
        engout <<c_lexid <<" " <<c_codes <<" " <<"#le? " <<c_val <<endl;
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        p_val= val;
        c_val= val;
        c_codes= codes;
        c_lexid= lexid;
      }
    }
    else {                        //different values
      if (key ==p_key) {
          ofs <<p_key <<endl;     //finalise.
          engout <<c_lexid <<" " <<c_codes <<" " <<c_val <<" #leD0" <<endl;
          //
          p_key= key;                         //initiate
          p_key_fa= key_fa;
          p_val= val;
          c_val= val +" #leD1" ;
          c_codes= codes;
          c_lexid= lexid;
      }
      else if (key_fa ==p_key_fa) {    //similar key -possibly distinct lexeme
        c_val= c_val +" #leR "                 //accumulate. R-review
                               +kac +" " +val.substr(val.find("$"));
        //p_key= key;                         //initiate, keep first key
        p_val= val;
      }
      else {                           //keys are completely different            
        ofs <<p_key <<endl;                 //finalise.
        engout <<c_lexid <<" " <<c_codes <<" " <<c_val <<endl;
        //
        p_key= key;                         //initiate
        p_key_fa= key_fa;
        p_val= val;
        c_val= val;
        c_codes= codes;
        c_lexid= lexid;
      }
    }
	}
  ofs <<p_key <<endl;  //finalise.
  engout <<c_lexid <<" " <<c_codes <<" " <<c_val <<endl;
}

int main()
{
  routineP();
  return 0;
}
