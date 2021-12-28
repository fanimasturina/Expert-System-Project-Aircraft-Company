;PROJECT SERIUS
;OKE 

;;CATATAN, AGAR GUI DAPAT BERJALAN & AGAR MENU NOMOR 5 TIDAK ERROR. COMPILE FILE GUI.java -NYA DI SRC, BUKAN FILE INI.
;;SEBAB KALAU FILE .CLP INI YANG DICOMPILE, MENU NOMOR 5 TIDAK DAPAT MENAMPILKAN GUINYA. 
;;JADI MOHON UNTUK COMPILE FILE GUI.java, AGAR PROJECT DAPAT BERJALAN SECARA LENGKAP DAN KESELURUHAN.
;;Terima kasih & mohon maaf..

;DODI JAYA TEGUH - 2001551611
;FANI MASTURINA - 2001573676
;COMP7066 - BA05
;Expert System - Project Case
;Aeroff

;VariabelGlobal
(defglobal
    ?*at* = ""
    ?*bt* = ""
    ?*ct* = ""
    ?*dt* = ""
    ?*et* = ""
    ?*ft* = 0
    ?*counter* = 0
    ?*chdel* = -1
    ?*chedit* = -1
    ?*counterdel* = 0
    ?*counteredit* = 0
    )

;TemplateData
(deftemplate Airplane
    (slot name)
    (slot material)
    (slot engineType)
    (slot color)
    (slot fuel)
    (slot price)
    )
(deftemplate Helicopter
    (slot name)
    (slot material)
    (slot color)
    (slot fuel)
    (slot price)
    )
(deftemplate Consultation
    (slot username)
    (slot aircraft)
    (slot material)
    (slot engineType)
    (slot budget)
    )

;RulePengolahData
(defrule viewAirplane
    (viewA) ;fungsi terpanggil untuk view list Airplane
    (Airplane(name ?a)(material ?b) (engineType ?c)(color ?d)(fuel ?e)(price ?f))
    =>
    (printout t "|" ?*counter* "	|" ?a "	|" ?b "	|" ?c "	|" ?d "	|" ?e "	|" ?f crlf)
    (++ ?*counter*)
    )
(defrule viewHelicopter
    (viewH) ;fungsi terpanggil untuk view list Helicopter
    (Helicopter(name ?a)(material ?b) (color ?c)(fuel ?d)(price ?e))
    =>
    (printout t "|" ?*counter* "	|" ?a "	|" ?b "	|" ?c "	|" ?d "	|" ?e crlf)
    (++ ?*counter*)
    )
(defrule delete-view-A
    ?i <- (viewA)
    =>
    (retract ?i))
(defrule delete-view-H
    ?i <- (viewH)
    =>
    (retract ?i))
(defrule addAirplane
    ?i <- (addA ?a ?b ?c ?d ?e ?f)
    (not (Airplane(name ?a)(material ?b)(engineType ?c)(color ?d)(fuel ?e)(price ?f)))
    =>
    (assert (Airplane(name ?a)(material ?b)(engineType ?c)(color ?d)(fuel ?e)(price ?f)))
    (printout t "Add Airplane Success" crlf)
    (retract ?i)
    )
(defrule addHelicopter
    ?i <- (addH ?a ?b ?c ?d ?e)
    (not (Helicopter(name ?a)(material ?b)(color ?c)(fuel ?d)(price ?e)))
    =>
    (assert (Helicopter(name ?a)(material ?b)(color ?c)(fuel ?d)(price ?e)))
    (printout t "Add Helicopter Success" crlf)
    (retract ?i)
    )
(defrule removeAirplane
    (removeA ?idx)
    ?i <- (Airplane)
    =>
    (if (eq ?idx ?*counterdel*) then
        (retract ?i)
        (printout t "DELETE AIRPLANE SUCCESS!!!" crlf)
        )
    (++ ?*counterdel*)
    )
(defrule removeHelicopter
    (removeH ?idx)
    ?i <- (Helicopter)
    =>
    (if (eq ?idx ?*counterdel*) then
        (retract ?i)
        (printout t "DELETE HELICOPTER SUCCESS!!!" crlf)
        )
    (++ ?*counterdel*)
    )
(defrule deleteRuleRemoveA
    ?i <- (removeA ?idx)
    => 
    (retract ?i)
    )
(defrule deleteRuleRemoveH
    ?i <- (removeH ?idx)
    => 
    (retract ?i)
    )
(defrule updateAirplane
    (modifyA ?idx)
    ?i <- (Airplane)
    =>
    (if (eq ?idx ?*counteredit*)then
        (modify ?i (name ?*at*)(material ?*bt*)(engineType ?*ct*)(color ?*dt*)(fuel ?*et*)(price ?*ft*))
        (printout t "Airplane Succesfully Updated!!" crlf)
        )
    (++ ?*counteredit*)
    )
(defrule updateHelicopter
    (modifyH ?idx)
    ?i <- (Helicopter)
    =>
    (if (eq ?idx ?*counteredit*)then
        (modify ?i (name ?*at*)(material ?*bt*)(color ?*dt*)(fuel ?*et*)(price ?*ft*))
        (printout t "Helicopter Succesfully Updated!!" crlf)
        )
    (++ ?*counteredit*)
    )
(defrule deleteModifyA
    ?i <- (modifyA ?idx)
    => 
    (retract ?i)
    )
(defrule deleteModifyH
    ?i <- (modifyH ?idx)
    => 
    (retract ?i)
    )

;Query GUI
(defquery consultInformation
    (Consultation (username ?username) (aircraft ?aircraft) (material ?material) (engineType ?engineType)(budget ?budget))
    )
(defquery infoAirplane
    (Consultation (username ?username) (aircraft ?aircraft) (material ?material) (engineType ?engineType)(budget ?budget))
    (Airplane(name ?a)(material ?b) (engineType ?c)(color ?d)(fuel ?e)(price ?f))
    (test(and (and (eq (str-compare ?b ?material) 0) (eq (str-compare ?engineType ?c) 0)) (<= ?f ?budget)))
    )
(defquery infoHelicopter
    (Consultation (username ?username) (aircraft ?aircraft) (material ?material) (engineType ?engineType)(budget ?budget))
    (Helicopter(name ?a)(material ?b) (color ?c)(fuel ?d)(price ?e))
    (test(and (eq (str-compare ?b ?material) 0) (<= ?e ?budget)))
    )

;DataDummy
(deffacts AirplaneFacts
    (Airplane (name "Hawker Horizon 4000")(material "Titanium")(engineType "Jet")(color "Black")(fuel "Bio Fuel")(price 750000))
    (Airplane (name "Fairchild 300")(material "Aluminum")(engineType "Jet")(color "Black")(fuel "Jet Fuel")(price 600000))
    (Airplane (name "210R Centurion")(material "Aluminum")(engineType "Jet")(color "White")(fuel "Avgas")(price 300000))
    (Airplane (name "Eclipse DA20-C1")(material "Titanium")(engineType "Piston")(color "Blue")(fuel "Avgas")(price 400000))
    (Airplane (name "Eurofox")(material "Graphite")(engineType "Piston")(color "White")(fuel "Avgas")(price 350000))
    )
(deffacts HelicopterFacts
    (Helicopter (name "F28F Falcon")(material "Aluminum")(color "Blue")(fuel "Avgas")(price 400000))
    (Helicopter (name "280F Shark")(material "Graphite")(color "Black")(fuel "Biofuel")(price 650000))
    (Helicopter (name "R22 Alpha Beta")(material "Alumunium")(color "Blue")(fuel "Avgas")(price 200000))
    (Helicopter (name "R22 Mariner")(material "Titanium")(color "White")(fuel "Avgas")(price 350000))
    (Helicopter (name "S-76 Spirit")(material "Graphite")(color "White")(fuel "Avgas")(price 500000))
    )

;Templates
(deffunction menu()
    ;Mengulang menu
    (printout t "====================" crlf)
    (printout t "||     Aeroff     ||" crlf)
    (printout t "====================" crlf)
    (printout t "1. View Aircraft" crlf)
    (printout t "2. Add a New Aircraft" crlf)
    (printout t "3. Update Aircraft Detail" crlf)
    (printout t "4. Delete Aircraft" crlf)
    (printout t "5. Search Match" crlf)
    (printout t "6. Exit" crlf)
    )
(deffunction clearScreen()
    ;Bersihin layar
    (for(bind ?i 0) (< ?i 30) (++ ?i)
    	(printout t crlf)
        )
    )
(deffunction AircraftChoice()
    (printout t "List of Aircraft To Be Viewed" crlf)
    (printout t "============================" crlf)
    (printout t "1. Airplane" crlf)
    (printout t "2. Helicopter" crlf)
    )

;Inisialisasi
(reset)
(bind ?choose 0)

;menuStart
(while (neq ?choose 6)
    (bind ?chooseSub 0)
    ;(clearScreen)
    (menu)
    (printout t ">> Input [1-6]: ")
    (bind ?choose (read))
    (if (eq (numberp ?choose) FALSE) then
			(clearScreen)
        	(printout t "Please Input a Number..." crlf)
        	)

    ;VIEW AIRCRAFT
    (if (eq ?choose 1) then
        (while (and (neq ?chooseSub 1)(neq ?chooseSub 2))
            (clearScreen)
            (AircraftChoice)
	        (printout t ">> Choose [1..2 | 0 back to main menu]: ")
    	    (bind ?chooseSub (read))
            ;;VIEW AIRPLANE
            (if (eq ?chooseSub 1) then
                (clearScreen)
                (printout t "Airplane Facts" crlf)
                (printout t "===================================================================================" crlf)
                (printout t "|No.	|Name		|Material	|Engine Type	|Color	|Fuel	|Price	|" crlf)
                (printout t "===================================================================================" crlf)
                (assert (viewA))
                (bind ?*counter* 1)
		        (run)
                (printout t "===================================================================================" crlf)
                (printout t "Press Enter to Continue.." crlf)
                (bind ?chooseSub (readline))
                (clearScreen)
                (bind ?chooseSub 1)
                )
            ;;VIEW HELICOPTER
            (if (eq ?chooseSub 2) then
                (clearScreen)
                (printout t "Helicopter Facts" crlf)
                (printout t "=================================================================" crlf)
				(printout t "|No.	|Name		|Material	|Color	|Fuel	|Price	|" crlf)
                (printout t "=================================================================" crlf)
                (assert(viewH))
                (bind ?*counter* 1)
                (run)
                (printout t "=================================================================" crlf)
                (printout t "Press Enter to Continue.." crlf)
                (bind ?chooseSub (readline))
                (clearScreen)
                (bind ?chooseSub 2)
                )
            ;;BACK TO MAIN MENU
            (if (eq ?chooseSub 0) then
                (clearScreen)
                (printout t "Back To Main Menu" crlf)
                (bind ?chooseSub 1)
                )
            )
        )
    ;;ADD AIRCRAFT
    (if (eq ?choose 2) then
         (while (and (neq ?chooseSub 1)(neq ?chooseSub 2))
            (clearScreen)
            (AircraftChoice)
	        (printout t ">> Choose [1..2 | 0 back to main menu]: ")
    	    (bind ?chooseSub (read))
            ;;ADD AIRPLANE
            (if (eq ?chooseSub 1) then
                (bind ?a "")
			    (bind ?b "")
			    (bind ?c "")
			    (bind ?d "")
			    (bind ?e "")
			    (bind ?f 0)
                (while (or (eq ?a "") (< (str-length ?a) 5) (>(str-length ?a) 25))
	                (printout t "Input Aircraft Name [5-25 Characters]: ")
    	            (bind ?a (readline))
                    )
                (while (and (neq ?b "Titanium") (neq ?b "Alumunium") (neq ?b "Graphite") )
	                (printout t "Input Material Type [Titanium|Alumunium|Graphite] (Case-Sensitive): ")
    	            (bind ?b (readline))
                	)
                (while (and (neq ?c "Jet") (neq ?c "Piston") )
	                (printout t "Input Engine Type [Jet|Piston] (Case-Sensitive): ")
    	            (bind ?c (readline))
                	)
                (while (and (neq ?d "Black") (neq ?d "White") (neq ?d "Blue") )
	                (printout t "Input Aircraft Color [Black|White|Blue] (Case-Sensitive): ")
    	            (bind ?d (readline))
                	)
                (while (and (neq ?e "Biofuel") (neq ?e "Jet Fuel") (neq ?e "Avgas") )
	                (printout t "Input Fuel Type [Biofuel|Jet Fuel|Avgas] (Case-Sensitive): ")
    	            (bind ?e (readline))
                	)                
                (while (or (< ?f 100000) (> ?f 1000000))
                    (printout t "Input Aircraft Price [100000-1000000] (dollars): ")
                    (bind ?f (read))
                    (if (eq (numberp ?f) FALSE) then
                        (printout t "Please Input a Number..." crlf)
                        (bind ?f 0)
                        )
                    )
                (assert (addA ?a ?b ?c ?d ?e ?f))
                (run)
                (printout t "Press ENTER To Continue..." crlf)
                (bind ?chooseSub (readline))
                (bind ?chooseSub 1)
                )
            ;;ADD HELICOPTER
            (if (eq ?chooseSub 2) then
                (bind ?a "")
			    (bind ?b "")
			    (bind ?d "")
			    (bind ?e "")
                (bind ?f 0)
                (while (or (eq ?a "") (< (str-length ?a) 5) (>(str-length ?a) 25))
	                (printout t "Input Aircraft Name [5-25 Characters]: ")
    	            (bind ?a (readline))
                    )
                (while (and (neq ?b "Titanium") (neq ?b "Alumunium") (neq ?b "Graphite") )
	                (printout t "Input Material Type [Titanium|Alumunium|Graphite] (Case-Sensitive): ")
    	            (bind ?b (readline))
                	)
                (while (and (neq ?d "Black") (neq ?d "White") (neq ?d "Blue") )
	                (printout t "Input Aircraft Color [Black|White|Blue] (Case-Sensitive): ")
    	            (bind ?d (readline))
                	)
                (while (and (neq ?e "Biofuel") (neq ?e "Jet Fuel") (neq ?e "Avgas") )
	                (printout t "Input Fuel Type [Biofuel|Jet Fuel|Avgas] (Case-Sensitive): ")
    	            (bind ?e (readline))
                	)                
                (while (or (< ?f 100000) (> ?f 1000000))
                    (printout t "Input Aircraft Price [100000-1000000] (dollars): ")
                    (bind ?f (read))
                    (if (eq (numberp ?f) FALSE) then
                        (printout t "Please Input a Number..." crlf)
                        (bind ?f 0)
                        )
                    )
                (assert (addH ?a ?b ?d ?e ?f))
                (run)
                (printout t "Press ENTER To Continue..." crlf)
                (bind ?chooseSub (readline))
                (bind ?chooseSub 2)
                )
            ;;BACK TO MAIN MENU
            (if (eq ?chooseSub 0) then
                (clearScreen)
                (printout t "Back To Main Menu" crlf)
                (bind ?chooseSub 1)
                )
            )
        )
    ;;UPDATE AIRCRAFT
    (if (eq ?choose 3) then
        (while (and (neq ?chooseSub 1)(neq ?chooseSub 2))
            (clearScreen)
            (AircraftChoice)
	        (printout t ">> Choose [1..2 | 0 back to main menu]: ")
    	    (bind ?chooseSub (read))
            ;;UPDATE AIRPLANE
            (if (eq ?chooseSub 1) then
                (clearScreen)
                (printout t "Airplane Facts" crlf)
                (printout t "===================================================================================" crlf)
                (printout t "|No.	|Name		|Material	|Engine Type	|Color	|Fuel	|Price	|" crlf)
                (printout t "===================================================================================" crlf)
                (assert (viewA))
                (bind ?*counter* 1)
		        (run)
                (printout t "===================================================================================" crlf)
                (-- ?*counter*) ;menyesuaikan urutan dan jumlah list
				(bind ?*chedit* -2) ;inisialisasi globalvar saja
                (while (or (< ?*chedit* 0) (> ?*chedit* ?*counter*))
                    (printout t "Which aircraft to be updated [1-" ?*counter* " | 0 back to main menu]: ")
                    (bind ?*chedit* (read))
                    )
                (if (eq ?*chedit* 0) then
                    (clearScreen)
                    (printout t "Back To Main Menu" crlf)
                    (bind ?chooseSub 1)
                else
                    (bind ?*at* "")
                    (bind ?*bt* "")
                    (bind ?*ct* "")
                    (bind ?*dt* "")
                    (bind ?*et* "")
                    (bind ?*ft* 0)
	                (while (or (eq ?*at* "") (< (str-length ?*at*) 5) (>(str-length ?*at*) 25))
		                (printout t "Input Aircraft Name [5-25 Characters]: ")
	    	            (bind ?*at* (readline))
	                    )
	                (while (and (neq ?*bt* "Titanium") (neq ?*bt* "Alumunium") (neq ?*bt* "Graphite") )
		                (printout t "Input Material Type [Titanium|Alumunium|Graphite] (Case-Sensitive): ")
	    	            (bind ?*bt* (readline))
	                	)
	                (while (and (neq ?*ct* "Jet") (neq ?*ct*"Piston") )
		                (printout t "Input Engine Type [Jet|Piston] (Case-Sensitive): ")
	    	            (bind ?*ct* (readline))
	                	)
	                (while (and (neq ?*dt* "Black") (neq ?*dt* "White") (neq ?*dt* "Blue") )
		                (printout t "Input Aircraft Color [Black|White|Blue] (Case-Sensitive): ")
	    	            (bind ?*dt* (readline))
	                	)
	                (while (and (neq ?*et* "Biofuel") (neq ?*et* "Jet Fuel") (neq ?*et* "Avgas") )
		                (printout t "Input Fuel Type [Biofuel|Jet Fuel|Avgas] (Case-Sensitive): ")
	    	            (bind ?*et* (readline))
	                	)                
	                (while (or (< ?*ft* 100000) (> ?*ft* 1000000))
	                    (printout t "Input Aircraft Price [100000-1000000] (dollars): ")
	                    (bind ?*ft* (read))
	                    (if (eq (numberp ?*ft*) FALSE) then
	                        (printout t "Please Input a Number..." crlf)
	                        (bind ?*ft* 0)
	                        )
	                    )
                    (assert (modifyA ?*chedit*))
					(bind ?*counteredit* 1)
					(run)
	                (bind ?chooseSub (readline))
	                (clearScreen)
	                (bind ?chooseSub 1)     
                    )
                )
            ;;UPDATE HELICOPTER
            (if (eq ?chooseSub 2) then
                (clearScreen)
                (printout t "Helicopter Facts" crlf)
                (printout t "===================================================================================" crlf)
                (printout t "|No.	|Name		|Material	|Engine Type	|Color	|Fuel	|Price	|" crlf)
                (printout t "===================================================================================" crlf)
                (assert (viewH))
                (bind ?*counter* 1)
		        (run)
                (printout t "===================================================================================" crlf)
                (-- ?*counter*) ;menyesuaikan urutan dan jumlah list
				(bind ?*chedit* -2) ;inisialisasi globalvar saja
                (while (or (< ?*chedit* 0) (> ?*chedit* ?*counter*))
                    (printout t "Which aircraft to be updated [1-" ?*counter* " | 0 back to main menu]: ")
                    (bind ?*chedit* (read))
                    )
                (if (eq ?*chedit* 0) then
                    (clearScreen)
                    (printout t "Back To Main Menu" crlf)
                    (bind ?chooseSub 1)
                else
                    (bind ?*at* "")
                    (bind ?*bt* "")
                    (bind ?*ct* "")
                    (bind ?*dt* "")
                    (bind ?*et* "")
                    (bind ?*ft* 0)
	                (while (or (eq ?*at* "") (< (str-length ?*at*) 5) (>(str-length ?*at*) 25))
		                (printout t "Input Aircraft Name [5-25 Characters]: ")
	    	            (bind ?*at* (readline))
	                    )
	                (while (and (neq ?*bt* "Titanium") (neq ?*bt* "Alumunium") (neq ?*bt* "Graphite") )
		                (printout t "Input Material Type [Titanium|Alumunium|Graphite] (Case-Sensitive): ")
	    	            (bind ?*bt* (readline))
	                	)
	                (while (and (neq ?*dt* "Black") (neq ?*dt* "White") (neq ?*dt* "Blue") )
		                (printout t "Input Aircraft Color [Black|White|Blue] (Case-Sensitive): ")
	    	            (bind ?*dt* (readline))
	                	)
	                (while (and (neq ?*et* "Biofuel") (neq ?*et* "Jet Fuel") (neq ?*et* "Avgas") )
		                (printout t "Input Fuel Type [Biofuel|Jet Fuel|Avgas] (Case-Sensitive): ")
	    	            (bind ?*et* (readline))
	                	)                
	                (while (or (< ?*ft* 100000) (> ?*ft* 1000000))
	                    (printout t "Input Aircraft Price [100000-1000000] (dollars): ")
	                    (bind ?*ft* (read))
	                    (if (eq (numberp ?*ft*) FALSE) then
	                        (printout t "Please Input a Number..." crlf)
	                        (bind ?*ft* 0)
	                        )
	                    )
                    (assert (modifyH ?*chedit*))
					(bind ?*counteredit* 1)
					(run)
	                (bind ?chooseSub (readline))
	                (clearScreen)
	                (bind ?chooseSub 2)     
                    )
                )
            ;;BACK TO MAIN MENU
            (if (eq ?chooseSub 0) then
                (clearScreen)
                (printout t "Back To Main Menu" crlf)
                (bind ?chooseSub 1)
                )
            )
        )
    ;; DELETE AIRCRAFT
    (if (eq ?choose 4) then
         (while (and (neq ?chooseSub 1)(neq ?chooseSub 2))
            (clearScreen)
            (AircraftChoice)
	        (printout t ">> Choose [1..2 | 0 back to main menu]: ")
    	    (bind ?chooseSub (read))
            ;;DELETE AIRPLANE
            (if (eq ?chooseSub 1) then
                (clearScreen)
                (printout t "Airplane Facts" crlf)
                (printout t "===================================================================================" crlf)
                (printout t "|No.	|Name		|Material	|Engine Type	|Color	|Fuel	|Price	|" crlf)
                (printout t "===================================================================================" crlf)
                (assert (viewA))
                (bind ?*counter* 1)
		        (run)
                (printout t "===================================================================================" crlf)
                (-- ?*counter*) ;menyesuaikan urutan dan jumlah list
                (bind ?*chdel* -1) ;inisialisasi globalvar saja
                (while (or (< ?*chdel* 0) (> ?*chdel* ?*counter*))
                    (printout t "Which aircraft to be deleted [1-" ?*counter* " | 0 back to main menu]: ")
                    (bind ?*chdel* (read))
                    )
                (if (eq ?*chdel* 0) then
                    (clearScreen)
                    (printout t "Back To Main Menu" crlf)
                    (bind ?chooseSub 1)
                else
                    (assert (removeA ?*chdel*))
					(bind ?*counterdel* 1)
					(run)
                    )
                (printout t "Press Enter to Continue.." crlf)
                (bind ?chooseSub (readline))
                (clearScreen)
                (bind ?chooseSub 1)
                )
            ;;DELETE HELICOPTER
            (if (eq ?chooseSub 2) then
                (clearScreen)
                (printout t "Helicopter Facts" crlf)
                (printout t "=================================================================" crlf)
				(printout t "|No.	|Name		|Material	|Color	|Fuel	|Price	|" crlf)
                (printout t "=================================================================" crlf)
                (assert (viewH))
                (bind ?*counter* 1)
		        (run)
                (printout t "===================================================================================" crlf)
                (-- ?*counter*) ;menyesuaikan urutan dan jumlah list
                (bind ?*chdel* -1) ;inisialisasi globalvar saja
                (while (or (< ?*chdel* 0) (> ?*chdel* ?*counter*))
                    (printout t "Which aircraft to be deleted [1-" ?*counter* " | 0 back to main menu]: ")
                    (bind ?*chdel* (read))
                    )
                (if (eq ?*chdel* 0) then
                    (clearScreen)
                    (printout t "Back To Main Menu" crlf)
                    (bind ?chooseSub 1)
                else
                    (assert (removeH ?*chdel*))
					(bind ?*counterdel* 1)
					(run)
                    )
                (printout t "Press Enter to Continue.." crlf)
                (bind ?chooseSub (readline))
                (clearScreen)
                (bind ?chooseSub 2)
                )
            ;;BACK TO MAIN MENU
            (if (eq ?chooseSub 0) then
                (clearScreen)
                (printout t "Back To Main Menu" crlf)
                (bind ?chooseSub 1)
                )
            )
        )
    (if (eq ?choose 5) then
        (clearScreen)
        (bind ?username "")
        (bind ?aircraft "")
        (bind ?material "")
        (bind ?engineType "")
        (bind ?budget 0)
        (printout t "Aircraft Consultation" crlf)
        (printout t "=====================" crlf)
        (while (or (eq ?username "") (< (str-length ?username) 3) (>(str-length ?username) 20))
	                (printout t "Input Your Name [3-20 Characters]: ")
    	            (bind ?username (readline))
            )
        (while (and (neq ?aircraft "Airplane") (neq ?aircraft "Helicopter"))
		                (printout t "Demanded Aircraft [Airplane|Helicopter] (Case-Sensitive): ")
	    	            (bind ?aircraft (readline))
            )
        (while (and (neq ?material "Titanium") (neq ?material "Alumunium") (neq ?material "Graphite"))
		                (printout t "Demanded Material Type [Titanium|Alumunium|Graphite] (Case-Sensitive): ")
	    	            (bind ?material (readline))
            )
        (if (eq ?aircraft "Airplane") then
            (while (and (neq ?engineType "Jet")(neq ?engineType "Piston"))
                (printout t "Demanded Engine Type [Jet|Piston] (Case-Sensitive): ")
                (bind ?engineType (readline))
                )
            )
        (while (< ?budget 1)
	                    (printout t "Your Budget (Greater than 0): ")
	                    (bind ?budget (read))
	                    (if (eq (numberp ?budget) FALSE) then
	                        (printout t "Please Input a Number..." crlf)
	                        (bind ?budget 0))
            )
        ;;masukin data untuk GUI
        (bind ?Consultation (assert (Consultation (username ?username) (aircraft ?aircraft) (material ?material) (engineType ?engineType) (budget ?budget))))
        (printout t "Press Enter to see your result...")
        (readline)
        (new GUI)
        (retract ?Consultation)
        (clearScreen)
        )
    (if (eq ?choose 6) then
        (printout t "EXIT!!!")    
        )
    )