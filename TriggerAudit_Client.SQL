--  un trigger qui mémorise dans une table d’historique HistClient les mises à effectuées sur la table Client--

create table histClient as select * from client where ID_CL<0;

ALTER TABLE histClient Add username varchar2(30);
ALTER TABLE histClient Add majDate date;
ALTER TABLE histClient 
	Add ACTION VARCHAR2(20)
	CONSTRAINT CHK_histclientaction check(action in('INSERT','UPDATE','DELETE'));

CREATE or replace TRIGGER audit_CLIENT
AFTER INSERT OR DELETE OR UPDATE ON client FOR EACH ROW 
	declare
	ACTION VARCHAR2(20);
	BEGIN
	IF INSERTING THEN
		INSERT INTO histClient VALUES(:NEW.ID_CL, :NEW.NOM_CL, :NEW.PNOM_CL, :NEW.RS_CL, :NEW.TEL_CL, :NEW.VIL_CL, user, sysdate, 'INSERT');
	END IF;
	IF DELETING THEN 
		INSERT INTO histClient VALUES(:old.ID_CL, :old.NOM_CL, :old.PNOM_CL, :old.RS_CL, :old.TEL_CL, :old.VIL_CL, user, sysdate, 'DELETE');
	END IF;
	IF UPDATING THEN
		INSERT INTO histClient VALUES(:old.ID_CL, :old.NOM_CL, :old.PNOM_CL, :old.RS_CL, :old.TEL_CL, :old.VIL_CL, user, sysdate, 'UPDATE');
	END IF;
end;
/
