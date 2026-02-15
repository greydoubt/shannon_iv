;*** Hex's Basic Borg *** (v1.2)

; To Install this Cyborg:
; 1) Make sure this file is named Cyborg.ipt.
; 2) Locate youre Palace client (C:\Program Files\CommunitiesCom\ThePalace\Palace32.exe).
; 3) If there is already a Cyborg.ipt in the folder with your Palace client, rename it to Old-Cyborg.ipt.
; 4) Move this file into the same folder as your Palace client.
; 5) In Palace, choose Reload Script from the File menu.
; 6) Say "`help cyborg" to get a listing of commands in your Palace log.

ON OUTCHAT {

	{ "$1" GREPSUB SAY "" CHATSTR = } CHATSTR "^s (.*)" GREPSTR IF
	
	;*** Help System ***
	{	{ LOGMSG }
		[		"-*-*- Cyborg Help: User Commands -*-*-"
				" `pdel		-- Clean the room of loose props"
				" `p <msg>	-- Page a message"
				" zip <ID>	-- Moves you to another room"
				" connect <Server Address> -- Connects you too another palace"
				"    Example Server Address: mansion.thepalace.com[:9998]"
				" clean		-- Clean the room of loose props and paint"
				" mpos		-- Moves you to youre mouse position"
				" pid		-- Prints your Prop ID's to log"
				" info		-- Prints information about various things to log"
				" dump		-- Prints PopIDs to log and drops worn props at mouse position"
				" antiscray on	-- Turns on anti-allscray until you leave the room"
				" brb [msg]	-- Activates the automated BRB scripts"
				" cb <propname>	-- Fills the room with propname, or alternates between two"
				"       [, propname2]  "
				" offer		-- Offer your avatar to target"
				" accept 	-- Accept someones offer"
				" s <msg>	-- Say your message regardless of whisper target or scripts"
				" msay <msg>	-- Spoof your message at mouse position."
				" xsay <msg>	-- Spoof your message at mouse position, as a room message"
				" scouch <prp>	-- Drop a couch made of prp1-prp6"
				" warpto	-- Does a fancy prop-based warp to mouse position"
				" zap		-- Plain old everyday zappage"
				" bzap		-- Bounce a zap off the walls"
				" zzap		-- Zig-Zagging bolt zap"
		] FOREACH
		{	{ LOGMSG }
			[	"-*-*- Cyborg Help: Operator/Moderator Commands -*-*-"
				" `w		-- List the current online wizards"
				" `l		-- List a user (OS, PUID, RegKey)"
				" `pn		-- Pin a user"
				" `upn		-- Unpin a user"
				" `gg		-- Gag a user"
				" `ugg		-- Ungag a user"
				" `pg		-- Propgag a user"
				" `upg		-- Unpropgag a user"
				" `rmsg <msg>	-- Say a room message"
				" dress    	-- *Dress a user in what you are wearing"
				" push		-- *Move a user to where your mouse is"
				" sendto <ID>	-- *Send user to another room"
				" clon		-- *Forces target to offer you thier avatar"
				" foff		-- *Forces target to offer you thier avatar"
				" cf		-- *Crashes target and forces loss of any recently cloned avatars"
				"* = Allscray must be installed in the room, and you must wear a star (*)"
			] FOREACH
		} { "-*-*- More commands available as operator -*-*-" LOGMSG
		} ISWIZARD IFELSE
		"" CHATSTR =
	} CHATSTR "^[`']help cyborg$" GREPSTR IF
	
	;*** Wiz Shortcuts ***
	{	com =
		{ "$1" GREPSUB wt = } { WHOTARGET wt = } WHOTARGET NOT IFELSE
		{	{ com " " & wt & SAY } wt VARTYPE SWAP POP 4 == IF
			{ com wt PRIVATEMSG } wt VARTYPE SWAP POP 1 == IF
		} {	{ com " " & wt & SAY }
			{ com wt PRIVATEMSG } wt "~" > IFELSE
		} IPTVERSION IFELSE
	} wtGet DEF
	{	"`list -o -p" wtGet EXEC "`list -k" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']l (.*)" GREPSTR CHATSTR "`l" == OR IF
	{	"`list -o -p" wtGet EXEC "`list -k" wtGet EXEC "" CHATSTR =
	} CHATSTR "^ll (.*)" GREPSTR CHATSTR "ll" == OR IF
	{	"`gag" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']gg (.*)" GREPSTR CHATSTR "`g" == OR IF
	{	"`ungag" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']ugg (.*)" GREPSTR CHATSTR "`ug" == OR IF
	{	"`pin" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']pn (.*)" GREPSTR CHATSTR "`pn" == OR IF
	{	"`unpin" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']upn (.*)" GREPSTR CHATSTR "`upn" == OR IF
	{	"`propgag" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']pg (.*)" GREPSTR CHATSTR "`pg" == OR IF
	{	"`unpropgag" wtGet EXEC "" CHATSTR =
	} CHATSTR "^[`']upg (.*)" GREPSTR CHATSTR "`upg" == OR IF

	{ CLEARLOOSEPROPS "" CHATSTR = } CHATSTR "`pdel" == IF
	{ CLEARLOOSEPROPS PAINTCLEAR "" CHATSTR = } CHATSTR "clean" == IF
	{ MOUSEPOS SETPOS "" CHATSTR = } CHATSTR "mpos" == IF
	{ "$1" GREPSUB MOUSEPOS SAYAT "" CHATSTR = } CHATSTR "^msay (.*)" GREPSTR IF
	{ "`wizcount" SAY "`glist -w -o" SAY "" CHATSTR = } CHATSTR "`w" == IF
	{ "$1" GREPSUB SUSRMSG "" CHATSTR = } CHATSTR "^`p (.*)" GREPSTR IF
	{ "$1" GREPSUB ROOMMSG "" CHATSTR = } CHATSTR "^`rmsg (.*)" GREPSTR IF
	{ "@" MOUSEPOS ITOA SWAP ITOA "," & SWAP & & "$1" GREPSUB & ROOMMSG "" CHATSTR =
	} CHATSTR "^xsay (.*)$" GREPSTR IF
	
	;*** Other Goodies ***
	{ "" CHATSTR = "$1" GREPSUB ATOI GOTOROOM } CHATSTR "^`zip ([0-9]+)" GREPSTR IF
	{ 	wichServ GLOBAL "$1" GREPSUB wichServ =
		{ wichServ GLOBAL "palace://" wichServ & NETGOTO } 10 ALARMEXEC
		"" CHATSTR =
	} CHATSTR "^`connect (.*)" GREPSTR IF
	{ "[ " { p USERPROP ITOA & " " & p ++ } { p NBRUSERPROPS < } WHILE "]" & LOGMSG "" CHATSTR =
	} CHATSTR "pid" == IF
	{ "[ " { p USERPROP ITOA & " " & p MOUSEPOS ADDLOOSEPROP p ++ }
	       { p NBRUSERPROPS < } WHILE "]" & LOGMSG "" CHATSTR =
	} CHATSTR "dump" == IF

	;Antiallscray controls
	antiscray GLOBAL
	{ 0 antiscray = "Anti-Allscray Deactivated" LOCALMSG "" CHATSTR = } CHATSTR "antiscray off" == IF
	{ 1 antiscray = "Anti-Allscray Activated" LOCALMSG "" CHATSTR = } CHATSTR "antiscray on" == IF	
	
	{	prp2 GLOBAL "$1" GREPSUB prp1 = 
		{ "$1" GREPSUB prp1 = "$2" GREPSUB prp2 = } { prp1 prp2 = } prp1 "(.*), (.*)" GREPSTR IFELSE
		CLEARLOOSEPROPS 0 nx = 0 ny =
		{	{ 44 nx = } { 0 nx = } nx 528 == IFELSE
			{ prp1 nx ny ADDLOOSEPROP 88 nx += } { nx 512 < } WHILE
			44 ny +=
		} { ny 384 < } WHILE
		{	nx GLOBAL ny GLOBAL prp2 GLOBAL
			44 nx = 0 ny =
			{	{ 0 nx = } { 44 nx = } nx 572 == IFELSE
				{ prp2 nx ny ADDLOOSEPROP 88 nx += } { nx 512 < } WHILE
				44 ny +=
			} { ny 384 < } WHILE
		} 80 ALARMEXEC
		"" CHATSTR =
	} CHATSTR "^cb (.*)$" GREPSTR IF
	
	;Info!
	{	"$1" GREPSUB infoMde =
		{ "room spot me all" infoMde = } infoMde "" == IF
		{	"; Error: Unknown Parameter. Try: Room, Spot, Me or All" LOCALMSG "" infoMde =
		} infoMde "room" SUBSTR infoMde "spot" SUBSTR OR infoMde "me" SUBSTR OR infoMde "all" SUBSTR OR NOT IF
		
		{	"; *** Info for Room ***" LOCALMSG
			"; Server: " SERVERNAME &
			"  Room: " & ROOMNAME &
			"  ID: " & ROOMID ITOA & LOCALMSG
			"; There are " NBRDOORS ITOA & " doors, " & NBRSPOTS NBRDOORS - ITOA &
			" spots and " &  NBRROOMUSERS ITOA & " users." & LOCALMSG			
		} infoMde "room" SUBSTR IF
		{	"; *** Info for Me ***" LOCALMSG
			"; Name: " USERNAME &
			"  ID: " & WHOME ITOA &
			"  Rank: " &
			{ "Guest" & } { { { "God" & } { "Wizard" & } ISGOD IFELSE } { "Member" & } ISWIZARD IFELSE } ISGUEST IFELSE
			"  Position: " & POSX ITOA & " " & POSY ITOA & LOCALMSG
			TICKS 216000 / h = TICKS 3600 / h 60 * - m = "; Time since last reboot: "
			{ h ITOA & " hour" & { "s" & } h 1 > IF " and " & } h 0 > IF m ITOA & " minutes." & LOCALMSG 
			"; Current Props: " { pc USERPROP ITOA & " " & pc ++ } { pc NBRUSERPROPS < } WHILE LOCALMSG		
		} infoMde "me" SUBSTR IF	
		{	"; *** Info for Spots ***" LOCALMSG
			"; There are " NBRDOORS ITOA & " doors and " & NBRSPOTS NBRDOORS - ITOA &
			" spots. " & LOCALMSG
			{	"; ID = " f SPOTIDX ITOA &
				"  State = " & f SPOTIDX GETSPOTSTATE ITOA &
				{ "  Name = \"" & f SPOTIDX SPOTNAME & "\"" & } f SPOTIDX SPOTNAME "" == NOT IF
				{ "  Dest = " & f SPOTIDX SPOTDEST ITOA & } f SPOTIDX SPOTDEST 0 <> IF
				{ "  <Locked>" & } f SPOTIDX ISLOCKED IF
				{ "  <In Spot>" & } f SPOTIDX INSPOT IF
				LOCALMSG f ++
			} { f NBRSPOTS < } WHILE	     
	    	} infoMde "spot" SUBSTR IF
		{	"; *** Info for All ***" LOCALMSG
			"; There are " NBRROOMUSERS ITOA & " users. (Listed in Entrance Order)" & LOCALMSG
			{	"; Name: " u ROOMUSER WHONAME &
				"  ID: " & u ROOMUSER ITOA & 
				"  Position: " u ROOMUSER WHOPOS SWAP ITOA " " & SWAP ITOA & & & LOCALMSG
				u ++
			} { u NBRROOMUSERS < } WHILE			
		} infoMde "all" SUBSTR IF
		"" CHATSTR = 
	} CHATSTR "^info *(.*)" GREPSTR IF

{ [  974407362 974407381 974407448 974407481 974407552 974407595 974407607 974407620 ] SETPROPS
} CHATSTR "maartman" == IF

	;*** Allscray Shortcuts ***
	{ 	{	{ "You must select a target" STATUSMSG }
			{ ";allscray \{ [ " { i USERPROP ITOA & " " & i ++ } { i NBRUSERPROPS < } WHILE
			  "] SETPROPS \} WHOCHAT WHOME <> IF" & GREPSUB WHOTARGET PRIVATEMSG } WHOTARGET NOT IFELSE
		} { "You must wear a * badge to use this command." STATUSMSG } USERNAME "^[*]" GREPSTR IFELSE
		"" CHATSTR =
	} CHATSTR "dress" == CHATSTR "dressy" == OR IF
	
	{ 	{	{ "You must select a target" STATUSMSG }
			{ ";allscray \{ " MOUSEPOS ITOA SWAP ITOA " " & SWAP & & " SETPOS \} WHOCHAT WHOME <> IF" 
			& GREPSUB WHOTARGET PRIVATEMSG } WHOTARGET NOT IFELSE
		} { "You must wear a * badge to use this command." STATUSMSG } USERNAME "^[*]" GREPSTR IFELSE
		"" CHATSTR =
	} CHATSTR "push" == IF
	
	{	"$1" GREPSUB rm =
		{	{ "You must select a target" STATUSMSG }
			{ ;{ "1118" rm = } rm "rules" == IF
			  ;{ "1119" rm = } rm "name" == IF
			  ";ao " rm & " GOTOROOM" & GREPSUB WHOTARGET PRIVATEMSG
			} WHOTARGET NOT IFELSE
		} { "You must wear a * badge to use this command." STATUSMSG } USERNAME "^[*]" GREPSTR IFELSE
		"" CHATSTR =
	} CHATSTR "^sendto (.*)" GREPSTR IF
	
	{ ;Slightly edited form of Glide's script =D
	 { "You must wear a * badge to use this command." STATUSMSG }
	 { "`bots off" SAY
	   "*** Sending out check... (Wiz = \";w\"  Member = \";m\"  PalTech User = \";w\"" LOGMSG
	   { ";ao \{ \";w\" WHOCHAT PRIVATEMSG \} \{ \";m\" WHOCHAT PRIVATEMSG \} ISWIZARD IFELSE"
	     { WHOTARGET PRIVATEMSG } { SAY } WHOTARGET IFELSE
	   } 30 ALARMEXEC
	   { "`bots on" SAY } 120 ALARMEXEC
	 } USERNAME "^[*]" GREPSTR NOT IFELSE
	 "" CHATSTR =
	} CHATSTR "paltech" == IF
	
	;Cloner-Killer by Hex (Originally by many people)
	{{	"Err: You must wear a * and select a target." STATUSMSG
	 } {	"`bots off" SAY
		"`list -o -p " WHOTARGET WHONAME & SAY
	 	"`list -k " WHOTARGET WHONAME & SAY
	 	{	";allscray \{ \"@20,20 !You are the weakest link, Goodbye!! (Press CTRL-ALT-DELTE to restart.)\" LOCALMSG \";bye\" SAY \} WHOCHAT WHOME == NOT IF" WHOTARGET PRIVATEMSG
	 		";allscray \{ \{ \"\x0A\" LOGMSG i ++ \} \{ i 120 < \} WHILE -1 SETFACE 3200000 DELAY \} WHOCHAT WHOME == NOT IF" WHOTARGET PRIVATEMSG
			"`bots on" SAY
		} 60 ALARMEXEC
	 } USERNAME "^[*]" GREPSTR WHOTARGET AND NOT IFELSE
	 "" CHATSTR =
	} CHATSTR "cf" == IF
	
	;ForceOffer (whisper "foff" or "`clon" to force them to offer thier avatar to you)
	{	{	";allscray \{ 0 pd = \";avoffer [ \" \{ pd USERPROP ITOA & \" \" & pd ++ \} "
			"\{ pd NBRUSERPROPS < \} WHILE \"]\" & " &
			WHOME ITOA &
			" PRIVATEMSG } WHOCHAT WHOME <> IF" & WHOTARGET PRIVATEMSG
		} { "Err: Must select a target." STATUSMSG } WHOTARGET IFELSE
		"" CHATSTR =
	} CHATSTR "foff" == CHATSTR "`clon" == OR IF
	
	;Offer/Accept Outchat Segment
	offeredAvatar GLOBAL
	{	{	0 i = ";avoffer [ "
			{ i USERPROP ITOA & " " & i ++
			} { i NBRUSERPROPS < } WHILE "]" &
			{ WHOTARGET PRIVATEMSG } { SAY } WHOTARGET IFELSE
		} NBRUSERPROPS IF "" CHATSTR =
	} CHATSTR "offer" == IF
	{ "" CHATSTR = offeredAvatar STRTOATOM EXEC
	} "accept" CHATSTR == "\"accept\"" CHATSTR == OR offeredAvatar "" <> AND IF

	;HBrb Outchat Segment
	isAway GLOBAL idleTime GLOBAL messageLog GLOBAL bbTxt GLOBAL brbProp GLOBAL mLogI GLOBAL
	DATETIME { 2147483647 + } DATETIME 0 < IF idleTime =
	{	{ "Error: You are already away!" LOCALMSG EXIT } isAway IF
		{ brbProp DONPROP } brbProp HASPROP NOT IF
		1 isAway = "" messageLog =
		"$1" GREPSUB bbTxt =
		{ "Im AFK, your message has been logged." bbTxt = "brb" SAY }
		{ bbTxt SAY } bbTxt "" == IFELSE "" CHATSTR = 
	} CHATSTR "^hbrb *(.*)" GREPSTR CHATSTR "^(brb[, ]*.*)" GREPSTR OR IF
	{	0 isAway =
		{ brbProp REMOVEPROP } { brbProp HASPROP } WHILE
		{	"You received " mLogI ITOA & " message(s). (In Log)" & LOCALMSG
			{ "; $1" GREPSUB LOCALMSG "$2" GREPSUB messageLog = i ++
			} { messageLog "^;ัต" i ITOA & "Y;(.*);๑K" & i ITOA & "ษ;(.*)" & GREPSTR } WHILE 0 mLogI =
		} { "You recieved no messages" LOCALMSG } messageLog "" == NOT IFELSE
		"" messageLog =
	} isAway WHOTARGET NOT AND CHATSTR "" == NOT AND IF
	
	;*** Fun Prop Scripts ***
	
	;Requires props, can be found by running this script at palace://koko.chatserve.com
	restore_props GLOBAL wtCnt GLOBAL
	{	{	NBRUSERPROPS n =
			{ 0 i = "[" { " " i USERPROP ITOA & & i ++ } { i n < } WHILE " ] SETPROPS" & restore_props =
			} { "NAKED" restore_props = } n IFELSE
		} { "$2" GREPSUB " MACRO" & restore_props = } "$2" GREPSUB "" == IFELSE 0 wtCnt =
		{ wtCnt GLOBAL " SETPROPS" & STRTOATOM wtCnt 3 * ALARMEXEC wtCnt ++ }
		[ "[ -1273076790 ]" "[ -1273054317 ]" "[ -1273054240 ]" "[ -1273054235 ]" "[ -1273054216 ]"
		  "[ -1273054210 ]" "[ -1273054525 ]" "[ -1273054173 ]" "[ -1273054160 ]" "[ -1273054608 ]" ] FOREACH
		{ wtCnt GLOBAL 0 wtCnt = MOUSEPOS SETPOS
		{ wtCnt GLOBAL " SETPROPS" & STRTOATOM wtCnt 3 * ALARMEXEC wtCnt ++ }
		[ "[ -1273054608 ]" "[ -1273054160 ]" "[ -1273054173 ]" "[ -1273054525 ]" "[ -1273054210 ]"
		  "[ -1273054216 ]" "[ -1273054235 ]" "[ -1273054240 ]" "[ -1273054317 ]" "[ -1273076790 ]" ] FOREACH
		{ restore_props GLOBAL restore_props STRTOATOM EXEC } 31 ALARMEXEC
		} 31 ALARMEXEC "" CHATSTR =
	} CHATSTR "^warpto([ ]*)([0-9]*)$" GREPSTR IF
	
	;Scouch, for all your prop couch needs.
 	{	"$1" GREPSUB prp = { "purc" prp = } prp "" == IF 44 nx =
 		CLEARLOOSEPROPS
 		"\"" prp & "1\" 0 302 ADDLOOSEPROP" & STRTOATOM EXEC
 		"\"" prp & "4\" 0 345 ADDLOOSEPROP" & STRTOATOM EXEC
 		"\"" prp & "3\" 472 302 ADDLOOSEPROP" & STRTOATOM EXEC
 		"\"" prp & "6\" 472 345 ADDLOOSEPROP" & STRTOATOM EXEC
 		{	"\"" prp & "2\" " & nx ITOA & " 302 ADDLOOSEPROP" & STRTOATOM EXEC
 			"\"" prp & "5\" " & nx ITOA & " 345 ADDLOOSEPROP" & STRTOATOM EXEC
 			nx 43 + nx =
 		} { nx 435 < } WHILE
 		"" CHATSTR =
 	} CHATSTR "^scouch *(.*)" GREPSTR IF
 
 	;; Snowball: throw a snowball at the mouse position
 	;; Author: Dr.X & Biks
 	{	"$1" GREPSUB s =
 		  { "snowball" s = } s "" == IF
 		  MOUSEPOS ty = tx = POSX tx - dx = POSY ty - dy =
 		  s tx dx 3 * 4 / + ty dy 3 * 4 / + ADDLOOSEPROP CLEARLOOSEPROPS
 		  s tx dx 2 / + ty dy 2 / + ADDLOOSEPROP CLEARLOOSEPROPS
 		  s tx dx 4 / + ty dy 4 / + ADDLOOSEPROP CLEARLOOSEPROPS ")Splat"
 		  ["!Splat!" "!Ker-Plop!" "!Biff!" "!Sploosh!" "!Fwap!" "!Sklish!" "!Sputch!"] 7 RANDOM GET & MOUSEPOS SAYAT
 		  "snowsplat" MOUSEPOS ADDLOOSEPROP
 		  { CLEARLOOSEPROPS "snowpile" MOUSEPOS ADDLOOSEPROP} 100 ALARMEXEC "" CHATSTR =
 	} CHATSTR "^snowball *(.*)$" GREPSTR IF
	
	;*** Fun Paint Zaps ***
	{ 255 0 0 PENCOLOR PENFRONT 2 PENSIZE POSX POSY MOUSEPOS LINE "!Zap" MOUSEPOS SAYAT "" CHATSTR =
	} CHATSTR "zap" == IF
	
	;Bounce Zap by Hex
	{	"$1" GREPSUB lcount = 0 SETCOLOR
		{ 4 lcount = } { lcount ATOI lcount = } lcount "" == IFELSE
		lcount 2 * psize =
		{ 8 psize = } psize 8 > IF PAINTCLEAR
		PENBACK POSX px = POSY py = MOUSEPOS my = mx =		
		mx px - run = my py - rise =	
		{ 1 direc = } mx px > my py < AND IF
		{ 2 direc = } mx px > my py > AND IF
		{ 3 direc = } mx px < my py > AND IF
		{ 4 direc = } mx px < my py < AND IF		
		rise 10 / rise = run 10 / run =
		{ { 2 } { -2 } 2 RANDOM IFELSE rise = } 0 rise == IF { { 2 } { -2 } 2 RANDOM IFELSE run = } 0 run == IF
		{	{	run  mx += rise my +=
			} { mx 0 >= mx 512 <= AND my 0 >= AND my 384 <= AND } WHILE		
			{ 0   mx = } mx 0   < IF
			{ 512 mx = } mx 512 > IF
			{ 0   my = } my 0   < IF
			{ 384 my = } my 384 > IF			
			255 0 0 PENCOLOR psize PENSIZE		
			px py mx my LINE
			"@" mx ITOA & "," & my ITOA & " " &
			")bzap.wav" &
			" !" &
			[ "Ping!" "Pop!" "Bounce!" "Toooing!" "Bing!" "Ting!" ] DUP LENGTH RANDOM GET & SAY 				
			{ psize -- } psize 1 > IF
			mx px = my py = 0 done =
			{ { 4 direc = 0 run - run = } { 2 direc = 0 rise - rise = } mx 512 == IFELSE 1 done = } 1 direc == done NOT AND IF
			{ { 3 direc = 0 run - run = } { 1 direc = 0 rise - rise = } mx 512 == IFELSE 1 done = } 2 direc == done NOT AND IF
			{ { 2 direc = 0 run - run = } { 4 direc = 0 rise - rise = } mx 0   == IFELSE 1 done = } 3 direc == done NOT AND IF
			{ { 1 direc = 0 run - run = } { 3 direc = 0 rise - rise = } mx 0   == IFELSE 1 done = } 4 direc == done NOT AND IF
			bz ++
		} { bz lcount < } WHILE
		{ PAINTCLEAR } lcount 60 * ALARMEXEC "" CHATSTR =
	} CHATSTR "^bzap *(.*)" GREPSTR IF
	
	;Zzap
	{ 8 PENSIZE 255 255 0 PENCOLOR PENFRONT MOUSEPOS POSY - difrow = POSX - difcol
	  = POSX slc = POSY slr = difrow 8 / aslr = difcol 8 / aslc =
	  difcol 20 / -1 * zrow = difrow 20 / zcol = POSY oldr = POSX oldc = { steps ++
	  aslc slc += aslr slr += slc zcol + newc = slr zrow + newr =
	  oldc oldr newc newr LINE -1 zrow *= -1 zcol *= newc oldc = newr oldr =
	  8 steps - PENSIZE } { steps 7 < } WHILE oldc oldr MOUSEPOS LINE
	  "@" MOUSEPOS SWAP ITOA "," & SWAP ITOA & & ")boom !Kerpow!" & ROOMMSG
	  { PAINTCLEAR } 300 ALARMEXEC "" CHATSTR = 
	} CHATSTR "zzap" == IF
	
; -*-*-*-  ADD YOUR OUTCHAT SCRIPTS BELOW THIS LINE  -*-*-*-









; -*-*-*-  ADD YOUR OUTCHAT SCRIPTS ABOVE THIS LINE  -*-*-*-

}

ON INCHAT {

	;Anti-Flood
	lastChat GLOBAL
	whoFlood GLOBAL
	floodCount GLOBAL
	CHATSTR afchat =
	{ "$1" GREPSUB afchat = } afchat "^@[0-9]+,[0-9]+(.*)" GREPSTR IF
	{	floodCount ++
		{ "`mute " whoFlood WHONAME & SAY "\"`unmute " whoFlood WHONAME & "\" SAY" & STRTOATOM 3600 ALARMEXEC
		} floodCount 3 == IF
	} { 0 floodCount = } afchat lastChat == WHOCHAT whoFlood == AND IFELSE
	afchat lastChat =
	WHOCHAT whoFlood =
	
	;Anti-Con.Con by saturn
	{	"$1$2" GREPSUB CHATSTR =
		{ WHOCHAT WHONAME " may have attempted sound bug." & SUSRMSG 7200 DELAY } WHOCHAT WHOME == IF
	} CHATSTR "^(\\\x29[^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^][^ -!:^])[^ -!:^]+(.*)$" GREPSTR DATETIME > 0 AND IF

	{	"" CHATSTR = "!" WHOCHAT WHONAME & " may have attempted to crash you!" & LOCALMSG
		"More information available at:\x0dhttp://www.securax.org/pers/scx-sa-01.txt" LOGMSG
	} {	CHATSTR LOWERCASE "^[)]con.(.*)" GREPSTR
		CHATSTR LOWERCASE "^[)]nul.(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]aux.(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]clock\x24.(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]config\x24.(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]com[0-9].(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]lpt[0-9].(.*)" GREPSTR OR
		CHATSTR LOWERCASE "^[)]prn.(.*)" GREPSTR OR
	} WHILE
	
	;Offer/Accept Inchat Segment
	offeredAvatar GLOBAL prps GLOBAL
	{	"$1" GREPSUB prps =
		{	"[ " prps & " ] SETPROPS" & offeredAvatar =
			"@" WHOCHAT WHOPOS ITOA SWAP ITOA "," & SWAP & &
			" You have been offered an avatar by " & WHOCHAT WHONAME &
			". To accept it, type \"accept\"." & LOCALMSG
		} prps ".* .* .* .* .* .* .* .* .* .*" GREPSTR NOT prps "-$" GREPSTR NOT AND
		prps "- " GREPSTR NOT AND prps ">$" GREPSTR NOT AND prps "> " GREPSTR NOT AND
		prps "<$" GREPSTR NOT AND prps "< " GREPSTR NOT AND WHOCHAT WHOME <> AND IF
		"" CHATSTR =
	} CHATSTR "^;avoffer [\[] ([0-9<>A-Fa-f -]+) [\]]" GREPSTR IF
	
	;HBrb Inchat Segment
	isAway GLOBAL messageLog GLOBAL bbTxt GLOBAL idleTime GLOBAL mLogI GLOBAL brbProp GLOBAL ctime GLOBAL
	{	2 isAway = "Im AFK (AutoIdle)" bbTxt = "" messageLog = 1 isLogging =
		{ brbProp DONPROP } brbProp HASPROP NOT IF
		"; Auto Idle Away (" ctime EXEC & ")" & LOCALMSG
	} isAway NOT DATETIME { 2147483647 + } DATETIME 0 < IF idleTime - 10 60 * > AND IF
	{	{ bbTxt WHOCHAT PRIVATEMSG } bbTxt "" == NOT IF
		messageLog ";ัต" & mLogI ITOA & "Y;(" & ctime EXEC & ") " & WHOCHAT WHONAME & ": " & CHATSTR &
		 ";๑K" & mLogI ITOA & "ษ;" & messageLog = mLogI ++
		"YES" SOUND
	} CHATSTR USERNAME SUBSTR
	  CHATSTR "New Friend" SUBSTR OR               ;<-- Add alternate nick names like so ***********
	  ;CHATSTR "my other name" SUBSTR OR
	  WHOCHAT WHOME <> AND isAway AND IF

	;Antiscray
	antiscray GLOBAL
	{	{ "" CHATSTR = EXIT } CHATSTR "^;[a-z]o " GREPSTR IF
		{ "" CHATSTR = EXIT } CHATSTR "^;[a-z]s " GREPSTR IF
		{ "" CHATSTR = EXIT } CHATSTR "^;[a-z]llscray " GREPSTR IF
	} WHOCHAT WHOME <> antiscray AND IF
	  
; -*-*-*-  ADD YOUR INCHAT SCRIPTS BELOW THIS LINE  -*-*-*-

	





; -*-*-*-  ADD YOUR INCHAT SCRIPTS ABOVE THIS LINE  -*-*-*-

}

ON SIGNON {
	
	;Wear your Macro #1 on signon
	1 MACRO
	
	
; -*-*-*-  ADD YOUR SIGNON SCRIPTS BELOW THIS LINE  -*-*-*-






; -*-*-*-  ADD YOUR SIGNON SCRIPTS ABOVE THIS LINE  -*-*-*-
	
}

ON ENTER {

	;HBrb Enter Segment
	brbProp GLOBAL "brb box" brbProp = ;<-- Special the name of your BRB prop. ***********
	isAway GLOBAL messageLog GLOBAL idleTime GLOBAL mLogI GLOBAL
	{	0 isAway =
		{ brbProp REMOVEPROP } { brbProp HASPROP } WHILE
		{	"You received " mLogI ITOA & " message(s). (In Log)" & LOCALMSG
			{ "; $1" GREPSUB LOCALMSG "$2" GREPSUB messageLog = i ++
			} { messageLog "^;ัต" i ITOA & "Y;(.*);๑K" & i ITOA & "ษ;(.*)" & GREPSTR } WHILE 0 mLogI =
		} { "You recieved no messages" LOCALMSG } messageLog "" == NOT IFELSE
		"" messageLog =
	} isAway IF
	idleTime GLOBAL DATETIME { 2147483647 + } DATETIME 0 < IF idleTime =
	
	;CTime, returns current time as a string
	ctime GLOBAL
	{	-5 timezone =  ;<-- Choose wich timezone your in (-5 = Cental) ***********
		{	DATETIME 86400 % t = t 3600 / timezone + h =
		} {	DATETIME 2147483647 + 86400 % 11647 + 86400 % t = t 3600 / h =
		} DATETIME 0 >= IFELSE
		{ 24 h -= } h 24 > IF { 24 h += } h 0 < IF
		{ 12 h -= " PM" timem = } { " AM" timem = } h 12 > IFELSE
		h ITOA ":" & t 3600 % 60 / m =
		{ "0" & } m 10 < IF m ITOA & ":" & t 60 %  s =
		{ "0" & } s 10 < IF s ITOA & timem &
	} ctime DEF
	
	antiscray GLOBAL 0 antiscray =
	
	"--- Moved to " ROOMNAME & " at " & ctime EXEC & "  ID: " & ROOMID ITOA & " ---" & LOGMSG
	
; -*-*-*-  ADD YOUR ENTER SCRIPTS BELOW THIS LINE  -*-*-*-







; -*-*-*-  ADD YOUR ENTER SCRIPTS ABOVE THIS LINE  -*-*-*-

}
