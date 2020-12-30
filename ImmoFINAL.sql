/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de création :  31/12/2018 11:20:52                      */
/*==============================================================*/


alter table BIEN
   drop constraint FK_BIEN_EST_L_OBJ_CONTRAT;

alter table BIEN
   drop constraint FK_BIEN_EST_POSSE_PROPRIET;

alter table CONTRAT
   drop constraint FK_CONTRAT_EST_LIE_CLIENT;

alter table CONTRAT
   drop constraint FK_CONTRAT_EST_LIE_A_AGENT;

alter table CONTRAT
   drop constraint FK_CONTRAT_EST_L_OBJ_BIEN;

drop table AGENT cascade constraints;

drop index EST_POSSEDE_FK;

drop index EST_L_OBJET_DE_FK;

drop table BIEN cascade constraints;

drop table CLIENT cascade constraints;

drop index EST_LIE_FK;

drop index EST_L_OBJET_DE2_FK;

drop index EST_LIE_A_FK;

drop table CONTRAT cascade constraints;

drop table PROPRIETAIRE cascade constraints;

/*==============================================================*/
/* Table : AGENT                                                */
/*==============================================================*/
create table AGENT 
(
   ID_AG                INTEGER              not null
      constraint CKC_ID_AG_AGENT check (ID_AG >= 1),
   NOM_AG               VARCHAR2(30)         not null
      constraint CKC_NOM_AG_AGENT check (NOM_AG = upper(NOM_AG)),
   PNOM_AG              VARCHAR2(30)         not null
      constraint CKC_PNOM_AG_AGENT check (PNOM_AG = upper(PNOM_AG)),
   DAT_NAIS_AG          DATE                 not null
      constraint CKC_DAT_NAIS_AG_AGENT check (DAT_NAIS_AG <= '1-JAN-2000'),
   RES_AG               NUMBER(2)            default 0 not null
      constraint CKC_RES_AG_AGENT check (RES_AG >= 0),
   AN_AG                DATE                 not null
      constraint CKC_AN_AG_AGENT check (AN_AG <= '13-JAN-2019'),
   VIL_AG               VARCHAR2(30)         not null
      constraint CKC_VIL_AG_AGENT check (VIL_AG = upper(VIL_AG)),
   TEL_AG               NUMBER(10)           not null,
   constraint PK_AGENT primary key (ID_AG)
);

/*==============================================================*/
/* Table : PROPRIETAIRE                                         */
/*==============================================================*/
create table PROPRIETAIRE 
(
   ID_PRO               INTEGER              not null
      constraint CKC_ID_PRO_PROPRIET check (ID_PRO >= 1),
   NOM_PRO              VARCHAR2(30)         not null
      constraint CKC_NOM_PRO_PROPRIET check (NOM_PRO = upper(NOM_PRO)),
   PNOM_PRO             VARCHAR2(30)         default 'SOC/ASS' not null
      constraint CKC_PNOM_PRO_PROPRIET check (PNOM_PRO = upper(PNOM_PRO)),
   D_NAIS_PRO           DATE                 default '1-JAN-1900' not null
      constraint CKC_D_NAIS_PRO_PROPRIET check (D_NAIS_PRO <= '1-JAN-2000'),
   TEL_PRO              NUMBER(10)           not null,
   VIL_PRO              VARCHAR2(30)        
      constraint CKC_VIL_PRO_PROPRIET check (VIL_PRO is null or (VIL_PRO = upper(VIL_PRO))),
   NB_PRO               NUMBER(4)            not null
      constraint CKC_NB_PRO_PROPRIET check (NB_PRO >= 1),
   constraint PK_PROPRIETAIRE primary key (ID_PRO)
);



/*==============================================================*/
/* Table : BIEN                                                 */
/*==============================================================*/

create table BIEN 
(ID_BIEN INTEGER not null constraint CKC_ID_BIEN_BIEN check (ID_BIEN >= 1),
ID_PRO INTEGER not null constraint CKC_ID_PRO_BIEN check (ID_PRO >= 1), constraint FK_BIEN_EST_POSSE_PROPRIET FOREIGN KEY (ID_PRO) REFERENCES PROPRIETAIRE(ID_PRO),
NUM_CONT INTEGER constraint CKC_NUM_CONT_BIEN check (NUM_CONT is null or (NUM_CONT >= 1)),
TYP_BIEN VARCHAR2(6) not null constraint CKC_TYP_BIEN_BIEN check (TYP_BIEN in ('APPART','MAISON','TERR') and TYP_BIEN = upper(TYP_BIEN)),
ADR_BIEN VARCHAR2(40) not null,
VIL_BIEN VARCHAR2(30)  not null constraint CKC_VIL_BIEN_BIEN check (VIL_BIEN = upper(VIL_BIEN)),
SUP_BIEN NUMBER(10,2) not null constraint CKC_SUP_BIEN_BIEN check (SUP_BIEN >= 0),
D_CONST_BIEN DATE default '1-JAN-2500' not null,
SI_BIEN VARCHAR2(8) default 'CONTRAT' not null constraint CKC_SI_BIEN_BIEN check (SI_BIEN in ('A LOUER','A VENDRE','VIAGER','CONTRAT') and SI_BIEN = upper(SI_BIEN)),
NBP_BIEN NUMBER(3) default 0 not null constraint CKC_NBP_BIEN_BIEN check (NBP_BIEN >= 0),
VAL_BIEN NUMBER(10,2) default 0 not null constraint CKC_VAL_BIEN_BIEN check (VAL_BIEN >= 0),
MON_BIEN NUMBER(10,2) default 0 not null constraint CKC_MON_BIEN_BIEN check (MON_BIEN >= 0), constraint PK_BIEN primary key (ID_BIEN)
);

/*==============================================================*/
/* Index : EST_L_OBJET_DE_FK                                    */
/*==============================================================*/
create index EST_L_OBJET_DE_FK on BIEN (
   NUM_CONT ASC
);

/*==============================================================*/
/* Index : EST_POSSEDE_FK                                       */
/*==============================================================*/
create index EST_POSSEDE_FK on BIEN (
   ID_PRO ASC
);

/*==============================================================*/
/* Table : CLIENT                                               */
/*==============================================================*/
create table CLIENT 
(
   ID_CL                INTEGER              not null
      constraint CKC_ID_CL_CLIENT check (ID_CL >= 1),
   NOM_CL               VARCHAR2(30)         not null
      constraint CKC_NOM_CL_CLIENT check (NOM_CL = upper(NOM_CL)),
   PNOM_CL              VARCHAR2(30)         default 'SOC/ASS' not null
      constraint CKC_PNOM_CL_CLIENT check (PNOM_CL = upper(PNOM_CL)),
   RS_CL                VARCHAR2(7)          not null
      constraint CKC_RS_CL_CLIENT check (RS_CL in ('SOC/ASS','PA') and RS_CL = upper(RS_CL)),
   TEL_CL               NUMBER(10)           not null,
   VIL_CL               VARCHAR2(30)         not null
      constraint CKC_VIL_CL_CLIENT check (VIL_CL = upper(VIL_CL)),
   constraint PK_CLIENT primary key (ID_CL)
);


/*==============================================================*/
/* Table : CONTRAT                                              */
/*==============================================================*/
create table CONTRAT 
(NUM_CONT INTEGER not null constraint CKC_NUM_CONT_CONTRAT check (NUM_CONT >= 1),
ID_BIEN INTEGER not null constraint CKC_ID_BIEN_CONTRAT check (ID_BIEN >= 1), constraint FK_CONTRAT_EST_L_OBJ_BIEN FOREIGN KEY (ID_BIEN) REFERENCES BIEN(ID_BIEN),
ID_AG INTEGER not null constraint CKC_ID_AG_CONTRAT check (ID_AG >= 1), constraint FK_CONTRAT_EST_LIE_A_AGENT FOREIGN KEY (ID_AG) REFERENCES AGENT(ID_AG),
ID_CL INTEGER not null constraint CKC_ID_CL_CONTRAT check (ID_CL >= 1), constraint FK_CONTRAT_EST_LIE_CLIENT FOREIGN KEY (ID_CL) REFERENCES CLIENT(ID_CL),
TYP_CONT VARCHAR2(8) not null constraint CKC_TYP_CONT_CONTRAT check (TYP_CONT in ('LOCATION','VENTE','VIAGER') and TYP_CONT = upper(TYP_CONT)),
D_DEB_CONT DATE not null constraint CKC_D_DEB_CONT_CONTRAT check (D_DEB_CONT <= '13-JAN-2019'),
DUR_CONT INTEGER  default 0 not null constraint CKC_DUR_CONT_CONTRAT check (DUR_CONT >= 0),
MON_CONT NUMBER(10,2) default 0 not null constraint CKC_MON_CONT_CONTRAT check (MON_CONT >= 0),
VAL_CONT NUMBER(10,2) default 0 not null constraint CKC_VAL_CONT_CONTRAT check (VAL_CONT >= 0), constraint PK_CONTRAT primary key (NUM_CONT)
);


/*==============================================================*/
/* Index : EST_LIE_A_FK                                         */
/*==============================================================*/
create index EST_LIE_A_FK on CONTRAT (
   ID_AG ASC
);

/*==============================================================*/
/* Index : EST_L_OBJET_DE2_FK                                   */
/*==============================================================*/
create index EST_L_OBJET_DE2_FK on CONTRAT (
   ID_BIEN ASC
);

/*==============================================================*/
/* Index : EST_LIE_FK                                           */
/*==============================================================*/
create index EST_LIE_FK on CONTRAT (
   ID_CL ASC
);

alter table BIEN add constraint FK_BIEN_EST_L_OBJ_CONTRAT FOREIGN KEY (NUM_CONT) REFERENCES CONTRAT(NUM_CONT);

/* alter table BIEN
   add constraint FK_BIEN_EST_POSSE_PROPRIET foreign key (ID_PRO)
      references PROPRIETAIRE (ID_PRO);*/

/*alter table CONTRAT
   add constraint FK_CONTRAT_EST_LIE_CLIENT foreign key (ID_CL)
      references CLIENT (ID_CL);*/

/* alter table CONTRAT
   add constraint FK_CONTRAT_EST_LIE_A_AGENT foreign key (ID_AG)
      references AGENT (ID_AG);*/

/* alter table CONTRAT
   add constraint FK_CONTRAT_EST_L_OBJ_BIEN foreign key (ID_BIEN)
      references BIEN (ID_BIEN);*/ 



insert into PROPRIETAIRE values(1,'ERIKSSON','DENIS','24-NOV-1935',0625012458,'NICE',1);
insert into PROPRIETAIRE values(2,'DOCOMPO','GILLES','8-DEC-1977',0708040200,'NICE',2);
insert into PROPRIETAIRE values(3,'CRISTENSEN','DYLAN','24-AUG-1986',0705010240,'NICE',1);
insert into PROPRIETAIRE values(4,'ADMISSIONS',DEFAULT,DEFAULT,0699898521,'NICE',3);
insert into PROPRIETAIRE values(5,'DYALA','LOUISE','17-MAR-1987',0704121516,'ST LAURENT DU VAR',1);
insert into PROPRIETAIRE values(6,'COURTIS','FANNY','29-JAN-1965',0696959412,'CAGNES SUR MER',1);
insert into PROPRIETAIRE values(7,'GARCIA','CLEMENCE','8-JUN-1979',0659595857,'CAGNES SUR MER',1);
insert into PROPRIETAIRE values(8,'DECO',DEFAULT,DEFAULT,0693929598,'NICE',2);
insert into PROPRIETAIRE values(9,'NICOLAS',DEFAULT, DEFAULT,0623262824,'NICE',1);
insert into PROPRIETAIRE values(10,'MARTINEZ','MATHILDA','10-NOV-1990',0699998512,'PARIS',1);
insert into PROPRIETAIRE values(11,'CHEVALIER','ROXANE','9-DEC-1978',0645489621,'ST LAURENT DU VAR',2);
insert into PROPRIETAIRE values(12,'LCELA',DEFAULT,DEFAULT,0688447596,'PARIS',2);
insert into PROPRIETAIRE values(13,'LAMERT','MAXIME','14-OCT-1965',0747854751,'ANTIBES',1);
insert into PROPRIETAIRE values(14,'LOPEZ','HRANCOIS','5-JUN-1971',0669469544,'ANTIBES',1);

insert into AGENT values(1,'TEMKIN','FLORIAN','3-MAR-1993',0,'5-MAR-2017','NICE',0606060606);
insert into AGENT values(2,'PINEIRO','JEROME','9-SEP-1980',3,'10-NOV-2010','ST LAURENT DU VAR',0628541200);
insert into AGENT values(3,'RAIDAUT','ELENA','12-FEB-1988',2,'24-AUG-2014','NICE',0602040687);
insert into AGENT values(4,'SCHMIDT','CLARA','5-DEC-1990',2,'15-JAN-2010','CANNES',0650214582);
insert into AGENT values(5,'RAIDAUT','CHRISTINE','17-APR-1982',1,'17-DEC-2015','ST LAURENT DU VAR', 0652525252);
insert into AGENT values(6,'ARMA','LAURA','18-MAR-1992',DEFAULT,'14-APR-2014','NICE',0600040201);
insert into AGENT values(7,'CARRE','CHARLES','14-SEP-1988',2,'13-NOV-2016','CAGNES SUR MER', 0701020304);
insert into AGENT values(8,'ALLON','CHRISTOPHE','12-JAN-1966',2,'29-MAR-2008','NICE',0625214587);
insert into AGENT values(9, 'LEGRAND','VINCENT','4-JUL-1975',3,'20-APR-2010','CAGNES SUR MER',0707010445);

insert into CLIENT values(1,'DUPONT','HENRI','PA',0650489785,'PARIS');

insert into CLIENT values(2,'CARR','ADELE','PA',0647852125,'LYON');

insert into CLIENT values(3,'MADONNA',DEFAULT,'SOC/ASS',0621547896,'PARIS');

insert into CLIENT values(4,'EXEMPLE',DEFAULT,'SOC/ASS',0612045784,'PARIS');

insert into CLIENT values(5,'DURAND','ANTOINE','PA',0741528654,'TOULON');

insert into CLIENT values(6,'MERLE','MICHEL','PA',0645125874,'CAGNES SUR MER');

insert into CLIENT values(7,'PETSCHE','MARIE','PA',0645875214,'NICE');

insert into CLIENT values(8,'MCNAMARA','ELISA','PA',0689542177,'NICE');

insert into CLIENT values(9,'WERNER','JEANNE','PA',0758423007,'CANNES');

insert into CLIENT values(10,'ASF',DEFAULT,'SOC/ASS',0689641257,'NICE');

insert into CLIENT values(11,'VENDOME',DEFAULT,'SOC/ASS',0600245874,'TOULON');

insert into CLIENT values(12,'PAUGAM','REMY','PA',0687002415,'CANNES');

insert into CLIENT values(13,'JEON','MARIE','PA',066086941,'ANTIBES');

insert into CLIENT values(14,'PARK','KIM','PA',0654125874,'NICE');

insert into CLIENT values(15,'TUCKER','SCOTT','PA',0632457899,'ANTIBES');


insert into BIEN values(1,4,NULL,'APPART','93 AVENUE CYRILLE','NICE EST',70,'1-MAR-1956',DEFAULT,4,DEFAULT,835);
insert into BIEN values(2,4,NULL,'APPART','8 AVENUE SAINT AUGUSTIN','NICE OUEST',90,'15-SEP-2006',DEFAULT,6,495000,DEFAULT);
insert into BIEN values(3,4,NULL,'TERR','98 AVENUE ST LAMBERT','NICE NORD',1400,DEFAULT,DEFAULT,DEFAULT,220000,DEFAULT);
insert into BIEN values(4,7,NULL,'APPART','69 BOULEVARD GORBELLA','NICE NORD',76.05,'19-JUN-2007',DEFAULT,4,DEFAULT,950);
insert into BIEN values(5,1,NULL,'MAISON','10 AVENUE FELIX FAURE','NICE SUD',120.69,'26-AUG-1987',DEFAULT,6,79000,DEFAULT);
insert into BIEN values(6,2,NULL,'TERR','26 AVENUE PIERRE ISNARD','NICE OUEST',300,DEFAULT,DEFAULT,DEFAULT,100000,DEFAULT);
insert into BIEN values(7,2,NULL,'MAISON','17 RUE SCARLIERO','NICE EST',130,'2-APR-1959',DEFAULT,6,540120,DEFAULT);
insert into BIEN values(8,5,NULL,'APPART','19 AVENUE GERMAINE','NICE EST',44.81,'6-NOV-1998',DEFAULT,3,250000,DEFAULT);
insert into BIEN values(9,8,NULL,'APPART','26 CHEMIN DU VINAIGRIER','NICE EST',60.25,'30-NOV-2010','A LOUER',4,DEFAULT,750);
insert into BIEN values(10,8,NULL,'MAISON','78 CHEMIN DE ARIETA','NICE OUEST',100.03,'19-JAN-1978',DEFAULT,5,420000,DEFAULT);
insert into BIEN values(11,3,NULL,'APPART','88 AVENUE SIMONE VEIL','NICE OUEST',58.65,'6-SEP-2000','A LOUER',4,DEFAULT,675);
insert into BIEN values(12,6,NULL,'APPART','23 AVENUE VALROSE','NICE NORD',88.04,'9-MAR-1999',DEFAULT,5,DEFAULT,720);
insert into BIEN values(13,9,NULL,'APPART','13 CHEMIN DE CREMAT','NICE OUEST',120.63,'25-APR-1994','A VENDRE',7,750200,DEFAULT);
insert into BIEN values(14,11,NULL,'TERR','58 CHEMIN DES SERRES','NICE OUEST',375.04,DEFAULT,DEFAULT,DEFAULT,120000,DEFAULT);
insert into BIEN values(15,12,NULL,'APPART','66 RUE DE LA BUFFA','NICE SUD',84.64,'10-JUL-1979',DEFAULT,6,DEFAULT,970);
insert into BIEN values(16,12,NULL,'APPART','7 RUE FRANCOIS PELLOS','NICE NORD',62.29,'5-JUL-1955','A LOUER',4,DEFAULT,680);
insert into BIEN values(17,14,NULL,'TERR','45 RUE GOUNOD','NICE SUD',1250.96,DEFAULT,DEFAULT,DEFAULT,250000,DEFAULT);
insert into BIEN values(18,10,NULL,'MAISON','85 RUE SORGENTINO','NICE EST',215.30,'19-NOV-1989','A VENDRE',9,1500720,DEFAULT);
insert into BIEN values(19,13,NULL,'MAISON','33 AVENUE DENIS SEMERIA','NICE EST',132.82,'30-AUG-2001',DEFAULT,7,850000,DEFAULT);
insert into BIEN values(20,11,NULL,'MAISON','12 AVENUE DE PESSICART','NICE NORD',115.30,'12-JUL-1988',DEFAULT,5,759000,DEFAULT);

insert into CONTRAT values(1,1,3,5,'LOCATION','15-SEP-2017',60,835,DEFAULT);
insert into CONTRAT values(2,2,8,15,'VENTE','14-NOV-2016',DEFAULT,DEFAULT,495000);
insert into CONTRAT values(3,3,9,11,'VENTE','01-DEC-2018',DEFAULT,DEFAULT,220000);
insert into CONTRAT values(4,4,8,2,'LOCATION','19-SEP-2012',84,950,DEFAULT);
insert into CONTRAT values(5,5,3,9,'VIAGER','20-AUG-2018',DEFAULT,DEFAULT,79000);
insert into CONTRAT values(6,6,4,10,'VENTE','10-JAN-2017',DEFAULT,DEFAULT,100000);
insert into CONTRAT values(7,7,9,12,'VENTE','2-JUL-2015',DEFAULT,DEFAULT, 540120);
insert into CONTRAT values(8,8,9,7,'VENTE','3-NOV-2017',DEFAULT,DEFAULT,250000);
insert into CONTRAT values(9,10,5,6,'VENTE', '16-JUN-2006',DEFAULT, DEFAULT,420000);
insert into CONTRAT values(10,12,7,13,'LOCATION','31-AUG-2018',12,720,DEFAULT);
insert into CONTRAT values(11,14,7,14,'VENTE','2-JUL-2012',DEFAULT,DEFAULT,120000);
insert into CONTRAT values(12,15,4,8,'LOCATION','8-MAR-2013',100,970,DEFAULT);
insert into CONTRAT values(13,17,2,3,'VENTE','30-MAY-2017',DEFAULT,DEFAULT,250000);
insert into CONTRAT values(14,19,2,1,'VENTE','31-AUG-2013',DEFAULT,DEFAULT,850000);
insert into CONTRAT values(15,20,2,4,'VENTE','21-SEP-2016',DEFAULT,DEFAULT,759000);

UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=1) where ID_BIEN=1;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=2) where ID_BIEN=2;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=3) where ID_BIEN=3;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=4) where ID_BIEN=4;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=5) where ID_BIEN=5;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=6) where ID_BIEN=6;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=7) where ID_BIEN=7;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=8) where ID_BIEN=8;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=10) where ID_BIEN=10;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=12) where ID_BIEN=12;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=14) where ID_BIEN=14;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=15) where ID_BIEN=15;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=17) where ID_BIEN=17;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=19) where ID_BIEN=19;
UPDATE BIEN set NUM_CONT=(SELECT NUM_CONT FROM CONTRAT WHERE ID_BIEN=20) where ID_BIEN=20;


commit; 

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



/*CONTROL */

/* select * from user_objects where object_name='EST_LIE_FK';

select * from user_objects where object_name='FK_BIEN_EST_L_OBJ_CONTRAT';

select constraint_name, constraint_type from user_constraints where table_name='BIEN'; 

select * from user_constraints where table_name='BIEN'; */