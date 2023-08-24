
/*==============================================================================================*/
 *                Detection of Collusion in Public Procurement in Chile: 
 *                          The Case of the Pharmaceutical Market
/*==============================================================================================*/
* Author: Paola Rojas 
* Last update: 08-15-2023


* ==============================================================================================
* SECTION A: DIRECTORIES
* ==============================================================================================
clear all
set more off
ssc install expl
   
  *A.1 Directory paths
	if "`c(username)'"=="Andres" {
			global path "C:\Users\      \AGL Dropbox\LicitacionesCenabast" 
			//Andres: Change to your path here
		}
	if "`c(username)'"=="Rosario" {
			global path  "D:\AGL Dropbox\LicitacionesCenabast"
		   //Paola's PC
		}
	if "`c(username)'"=="Paola" {
			global path "C:\Users\Paola\AGL Dropbox\LicitacionesCenabast"
		   //Paola's laptop
		}
    pwd

		
  *A.2 Globals
   cd "$path"  
   global biddings     "$path\data\input_data\mercado_publico\biddings"
   global purchase     "$path\data\input_data\mercado_publico\purchase_orders"   
   global zgen         "$path\data\input_data\mercado_publico\purchase_orders_zgen"   
   global datasets     "$path\data\processed_data" 
   
     

   
* ================================================================================================
* SECTION B: CREATING MASTER DATASET
* ================================================================================================

**************************************************************************************************
*B.1 Importing raw data: Biddings
**************************************************************************************************
   
  *B.1.1 Datasets (Quarterly frequency): The number of variables in each dataset differs by year.
       * Given that the ownership information is available for 2017-2021  period, these years are 
	   * prioritized for the analysis.The information downloaded is from awarded tenders (licitaciones 
	   * adjudicadas).
         
		  local years "2017 2018 2019 2020 2021"
		  local quarters "1 2 3 4"
		  
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
		 

  *B.1.3 Including a set of constraints on the dataset: 
    
	    *I. We do not include rejected bids in our analysis. 
		    drop if EstadoOferta=="Rechazada"
		    *===================================================================
            *Information to be included in the Annex A. 
		    unique CodigoExterno Codigoitem
		    *Number of unique values of "CodigoExterno" and "Codigoitem":491,305
		    *Number of record is: 2,368,482
            *===================================================================
		
		
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
          
		  
********************************************************************************
*B.2 Importing raw data: Purchase Orders
********************************************************************************	 

  *B.2.1 Datasets (Quarterly frequency):  Preliminary cleaning of the data
   clear all
		 local years "2017 2018 2019 2020 2021"
		 local quarters "1 2 3 4"
		  
         foreach i of local years {
		     foreach j of local quarters {
			   import excel "$purchase\purch_`i'_`j'_MEDICINE.xlsx", sheet("Sheet1") firstrow
		       gen year=`i'
			   keep Codigo CodigoLicitacion year MontoTotalOC_PesosChilenos   ///
			        Impuestos TipoImpuesto Descuentos Cargos TotalNetoOC      ///
					codigoProductoONU NombreroductoGenerico RubroN2 RubroN3   ///
					RubroN1 cantidad UnidadMedida monedaItem precioNeto       ///
					totalCargos totalDescuentos totalImpuestos totalLineaNeto ///
					IDItem RutSucursal CodigoProveedor NombreProveedor        ///
					RutUnidadCompra
		       save "$purchase\purch_`i'_`j'_MEDICINE.dta", replace
		       clear all
			 }
		   }

		   
  *B.2.2 Appending all datasets: Creating master dataset of purchase orders	 
         clear all
		 local years "2017 2018 2019 2020 2021"
		 local quarters "1 2 3 4"
		  
		 foreach i of local years {
		     foreach j of local quarters {
			   append using "$purchase\purch_`i'_`j'_MEDICINE.dta", force
		       save "$datasets\purchase_ChileCompras_MED2017-2021.dta", replace
			 }
		   }
		   
  *B.2.3 Last checks 
		 duplicates drop // There are not duplicates in terms of all variables
		 replace RubroN1=strtrim(RubroN1)
		 replace RubroN2=strtrim(RubroN2)
		 replace RubroN3=strtrim(RubroN3)
		 format  IDItem %12.0f
		 
		 
  *B.2.4 Missing values in terms of "CodigoLicitacion"
		 nmissing CodigoLicitacion
		 *======================================================================
         *Information to be included in the Annex A. 
		  unique Codigo
		  unique Codigo if CodigoLicitacion!=""
		 *Number of unique values of "Codigo" [Purchase Order]: 552,695
		 *Number of record is: 955,928
		 *======================================================================
	     keep if CodigoLicitacion!=""		 
		 
		 
  *B.2.5 No duplicates in terms of "Codigo", "CodigoLicitacion", "year", "cantidad",
         *"precioNeto" and "totalLineaNeto". These are the only variables that allow
		 * us to merge this dataset to the ZGEN dataset.
		 duplicates r Codigo CodigoLicitacion year RutUnidadCompra cantidad ///
		            precioNeto totalLineaNeto 
	     duplicates tag Codigo CodigoLicitacion year RutUnidadCompra cantidad ///
		            precioNeto totalLineaNeto , gen (duplicates_ID)
	     keep if duplicates_ID==0
	     drop duplicates_ID
		 *======================================================================
         *Information to be included in the Annex A. 
		  unique Codigo
		 *Number of unique values of "Codigo" [Purchase Order]: 551,285
		 *Number of record is: 941,196
		 *======================================================================
		 
  	     save "$datasets\purchase_ChileCompras_MED2017-2021.dta", replace

		 
********************************************************************************
*B.3 Importing external datasets: Purchase orders with ZGEN 
********************************************************************************

  *B.3.1 Defining workspace
         use "$zgen\mercadoPublico2011_2021.dta", clear
		 
		 nmissing ordendecompra // No missing values in terms of "ordendecompra"
	     duplicates drop
         keep if ano>2016
		 *======================================================================
         *Information to be included in the Annex A. 
		 unique ordendecompra
		 *Number of unique values of "ordendecompra": 635,791
		 *Number of record is: 1,284,703
		 *======================================================================
 		 
		 
  *B.3.2 Defining key variables	 
	     nmissing licitacion
		 *======================================================================
         *Information to be included in the Annex A. 
		 unique ordendecompra if licitacion!=""
		 *Number of unique values of "ordendecompra"[Purchase Order]: 486,574
		 *Number of record is:  893,790
		 *======================================================================
	     drop if licitacion==""
		 	 	  
				  
  *B.3.3 Renaming key variables
         rename (ordendecompra licitacion ano preciounitario montoneto rutcomprador) ///
	            (Codigo CodigoLicitacion year precioNeto totalLineaNeto RutUnidadCompra)
	     drop mes mesadj fechaadjudicaciãn anoadj region segmentocomprador 
	     drop producto descripcioncomprador descripcionproveedor compradorantiguo
	  
	     duplicates tag Codigo CodigoLicitacion year cantidad precioNeto            ///
	                RutUnidadCompra totalLineaNeto, gen (duplicates_ID)
	     tab duplicates_ID
	     keep if duplicates_ID==0
	     drop duplicates_ID
		 *======================================================================
         *Information to be included in the Annex A. 
		 unique Codigo
		 *Number of unique values of "Codigo": 485,902
		 *Number of record is:  885,093
		 *======================================================================
         save "$datasets\purchase_zgen_2017_2021.dta", replace

		 
  *B.3.4 Merging datasets to recover ZGEN variable
	     use "$datasets\purchase_ChileCompras_MED2017-2021.dta", clear
	     duplicates tag Codigo CodigoLicitacion year cantidad precioNeto  ///
	                RutUnidadCompra totalLineaNeto, gen (duplicates_ID)
		 tab duplicates_ID 			
	     keep if duplicates_ID==0
	     drop duplicates_ID
         ***********************************************************************
         *Information to be included in the Annex A. 
		 unique Codigo
		 *Number of unique values of "Codigo": 731,584
		 *Number of record is:  1,290,798
         ***********************************************************************		  		 		 
		 		 
         merge 1:1 Codigo CodigoLicitacion year cantidad precioNeto RutUnidadCompra ///
	               totalLineaNeto using "$datasets\purchase_zgen_2017_2021.dta"				
	     *============================*			
	     *Results:
	     *Not matched: 932,555
	        * from master: 669,130
		    * from using:  263,425
	     *Matched: 621,668
		 *============================*		
	     keep if _merge==3	
	     drop _merge
         ***********************************************************************
         *Information to be included in the Annex A. 
		 unique Codigo
		 *Number of unique values of "Codigo": 394,251
		 *Number of record is:  621,668
         ***********************************************************************	
		 
  *B.3.5 Dropping irrelevant variables		
		 sort  CodigoLicitacion Codigo
		 order CodigoLicitacion, before (Codigo)
	     drop  Codigo MontoTotalOC_PesosChilenos Impuestos TipoImpuesto 
		 drop  Descuentos Cargos TotalNetoOC IDItem totalCargos totalDescuentos 
		 drop  totalImpuestos totalLineaNeto year monedaItem cantidad
		 drop  UnidadMedida comprador proveedor
		
  *B.3.6 Renamig key variables		
         rename CodigoLicitacion CodigoExterno
		 rename RutSucursal RutProveedor
		 rename codigoProductoONU CodigoProductoONU
		 rename RubroN1 Rubro1
		 rename RubroN2 Rubro2
		 rename RubroN3 Rubro3
		 rename precioNeto MontoUnitarioOferta
         rename NombreroductoGenerico Nombreproductogenrico
		 
  *B.3.7 Standardizing key variables	
         replace CodigoExterno=strupper(CodigoExterno)
         replace RutProveedor=strupper(RutProveedor)
		 replace atc=strupper(atc)
 
         replace CodigoExterno=strtrim(CodigoExterno)
         replace RutProveedor=strtrim(RutProveedor)
		 replace atc=strtrim(atc)		 
         replace Rubro1=strtrim(Rubro1)		 
         replace Rubro2=strtrim(Rubro2)
         replace Rubro3=strtrim(Rubro3)
		 replace Nombreproductogenrico=strtrim(Nombreproductogenrico)
		 
         replace Rubro1 = lower(ustrto(ustrnormalize(Rubro1, "nfd"), "ascii", 2)) 	     
         replace Rubro2 = lower(ustrto(ustrnormalize(Rubro2, "nfd"), "ascii", 2)) 
         replace Rubro3 = lower(ustrto(ustrnormalize(Rubro3, "nfd"), "ascii", 2)) 
         replace Nombreproductogenrico = lower(ustrto(ustrnormalize(Nombreproductogenrico, "nfd"), "ascii", 2))
		 
		 duplicates drop // We dropped 337,386 duplicates in terms of all variables.
		 
  *B.3.8 How do we merge this dataset with biddings' dataset? We identify all 
         *common variables in both datasets.
		    *a) CodigoExterno
			*b) RutProveedor
			*c) CodigoProductoONU 
			*d) Rubro1
			*e) Rubro2
			*f) Rubro3
			*g) Nombreproductogenrico
			*h) MontoUnitarioOferta
			*i) RutUnidadCompra
		
		*But previously, we analyze the case of missing values in terms of "ZGEN".
		 nmissing zgen // 7879 nmissing values
	     save "$datasets\zgen_ChileCompras_MED2017-2021.dta", replace  
		 
  *B.3.9 Is there any chance to recover ZGEN's missing values? Yes, there is.
		 preserve
		 keep zgen principioactivo concentracion formafarmaceutica liberacion 
		 sort zgen principioactivo concentracion formafarmaceutica liberacion 	 
		 duplicates drop
		 *drop if zgen=="" | zgen==" "
		 
		    *A. Duplicates in terms of "zgen"
		    duplicates tag zgen, gen (dup_zgen)
		    tab dup_zgen // 
	        *============================*			
	        *Results:
	        *dup_zgen  
	          * 0: 1,892
		      * 1:    40
		      * 2:     6
		    *============================*		
		    br if dup_zgen!=0	
		    *Conclusion: The variable "zgen" does not identify a unique combination of:
		    *"principioactivo" + "concentracion" + "formafarmaceutica" and liberacion".
		 
		    *B. Duplicates in terms of "principioactivo" + "concentracion" + 
		    *   "formafarmaceutica" and "liberacion"
		    duplicates tag principioactivo concentracion formafarmaceutica liberacion ///
			           , gen (dup_des)
			sort principioactivo concentracion formafarmaceutica liberacion		   
		    tab dup_des // 
	        *============================*			
	        *Results:
	        *dup_zgen  
	          * 0: 1,892
		      * 1:    40
		      * 2:     6
		    *============================*		
		    br if dup_des!=0	
		    *Conclusion: The combination "principioactivo" + "concentracion" + 
			*"formafarmaceutica" and "liberacion" is not associated to a unique
			*"zgen".		
		    save "$datasets\zgen_register.dta", replace
		    restore
		
  *B.3.10 Using zgen_register to recover ZGEN's missing values.
		 drop principioactivo concentracion formafarmaceutica liberacion 
		
		
		
		
		
		
		
		 gen nmissing_zgen=0
		 replace nmissing_zgen=1 if zgen==""
		 bysort CodigoExterno RutProveedor CodigoProductoONU Rubro1 Rubro2 ///
		        Rubro3 Nombreproductogenrico MontoUnitarioOferta: egen Nmissing_zgen=sum(nmissing_zgen)
		 br if Nmissing_zgen!=0
		 
		 
		 bysort CodigoExterno RutProveedor CodigoProductoONU Rubro1 Rubro2 ///
		        Rubro3 Nombreproductogenrico MontoUnitarioOferta: gen N_observations=_n
				
				
				
		 tab N_observations						
		 tab Nmissing_zgen		
				
				
		
		 *Do we have a unique ZGEN in terms of all the common variables?
	     unique zgen, by (CodigoExterno RutProveedor CodigoProductoONU Rubro1 Rubro2 Rubro3 Nombreproductogenrico MontoUnitarioOferta) ///
	     gen (unique_zgen)
		 tab unique_zgen 
		 
		 *No, we don't. We have the following results:
	     bysort CodigoExterno RutProveedor CodigoProductoONU Rubro1 Rubro2 Rubro3 ///
		        Nombreproductogenrico MontoUnitarioOferta: egen T_unique_zgen=max(unique_zgen)
		 tab T_unique_zgen
		 drop unique_zgen	 
         ****************************
         /*T_unique_zgen [Freq]:
		          1      [273,355]
		          2      [7,316] 
		          3      [634]
		          4      [85]
		          5      [20]
		          6      [6] */
         ****************************	
		 
		 *We drop all the observations associated with more than one ZGEN code.		 
         keep if T_unique_zgen==1       
		 sort  CodigoExterno CodigoProductoONU Rubro1 Rubro2 Rubro3 Nombreproductogenrico ///
		       RutProveedor MontoUnitarioOferta
			   
		 *After identifying the observations associated with one ZGEN, we validate 
		 *the existence of duplicates.
		 drop liberacion
		 duplicates drop
		 duplicates r CodigoExterno CodigoProductoONU Rubro1 Rubro2 Rubro3 Nombreproductogenrico   ///
		              RutProveedor  MontoUnitarioOferta 
		 duplicates tag CodigoExterno CodigoProductoONU Rubro1 Rubro2 Rubro3 Nombreproductogenrico ///
		              RutProveedor MontoUnitarioOferta, gen(dup)
		 tab dup
		 br if dup==1
	  		 
		 duplicates tag CodigoExterno CodigoProductoONU Rubro1 Rubro2 Rubro3 Nombreproductogenrico ///
		              RutProveedor MontoUnitarioOferta, gen(dup)					  
		 tab dup
		 br if dup==1 
		 keep if dup==0
		 drop T_unique_zgen dup
	     duplicates drop

         nmissing zgen
	     nmissing atc
	     gen Ofertaseleccionada="Seleccionada"
	     save "$datasets\zgen_ChileCompras_MED2017-2021.dta", replace  

	  
	  
********************************************************************************
*B.5 Importing ZGEN variable and creating final master dataset
********************************************************************************

  *B.5.1 Standardizing key variables	
   clear all
	     use "$datasets\biddings_ChileCompras_MED2017-2021.dta", replace
		 
		 replace CodigoExterno=strupper(CodigoExterno)
         replace RutProveedor=strupper(RutProveedor)
		 
         replace CodigoExterno=strtrim(CodigoExterno)
         replace RutProveedor=strtrim(RutProveedor)
         replace Rubro2=strtrim(Rubro2)
         replace Rubro3=strtrim(Rubro3)
		 
         replace Rubro2 = lower(ustrto(ustrnormalize(Rubro2, "nfd"), "ascii", 2))
         replace Rubro3 = lower(ustrto(ustrnormalize(Rubro3, "nfd"), "ascii", 2))
         replace Nombreproductogenrico = lower(ustrto(ustrnormalize(Nombreproductogenrico, "nfd"), "ascii", 2))
		 

		 duplicates r CodigoExterno RutProveedor CodigoProductoONU Rubro2 Rubro3   ///
		              Nombreproductogenrico MontoUnitarioOferta if Ofertaseleccionada=="Seleccionada"
		 duplicates tag CodigoExterno RutProveedor CodigoProductoONU Rubro2 Rubro3 ///
		              Nombreproductogenrico MontoUnitarioOferta if Ofertaseleccionada=="Seleccionada", gen (duplicates_ID)		
		 tab duplicates_ID
		
		
  *B.5.2 We are dropping observations where the combination (CodigoExterno RutProveedor 
		 *CodigoProductoONU Rubro2 Rubro3 MontoUnitarioOferta) has duplicates.		 
		 bysort CodigoExterno Codigoitem: egen Total_dup_ID=max(duplicates_ID)
		 drop duplicates_ID
		 tab Total_dup_ID
		 keep if Total_dup_ID==0
		 
		 duplicates r CodigoExterno RutProveedor CodigoProductoONU Rubro2 Rubro3 ///
		             Nombreproductogenrico MontoUnitarioOferta if Ofertaseleccionada=="Seleccionada"

					  
  *B.5.3 Merging with external dataset (ZGEN_ChileCompras_MED2017-2021.dta) 
	     merge m:1 CodigoExterno RutProveedor CodigoProductoONU Rubro2 Rubro3   ///
		           Nombreproductogenrico MontoUnitarioOferta Ofertaseleccionada ///
				   using "$datasets\ZGEN_ChileCompras_MED2017-2021.dta"
         drop if _merge==2
		 sort CodigoExterno Codigoitem	
		*============================*			
	    *Results:
	    *Not matched:    1,106,986
	        * from master: 950,069
		    * from using:  156,917
	    *Matched:        115,299
		*============================*
 	
	 
  *B.5.4 Creating an auxiliary dataset 	  
	     preserve
	     keep CodigoExterno Codigoitem zgen principioactivo concentracion ///
	     formafarmaceutica atc
		 drop if zgen=="" & principioactivo=="" & concentracion=="" &    ///
		         formafarmaceutica=="" & atc=="" 
         duplicates drop 
		 duplicates r CodigoExterno Codigoitem 
	     save "$datasets\auxiliary_dataset_MED2017-2021.dta", replace
         restore
   
  *B.5.5 Final master dataset 	  
	     drop _merge zgen principioactivo concentracion formafarmaceutica atc
	     merge m:1 CodigoExterno Codigoitem using "$datasets\auxiliary_dataset_MED2017-2021.dta"
		 *============================*			
	     *Results:
	     *Not matched:      404,839
	        * from master:  404,839
		    * from using:         0
	     *Matched:          660,529
		 *============================*

		 drop if _merge==1
	     unique CodigoExterno Codigoitem // There are 115,299 unique biddings
	     unique CodigoExterno Codigoitem, by (year)
		 *============================*			
	     *year   _Unique
	     *2017    34,959
		 *2018    31,202
		 *2019    27,016
		 *2020    18,827
		 *2021     3,295
		 *============================*		 		 
         drop observations Total_dup_ID _merge _Unique
	     save "$datasets\biddings_masterdataset_MED2017-2021.dta", replace
   
   
********************************************************************************
*B.6 Analyzing internal consistency in the master dataset
********************************************************************************
   
   *B.6.1 Defining workspace 
	clear all
	      use "$datasets\biddings_masterdataset_MED2017-2021.dta", replace

   *B.6.2 Analyzing internal consistency:
         *zgen 
		 *atc
	     *Rubro2
	     *Rubro3
	     *CodigoProductoONU
	     *Nombreproductogenrico
		 
	  	 nmissing zgen                  //9616 missing values
		 nmissing atc                   //1240 missing values
		 nmissing Rubro2                //   0 missing values
		 nmissing Rubro3                //   0 missing values
		 nmissing CodigoProductoONU     //   0 missing values
		 nmissing Nombreproductogenrico //   0 missing values
		 
		 gen zgen_cod=0
		 replace zgen_cod=1 if zgen==""
		 bysort  CodigoExterno Codigoitem: egen num_missing=sum(zgen_cod)
		 
		 tab num_missing 
		 tab zgen if num_missing!=0     //There are not information of the "zgen" variable. 
		 keep if num_missing==0
		 drop num_missing zgen_cod
	     save "$datasets\biddings_masterdataset_MED2017-2021.dta", replace
		 		 
		 
   *B.6.3 Analyzing "zgen" variable
         sort zgen
         unique principioactivo concentracion formafarmaceutica atc, by (zgen) ///
		 gen (unique_zgen)
         tab unique_zgen
		 
		 bysort zgen: egen T_unique_zgen=max(unique_zgen)
         drop unique_zgen
         tab T_unique_zgen
   
         br if T_unique_zgen==2 
         br if T_unique_zgen==3 
         drop T_unique_zgen
         sort CodigoExterno Codigoitem
		 
   *B.6.4 Conclusion
         unique CodigoExterno Codigoitem //112,943 biddings
		 unique RutProveedor             //356 unique firms		 
	     save "$datasets\biddings_masterdataset_MED2017-2021.dta", replace
   
********************************************************************************   
*                                 END
********************************************************************************   
   