# PlistParser

PlistParser is a shell script that extracts timestamps in Property Lists into an Sqlite database. It will run on a decompressed directory or a parsed Itunes Backup. This project was written as a quarantine hobby, so please be forgiving if it is badly written as I have no background in programming.

This script was tested on MacOS Catalina 10.15.7. 

## Requirements
- **MacOS** > 10.2
- **Homebrew** - you can install Homebrew by following the instructions on their [website](https://brew.sh/). 
- **plutil** - plutil is a command line tool that is pre-installed in MacOS. 
- **sqlite3**- sqlite3 is a command line tool that is pre-installed in MacOS. 
- **gsed** - gsed aka [GNU-sed](https://www.gnu.org/software/sed/) is a stream editor that can edit text files from the Command Line. You can install [gsed](https://formulae.brew.sh/formula/gnu-sed) on your Mac with Homebrew: `brew install gnu-sed`

## Instructions
Clone the repository:
* `git clone ***`

Cd into the repository:
* `cd PlistParser`

Make the code executable: 
* `chmod +x PlistParser.sh`

Execute the code and indicate the directory that contains the Property List files: 
* `./PlistParser.sh /target/directory/`

## How it works

The script works by finding files with the ".plist" extension in the target directory and copying them (and the folder structure) into a new directory. The "*.plist" files in the new directory are then converted to a readable, XML format using plutil.
Timestamps are generally stored in Plists as "real", "integer" or "date". Using grep, the script finds potential timestamp matches and outputs them to four different text files according to the timestamp format (CocoaCore, Unix, yyyy-mm-ddthh-mm-ssz). 
The text files are then "cleaned" using gsed, and imported as Tables in Sqlite. The timestamps are converted into "YYYY-MM-DD HH:MM:SS" format and merged into a single table "Timestamps". 
