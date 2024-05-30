<!--
SPDX-FileCopyrightText: 2021 Free Software Foundation Europe <https://fsfe.org>
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-3.0-DE
-->

# Translation guidelines

Below a few notes which we share with publishers who want to translate
the book in other languages, but we consider it also helpful for
community translations.

* Names: Ada, Zangemann, Alan must not to be changed. The other names
  are also mostly references to existing people in computer history or
  science, but if you want to change them in order to make it easier for
  children to relate to the characters we should find names which are
  still common but connected to important figures in the computer
  history. If you have problems with that, feel free to reach out to
  Matthias. Please also make sure to just exchange male names with male
  names, female names with female names to keep the gender balance
  as intended, or use names which can be male and female. 

* As the book is often used to read it out to children, we highly
  recommend to test reading it aloud, best also to a few children, to
  see if the translation works out.

* The FSFE has a dedicated translation team with volunteer proofreaders
  for many languages. They can help you as additional proofreaders to
  make sure special terms are translated correctly, or make
  recommendations.

* For the German and the English version the following parts where
  handwritten by the designer Sandra Brandstätter (if it is a latin
  language we can ask Sandra if she has time to do that for your
  language -- if you cover the costs but the Ukrainian and the Arabic
  translations found similar free fonts):
  * The title and subtitle "Ada & Zangemann - Ein Märchen über Software,
    Skateboards und Himbeereis"
  * The initials on some of the pages (we can provide them for the Latin
    alphabet)
  * On page 40-41 there is the demonstration, for the English version we 
    we changed the text for "Ohne Code ist alles doof" ("Don't wreck our 
    tech") and "Sie sind jung + brauchen den Code!" ("They are young + 
    they need the Code!") and pencilled this again. We
    recommend that your designer exchanges those with the slogans being
    used in your translation -- else you can also use the English
    version.
  * The headlines "Danksagung des Autors" + "Über den Author Matthias
    Kirschner" + "Über die Illustratorin Sandra Brandstätter" +
    "Webseite zum Buch" + "Lizenz" are handwritten but based on the
    font "Amatic SC". For the Ukrainian
    version they found a similar font for that. 

* For the illustrations you can change the following:
  * Page 40+41 - the left banner (two children), right button banner
    (Ada), and top right (grandma) can be translated, the others are
    more difficult and we recommend to keep them to also show that it is
    not just a protest in the local language.
  * Page 32 - "Burp" can stay, or can be changed to local language

* We would advise to keep the following English text in the
  illustrations:
  * Page 5 - richest man, can stay in EN (it is in an international magazine)
  * Page 21 - programming, can stay in EN
  * Page 43 - Ring ring, can stay    

* All fonts being used should be under a free cultural font license.
  E.g. the Open Font License so it is in line with CC-BY-SA of the book. 

* Right to Left (mirror illustrations)
  * Keep all illustrations mirrored (already available in git repo),
    but make sure that writing still works out (e.g. the "Z" Zangemann
    logo), except the following ones:
    * Page 5 - magazines
    * Page 21 - programming

* "Z": In the war against Ukraine the Russian army is using a "Z" sign
  on military vehicles. The "Z" is quite different to the "Z"-logo of
  Zangemann, but if you do not have the "Z" in your alphabet and are
  from the war area, it could still be traumatic. That is why we decided
  for the Ukrainian version to exchange all "Z"s into the Ukrainian
  version of "Z". If you have the "Z" in your alphabet or your are not
  close to this war, you should be fine and readers will not associate
  the Zangemann logo with the war.

* It is highly appreciated if the FSFE get two copies. We can use
  pictures with the book, or also all the different language versions of
  the book for advertisement of the book. 

* You can reach out to Matthias Kirschner about promotion of the books
  in those countries, suggestions who could be good to get a quote for
  marketing, etc. 

* In the acknowledgements of the English version you can change "No
  Starch Press" to the name of your publisher, as we would like to thank
  you for publishing this book in your language under a free cultural
  license, and encourage you to do that for other books in future as
  well. 

# Technical details

This repository is set up in a way that scripts can generate multiple output
files from the single translation. This allows you as a translator to focus on
the translation and let the automation create a transcript for book readings and
to output the formatted files for print and digital reading.

It might require some tweaking to get the best possible output from this
automation. Your translation is still valuable regardless of how well it works
with the rendering. Others from the community can help to run the scripts and
tweak it to get nice rendered formats.

To use the automation you can copy the directory structure from one of the other
languages and executed the scripts accordingly.

Some hints on how the scripting deals with the translation file:

* A line break in the source file does not always represent a line break in the
  Scribus book output.

* When a line ends with a trailing space it considere a continuation of the same
  line. So if you to use a line break in your source file for readibility but
  don't want it to show up in the render, then make sure the line has a trailing
  space.

* Explicit line breaks can be inserted by having a line end with two spaces. This
  is used to controle line wrapping to prevent text over the images on page 19
  and 44.

* Some pages start with a drawn capital letter. This is signified in the source
  text in brackets, like `[A]da`. These capital letters are includes as images.
  Different pages use different colors, so it can be that the letter isn't
  available in the needed color. In that case the image will have to be created.

* The source text includes alternative text (alt text) that is added to the
  images to improve accessibility. This alt text can be recognised by the double
  bracket syntax. This should work out just fine as long as formatting is
  maintained.

* Illustrations are linked from the translation page using symbolic links. So if
  you want to translate certain images you should create translated images and
  update the links to point to the translated illustrations.

The scripts are subject to change in order to improve usability and deal with
situations encountered for new translations.
