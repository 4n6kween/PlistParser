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

In the directory, you will find the output database "Timestamps.db" and a folder named 'Plists' which will contain a copy of all .plist files in XML format with their original directory structure.  
