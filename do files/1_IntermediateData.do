
/*==============================================================================================*/
 *                Brechas de la Carrera Pública Magisterial
/*==============================================================================================*/
* Author: Paola Rojas 
* Last update: 08-19-2023
* Prepared for: Graciela Perez, Gregory Elacqua and Mayte Ysique


* ==============================================================================================
* SECTION A: DIRECTORIES
* ==============================================================================================
clear all
set more off
   
  *A.1 Directory paths
	if "`c(username)'"=="Graciela" {
			global path "C:\Users\      \ReformaMagisterialPeru" 
			//Graciela: Change to your path here
		}
	if "`c(username)'"=="Mayte" {
			global path "C:\Users\      \ReformaMagisterialPeru" 
			//Mayte: Change to your path here
		}		
	if "`c(username)'"=="Rosario" {
			global path  "D:\AGL Dropbox\Paola Nelly Rojas Valero\IDB\ReformaMagisterialPeru"
		   //Paola's PC
		}
	if "`c(username)'"=="PC" {
			global path "C:\Users\PC\AGL Dropbox\Paola Nelly Rojas Valero\IDB\ReformaMagisterialPeru"
		   //Paola's laptop
		}
    pwd

		
  *A.2 Globals
   cd "$path"  
   global nexus        "$path\Data\Input_data\Nexus\With_teacher_ID"
 
* ================================================================================================
* SECTION B: CREATING NEXUS' MASTER DATASET 
* ================================================================================================

**************************************************************************************************
*B.1 Importing raw data: Nexus
**************************************************************************************************
   
  *B.1.1 We have the following excel files:
         *a) 20190314_121226_20190219_101948_docentes_cesados_años
		 *b) 20190314_121342_20190219_101853_Docentes_años_2015_2016
		 *c) 20190314_121522_20190219_10198_docentes_años_2017_2018
		 *d) 20190314_121728_20190219_1000_asigTemporales_AÑOS
		 *e) 20190314_123351_20190206_154755_DOCENTES_CPM_ATS_ESCALAFON
         
  *B.1.2 Importing excel files
         import excel "$nexus\20190314_121226_20190219_101948_docentes_cesados_años.xlsx", sheet("CESES") firstrow
         save "$nexus\ceses_2015_2018.dta", replace		 
         clear
		 import excel "$nexus\20190314_121342_20190219_101853_Docentes_años_2015_2016.xlsx", sheet ("2015") firstrow
		 gen year=2015
         save "$nexus\nexus_2015.dta", replace
         clear
		 import excel "$nexus\20190314_121342_20190219_101853_Docentes_años_2015_2016.xlsx", sheet ("2016") firstrow
		 gen year=2016
         save "$nexus\nexus_2016.dta", replace
         clear
		 import excel "$nexus\20190314_121522_20190219_10198_docentes_años_2017_2018.xlsx", sheet ("2017") firstrow
		 gen year=2017
         save "$nexus\nexus_2017.dta", replace
         clear
		 import excel "$nexus\20190314_121522_20190219_10198_docentes_años_2017_2018.xlsx", sheet ("2018 (2)") firstrow
		 gen year=2018
         save "$nexus\nexus_2018.dta", replace
         clear
		 import excel "$nexus\20190314_121728_20190219_1000_asigTemporales_AÑOS.xlsx", sheet ("2015") firstrow
		 gen year=2015
         save "$nexus\asignaciones_2015.dta", replace
         clear
		 import excel "$nexus\20190314_121728_20190219_1000_asigTemporales_AÑOS.xlsx", sheet ("2016") firstrow
		 gen year=2016
         save "$nexus\asignaciones_2016.dta", replace
         clear
		 import excel "$nexus\20190314_121728_20190219_1000_asigTemporales_AÑOS.xlsx", sheet ("2017") firstrow
		 gen year=2017
         save "$nexus\asignaciones_2017.dta", replace
         clear
		 import excel "$nexus\20190314_121728_20190219_1000_asigTemporales_AÑOS.xlsx", sheet ("2018") firstrow
		 gen year=2018
         save "$nexus\asignaciones_2018.dta", replace
         clear
		 import excel "$nexus\20190314_123351_20190206_154755_DOCENTES_CPM_ATS_ESCALAFON.xlsx", sheet ("Docentes_ats") firstrow
         save "$nexus\escalafon.dta", replace
		 
  *B.1.3 Appending datasets
         clear 
		 local years "2015 2016 2017 2018"	
		 foreach i of local years {
		 append using "$nexus\nexus_`i'.dta"
		 duplicates drop
		 save "$nexus\nexus_2015_2018.dta", replace
		 } 
		 
		 clear
         local years "2015 2016 2017 2018"
		 foreach i of local years {
		 append using "$nexus\asignaciones_`i'.dta", force
		 duplicates drop 
		 save "$nexus\asignaciones_2015_2018.dta", replace	 
		 }
		 
  *B.1.4 Analyzing variables' consistency
    
                          *===============================*
						  *             NEXUS             *
						  *===============================*
		 use "$nexus\nexus_2015_2018.dta", clear
		 		 
	    *I. descreg
		    rename descreg region
			label variable region "region"
		    replace region=strtrim(region)
		
		    gen cod_reg=0
			replace cod_reg=1  if region=="AMAZONAS"			
			replace cod_reg=2  if region=="ANCASH"
			replace cod_reg=3  if region=="APURIMAC"
			replace cod_reg=4  if region=="AREQUIPA"
			replace cod_reg=5  if region=="AYACUCHO"
			replace cod_reg=6  if region=="CAJAMARCA"
			replace cod_reg=7  if region=="CALLAO"
			replace cod_reg=8  if region=="CUSCO"
			replace cod_reg=9  if region=="HUANCAVELICA"
			replace cod_reg=10 if region=="HUANUCO"
			replace cod_reg=11 if region=="ICA"
			replace cod_reg=12 if region=="JUNIN"
			replace cod_reg=13 if region=="LA LIBERTAD"
			replace cod_reg=14 if region=="LAMBAYEQUE"
			replace cod_reg=15 if region=="LIMA METROPOLITANA"
			replace cod_reg=16 if region=="LIMA PROVINCIAS"
			replace cod_reg=17 if region=="LORETO"
			replace cod_reg=18 if region=="MADRE DE DIOS"
			replace cod_reg=19 if region=="MOQUEGUA"
			replace cod_reg=20 if region=="PASCO"
			replace cod_reg=21 if region=="PIURA"
			replace cod_reg=22 if region=="PUNO"
			replace cod_reg=23 if region=="SAN MARTIN"
			replace cod_reg=24 if region=="TACNA"
			replace cod_reg=25 if region=="TUMBES"
			replace cod_reg=26 if region=="UCAYALI"

	    *II. nombreooii
		    label variable nombreooii "Organismo informante"
		    replace nombreooii=strtrim(nombreooii) 
		    replace nombreooii=upper(ustrto(ustrnormalize(nombreooii, "nfd"), "ascii", 2)) 	     
            
			tab nombreooii
            replace nombreooii="COLEGIO MILITAR RAMON CASTILLA" if nombreooii=="UOLEGIO MILITAR RAMON CASTILLA" 
		    tab region if nombreooii=="COLEGIO MILITAR RAMON CASTILLA"
		    tab region if nombreooii=="UGEL ANTONIO RAIMONDI" | nombreooii=="UGEL ANTONIO RAYMONDI"
            replace nombreooii="UGEL ANTONIO RAIMONDI" if nombreooii=="UGEL ANTONIO RAYMONDI" 
			
	    *III. codmodce
		    label variable codmodce "Codigo modular CE"
		    replace codmodce=strtrim(codmodce) 
			
	    *IV. codniveduc and descniveduc
		    label variable codniveduc  "Codigo de nivel educativo"
		    label variable descniveduc "Descripción codigo de nivel educativo"			
			replace descniveduc=upper(ustrto(ustrnormalize(descniveduc, "nfd"), "ascii", 2))
			replace codniveduc=upper(ustrto(ustrnormalize(codniveduc, "nfd"), "ascii", 2))

			tab codniveduc  year 
			tab descniveduc year
			replace codniveduc="0" if descniveduc=="ADMINISTRACION"
			
			sort numdocum year // Given that a teacher has the same "codplaza" 
			                   // throughout the 4 years (2015-2018) of analysis,  
						       // the educational level in which he/she teaches 
						       // must be the same throughout the whole time too.
			replace descniveduc=strtrim(descniveduc) 	
			replace codniveduc=strtrim(codniveduc)
			replace descniveduc="E.B.R. PRIMARIA" if descniveduc=="PRIMARIA"
			replace codniveduc="2" if codniveduc=="B0"			
			replace descniveduc="E.B.R. SECUNDARIA" if descniveduc=="SECUNDARIA"
			replace codniveduc="3" if codniveduc=="F0"
			replace descniveduc="ED. TECNICO PRODUCTIVA" if descniveduc=="TECNICO PRODUCTIVA"
			replace codniveduc="5" if codniveduc=="L0"
			replace descniveduc="E.B.R. INICIAL" if descniveduc=="INICIAL - JARDIN"
			replace codniveduc="1" if codniveduc=="A2"
			replace descniveduc="E.B.A. AVANZADA" if descniveduc=="BASICA ALTERNATIVA-AVANZADO"
			replace codniveduc="7" if codniveduc=="D2"
			replace descniveduc="ED. BASICA ESPECIAL" if descniveduc=="BASICA ESPECIAL"
			replace codniveduc="8" if codniveduc=="E0"
			replace descniveduc="ED. BASICA ESPECIAL" if descniveduc=="BASICA ESPECIAL-PRIMARIA"
			replace codniveduc="8" if codniveduc=="E2"
			replace descniveduc="E.B.R. INICIAL" if descniveduc=="INICIAL - CUNA-JARDIN"
			replace codniveduc="1" if codniveduc=="A3"
			replace descniveduc="E.B.A. AVANZADA" if descniveduc=="SECUNDARIA DE ADULTOS"
			replace codniveduc="7" if codniveduc=="G0"
			replace descniveduc="ED. BASICA ESPECIAL" if descniveduc=="BASICA ESPECIAL-INICIAL"
			replace codniveduc="8" if codniveduc=="E1"
			replace descniveduc="E.B.A. INICIAL-INTERMEDIA" if descniveduc=="PRIMARIA DE ADULTOS"
			replace codniveduc="4" if codniveduc=="C0"
			replace descniveduc="E.B.A. INICIAL-INTERMEDIA" if descniveduc=="BASICA ALTERNATIVA"
			replace codniveduc="4" if codniveduc=="D0"
			replace descniveduc="E.B.A. INICIAL-INTERMEDIA" if descniveduc=="BASICA ALTERNATIVA-INICIAL E I"
			replace codniveduc="4" if codniveduc=="D1"
			
			* Important to take into consideration: "Cabe precisar que según el Currículo 
			* Nacional de la Educación Básica, la Educación Inicial atiende a niños menores 
			* de 6 años y se desarrolla en forma escolarizada y no escolarizada (...)"
			replace descniveduc="E.B.R. INICIAL" if descniveduc=="INICIAL - CUNA"
			replace codniveduc="1" if codniveduc=="A1"
			replace descniveduc="E.B.R. INICIAL" if descniveduc=="INICIAL - PROGRAMA NO ESCOLARI"
			replace codniveduc="1" if codniveduc=="A5"
			replace descniveduc="E.B.R. INICIAL" if descniveduc=="INICIAL - PROGRAMA NO ESCOLARI"
			replace codniveduc="1" if codniveduc=="A5"
			
	    *V. codplaza
		    label variable codplaza "Codigo de plaza"
		    gen length_codplaza=strlen(codplaza)
		    tab length_codplaza
		    *=================
		    *length_codplaza
		    *11: 27
		    *12: 1,569,199
            *==================
		
	    *VI. codcargo, and descargo
		    label variable codcargo "Codigo cargo"
			label variable descargo "Descripcion cargo" 
			replace codcargo=upper(ustrto(ustrnormalize(codcargo, "nfd"), "ascii", 2))
			replace descargo=upper(ustrto(ustrnormalize(descargo, "nfd"), "ascii", 2))
			replace codcargo=strtrim(codcargo)		
			replace descargo=strtrim(descargo)		
		    
			unique descargo, by(codcargo) gen(n_descargo)
			bysort codcargo: egen N_descargo=max(n_descargo)
            drop n_descargo
		    tab N_descargo
		    tab codcargo if N_descargo==2 // There are 5 cases where a unique
			                              // "codcargo" is associated with 2 
			                              // categories of "descargo". We 
										  // identified the cases but we are not
										  // making corrections at this stage.
										  
		    tab descargo if codcargo=="12063" // COORDINADOR DE TUTORIA Y ORIENTACION EDUCATIVA
			                                  // COORDINADOR DE TUTORIA Y DESARROLLO INTEGRAL
		    tab descargo if codcargo=="13003" // DOCENTE COORDINADOR
			                                  // PROFESOR COORDINADOR
		    tab descargo if codcargo=="13004" // DOCENTE COORDINADOR
			                                  // DOCENTE DE CAMPO
		    tab descargo if codcargo=="13056" // COORDINADOR
			                                  // COORDINADOR PEDAGOGICO JEC
		    tab descargo if codcargo=="13057" // COORDINADOR DE TUTORIA JEC
		                                      // PROFESOR COORDINADOR
			drop N_descargo 		
			
	    *VII. codtipotrab, and desctipotrab
            drop codtipotrab
			label variable desctipotrab "Descripcion tipo de trabajo" 
			replace desctipotrab=upper(ustrto(ustrnormalize(desctipotrab, "nfd"), "ascii", 2))
            replace desctipotrab=strtrim(desctipotrab)											  
			tab desctipotrab								  
											  
	    *VIII. codsubtipt, and descsubtipt
			label variable codsubtipt  "Codigo subtipo de trabajo" 
			label variable descsubtipt "Descripcion subtipo de trabajo" 
			replace codsubtipt=upper(ustrto(ustrnormalize(codsubtipt, "nfd"), "ascii", 2))
            replace codsubtipt=strtrim(codsubtipt)	
			replace descsubtipt=upper(ustrto(ustrnormalize(descsubtipt, "nfd"), "ascii", 2))
            replace descsubtipt=strtrim(descsubtipt)											  
		    tab codsubtipt
			tab descsubtipt
					
	    *IX. apellipat, apellImat, and nombres
			label variable apellipat "Apellido paterno" 
			label variable apellImat "Apellido materno" 
			label variable nombres   "Nombres" 
			replace apellipat=upper(ustrto(ustrnormalize(apellipat, "nfd"), "ascii", 2))
			replace apellImat=upper(ustrto(ustrnormalize(apellImat, "nfd"), "ascii", 2))
			replace nombres=upper(ustrto(ustrnormalize(nombres, "nfd"), "ascii", 2))
            replace apellipat=strtrim(apellipat)											  
            replace apellImat=strtrim(apellImat)											  
            replace nombres=strtrim(nombres)											  
			unique apellipat apellImat nombres
	        *There are 474,225 unique combinations of apellipat apellImat nombres.
	
	    *X. numdocum
			label variable numdocum "Numero de documento" 
		    nmissing numdocum // There is one missing value. Since we do not have
			                  // have the teacher's full name, we can not recover 
							  // the variable "Numero de documento". We drop that 
							  // observation.
			drop if numdocum==""
			
			*Analyzing internal consistency: Each "Numero de documento" has to be 
			*associated with a unique combination of "apellipat" + "apellImat" 
			* + "nombres".
			ssc install unique
			unique apellipat apellImat nombres, by (numdocum) gen(DNI_n_teachers)
			bysort numdocum: egen DNI_N_teachers=max(DNI_n_teachers)
		    drop DNI_n_teachers
	        tab DNI_N_teachers
	        
			gen consistency_DNI=0
			replace consistency_DNI=1 if DNI_N_teachers==1
			
			*Case 1:
			*=======
			br if DNI_N_teachers==2 // There are 66,415 cases of inconsistency in 
			                        // this case.
			unique apellipat, by (numdocum) gen(DNI_n_teachers_2)
			bysort numdocum: egen DNI_N_teachers_2=max(DNI_n_teachers_2)
		    drop DNI_n_teachers_2
	        tab DNI_N_teachers_2

			br if DNI_N_teachers_2==2 & DNI_N_teachers==2
									
			*Case 2:
			*=======
			br if DNI_N_teachers==3
			
			*Case 3:
			*=======
			br if DNI_N_teachers==4
			   *Solution:
			    replace apellImat="VILCHEZ DE RUIZ"          if numdocum=="41949310"   
			    replace nombres="IRENE LOURDES"              if numdocum=="41949310" 
				replace consistency_DNI=1                    if numdocum=="41949310"
				
			    replace apellipat="MEJIA"                    if numdocum=="29680525"   
			    replace nombres="WALTHER ROSENDO"            if numdocum=="29680525"   
			    replace apellImat=""                         if numdocum=="29680525"   
                replace consistency_DNI=1                    if numdocum=="29680525" 
				
			    replace apellipat="CAMPOS"                   if numdocum=="29533868"   
			    replace nombres="JENNY NORMA"                if numdocum=="29533868"   
			    replace apellImat=""                         if numdocum=="29533868"   
                replace consistency_DNI=1				     if numdocum=="29533868"
				
			    replace apellipat="RODRIGUEZ"                if numdocum=="10214849"   
			    replace nombres="MANUEL DAVID"               if numdocum=="10214849"   
			    replace apellImat=""                         if numdocum=="10214849"   
                replace consistency_DNI=1				     if numdocum=="10214849"
				
			    replace apellipat="LUNA"                     if numdocum=="05710417"   
			    replace nombres="GLORIA AMELIA"              if numdocum=="05710417"   
			    replace apellImat=""                         if numdocum=="05710417" 
                replace consistency_DNI=1				     if numdocum=="05710417"

			    replace apellipat="ALVAREZ"                  if numdocum=="05399704"   
			    replace nombres="MARIA IRENE"                if numdocum=="05399704"   
			    replace apellImat="YUMBATO VDA. DE REATEGUI" if numdocum=="05399704"   
                replace consistency_DNI=1				     if numdocum=="05399704" 
				
				replace numdocum="19030774" if apellipat=="ARANGURI" & apellImat=="CASTRO" & nombres=="EXEQUIEL MANUEL"
                replace consistency_DNI=1				     if numdocum=="19030774" 
				
				replace numdocum="18090030" if apellipat=="NUNEZ" & apellImat=="RODRIGUEZ" & nombres=="DORA LUZ"
                replace consistency_DNI=1				     if numdocum=="18090030"
				
				replace numdocum="22497738" if apellipat=="VILLANUEVA" & apellImat=="RUIZ" & nombres=="ELI"
                replace consistency_DNI=1				     if numdocum=="22497738"
				
				drop if numdocum=="00000000"  // There is not match between the variable "Numero 
			                                  // de documento" and "apellipat" + "apellImat" 
									          // + "nombres"according to RENIEC and SUNEDU.
				
				
			*Case 4:
			*=======
			br if DNI_N_teachers==5
			   *Solution:
			    drop if DNI_N_teachers==5 // 7 observations were deleted. There are 
			                              // not match between the variables "Numero 
			                              // de documento" and "apellipat" + "apellImat" 
									      // + "nombres"according to RENIEC and SUNEDU.
			*Case 5:
			*=======
			br if DNI_N_teachers==546
			count if DNI_N_teachers==546     // We have 1,062 observations in this scenario.
			tab region if DNI_N_teachers==546// Ancash [2] and Tumbes [1,060]
			tab descniveduc if DNI_N_teachers==546 // ADMINISTRACION            [10]
			                                       // E.B.A. AVANZADA           [69]
												   // E.B.A. INICIAL-INTERMEDIA [7]
												   // E.B.R. INICIAL            [148]
												   // E.B.R. PRIMARIA           [414]
												   // E.B.R. SECUNDARIA         [349]
												   // ED. BASICA ESPECIAL       [32]
												   // ED. TECNICO PRODUCTIVA    [33]
			unique codmodce if DNI_N_teachers==546 // Unique values of codmodce: 192
			unique codplaza if DNI_N_teachers==546 // Unique values of codplaza: 562
			   *Solution:
			    drop if DNI_N_teachers==546 // 1,062 observations were deleted. There are 
			                                // not match between the variables "Numero 
			                                // de documento" and "apellipat" + "apellImat" 
									        // + "nombres"according to RENIEC and SUNEDU.
			
			
	    *IX. codcatrem
			label variable codcatrem  "Categoria remunerativa" 
			replace codcatrem=upper(ustrto(ustrnormalize(codcatrem, "nfd"), "ascii", 2))
            replace codcatrem=strtrim(codcatrem)											  
            tab codcatrem year // We identify the following 	
			
			br if codcatrem=="A"
			br if codcatrem=="AE"
			br if codcatrem=="B"
			br if codcatrem=="C"
			br if codcatrem=="D"
			br if codcatrem=="E"
			br if codcatrem=="F2"
			br if codcatrem=="SE"
			
			
                          *===============================*
						  *          ASIGNACIONES         *
						  *===============================*
		 use "$nexus\asignaciones_2015_2018.dta", clear
		 	 		 
	    *I. Keeping key variables for the analysis.
		    keep TDOCUMENTO NDOCUMENTO PATERNO MATERNO NOMBRES year TIPODOCUMENTO ASIGNACION ASIGNACIONES
            duplicates drop // Duplicates in terms of key variables: 0 
		    
	    *II. Standardizing variables
			rename (NDOCUMENTO PATERNO MATERNO NOMBRES) (numdocum apellipat apellImat nombres)
			
			tab TDOCUMENTO year    // 2015, 2016, and 2017
			tab TIPODOCUMENTO year // 2018
			gen tipodocum=TDOCUMENTO
			replace tipodocum=TIPODOCUMENTO if year==2018
			nmissing tipodocum
			tab tipodocum
			drop TDOCUMENTO TIPODOCUMENTO
			
			replace apellipat=upper(ustrto(ustrnormalize(apellipat, "nfd"), "ascii", 2))
			replace apellImat=upper(ustrto(ustrnormalize(apellImat, "nfd"), "ascii", 2))
			replace nombres=upper(ustrto(ustrnormalize(nombres, "nfd"), "ascii", 2))
			replace apellipat=stritrim(apellipat)
			replace apellImat=stritrim(apellImat)
			replace nombres=stritrim(nombres)
			
			tab ASIGNACION year   // 2015, 2016, and 2017
			tab ASIGNACIONES year // 2018
			gen asignaciones=ASIGNACION
			replace asignaciones=ASIGNACIONES if year==2018
			nmissing asignaciones
			tab asignaciones
			drop ASIGNACION ASIGNACIONES

			replace asignaciones=upper(ustrto(ustrnormalize(asignaciones, "nfd"), "ascii", 2))
			replace asignaciones=stritrim(asignaciones)
		
				
	    *III. Consistency analysis: numdocum, apellipat, apellImat, and nombres
			label variable numdocum "Numero de documento" 
		    nmissing numdocum // There is one missing value. Since we do not have
			                  // have the teacher's full name, we can not recover 
							  // the variable "Numero de documento". We drop that 
							  // observation.
			br if numdocum==""				  
			drop if numdocum==""
			
			*Analyzing internal consistency: Each "numdocum" has to be 
			*associated with a unique combination of "apellipat" + "apellImat" 
			* + "nombres".
			ssc install unique
			unique apellipat apellImat nombres, by (numdocum) gen(numdoc_n_teachers)
			bysort numdocum: egen numdoc_N_teachers=max(numdoc_n_teachers)
		    drop numdoc_n_teachers
	        tab numdoc_N_teachers
			
			gen consistency_numdoc=0
			replace consistency_numdoc=1 if numdoc_N_teachers==1
			sort numdocum year
						
									
			*Case 1: We begin for the easiest case to solve.
			*=======
			br if numdoc_N_teachers==3 // There are 68 cases of inconsistency 			
            replace apellImat="BOLO"                   if numdocum=="00486164"
            replace apellipat="VELASQUEZ"              if numdocum=="00486164"			
			replace nombres="MARTA YSABEL"             if numdocum=="02735424"
            replace apellImat="BOLO"                   if numdocum=="15614066"
            replace apellipat="CHAPOAN"                if numdocum=="15614066"
			replace nombres="MARIA HERMELINDA"         if numdocum=="15614066"		
            replace apellImat="GERONIMO DE PALOMARES"  if numdocum=="16025175"
            replace apellipat="SIGUENAS"               if numdocum=="16535746"
            replace apellImat="DE BECERRA"             if numdocum=="16561243"
            replace apellipat="CASTANEDA"              if numdocum=="16561243"
            replace apellImat="QUIONEZ"                if numdocum=="16721681"
            replace apellImat="FRAIRE"                 if numdocum=="17434149"
            replace apellipat="ZENA"                   if numdocum=="17556571"			
			replace nombres="TOMAS ELEUTERIO"          if numdocum=="17556571"
            replace apellImat="PIO DE HUERTO"          if numdocum=="22461478"			
            replace apellImat="SANTIAGO DE CHAGUA"     if numdocum=="22489824"			
            replace apellImat="VILLALOBOS DE VILLEGAS" if numdocum=="23994546"			
            replace apellImat="MEZA DE CARMONA"        if numdocum=="26703684"
            replace apellipat="FABIAN"                 if numdocum=="26703684"
			replace nombres="FELICITA LIDIA"           if numdocum=="26703684"		
            replace apellImat="SANCHEZ"                if numdocum=="27046244"
            replace apellImat="FERNANDEZ"              if numdocum=="27081877"
            replace apellipat="MEJIA"                  if numdocum=="27081877"
            replace apellipat="PEREZ"                  if numdocum=="27262002"
			replace apellImat="PEREIRA"                if numdocum=="27262002"
			replace nombres="MARIA MERCEDES"           if numdocum=="27262002"		
			replace apellImat="VASQUEZ"                if numdocum=="27716944"
            replace apellipat="VASQUEZ"                if numdocum=="46043096"
			replace apellImat="GONZALEZ"               if numdocum=="46043096"
			
			*Case 2:
			*=======
			br if numdoc_N_teachers==2 // There are 6,517 cases of inconsistency 
			*Since the number of inconsistency cases is high to analyze one by one,  
			*we are going to impose a weaker restriction.
			unique apellipat nombres, by (numdocum) gen(numdoc_n_teachers)
			bysort numdocum: egen weaker_numdoc_N_teachers=max(numdoc_n_teachers)
		    drop numdoc_n_teachers
	        tab weaker_numdoc_N_teachers // There are 3,389 cases of inconsistency. 
			
			gen weaker_consistency_numdoc=0
			replace weaker_consistency_numdoc=1 if weaker_numdoc_N_teachers==1
			sort numdocum year
            br if weaker_consistency_numdoc==0
			

			
			
			
	
	
	    *II. In our setting, each bidder can only submit one bid per auction. 
		     gen observations=1
		     bysort CodigoExterno Codigoitem: egen num_bids=sum(observations)
		     unique RutProveedor, by (CodigoExterno Codigoitem) gen(num_fimr_auction)
		     bysort CodigoExterno Codigoitem: egen TFimr_auction=max(num_fimr_auction) 
		     drop num_fimr_auction

		     gen submit_onebid=0
		     replace submit_onebid=1 if TFimr_auction==num_bids
		     tab submit_onebid		 	 
		     *======================================================================
             *Information to be included in the Annex A. 
		     unique CodigoExterno Codigoitem if submit_onebid==1
		     *Number of unique values of "CodigoExterno" and "Codigoitem": 488,308
		     *Number of record is: 2,343,160
		     *======================================================================
	         keep if submit_onebid==1
			  	
				
	     *III. We are only considering auctions with at least two bidders.
		     tab num_bids		 
		     *======================================================================
             *Information to be included in the Annex A. 
		     unique CodigoExterno Codigoitem if num_bids!=1
		     *Number of unique values of "CodigoExterno" and "Codigoitem": 416,944
		     *Number of record is: 2,271,796
		     *======================================================================
		     drop if num_bids==1 // Auctions with at least two bids
			   	
				
	     *IV. Single winning bidder per auction (CodigoExterno Codigoitem)
		     gen winner_bidder=0 
		     replace winner_bidder=1 if Ofertaseleccionada=="Seleccionada"
		     bysort CodigoExterno Codigoitem: egen num_winners=sum(winner_bidder)
		     tab num_winners
		     *======================================================================
             *Information to be included in the Annex A. 
		     unique CodigoExterno Codigoitem if num_winners==1
		     *Number of unique values of "CodigoExterno" and "Codigoitem": 360,564
		     *Number of record is: 1,995,983
		     *======================================================================
		     drop if num_winners!=1 // Single winning bidder per auction (CodigoExterno Codigoitem)		   
		  
		  
	     *V. Last checks 
		    duplicates r CodigoExterno Codigoitem RutProveedor 
		    replace Rubro1=strtrim(Rubro1)
		    replace Rubro2=strtrim(Rubro2)
		    replace Rubro3=strtrim(Rubro3)
		    save "$datasets\biddings_ChileCompras_MED2017-2021.dta", replace
          
		 
		 
		 
          foreach i of local years {
		     foreach j of local quarters {
			   import excel "$biddings\bid_`i'_`j'_MEDICINE.xlsx", sheet("Sheet1") firstrow
		       gen year=`i'
		       drop A
			   drop Codigo Descripcion CodigoEstado Link                //Dropping irrelevant variables
	           drop CodigoTipo Informada TipoConvocatoria               //Dropping irrelevant variables
			   drop CodigoMoneda DireccionUnidad Tiempo                 //Dropping irrelevant variables
			   drop EstadoPublicidadOfertas CodigoEstadoLicitacion      //Dropping irrelevant variables
			   drop EstadoCS Contrato Obras DireccionEntrega            //Dropping irrelevant variables
			   drop FechaEstimadaFirma FechaTiempoEvaluacion            //Dropping irrelevant variables
			   drop UnidadTiempoEvaluacion FechaEntregaAntecedentes     //Dropping irrelevant variables		   
			   drop FechasUsuario FechaVisitaTerreno FechaPubRespuestas //Dropping irrelevant variables
			   drop FuenteFinanciamiento Estimacion                     //Dropping irrelevant variables
			   drop FechaSoporteFisico DireccionVisita                  //Dropping irrelevant variables
		       drop UnidadTiempo ValorTiempoRenovacion Modalidad        //Dropping irrelevant variables
			   drop TipoPago UnidadTiempoContratoLicitacion             //Dropping irrelevant variables
		       drop UnidadTiempoDuracionContrato TiempoDuracionContrato //Dropping irrelevant variables
			   drop ProhibicionContratacion ObservacionContrato         //Dropping irrelevant variables
			   drop EsBaseTipo EsRenovable TipoAprobacion               //Dropping irrelevant variables
               drop JustificacionPublicidad JustificacionMontoEstimado  //Dropping irrelevant variables
               drop SubContratacion TipoDuracionContrato                //Dropping irrelevant variables
               drop PeriodoTiempoRenovacion NombredelaOferta            //Dropping irrelevant variables
               drop DescripcionlineaAdquisicion                         //Dropping irrelevant variables
               drop DescripcionProveedor CantidadReclamos               //Dropping irrelevant variables
			   drop Correlativo NumeroOferentes TomaRazon               //Dropping irrelevant variables
			   drop FechaCreacion FechaCierre FechaInicio               //Dropping irrelevant variables
			   drop FechaActoAperturaTecnica                            //Dropping irrelevant variables
			   drop FechaPublicacion FechaEstimadaAdjudicacion          //Dropping irrelevant variables
			   drop FechaFinal FechaAprobacion FechaEnvioOferta         //Dropping irrelevant variables
		       drop Nombre CodigoSucursalProveedor                      //Dropping irrelevant variables
			   drop CodigoUnidad Tipo MonedaAdquisicion                 //Dropping irrelevant variables
			   drop ComunaUnidad VisibilidadMonto Etapas                //Dropping irrelevant variables
               drop EstadoEtapas Estado NumeroAprobacion                //Dropping irrelevant variables
			   drop NombreProveedor CodigoProveedor                     //Dropping irrelevant variables
			   drop FechaActoAperturaEconomica                          //Dropping irrelevant variables
			   
			   save "$biddings\bid_`i'_`j'_MEDICINE.dta", replace
		       clear all
			 }
		   }
		   
  *B.1.2 Appending datasets (Quarterly frequency)
         clear all
		 local years "2017 2018 2019 2020 2021"
		 local quarters "1 2 3 4"
		  
		  foreach i of local years {
		     foreach j of local quarters {
			   append using "$biddings\bid_`i'_`j'_MEDICINE.dta"   
			   save "$biddings\bid_MEDICINE_all.dta", replace
			 }
		   }	   
		 duplicates r // There are duplicates in terms of all variables.
		 duplicates tag, gen(duplicates_all) // Why do we have duplicates? 
	     tab duplicates_all // Do we find this phenomenon every year?
	     tab year if duplicates_all!=0
	     duplicates drop // We are dropping all the duplicates in terms of all variables.
		 drop duplicates_all 
		 
	     *Are there duplicates in terms of "CodigoExterno", "Codigoitem", and "RutProveedor"?
		 duplicates r CodigoExterno Codigoitem RutProveedor if EstadoOferta=="Aceptada"
		 *There is a possibility that a bidder may submit more than one bid per auction.
         save "$biddings\bid_MEDICINE_all.dta", replace
		 
		 *======================================================================
         *Information to be included in the Annex A. 
		  unique CodigoExterno Codigoitem
		 *Number of unique values of "CodigoExterno" and "Codigoitem": 496,724
		 *Number of record is: 2,475,495
         *======================================================================
		 








/* SOME COMMANDS USED
ssc install ereplace, replace
ssc install distinct, replace
ssc install ietoolkit, replace
ssc install matchit, replace
ssc install reclink, replace
*/

/*************************************
    BASE DE REGISTRO DE ESCUELAS EIB 
**************************************/
	import excel "Data/Raw/Registro Nacional IIEE_EIB_2022.xlsx", sheet("Sheet1") cellrange(A2:R28186) firstrow case(lower) clear
	keep códigomodular nombredelenguaoriginaria1 nombredelenguaoriginaria2 nombredelenguaoriginaria3
	duplicates drop códigomodular, force
	gen EIB=1
	destring códigomodular, gen(cod_mod)
	save "Data/Intermediate/EIB2022.dta", replace
	
/*************************************
BASE DE REGISTRO DE DOCENTES BILINGÜES CERTIFICADOS
**************************************/
	import excel "Data/Raw/anexo-3-padron-de-docentes-bilingues-acreditados.xlsx", sheet("Anexo3") cellrange(A2:I69447) firstrow case(lower) clear
	gen DOCENTE_EIB=1
	save "Data/Intermediate/PADRON_DOCENTEEIB_2022.dta", replace
	
		
/*************************************
 BASE DE DATOS INSTITUTOS/UNIVERSIDADES
**************************************/
	*Revision de la base de datos de titulos, para identificar titulos de ISP y UNIV Publicas y Privadas
	import excel "Data/Raw/rptInstitucionPorGrupo.xls", sheet("instituciones") cellrange(A2:I3862) firstrow clear
	drop A E G I
	drop RÉGIMEN
	keep if B=="1 Entidad Pública" | B=="2 Entidad Privada" 
	rename B REGIMEN
	drop if CÓDIGO=="15null" | CÓDIGO=="16null" | CÓDIGO=="25null" | CÓDIGO=="26null"
	keep if TIPO=="5 Instituto Superior Pedagógico (ISP)" | TIPO=="5 Instituto Superior Pedagógico (ISP)" | TIPO=="6 Universidad (UNIV)"
	
	gen TITULO_PROCEDENCIA_NOMBRE = ustrupper(substr(INSTITUCIÓN,8,.))
	
	gen id_inst=_n
	save "Data/Intermediate/INST_PEDAG.dta", replace	

		
/*************************************
		CONCURSO MAGISTERIAL
**************************************/

	******************** 2009 ****************************
	
		import excel "Data/Raw/CPM/Concurso 2009/2009_innominada_VF2.xlsx", sheet("Base Evaluados-OFIN 2009") firstrow clear
		save "Data/Intermediate/CPM_2009_innominada.dta", replace
		
		import excel "Data/Raw/CPM/Concurso 2009/Evaluados Concurso Público para nombramiento en el nivel I a la CPM 2009, 2011 y 2015_nominadax.xlsx", firstrow sheet("Base Evaluados-OTIC 2009") clear
		gen id=ord


		gen AÑO=2009
		gen ID_DOCENTE=documento
		gen APELLIDO_PATERNO=apellido_paterno
		gen APELLIDO_MATERNO=apellido_materno
		gen NOMBRES=nombres
		gen NIVEL=nivel_educativo
		gen PUNTAJE=puntaje_pc
		gen PRUEBA_APROBADO=(situacion_pc=="Clasificado")
		
		merge 1:1 id using "Data/Intermediate/CPM_2009_innominada.dta", force
		
		gen FECHA_NAC=fech15
		gen EDAD=edad
			gen EDAD_GRUPOS=1 if EDAD<=25 
			replace EDAD_GRUPOS=2 if EDAD<=30 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=3 if EDAD<=35 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=4 if EDAD<=40 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=5 if EDAD<=45 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=6 if EDAD<=50 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=7 if EDAD>=51 & EDAD_GRUPOS==. & EDAD!=.
				label define edad_g 1 "Menor de 25 años" 2 "Entre 26 y 30 años" 3 "Entre 31 y 35 años" 4 "Entre 36 y 40 años" 5 "Entre 41 y 45 años" 6 "Entre 46 y 50 años" 7 "Mayor a 51 años" 
				label values EDAD_GRUPOS edad_g
			
		gen SEXO=sexo
			label define sexo 1 "Masculino" 2 "Femenino"
			label values SEXO sexo
			
		replace postgrad="" if postgrad=="*"
		destring postgrad, gen(EDU_POSTGRADO)
			label define educ 1 "Doctorado" 2 "Maestria" 3 "Diplomado o Especializacion" 4 "Estudiando"
			label values EDU_POSTGRADO educ
		
		replace experien="" if experien=="*"
		destring experien, gen(EXPERIENCIA)
		recode EXPERIENCIA (1=4) (2=3) (3=2) (4=1)
			label define expe 1 "Menos de un año" 2 "Entre 2 y 4 años" 3 "Entre 5 y 10 años" 4 "Más de 10 años"
			label values EXPERIENCIA expe
		
		replace titulado="" if titulado=="*"
		destring titulado, gen(TITULO_PROCEDENCIA)
			label define titulo 1 "INST. SUP. PEDAGOGICO" 2 "UNIVERSIDAD" 3 "AMBOS"
			label values TITULO_PROCEDENCIA titulo
		
		gen REGION=region
		gen NOMBRADO=(fingreso!=.) //Revisar que 10 prof fueron nombrados sin aprobar el examen
		gen REGION_NOMB=O
		gen CICLO_NOMB=nivelciclo
			replace CICLO_NOMB="Inicial" if CICLO_NOMB=="INICIAL"
			replace CICLO_NOMB="Primaria" if CICLO_NOMB=="PRIMARIA"
			replace CICLO_NOMB="Secundaria" if CICLO_NOMB=="SECUNDARIA"
		
		gen TIPO_EI_NOMB=tipodeie
			replace TIPO_EI_NOMB="Multigrado" if TIPO_EI_NOMB=="MULTIGRADO"
			replace TIPO_EI_NOMB="Polidocente" if TIPO_EI_NOMB=="POLIDOCENTE"
			replace TIPO_EI_NOMB="Unidocente" if TIPO_EI_NOMB=="UNIDOCENTE"
			
		gen AREA_NOMB="RURAL" if caracteristicadelaie=="RURAL"
		replace AREA_NOMB="RURAL" if caracteristicadelaie=="BILINGÜE" //REVISAR ESTO CON EL DISTRITO DE LA EI
		replace AREA_NOMB="URBANO" if caracteristicadelaie=="URBANA" | caracteristicadelaie=="URBANO"
		
		gen EIB_NOMB=(caracteristicadelaie=="BILINGÜE")
		
		keep AÑO ID_DOCENTE APELLIDO_PATERNO APELLIDO_MATERNO NOMBRES NIVEL PUNTAJE PRUEBA_APROBADO EDU_POSTGRADO EXPERIENCIA TITULO_PROCEDENCIA EDAD EDAD_GRUPOS SEXO REGION NOMBRADO REGION_NOMB CICLO_NOMB TIPO_EI_NOMB AREA_NOMB EIB_NOMB
		save "Data/Intermediate/CPM2009.dta", replace
		
	******************** 2011 ****************************
		import excel "Data/Raw/CPM/Concurso 2009/2011_innominada_VF2.xlsx", sheet("Base Evaluados-OFIN 2011") firstrow clear
		save "Data/Intermediate/CPM_2011_innominada.dta", replace
		
		import excel "Data/Raw/CPM/Concurso 2009/Evaluados Concurso Público para nombramiento en el nivel I a la CPM 2009, 2011 y 2015_nominadax.xlsx", firstrow sheet("Base Evaluados-OTIC 2011") clear
		gen id=ord


		gen AÑO=2011
		gen ID_DOCENTE=documento
		gen APELLIDO_PATERNO=apellido_paterno
		gen APELLIDO_MATERNO=apellido_materno
		gen NOMBRES=nombres
		gen NIVEL=nivel_educativo
		gen PUNTAJE=puntaje_pc
		gen PRUEBA_APROBADO=(situacion_pc=="Clasificado")
		
		merge 1:1 id using "Data/Intermediate/CPM_2011_innominada.dta", force
		
		gen FECHA_NAC=fech15
		gen EDAD=edad
			gen EDAD_GRUPOS=1 if EDAD<=25 
			replace EDAD_GRUPOS=2 if EDAD<=30 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=3 if EDAD<=35 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=4 if EDAD<=40 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=5 if EDAD<=45 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=6 if EDAD<=50 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=7 if EDAD>=51 & EDAD_GRUPOS==. & EDAD!=.
			replace EDAD_GRUPOS=.a if EDAD==.
				label define edad_g 1 "Menor de 25 años" 2 "Entre 26 y 30 años" 3 "Entre 31 y 35 años" 4 "Entre 36 y 40 años" 5 "Entre 41 y 45 años" 6 "Entre 46 y 50 años" 7 "Mayor a 51 años" .a "Sin Datos"
				label values EDAD_GRUPOS edad_g
		
		gen SEXO=sexo
			label define sexo 1 "Masculino" 2 "Femenino"
			label values SEXO sexo
			
		replace estpos="" if estpos=="*"
		destring estpos, gen(EDU_POSTGRADO)
			label define educ 1 "Doctorado" 2 "Maestria" 3 "Diplomado o Especializacion" 4 "Estudiando"
			label values EDU_POSTGRADO educ
		
		gen EXPERIENCIA=.
		
		gen TITULO_PROCEDENCIA=.
		
		gen REGION=region
		gen NOMBRADO=(fingreso!=.) //Revisar que 10 prof fueron nombrados sin aprobar el examen
		gen REGION_NOMB=N
		gen CICLO_NOMB=nivelciclo
			replace CICLO_NOMB="Inicial" if CICLO_NOMB=="INICIAL"
			replace CICLO_NOMB="Primaria" if CICLO_NOMB=="PRIMARIA"
			replace CICLO_NOMB="Secundaria" if CICLO_NOMB=="SECUNDARIA"
		
		gen TIPO_EI_NOMB=tipodeie
			replace TIPO_EI_NOMB="Multigrado" if TIPO_EI_NOMB=="MULTIGRADO"
			replace TIPO_EI_NOMB="Polidocente" if TIPO_EI_NOMB=="POLIDOCENTE"
			replace TIPO_EI_NOMB="Unidocente" if TIPO_EI_NOMB=="UNIDOCENTE"
			
		gen AREA_NOMB="RURAL" if caracteristicadelaie=="RURAL"
		replace AREA_NOMB="RURAL" if caracteristicadelaie=="BILINGÜE" //REVISAR ESTO CON EL DISTRITO DE LA EI
		replace AREA_NOMB="URBANO" if caracteristicadelaie=="URBANA" | caracteristicadelaie=="URBANO"
		
		gen EIB_NOMB=(caracteristicadelaie=="BILINGÜE")
		
		keep AÑO ID_DOCENTE APELLIDO_PATERNO APELLIDO_MATERNO NOMBRES NIVEL PUNTAJE PRUEBA_APROBADO EDU_POSTGRADO EXPERIENCIA TITULO_PROCEDENCIA EDAD EDAD_GRUPOS SEXO REGION NOMBRADO REGION_NOMB CICLO_NOMB TIPO_EI_NOMB AREA_NOMB EIB_NOMB
		save "Data/Intermediate/CPM2011.dta", replace	
	
	******************** 2015 ****************************
		import excel "Data/Raw/CPM/Concurso 2009/Evaluados Concurso Público para nombramiento en el nivel I a la CPM 2009, 2011 y 2015_nominadax.xlsx", firstrow sheet("Base Evaluados - DIED 2015") clear
		merge 1:m documento using "Data/Raw/CPM/Concurso 2015/seleccion_prim_fase_2015.dta", keepusing(cod_mod) keep(1 3)
		drop _m
		merge m:1 cod_mod using "Data/Intermediate/EIB2022.dta", keep(1 3) keepusing(EIB)
		replace EIB=0 if EIB ==.
		bysort documento: egen EIB_POST=max(EIB)
		bysort documento: gen N_POSTULACIONES=_N
		drop EIB cod_mod _m
		duplicates drop
		
		gen AÑO=2015
		gen ID_DOCENTE=documento
		gen APELLIDO_PATERNO=apellido_paterno
		gen APELLIDO_MATERNO=apellido_materno
		gen NOMBRES=nombres
		gen NIVEL=""
		gen PUNTAJE_CT=puntaje_sp1_CT
		gen PUNTAJE_RL=puntaje_sp2_RL
		gen PUNTAJE_CC=puntaje_sp3_CC
		gen PUNTAJE=puntaje_pun
		gen PRUEBA_APROBADO=(situacion_pun=="Clasificado")
			
		gen FECHA_NAC=""
		gen EDAD=edad
			gen EDAD_GRUPOS=1 if EDAD<=25 
			replace EDAD_GRUPOS=2 if EDAD<=30 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=3 if EDAD<=35 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=4 if EDAD<=40 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=5 if EDAD<=45 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=6 if EDAD<=50 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=7 if EDAD>=51 & EDAD_GRUPOS==. & EDAD!=.
			replace EDAD_GRUPOS=.a if EDAD==.
				label define edad_g 1 "Menor de 25 años" 2 "Entre 26 y 30 años" 3 "Entre 31 y 35 años" 4 "Entre 36 y 40 años" 5 "Entre 41 y 45 años" 6 "Entre 46 y 50 años" 7 "Mayor a 51 años" .a "Sin Datos"
				label values EDAD_GRUPOS edad_g
				
		gen SEXO=1 if sexo=="Hombre"
			replace SEXO=2 if sexo=="Mujer"
			label define sexo 1 "Masculino" 2 "Femenino"
			label values SEXO sexo
			
		gen EDU_POSTGRADO=.
		
		gen EXPERIENCIA_PUB=exp_publica
		gen EXPERIENCIA_PRIV=exp_privada
		gen EXPERIENCIA_TOTAL=exp_publica+exp_privada
		gen EXPERIENCIA=1 if EXPERIENCIA_TOTAL<=1
			replace EXPERIENCIA=2 if EXPERIENCIA_TOTAL<=4 & EXPERIENCIA==.
			replace EXPERIENCIA=3 if EXPERIENCIA_TOTAL<=10 & EXPERIENCIA==.
			replace EXPERIENCIA=4 if EXPERIENCIA_TOTAL>10 & EXPERIENCIA==.
			
			label define expe 1 "Menos de un año" 2 "Entre 2 y 4 años" 3 "Entre 5 y 10 años" 4 "Más de 10 años"
			label values EXPERIENCIA expe

			
		gen TITULO_PROCEDENCIA=1 if INS=="SI" & UNI=="NO"
			replace TITULO_PROCEDENCIA=2 if UNI=="SI" & INS=="NO"
			replace TITULO_PROCEDENCIA=3 if UNI=="SI" & INS=="SI"
			label define titulo 1 "INST. SUP. PEDAGOGICO" 2 "UNIVERSIDAD" 3 "AMBOS"
			label values TITULO_PROCEDENCIA titulo	
		
		gen TITULO_PROCEDENCIA_NOMBRE=""

		gen REGION=region_evaluado
		gen NOMBRADO=(ganador=="Ganador") 
		
		gen REGION_NOMB=region_selec
		
		gen CICLO_NOMB=mod
			replace CICLO_NOMB="Inicial" if CICLO_NOMB=="EBR INICIAL"
			replace CICLO_NOMB="Primaria" if CICLO_NOMB=="EBR PRIMARIA"
			replace CICLO_NOMB="Secundaria" if CICLO_NOMB=="EBR SECUNDARIA"
		
		gen TIPO_EI_NOMB="" //Podemos juntar el padron 2015 para averiguar
			
		gen AREA_NOMB="" //Podemos juntar el padron 2015 para averiguar
		
		gen EIB_NOMB=. //Podemos juntar el padron 2015 para averiguar
		
		keep AÑO ID_DOCENTE APELLIDO_PATERNO APELLIDO_MATERNO NOMBRES NIVEL PUNTAJE* PRUEBA_APROBADO EDU_POSTGRADO EXPERIENCIA TITULO_PROCEDENCIA EDAD EDAD_GRUPOS SEXO REGION NOMBRADO REGION_NOMB CICLO_NOMB TIPO_EI_NOMB AREA_NOMB EIB_NOMB EIB_POST TITULO_PROCEDENCIA_NOMBRE N_POSTULACIONES
		save "Data/Intermediate/CPM2015.dta", replace	
		
	
	******************** 2017 ****************************	
		use "Data/Raw/CPM/Concurso 2017/1b_Evaluados_etapa_nacional_2017.dta", clear
		
		gen AÑO=2017
		gen ID_DOCENTE=documento
			tostring ID_DOCENTE, replace
		gen APELLIDO_PATERNO=apellido_paterno
		gen APELLIDO_MATERNO=apellido_materno
		gen NOMBRES=nombre
		gen NIVEL=""
		gen PUNTAJE_CT=puntaje_sp1
		gen PUNTAJE_RL=puntaje_sp2
		gen PUNTAJE_CC=puntaje_sp3
		gen PUNTAJE=puntaje_pun
		gen PRUEBA_APROBADO=(situacion_pun=="Clasificado")
			
		gen FECHA_NAC=fecha_nac
		gen EDAD=edad
			gen EDAD_GRUPOS=1 if EDAD<=25 
			replace EDAD_GRUPOS=2 if EDAD<=30 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=3 if EDAD<=35 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=4 if EDAD<=40 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=5 if EDAD<=45 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=6 if EDAD<=50 & EDAD_GRUPOS==.
			replace EDAD_GRUPOS=7 if EDAD>=51 & EDAD_GRUPOS==. & EDAD!=.
			replace EDAD_GRUPOS=.a if EDAD==.
				label define edad_g 1 "Menor de 25 años" 2 "Entre 26 y 30 años" 3 "Entre 31 y 35 años" 4 "Entre 36 y 40 años" 5 "Entre 41 y 45 años" 6 "Entre 46 y 50 años" 7 "Mayor a 51 años" .a "Sin Datos"
				label values EDAD_GRUPOS edad_g
		
		gen SEXO=1 if sexo=="Masculino"
			replace SEXO=2 if sexo=="Femenino"
			label define sexo 1 "Masculino" 2 "Femenino"
			label values SEXO sexo
			
		gen EDU_POSTGRADO=.
		/*
		gen EXPERIENCIA_PUB=exp_publica
		gen EXPERIENCIA_PRIV=exp_privada
		gen EXPERIENCIA_TOTAL=exp_publica+exp_privada
		gen EXPERIENCIA=1 if EXPERIENCIA_TOTAL<=1
			replace EXPERIENCIA=2 if EXPERIENCIA_TOTAL<=4 & EXPERIENCIA==.
			replace EXPERIENCIA=3 if EXPERIENCIA_TOTAL<=10 & EXPERIENCIA==.
			replace EXPERIENCIA=4 if EXPERIENCIA_TOTAL>10 & EXPERIENCIA==.
			
			label define expe 1 "Menos de un año" 2 "Entre 2 y 4 años" 3 "Entre 5 y 10 años" 4 "Más de 10 años"
			label values EXPERIENCIA expe
		*/
			
		gen TITULO_PROCEDENCIA=1 if ins=="SI" & uni=="NO"
			replace TITULO_PROCEDENCIA=2 if uni=="SI" & ins=="NO"
			replace TITULO_PROCEDENCIA=3 if uni=="SI" & ins=="SI"
			label define titulo 1 "INST. SUP. PEDAGOGICO" 2 "UNIVERSIDAD" 3 "AMBOS"
			label values TITULO_PROCEDENCIA titulo	
		
		gen TITULO_PROCEDENCIA_NOMBRE=nombre_univ
			replace TITULO_PROCEDENCIA_NOMBRE=nombre_ins if TITULO_PROCEDENCIA_NOMBRE==""

		*reclink TITULO_PROCEDENCIA_NOMBRE using "Data/Intermediate/INST_PEDAG.dta", idmaster(ID_DOCENTE) idusing(id_inst) gen(match) minscore(0.1) 
		
		*matchit ID_DOCENTE TITULO_PROCEDENCIA_NOMBRE using "Data/Intermediate/INST_PEDAG.dta", idusing(CÓDIGO) txtusing(TITULO_PROCEDENCIA_NOMBRE) override
		
		gen DISCAPACIDAD=(discapacidad!="NINGUNA")
		
		gen REGION=region_evaluado
		gen NOMBRADO=(ganador_2017=="SI") 
		
		gen REGION_NOMB=region_selec
		
		gen CICLO_NOMB=mod
			replace CICLO_NOMB="Inicial" if CICLO_NOMB=="EBR INICIAL"
			replace CICLO_NOMB="Primaria" if CICLO_NOMB=="EBR PRIMARIA"
			replace CICLO_NOMB="Secundaria" if CICLO_NOMB=="EBR SECUNDARIA"
		
		gen TIPO_EI_NOMB="" //Podemos juntar el padron 2017 para averiguar
			
		gen AREA_NOMB="" //Podemos juntar el padron 2017 para averiguar
		
		gen EIB_NOMB=. //Podemos juntar el padron 2017 para averiguar
		
		keep AÑO ID_DOCENTE APELLIDO_PATERNO APELLIDO_MATERNO NOMBRES NIVEL PUNTAJE* PRUEBA_APROBADO EDU_POSTGRADO TITULO_PROCEDENCIA EDAD EDAD_GRUPOS SEXO REGION NOMBRADO REGION_NOMB CICLO_NOMB TIPO_EI_NOMB AREA_NOMB EIB_NOMB TITULO_PROCEDENCIA_NOMBRE DISCAPACIDAD
		save "Data/Intermediate/CPM2017.dta", replace	
		
	******************** 2019 ****************************	
		
		*Base de datos de la segunda etapa (obtenemos promedios por docente)
			use "Data/Raw/CPM/Concurso 2019/4_Etapa_descentralizada_Nombramiento_2019.dta", clear 
			keep documento puntaje_tray obsaula_ptje entrevista_ptje
			replace puntaje_tray=subinstr(puntaje_tray,"-","",.)
			replace obsaula_ptje=subinstr(obsaula_ptje,"-","",.)
			replace entrevista_ptje=subinstr(entrevista_ptje,"-","",.)
			replace entrevista_ptje=subinstr(entrevista_ptje,"NO SE PRESENTÓ","",.)
			
			destring puntaje_tray obsaula_ptje entrevista_ptje, replace
			drop if  puntaje_tray==. | obsaula_ptje==. | entrevista_ptje==.
			collapse (mean) puntaje_tray obsaula_ptje entrevista_ptje, by(documento)
			
			rename puntaje_tray PUNTAJE_TRAYECTORIA
			rename obsaula_ptje PUNTAJE_AULA
			rename entrevista_ptje PUNTAJE_ENTREVISTA
			
			save "Data/Intermediate/SegundaEtapa2019.dta", replace
		
		*Primera etapa
			use "Data/Raw/CPM/Concurso 2019/1_Evaluados_PUN_2019.dta", clear
			merge 1:m documento using "Data/Raw/CPM/Concurso 2019/3_Seleccion_lista_plazas_fase1y2.dta", keepusing(codigomodular) keep(1 3)
			drop _m
			destring codigomodular, gen(cod_mod)
			merge m:1 cod_mod using "Data/Intermediate/EIB2022.dta", keep(1 3) keepusing(EIB) //Identificar EIB
			replace EIB=0 if EIB ==.
			bysort documento: egen EIB_POST=max(EIB)
			bysort documento: gen N_POSTULACIONES=_N
			drop EIB cod_mod _m codigomodular
			duplicates drop
			
			merge 1:1 documento using "Data/Intermediate/SegundaEtapa2019.dta", nogenerate
			
			gen AÑO=2019
			gen ID_DOCENTE=documento
			gen APELLIDO_PATERNO=apellido_paterno
			gen APELLIDO_MATERNO=apellido_materno
			gen NOMBRES=nombres
			gen NIVEL=""
			gen PUNTAJE_CT=puntajes1
			gen PUNTAJE_RL=puntajes2
			gen PUNTAJE_CC=puntajes3
			gen PUNTAJE=puntajetotal
			gen PRUEBA_APROBADO=(condicion_final=="Clasificado") //Incluyendo a los 338 docentes que pasaron la PUN pero no avanzaron a la siguiente etapa (¿?)
				
			gen FECHA_NAC=fnacimiento
			gen EDAD=edad
				gen EDAD_GRUPOS=1 if EDAD<=25 
				replace EDAD_GRUPOS=2 if EDAD<=30 & EDAD_GRUPOS==.
				replace EDAD_GRUPOS=3 if EDAD<=35 & EDAD_GRUPOS==.
				replace EDAD_GRUPOS=4 if EDAD<=40 & EDAD_GRUPOS==.
				replace EDAD_GRUPOS=5 if EDAD<=45 & EDAD_GRUPOS==.
				replace EDAD_GRUPOS=6 if EDAD<=50 & EDAD_GRUPOS==.
				replace EDAD_GRUPOS=7 if EDAD>=51 & EDAD_GRUPOS==. & EDAD!=.
				replace EDAD_GRUPOS=.a if EDAD==.
					label define edad_g 1 "Menor de 25 años" 2 "Entre 26 y 30 años" 3 "Entre 31 y 35 años" 4 "Entre 36 y 40 años" 5 "Entre 41 y 45 años" 6 "Entre 46 y 50 años" 7 "Mayor a 51 años" .a "Sin Datos"
					label values EDAD_GRUPOS edad_g
			
			gen SEXO=1 if sexo=="Masculino"
				replace SEXO=2 if sexo=="Femenino"
				label define sexo 1 "Masculino" 2 "Femenino"
				label values SEXO sexo
				
			gen EDU_POSTGRADO=.
			/*
			gen EXPERIENCIA_PUB=exp_publica
			gen EXPERIENCIA_PRIV=exp_privada
			gen EXPERIENCIA_TOTAL=exp_publica+exp_privada
			gen EXPERIENCIA=1 if EXPERIENCIA_TOTAL<=1
				replace EXPERIENCIA=2 if EXPERIENCIA_TOTAL<=4 & EXPERIENCIA==.
				replace EXPERIENCIA=3 if EXPERIENCIA_TOTAL<=10 & EXPERIENCIA==.
				replace EXPERIENCIA=4 if EXPERIENCIA_TOTAL>10 & EXPERIENCIA==.
				
				label define expe 1 "Menos de un año" 2 "Entre 2 y 4 años" 3 "Entre 5 y 10 años" 4 "Más de 10 años"
				label values EXPERIENCIA expe
			*/
				
			gen TITULO_PROCEDENCIA=1 if procedencia=="Solo ISP"
				replace TITULO_PROCEDENCIA=2 if procedencia=="Solo UNIV"
				replace TITULO_PROCEDENCIA=3 if procedencia=="Ambos"
				label define titulo 1 "INST. SUP. PEDAGOGICO" 2 "UNIVERSIDAD" 3 "AMBOS"
				label values TITULO_PROCEDENCIA titulo			
			
			gen TITULO_PROCEDENCIA_NOMBRE=nombre_universidad
				replace TITULO_PROCEDENCIA_NOMBRE=nombre_instituto if TITULO_PROCEDENCIA_NOMBRE==""
			
			gen DISCAPACIDAD=(postulante_con_discapacidad!="")
			gen REGION=region_eval
			gen NOMBRADO=(selecc_plaza=="SI") 
			
			gen REGION_NOMB=""
			
			gen CICLO_NOMB=mod
				replace CICLO_NOMB="Inicial" if CICLO_NOMB=="EBR-INI"
				replace CICLO_NOMB="Primaria" if CICLO_NOMB=="EBR-PRI"
				replace CICLO_NOMB="Secundaria" if CICLO_NOMB=="EBR-SEC"
				replace CICLO_NOMB="EBA" if CICLO_NOMB=="EBA"
				replace CICLO_NOMB="EBE" if CICLO_NOMB=="EBE"

			gen TIPO_EI_NOMB="" //Podemos juntar el padron 2019 para averiguar
				
			gen AREA_NOMB="" //Podemos juntar el padron 2019 para averiguar
			
			gen EIB_NOMB=. //Podemos juntar el padron 2019 para averiguar
			
			keep AÑO ID_DOCENTE APELLIDO_PATERNO APELLIDO_MATERNO NOMBRES NIVEL PUNTAJE* PRUEBA_APROBADO EDU_POSTGRADO TITULO_PROCEDENCIA EDAD EDAD_GRUPOS SEXO REGION NOMBRADO REGION_NOMB CICLO_NOMB TIPO_EI_NOMB AREA_NOMB EIB_NOMB EIB_POST TITULO_PROCEDENCIA_NOMBRE TITULO_PROCEDENCIA_NOMBRE DISCAPACIDAD N_POSTULACIONES
			save "Data/Intermediate/CPM2019.dta", replace		
		

	
