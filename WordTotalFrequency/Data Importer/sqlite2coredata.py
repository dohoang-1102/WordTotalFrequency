import sqlite3;
from datetime import datetime, date;
import time
 
inConn = sqlite3.connect('mysql.sqlite')
outConn = sqlite3.connect('WordTotalFrequency.sqlite')
 
inCursor = inConn.cursor()
outCursor = outConn.cursor()
 
outConn.execute("DELETE FROM ZWORD")
 
maxId = 0
count = -1
inCursor.execute("select * from word order by frequency desc")
#print inCursor.fetchall()
for row in inCursor:
	if row[0] > maxId:
		maxId = row[0]
	
	count = count + 1
	# Create ZWORD entry
	vals = []
	vals.append(count+1)			# Z_PK	row[0]
	vals.append(2)					# Z_ENT
	vals.append(1)					# Z_OPT
	vals.append(0)					# ZMARKSTATUS
	vals.append(row[3])				# ZRANK
	vals.append(min(count/2700, 4)) # ZCATEGORY	row[11]
	vals.append(row[7])				# ZTRANSLATE
	vals.append(row[8])				# ZTAGS
	vals.append("")                 # ZMARKDATE
	vals.append(row[1])				# ZSPELL
	vals.append(row[4])				# ZPHONETIC
	vals.append(row[9])				# ZDETAIL
	vals.append(row[5])				# ZSOUNDFILE
	outConn.execute("insert into ZWORD values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", vals)
    
    
print count+1 
outConn.execute("update Z_PRIMARYKEY set Z_MAX=? where Z_NAME = 'Word'", [count+1])
 
outConn.commit()