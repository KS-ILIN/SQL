 SET SERVEROUTPUT ON

create or replace package pk_contrat is

mess varchar2(1000);
procedure insertContrat(NUM_CON IN NUMBER, ID_BIE IN NUMBER, ID_A IN NUMBER, ID_C IN NUMBER, TYP_CON IN VARCHAR2, D_DEB_CON IN DATE, DUR_CON IN NUMBER, MON_CON IN NUMBER, VAL_CON IN NUMBER);

procedure deleteContrat(NUM_C IN NUMBER);

no_data_updated EXCEPTION;
pragma exception_init(no_data_updated, -20001);

procedure updateContrat(NUM_C IN NUMBER, DUR_CON IN NUMBER);

TYPE refCursorType IS REF CURSOR;
function getContratByCli(ID_C IN NUMBER) return pk_contrat.refCursorType ;
end pk_contrat; 
/

create or replace package body pk_contrat is 

procedure insertContrat(NUM_CON IN NUMBER, ID_BIE IN NUMBER, ID_A IN NUMBER, ID_C IN NUMBER, TYP_CON IN VARCHAR2, D_DEB_CON IN DATE, DUR_CON IN NUMBER, MON_CON IN NUMBER, VAL_CON IN NUMBER) IS
cl number;
bie number;
cont number;
ag number;
bi number;

	begin
		select count(*) into cont from contrat where NUM_CONT=NUM_CON;
		IF cont=0 THEN

			select count(*) into bie from bien where ID_BIEN=ID_BIE;

			
			CASE
			when bie=0 THEN
				mess:='Ce bien n existe pas et doit être enregistré avant';
				raise_application_error(-20011, mess);				
			
			
			when bie=1 THEN 
				select count(*) into bi from bien where ID_BIEN=ID_BIE and NUM_CONT IS NULL;		

			END CASE;
			
			CASE 
			when bi=0 THEN
				mess:='Ce bien possède déjà un numéro de contrat';
				raise_application_error(-20010, mess);
			when bi=1 THEN
				select count(*) into ag from AGENT where ID_AG=ID_A;
			END CASE;

			CASE
			when ag=0 THEN
				mess:='Cet agent existe pas';
				raise_application_error(-20009, mess);
			when ag=1 THEN
				select count(*) into cl from CLIENT where ID_CL=ID_C;
			END CASE;

			CASE 
			when cl=0 THEN
				mess:='Ce client n existe pas et doit d abord être enregistré';
				raise_application_error(-20008, mess);
			when cl=1 THEN
				insert into contrat values(NUM_CON, ID_BIE, ID_A, ID_C, TYP_CON, D_DEB_CON, DUR_CON, MON_CON, VAL_CON);
				UPDATE BIEN set NUM_CONT=NUM_CON where ID_BIEN=ID_BIE;
				update agent set RES_AG=RES_AG+1 where ID_AG=ID_A;
			END CASE;
		ELSE
			raise DUP_VAL_ON_INDEX;
		END IF;

EXCEPTION		
		 WHEN NO_DATA_FOUND THEN
		 dbms_output.put_line('aucune ligne trouvée');
		 dbms_output.put_line('sqlcode='|| sqlcode);
		 dbms_output.put_line('sqlerrm='|| sqlerrm);
		 raise;
		
		 WHEN DUP_VAL_ON_INDEX THEN
		 dbms_output.put_line('Ce numéro de contrat existe déjà');
		 dbms_output.put_line('sqlcode='|| sqlcode);
		 dbms_output.put_line('sqlerrm='|| sqlerrm);
		 raise;

	end insertContrat;

procedure deleteContrat(NUM_C IN NUMBER) IS
numc number;
	 
	begin 

			select count(*) into numc from contrat where NUM_CONT=NUM_C ;

			update bien set NUM_CONT=NULL where NUM_CONT=NUM_C;
			
			
			
			update bien set SI_BIEN='A LOUER' where NUM_CONT=NUM_C and (select TYP_CONT from contrat where NUM_CONT=NUM_C)='LOCATION';
			update bien set SI_BIEN='A VENDRE' where NUM_CONT=NUM_C and (select TYP_CONT from contrat where NUM_CONT=NUM_C)='VENTE';
			update bien set SI_BIEN='VIAGER' where NUM_CONT=NUM_C and (select TYP_CONT from contrat where NUM_CONT=NUM_C)='VIAGER';
			
			update agent set RES_AG=RES_AG-1 where ID_AG=(select ID_AG from contrat where NUM_CONT=NUM_C);

			delete from contrat where ID_CL=(select ID_CL from contrat where NUM_CONT=NUM_C);
			

			
		IF numc=1 THEN
		dbms_output.put_line('effectuée avec succès');
		END IF;

		IF numc=0 THEN
		raise NO_DATA_FOUND;
		END IF;

		EXCEPTION 
			 WHEN NO_DATA_FOUND THEN
			 dbms_output.put_line('AUCUN CONTRAT NE PORTE CE NUMERO');
			 dbms_output.put_line('AUCUNE LIGNE SUPPRIMEE');
			 dbms_output.put_line('sqlcode='|| sqlcode);
			 dbms_output.put_line('sqlerrm='|| sqlerrm);

			 WHEN OTHERS THEN
			 raise;

	end deleteContrat;

procedure updateContrat(NUM_C IN NUMBER, DUR_CON IN NUMBER) IS

begin

		update contrat set DUR_CONT=DUR_CON where NUM_CONT=NUM_C;

	IF SQL%FOUND THEN
		dbms_output.put_line('Mise à jour effectuée avec succès');
	END IF;

	IF SQL%NOTFOUND THEN
		pk_contrat.mess:='numéro de contrat inexistant';
		raise_application_error(-20006, mess);
		raise pk_contrat.no_data_updated;
	END IF;
					
	EXCEPTION
		 WHEN pk_contrat.no_data_updated THEN
		 dbms_output.put_line('Aucune mise à jour effectuée');
		 dbms_output.put_line('sqlcode='|| sqlcode);
		 dbms_output.put_line('sqlerrm='|| sqlerrm);

		 WHEN OTHERS THEN
		 raise;

end updateContrat;

function getContratByCli(ID_C IN NUMBER) return pk_contrat.refCursorType  IS

ContratByCli pk_contrat.refCursorType;
ligneContrat contrat%rowtype;
ct contrat.ID_CL%type;

begin

	select ID_CL into ct from contrat where ID_CL=ID_C;

	IF ct=0 then
	raise no_data_found;
	end if;
	
	open ContratByCli for
	
	select * 
	FROM contrat
	where ID_CL=ID_C; 

	return 	ContratByCli ;

	loop 
		fetch ContratByCli INTO ligneContrat;
		EXIT WHEN ContratByCli%notfound;

		DBMS_OUTPUT.PUT_LINE(' Numéro de contrat = '||ligneContrat.NUM_CONT
		|| ' Identifiant du client = '||ligneContrat.ID_CL
		|| ' Identifiant agent = '||ligneContrat.ID_AG);

	end loop;
	

	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('CE CLIENT EST INEXISTANT');		
			dbms_output.put_line('sqlcode='|| sqlcode);
			dbms_output.put_line('sqlerrm='|| sqlerrm);

		WHEN OTHERS THEN
			dbms_output.put_line('sqlcode='|| sqlcode);
			dbms_output.put_line('sqlerrm='|| sqlerrm);




	
end getContratByCli;
end pk_contrat; 
/

--- test 

--test normal de la fonction(insertContrat)
update bien set NUM_CONT=DEFAULT where NUM_CONT=1;
EXEC pk_contrat.deleteContrat(1); // remplacer par notre fonction delete dans le package
EXEC pk_contrat.insertContrat(1,1,3,5,'LOCATION','15-SEP-2017',60,835,0);
update bien set NUM_CONT=1 where ID_BIEN=1; 

--test de la fonction(insertContrat) cas NUM_CONTRAT pour bien INEXISTANT(NULL)
EXEC pk_contrat.insertContrat(35,13,3,5,'LOCATION','15-SEP-2017',60,835,0);
update bien set NUM_CONT=DEFAULT where NUM_CONT=35;
EXEC pk_contrat.deleteContrat(35); // remplacer par notre fonction delete dans le package


--test de la fonction(insertContrat) cas NUM_CONTRAT pour bien EXISTANT(NOT NULL)
EXEC pk_contrat.insertContrat(70,1,3,5,'LOCATION','15-SEP-2017',60,835,0);

--test de la fonction(insertContrat) cas ID_AGENT  INEXISTANT
EXEC pk_contrat.insertContrat(70,13,12,5,'LOCATION','15-SEP-2017',60,835,0);

--test de la fonction(insertContrat) cas CLIENT INEXISTANT
EXEC pk_contrat.insertContrat(70,13,3,21,'LOCATION','15-SEP-2017',60,835,0);


select * from histClient;

--test delete contrat
select * from contrat where NUM_CONT=1;
EXEC pk_contrat.deleteContrat(1);
EXEC pk_contrat.insertContrat(1,1,3,5,'LOCATION','15-SEP-2017',60,835,0);

select * from histClient;

--test delete contrat
EXEC pk_contrat.deleteContrat(36);

--test update contrat
select * from contrat where NUM_CONT=1;
EXEC pk_contrat.updateContrat(1,360);
select * from contrat where NUM_CONT=1;
EXEC pk_contrat.updateContrat(1,60);

select * from histClient;

select * from contrat;
EXEC pk_contrat.updateContrat(75,360);

--test getContratByCli

SELECT pk_contrat.getContratByCli(5) FROM DUAL;
SELECT pk_contrat.getContratByCli(70) FROM DUAL;