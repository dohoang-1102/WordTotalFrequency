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
	vals.append(1)					# Z_ENT
	vals.append(1)					# Z_OPT
	vals.append(row[3])				# ZRANK
	vals.append(0)					# ZMARKED
	vals.append(min(count/3000, 4)) # ZCATEGORY	row[11]
	vals.append(row[7])				# ZTRANSLATE
	vals.append(row[8])				# ZTAGS
	vals.append(row[1])				# ZSPELL
	vals.append(row[4])				# ZPHONETIC
	vals.append(row[9])				# ZDETAIL
	vals.append(row[5])				# ZSOUNDFILE
	outConn.execute("insert into ZWORD values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", vals)
    
    
 
outConn.execute("update Z_PRIMARYKEY set Z_MAX=?", [maxId])
 
outConn.commit()