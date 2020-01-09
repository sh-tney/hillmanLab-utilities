# fileFisher.bat

This utility makes organizing multi-layered subdirectory trees & getting specific files out of them a breeze, by taking in any "root" directory to search from; and a target filename. Searching through all the subdirectories and copying out matches, the files are all placed in a single folder and renamed to match the immediate parent folder + actual filename.

## Usage and Examples
For now, simply double-clicking the *fileFisher.bat* file will work fine. The *fileFisher.bat* file can be safely copied/moved anywhere on it's own and should work fine; although having the link to this documentation available may be handy for future reference.

### ```> Enter Root of Search Tree: ```

- Put any full path to an actual folder here, such as:

```> Enter Root of Search Tree: C:\Users\Josh\Documents```

- **Don't** use the root of an entire drive like: 

```> Enter Root of Search Tree: C:\``` - *This won't work*.

- If any of your directories have spaces in them, you'll have to use double quotes:

```> Enter Root of Search Tree: "C:\Users\Josh Whitney\Pictures\Family Holiday 2020"```

- It's worth noting that you probably need the correct permissions to access the folders you want to search, so you may need to Run as Administrator.
- If the folder can't be found, you'll be told and given a chance to check for any typos or the like.

### ```> Enter Target Filename: ```

- Put any filename, including the extension, e.g.:

```> Enter Target Filename: image.png```

- This will pull anything with the name *image.png* from all subdirectories inside the Search Root. 
- You can also use wildcards in this; the question mark wildcard will substitute for any single character:

```> Enter Target Filename: report-200?.xlsx```

- The above example will pull all my report spreadsheets from the 2000s, including *report-2001.xlsx* and *report-2009.xlsx*, but **not** *report-2010.xlsx*

- We can also use the asterisk as a variable length wildcard:

```> Enter Target Filename: M*.png```

- The above example will pull all my .png files that start with a capital M, such as *Marie.png* or *Margaret.png*
- Like with the Search Root, filenames that include spaces will need double quotes:

```> Enter Target Filename: "Marie's Report.xlsx"```

- We can combine all of these things here to make very specialized searches:

```> Enter Target Filename: "M*'s * 19??-01-01.*"```

- The above example is complex, grabbing all the named files that begin with *M* and have a *'s* suffix, followed by a space and another word, another space, and a formatted date that must be the first of January for any year between 1900 and 2000; and finally any file extension after the ".".
- This will pull *"Margaret's Picture 1997-01-01.png"*, as well as *"Marie's Report 1999-01-01.xlsx"*
- Particularly here, the .* at the end can be helpful if you are unsure of the file extension you are looking for.

### ```= Output to %Folder%\_fishedData\?```
### ```> y/n (Choose 'n' to set your own output folder): ```

- Fairly self-explanatory, entering a single *"y"* here will generate the indicated folder; and place all the resulting files in that folder. This default option will always be one directory up from where you set the search root.
- Selecting *"n"* will prompt you with ``` > Enter Custom Output Directory: ```. This behaves similarly to the Search Root prompt; Except in this case if the folder doesn't already exist, it will be generated if possible. Entering an invalid path will cause an error, and you will be prompted to try again. Try to ensure the correct full path is used, and that you use double quotes if there are spaces.
- Entering anything that isn't *"y"* or *"n"* will simply result in you being prompted again.

## Where are my files?

The pulled files are all placed in a directory above the Search Root under *_fishedFiles*. For example if I search *C:\Users\Josh\\*, my files will end up in *C:\Users\\_fishedFiles*, if you selected *"y"*. If you selected *"n"*, the files will be in whatever

A *_report.txt* will also be here, detailing the origin of each file. Note that if you engage multiple sessions of fileFisher with the same output folder, the new report will be appended to the end of the first report.

Your original files will be left in their original locations, unaffected, as this utility exlusively makes new copies; no deleting or cutting/pasting.

## Potential Future Developments
- More options regarding the way files are named on copy, with maybe with custom configurations.
- Multiple searches per sessions (rather than simply ending after one).
- Development into standalone callable-function, with proper arguments.
- Options to suppress progress output.
- Bugfixing & better error handling as needed.

## Completed Developments
- Basic Functionality: Mass Search, Copy & Renaming files from layered folder structures into a single folder.
- Report generation, containing original paths & their corresponding new filenames.
- Support for "?" and "*" wildcards.
- Option to select a custom output folder, rather than just the default *..\\_fishedData\\*.
