# lectomorph
Lectomorphic translation aids for inflected languages

The project is a translation aid to assist early stage students of inflected foreign languages to read authentic texts. The intention is that a common model can be used for different languages. Here we have worked on Latin and Polish as target languages for students operating in English and French.

The work draws on available dictionary resources for each language, or pair of languages. 

In principle the necessary resources are, for each studied language, inflection analysis, word (lemma) lists and bilingual word to word (lemma to lemma) maps.

Inflection analysis is something that takes a written word and determines from its form, basically the ending of the form, a list of possibilities for the word as a combination of lemma and inflection. In principle the lemma might be hypothetical and in this case, as a separate step, its existence can be checked in the list of lemmas.

The lemma to lemma map is a bilingual dictionary, without needing the grammatical information that normal dictionaries have since by the time it is consulted the inflections are worked out.

Available resources may well combine some or all of these elements. In Polish we have used the SGJP grammatical which lists all possible Polish inflected forms and returns for each the inflection analyses and corresponding lemma (frequently more than one). The bilingual map in use has been extracted from Swan's lektorek.org Polish-English dictionary. For Latin, resources taken from Collatinus and Whitaker have been used.

Each time that a resource is harnessed there is attention required to convert it into a form usable by our framework. Because of that, the need of standard data formats is a salient aspect of this project.

Machine translation, or translation by 'artificial intelligence', of languages is by now very successful. This project has no relation to any of that and the translation aid works in a simple mechanical way that the user should understand. It does only the tedious work of dictionary lookup and case calculations. Intelligence is not something that the program is equipped with. It is required of the user.

A user must have a serious attitude to learning the principles of the foreign language and will have to work hard to extract the meaning even with the words analysed. Likewise the software while simple enough is not necessarily ovbious in how to use it. 

##Presentation

With databases prepared it is a simple enough matter to collect the analyses for a word in a foreign language text but we aim higher than that, so as to give the user something of the same benefit that he or she would have if accomplished in the foreign language. It is a matter of presentation. Whereas words in text could be looked as needed, if the user was in possession of the databases, the primary means of delivery is to process and annotate an entire text. The format of the annotations is in principle readable but in practice not so, and the annotationns are far more bulky than the basic text.

Since no well-known editor would be programmable to do this, editing facilities have been provided in javascript and embedded into an html file. The html files have no links and little in the way of menus and obvious controls. A text treated in this way presents like an e-book. The editing functions are controlled by mouse-selection and keyboard operations. These functions support displaying and editing the annotations which are hidden by default. The principle is that a user may select discrete, line-sized sequences of words for examination, perhaps several at one time and may selectively examine and select from the tree of possibilities for each word, this without leaving behind his or her view of the original document.

For examples, please consult any of the "usage" pdf documents accompanying the html files.

##The repository layout.
Although we are advocating an approach applicable to multiple languages, there are no common resources to be presented. The main resources are demonstration annotated text files. The content is split by the target foreign language, Polish and Latin. Within these divisions the the next division is into the operating languages, being English and also French.

In the Latin directory we have given for the sake of disclosure the processing of the Whitaker data files. If anyone wishes to reproduce or audit this work they may ask for further information or assistance, since while the data is there it is not in a buildable state.

Depending on interest there would be two modes of use for this work. One is to create a library of texts allowing students to use with no more than a browser. The second is to distribute the data, and the software that goes with it, so as to allow users to use as they please. There can be copyright issues in this case stemming from the dictionary resources if they are not freely licensed.

*lectomorphic is a made up word. It was invented to honour the resources used by the Polish-English application, Lekorek.org and Morfeusz which is associated with SGJP.
