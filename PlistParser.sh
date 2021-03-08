#!/bin/bash

echo
echo 'Plists Parser'
echo 'Generating Database...'

mkdir Plists;

find "$@" -name '*.plist' | cpio -pdm  Plists;
find ./Plists -type f -name "*.plist" -exec plutil -convert xml1 "{}" \;

grep -rs "real>[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"  -B 1 Plists > realcc.txt;

gsed -i '
s/,/;/g
/<\/key>/{ N; s/<\/key>.*<real>/,/}
s/plist-.*<key>/plist,/g
s/<\/real>//g
/<\/string/{ N; s/<\/string>.*<real>/,/}
s/plist-.*<string>/plist,/g
s/<\/dict>/dict,/g
/--/d
/addaily.plist/d
s/plist:.*<real>/plist,array,/g
/<integer>/d
/<real>/d
/<array>/d
/<\/array>/d
/dict,/d
/<false\/>/d
/PixelFormatType/d
' realcc.txt ;


grep -rs "integer>1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]<" -B 1  Plists > integer.txt ;

gsed -i '
s/,/;/g
/<\/key>/{ N; s/<\/key>.*<integer>/,/}
s/plist-.*<key>/plist,/g
/<\/string/{ N; s/<\/string>.*<integer>/,/}
/--/d
s/<\/integer>//g
s/plist-.*<string>/plist,/g
/integer>100/d
s/plist:.*<integer>/plist,array,/g
/<array>/d
/iTunesMetadata.plist/d
/RadioPlayBackHistoryStore/d
/<\/dict>/d
s/plist-.*<integer>/plist,array,/g
' integer.txt ;

grep -rs "real>[1][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"  -B 1 Plists > realeu.txt;

gsed -i '
s/,/;/g
/<\/key>/{ N; s/<\/key>.*<real>/,/}
s/plist-.*<key>/plist,/g
s/<\/real>//g
/<\/string/{ N; s/<\/string>.*<real>/,/}
s/plist-.*<string>/plist,/g
s/<\/dict>/dict,/g
/--/d
/addaily.plist/d
s/plist:.*<real>/plist,array,/g
/<integer>/d
/<real>/d
/<array>/d
/<\/array>/d
/dict,/d
/<false\/>/d
/PixelFormatType/d
' realeu.txt ;


grep -rs "<date>" -B 1 Plists > date.txt;

gsed -i '
s/,/;/g
/<\/key>/{ N; s/<\/key>.*<date>/,/}
/<\/string/{ N; s/<\/string>.*<date>/,/}
s/plist-.*<key>/plist,/g
s/Z<\/date>//g
/--/d
s/plist:.*<date>/plist,array,/g
/<array>/d
s/plist-.*<string>/plist,/g
' date.txt ;

{ echo "directory,activity,timestamp"; cat date.txt;} > dates.txt;
{ echo "directory,activity,timestamp"; cat integer.txt;} > integers.txt;
{ echo "directory,activity,timestamp"; cat realcc.txt;} > realc.txt;
{ echo "directory,activity,timestamp"; cat realeu.txt;} > realu.txt;

rm -r date.txt
rm -r integer.txt
rm -r realcc.txt
rm -r realeu.txt

sqlite3 <<'END_SQL'
.mode csv
.import dates.txt DATE
.import integers.txt INTEGER
.import realc.txt REALC
.import realu.txt REALU

UPDATE REALC
SET timestamp = datetime(timestamp + 978307200, 'unixepoch');

UPDATE REALU
SET timestamp = datetime(timestamp, 'unixepoch');

UPDATE INTEGER
SET timestamp = datetime(timestamp, 'unixepoch');
 
UPDATE DATE
SET timestamp = replace(timestamp, 'T', ' ');

CREATE TABLE Ts(directory Varchar, activity Varchar, timestamp datetime);
INSERT INTO Ts SELECT * FROM DATE;
INSERT INTO Ts SELECT * FROM INTEGER;
INSERT INTO Ts SELECT * FROM REALC;
INSERT INTO Ts SELECT * FROM REALU;
.save plists.db
END_SQL

rm -r dates.txt
rm -r integers.txt
rm -r realc.txt
rm -r realu.txt

echo 'Done!'
