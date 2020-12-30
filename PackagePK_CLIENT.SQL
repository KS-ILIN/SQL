SET SERVEROUTPUT ON

create or replace package pk_client is

TYPE refCursorType IS REF CURSOR;

procedure insertClient(ID_C IN INTEGER, NOM_C IN VARCHAR2,PNOM_C IN VARCHAR2, RS_C IN VARCHAR2, TEL_C IN NUMBER, VIL_C IN VARCHAR2);
messs varchar2(1000);
procedure deleteClient(idcli IN NUMBER);

mess varchar2(1000);

no_data_updated EXCEPTION;
pragma exception_init(no_data_updated, -20001);

procedure updateClient(idc IN NUMBER, NOM_C IN varchar2);

function listClient return pk_client.refCursorType;

procedure totalClient;

function getCoupleClient return pk_client.refCursorType;
end pk_client; 
/

create or replace package body pk_client is

procedure insertClient(ID_C IN INTEGER, NOM_C IN VARCHAR2,PNOM_C IN VARCHAR2, RS_C IN VARCHAR2, TEL_C IN NUMBER, VIL_C IN VARCHAR2) IS


	begin

		insert into client values (ID_C, NOM_C, PNOM_C, RS_C, TEL_C, VIL_C);



	EXCEPTION 
		 WHEN DUP_VAL_ON_INDEX THEN
		 raise;	
		 WHEN OTHERS THEN
		 raise;

	end insertClient;


procedure deleteClient(idcli IN NUMBER) IS
cct number;
	 
	begin 

		select count(*) into cct from contrat where ID_CL=idcli;
		IF cct>=1 THEN
		pk_client.mess:='ACTION IMPOSSIBLE : ce client est rattaché à un contrat';
		raise_application_error(-20009, mess);
		END IF; 
		
		
			
			delete from client where ID_CL=idcli;

		IF SQL%NOTFOUND THEN
		pk_client.mess:='Aucune ligne supprimée';
		raise_application_error(-20002, mess);
		raise NO_DATA_FOUND;
		END IF;

		EXCEPTION 
			 WHEN NO_DATA_FOUND THEN
			 dbms_output.put_line('client inexistant');
			 dbms_output.put_line('sqlcode='|| sqlcode);
			 dbms_output.put_line('sqlerrm='|| sqlerrm);
			 WHEN OTHERS THEN
			 raise;

	end deleteClient;


 
procedure updateClient(idc IN NUMBER, NOM_C IN varchar2) IS 

begin

		update client set NOM_CL=NOM_C where ID_CL=idc;

	IF SQL%FOUND THEN
		dbms_output.put_line('Mise à jour effectuée avec succès');
	END IF;

	IF SQL%NOTFOUND THEN
		pk_client.mess:='client inexistant';
		raise_application_error(-20001, mess);
		raise pk_client.no_data_updated;
	END IF;
					
	EXCEPTION
		 WHEN pk_client.no_data_updated THEN
		 dbms_output.put_line('Aucune mise à jour effectuée');
		 dbms_output.put_line('sqlcode='|| sqlcode);
		 dbms_output.put_line('sqlerrm='|| sqlerrm);
		 WHEN OTHERS THEN
		 raise;

end updateClient;


function listClient return pk_client.refCursorType IS 

Cli pk_client.refCursorType;
ligneClient client%rowtype;

begin 
		open Cli for

		select * from client;
		
		return Cli;

	loop 
		fetch Cli INTO ligneClient;
		EXIT WHEN Cli%notfound;

		-- Afficher les informations sur le client extrait du curseur
		DBMS_OUTPUT.PUT_LINE(' Identifiant='||ligneClient.ID_CL
		|| ' Nom='||ligneClient.NOM_CL
		|| ' Raison sociale='||ligneClient.RS_CL
		|| ' Ville='||ligneClient.VIL_CL);

	end loop;
		
		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			 DBMS_OUTPUT.PUT_LINE('AUCUN CLIENT');		
			 dbms_output.put_line('sqlcode='|| sqlcode);
			 dbms_output.put_line('sqlerrm='|| sqlerrm);
			 raise;

		 WHEN OTHERS THEN
		 	 raise;
end listClient;


procedure totalClient AS 
clitot number;


begin 
		select count(ID_CL) into clitot from client;
 
		dbms_output.put_line('Il y a '|| clitot ||' clients au total.');
	EXCEPTION
		 WHEN OTHERS THEN
		 raise;
		 
end totalClient;



function getCoupleClient return pk_client.refCursorType IS

Cli pk_client.refCursorType;
ligneClient client%rowtype;

begin 

		open Cli for

		select c1.NOM_CL, c2.ID_BIEN from CLIENT c1 join BIEN c2 on c1.VIL_CL=c2.VIL_BIEN where c2.NUM_CONT IS NULL;
		
		return Cli ;

	loop 
		fetch Cli INTO ligneClient;
		EXIT WHEN Cli%notfound;
		
		DBMS_OUTPUT.PUT_LINE('Nom='||ligneClient.NOM_CL
		|| ' Identifiant client='||ligneClient.ID_CL
		|| ' Ville='||ligneClient.VIL_CL);

	end loop;

	IF SQL%ROWCOUNT = 0 THEN
		raise NO_DATA_FOUND;
	END IF;

	

	EXCEPTION 
		 WHEN NO_DATA_FOUND THEN
		 dbms_output.put_line('aucune ligne trouvée');
		 dbms_output.put_line('sqlcode='|| sqlcode);
		 dbms_output.put_line('sqlerrm='|| sqlerrm);

		 WHEN OTHERS THEN
		 raise;

end getCoupleClient;
end pk_client;
/

--- 
test insertclient
select * from client;
exec pk_client.insertClient(20,'ALBERT','MARINE','PA',0696806428,'PARIS');
select * from histClient;
select * from client;

---
test deleteclient
EXEC pk_client.deleteClient(20);
select * from histClient;
EXEC pk_client.deleteClient(2);
select * from client;

---
test update client
EXEC pk_client.updateClient(30,'ALBERT'); -- client inexistant
select * from client;
EXEC pk_client.updateClient(14,'ALBERT');
select * from histClient;

EXEC pk_client.updateClient(14,'PARK');
select * from histClient;

rollback;

--- 
test totalClient
EXEC pk_client.totalClient;
---
test listClient
select pk_client.listClient from dual;


----
test getCoupeClient
select * from client where ID_CL=1;
update client set VIL_CL='NICE EST' where ID_CL=1;
select pk_client.getCoupleClient from dual;

update client set VIL_CL='PARIS' where ID_CL=1;

---




