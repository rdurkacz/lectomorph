# Reforming Whitaker's lexicon

Whitaker's lexicon is the file DICTLINE.GEN in his Words project. The project can be found in several places on the web, notably https://github.com/dsanson/Words and http://mk270.github.io/whitakers-words . There are projects around to modernise Whitaker, case in point being https://github.com/cqb13/vocab-vault . There is some discussion among the players at https://www.reddit.com/r/latin/comments/168pnbc/whitakers_words_and_comparable_projects/ . The object here and now is to modernise the lexicon so that it can be used outside of Whitaker's program (only the English translations - to salvage the grammatical, ie inflectional, data is a bigger challenge.) The first step is to get hold of a list of lexemes.

## List of lexemes.

From a lexicon it should be expected that one could extract a list of lexemes. Conversely a lexicon must be built upon a list of lexemes.

There are two facts to contend with in constructing a list - that any lexeme may exist in several versions and any lexeme, or version of a lexeme for that matter, may have a range of meanings.

It is necessary to have names to identify the lexemes. The starting point is the lemma (except if an arbitrary record number is used). Lemmas are agreed on widely but have the issue that they are not always unique - there are cases of homonyms. The usual response is to append a number, 2, 3 etc. The number need only be appended in the case of non-uniqueness, so it is enough to start with 2. Alternatively, when a homonym is first discovered, one could go back to the first case and rename the identifier by adding 1 to the lemma.

The disadvantage of this method is arbitrariness. Two authorities will not naturally come up with the same identifier for each lexeme and communication between them is impaired.

A natural response is to let the identifier be constructed by appending to the lemma an indicator of the category to which the lexeme belongs. Lila (https://lila-erc.eu/) uses the term 'flectional category' and each lexeme belongs to one category. For instance the category of amo is v1r, meaning first conjugation verb (I do not know what r signifies). Therefore, let the identifier for amo be amo-v1r. Once a list of categories is adopted there is generally agreement between authorities as to how lexemes are categorised.

Even with this method there are cases of non-uniqueness but they are not common. From Whitaker an example is salio, a fourth conjugation verb meaning to jump as one lexeme and to salt as another. Also sero of the third conjugation. Then, but only in such cases, would one resort to an arbitrary distinction in the identifier, eg perhaps salio-v4-1 and salio-v4-2.

## Versions

Whitaker recognises explicitly that lexemes may exist in multiple versions. He is forced into this by giving codes for each entry as to the era, source etc for each entry. Therefore there can be and are multiple entries for each lexeme. From one to another details may change. It is a challenge with Whitaker's lexicon to bring it back to tidy form, so as to know which are the lexemes and which are the variations. Note that there may be alternate forms for the lemma in which case there will be various lexeme identifier candidates for what is arguably the same lexeme.

## Schema

Whitaker's lexicon has its own peculiarities but sticking to what is typical or desirable in any lexicon we can say it has the following structure.

It has no unique index but the primary key field is the lemma. It is more correct to say in the case of Whitaker, and more logical, to use the stem, but practice favours the lemma. Additional to the lemma each entry belongs to a category of part of speech or a nrrower subdivision - if a verb then the category includes the conjugation.
Then there is a version code for each entry. A version code might in effect amount to being the general and only case or it might be a fine-grained combination of conditions, one of several versions of the lexeme.
In addition to the version field there is a kind field for eg verbs. The kind can be transitive, intransitive, deponent etc.

An improved schema is needed. Lemma, category together should be the primary key and there should be a unique key based on that. We work through Whitaker's lexicon, firstly to supply the actual lemma and category according to our plan of the categories and then classify and combine entries so as to have one entry per lexeme.

To begin with, where there are multiple entries for a given primary key, it needs to be determined if it is a case of hononymy where distinct lexemes happen to have the same lemma and belong to the same category. In this case the identifier is modified to distinguish the cases. More often than that the differing entries correspond to different usages of what would be judged to be the same lexeme.

Once it can be assumed that the keys are unambiguous, both grammatical and semantic information can be stored and accessed against the keys. 
The grammatical information is about inflections, ie the principal parts or equivalent data. The semantic information is the meaning in the working language and this has its own structure. The structure is expressed in text and the text can be hundreds of characters where there is a range of meanings and senses attached to the lexeme. 

The connection between key and value may be qualified by a 'kind' attribute or by a version code. In the simpler case the lexeme itself is governed by a kind or a version. Whitaker gives a version code for every lexeme or codes specialised to eech of its property values. The kind applies to different to the various parts of speech and has either grammatical or semantic meaning.

The components in the data are in summary as follows-

```
key
  lemma-category (plus occasional disambiguating element)

value
  parts
  meaning

qualifications
  version code
  kind
```

**Alternate forms.** A lexeme may have alternate forms, either alternate principal parts or an alternate stem leading to an alternate lemma therefore an alternate key. There should be signposts so that all alternates can be returned that apply to a given lexeme. Whitaker's lexicon is crude in this regard. Alternate forms are listed as if distinct lexemes with the meaning field reproduced identically. With the meaning field being reproduced we can work backword and infer alternate forms.

Whereas these notes are not derived from the Lila project, that project would appear to satisfy our objectives. We will aim for compatibility with Lila. 

The present work goes toward converting the Whitaker lexicon into the form described. The conversion is done repeatably by a scripted process, such that the process can be audited, reviewed and modified indefinitely. The software is of course ad hoc, in no way is it any better than it needs to be, since it should fall out of use as soon as its one and only job is done satisfactorily.

It amounts to either combining two or more definitions against a single lexeme into one, taking account of the qualifiers, or deciding that the entries should remain distinct being cases of homonymy. In fact there are few such cases where two lexemes have not only the same lemma but the same category yet appear to unrelated. More often than that there is a temptation to leave widely different meanings as distinct meanings as separate lexemes though they are likely to have a historic relation.

The classification is automated based on unreliable heuristics, and therefore is set up for manual review. The decision becomes supplementary information to be added to Whitaker's data file. These addditions together with any other editorial changes thought necessary can be reviewed by comparing the original file.

The logical objective is to replace Whitaker's file (DICTLINE.GEN) with a more developed body of data, bound to consist of multiple files. This work is organised into two stages. Stage 1 is a human readable recompilation where the various versions of each lexeme are combined in a compact way suitable for a readable dictionary entry.

Stage 2 goes further with data processing. The assumption here is that a user should filter the data according to the version information suitable for a particular application. That effectively removes the version field and with that allternative forms can be inferred.

## Stage 1 representation of Whitaker lexicon.

The Stage 1 representation is split into two files lexid.txt and eng.txt. It is a simple split as the two files can be lined up line by line. eng.txt contains the variable length meaning field.

The grammatical parts information has not been recovered and of course it should be eventually recovered. There would be a lot to do in reorganising this information and settling on a suitable structure.

Some categories of Greek words have been dropped as being more trouble than they are worth (in a Latin lexicon).

We have not recovered alternate forms. Alternate forms appear either as if distinct lexemes or if the lemma is unaffected do not appear at all.

Thus what is retained the list of lexemes from Whitaker (with exclusions as noted) and the meanings in English. The lexemes are listed in the file **lexid.txt**. This file has as primary key lemma-category. In 35,000 entries there are only a few dozen cases of duplicate keys. These can be extracted by sorting -see the file lexid.uniq.txt. Against the key is listed the qualifiers, the version code and kind. On this subject see also below. As appropriate to the part of speech the conjugation or declension number and gender is given though these are also factored into the category. 

The English meanings are in a separate file **eng.txt** indexed the same way and in the same order with the same number of records (blank lines etc omitted). Frequently the record is a combination of original records with the versions carried over. For traceability a # sign and a clue of a few characters are inserted in the join.

From the careful of ordering of Whitaker's original file, it is a reasonable assumption that the first item in a combined entry is the most general. Therefore for the second and subsequent entries, but not the first, the qualifiers are treated as applying to the meaning and not the entry as a whole, and so are carried over into the combined meaning record.

### Examples from lexid.txt and eng.txt

lexid.txt
```
salio-v4 con: 4 var: normal kind: TRA XXXDO
interpretation: salio is a fourth conjugation verb, of "nor-mal" kind with version code XXXDO. (The var field is of no interest, should be removed.) It is a TRAnsitive verb.
```

eng.txt:
```
salio-v4              $salt, salt down, preserve with salt; sprinkle before sacrifice; #leR (nor XXXBS) $leap, jump; move suddenly/spasmodically (part of body under stress), twitch;$|spurt, discharge, be ejected under force (water/fluid); mount/cover (by stud); #le also (nor XXXBO) $...;
```

interpretation: The description is a combination of four (even five) original entries (each begininning with $). First mentioned, to salt, we are asked to review (#leR) with the second, to leap ..., as to whether it is been correctly classified as one lexeme rather than two. (It is surely two.) The second line is joined to a third, spurt..., which begins with |. The | character is from Whitaker's file and it indicates that the line is a continuation of the previous line. The last part, "also (nor XXXBO)" means that the preceding line was duplicated by another line which had the qualifiers XXXBO.

The original lines for salio, after a little processing, are best seen in DICTPAGE.OUT. The fact that salio, to salt, ends up as the main choice over salio, to leap, is not the best and it is a result simply of it being listed first by Whitaker. As a result of review, some kind of editing of the original file would be appropriate. Any author would treat the two senses of salio as distinct lexemes, but if not then the leap sense should be preferred as the leading one.

After editing, and removing the temporary signs the result would be-

```
salio-v4-1 con: 4 kind: nor XXXBS
salio-v4-1 leap, jump; move suddenly/spasmodically (part of body under stress), twitch; spurt, discharge, be ejected under force (water/fluid); mount/cover (by stud); also (nor XXXBO) ...;

salio-v4-2 con: 4 kind: TRA XXXDO
salio-v4-2 salt, salt down, preserve with salt; sprinkle before sacrifice;
```

Whitaker gives the kind of salio to leap as nor-mal whereas INTransitive might have been expected. The differences in the version codes is B is a more frequently seen word than D, and the S entries are from Lewis and Short whereas the O's are from Oxford.

In lexid.uniq.txt are collected the few lexeme keys that appeared to the heuristics to require disambiguation forms to be invented. In review.txt are listed the entries from lexid.txt that were flagged for review and remain after I dismissed the majority of the 250 originally found.

## Symbols for word categories

Following symbols are used in constructing the category part of the lexeme keys. They are not the same as LILA uses but similar. Some may seem eccentric.

```
  s noun           s (substantive), to leave n for neuter
  v verb
  a adj
  @ adverb
  & conjunction
  e preposition    pr_e_
  , particle 
  o pronoun        pr_o_
  ! interjection

Gender
  M F N

Kind
  nor  "normal" or no information 
  TRA  transitive
  INT  intransitive
  DEP  deponent
  P    person
  T    thing
  etc, see Whitaker
```

### Conversion scripts
The scripts etc that were used in converting Whitaker's lexicon can be found in src/ directory. The value of them is to rerun the entire conversion process when defects are found in the present results, as will happen as soon as I or anyone else attempts to make serious use of them. The ada files cannot be compiled alone since they link into Whitaker's ada files. I will cooperate if anyone wants to carry on with these scripts.

Convert.py goes a step further to produce csv files.

## Stage 2 representation of Whitaker lexicon.

In stage 2 we recover alternate forms. Since Whitaker did not present alternate forms at all this is progress beyond what W did. It relies on the inference of an alternate form being present where the English meaning is the same. This would fail in the case of exact synonyms. In practice it is more likely to fail in the other direction where a trivial change in the meaning field has occurred for no important reason.

In stage 2 the first thing to do is to eliminate the version information by filtering the database for whatever combination of versions is appropriate to some particular application. This filtering exercise is applied to the database files lexid.txt and eng.txt but instead of combining version information as described in stage 1. Therefore those files are starting points for stage 2 but are different in detail to the stage 1 endpoints.

In stage 2 there is some combining of meaning fields but only n the case where meaning field was too long for a single record.

The schema is as follows-

```
lexid map (many to one, file lexidmap.txt)
  key
    lexid (lemma-category)
  value
    principal lexid

def map (one to one, file defmap.txt)
  key
    principal lexid (lemma-category)
  value
    definition text
```

### Examples from lexidmap.txt and defmap.txt

The files were generated to be appropriate for Caesar's De Bello Gallico, classical or earlier age and any regional terms excluded except from Gaul.

From lexidmap, the verb afficio-v3 is redirected to adficio-v3. The mapping is indexed on the left-hand element. adficio-v3 does not occur as an index so it will not be found and is not redirected.

lexidmap.txt: afficio-v3 adficio-v3

The definition for adficio and any alternate forms is lested in defmap.txt.
defmap.txt: adficio-v3 $affect, make impression; move, influence; cause (hurt/death), afflict, weaken;
