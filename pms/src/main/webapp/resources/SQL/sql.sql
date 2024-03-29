/* PMS */
  /* TABLES 
    0-1. MEMBERLEVEL(MLV) : 멤버등급
         등급코드, 등급명
    0-2. CLASSES(CLA) : 멤버가 소속되어있는 반
         반코드, 반명, 기수
    1. PMSMEMBERS(PMB) : 프로젝트에 참여 할 수 있는 멤버
         멤버코드, 인증패스워드, 멤버명, 등급코드, 반코드
  */
-- 0-1 DBA:MEMBERLEVEL(MLV)
CREATE TABLE MEMBERLEVEL(
  MLV_CODE  NCHAR(1) NOT NULL,
  MLV_NAME  NVARCHAR2(10) NOT NULL
)TABLESPACE USERS;

  -- DBA:CONSTRAINTS
  ALTER TABLE MEMBERLEVEL
  ADD CONSTRAINT MLV_CODE_PK    PRIMARY KEY(MLV_CODE);
  
  -- DBA:GRANT
  GRANT SELECT, UPDATE, INSERT ON HOONZZANG.MEMBERLEVEL TO JH, KHB, TH, SG;
  
  -- DEV:PERSONAL SYNONYM
  CREATE SYNONYM MLV FOR TEAM4.MEMBERLEVEL;
  
  -- DEV:DATA INPUT
  INSERT INTO MLV(MLV_CODE, MLV_NAME) VALUES('S', 'STUDENT');
  INSERT INTO MLV(MLV_CODE, MLV_NAME) VALUES('T', 'TEACHER');
  INSERT INTO MLV(MLV_CODE, MLV_NAME) VALUES('E', 'EMPLOYEE');
 
  
-- 0-2. CLASSES(CLA)
CREATE TABLE CLASSES(
  CLA_CODE      NCHAR(3)        NOT NULL,
  CLA_NAME      NVARCHAR2(50)   NOT NULL,
  CLA_NUM       NUMBER(2, 0)    NOT NULL
)TABLESPACE USERS;

  -- CONSTRAINTS
  ALTER TABLE CLASSES
  ADD CONSTRAINT CLA_CODE_PK    PRIMARY KEY(CLA_CODE);
  
  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON HOONZZANG.CLASSES TO JH, KHB, TH, SG;
  
  -- SYNONYM
  CREATE SYNONYM CLA FOR TEAM4.CLASSES;
  
  -- DATA INPUT
  INSERT INTO CLA(CLA_CODE, CLA_NAME, CLA_NUM) VALUES('F01', 'JS프레임워크를 활용한 스마트 웹 개발자', 3);



-- 1. PMSMEMBERS(PMB)
CREATE TABLE PMSMEMBERS(
  PMB_CODE      NCHAR(8)        NOT NULL,  -- YYYYMM+순번
  PMB_PASSWORD  NVARCHAR2(500)  NOT NULL,  -- 암호화
  PMB_NAME      NVARCHAR2(5)    NOT NULL,
  PMB_MLVCODE   NCHAR(1)        NOT NULL,
  PMB_CLACODE   NCHAR(3)        NOT NULL
)TABLESPACE USERS;

  -- CONSTRAINTS
  ALTER TABLE PMSMEMBERS
  ADD CONSTRAINT PMB_CODE_PK    PRIMARY KEY(PMB_CODE)
  ADD CONSTRAINT PMB_MLVCODE_FK FOREIGN KEY(PMB_MLVCODE) REFERENCES MEMBERLEVEL(MLV_CODE)
  ADD CONSTRAINT PMB_CLACODE_FK FOREIGN KEY(PMB_CLACODE) REFERENCES CLASSES(CLA_CODE);
  
  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON HOONZZANG.PMSMEMBERS TO JH, KHB, TH, SG;
  select*from pmb;
  -- SYNONYM
  CREATE SYNONYM PMB FOR TEAM4.PMSMEMBERS;
  
  -- DATA INPUT
  INSERT INTO PMB(PMB_CODE, PMB_PASSWORD, PMB_NAME, PMB_MLVCODE, PMB_CLACODE) 
  VALUES('20220401', '1234', '훈짱', 'T', 'F01');
  
  
  -- TABLE CHECK
  SELECT * FROM USER_TABLES;
  SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN('PMSMEMBERS', 'MEMBERLEVEL', 'CLASSES');
  SELECT * FROM USER_TAB_COLS WHERE TABLE_NAME IN('PMSMEMBERS', 'MEMBERLEVEL', 'CLASSES')
  ORDER BY TABLE_NAME;

  -- PMBNAME 데이터 사이즈 늘리기
  ALTER TABLE PMSMEMBERS
  MODIFY PMB_NAME NVARCHAR2(200);
 
  
  -- EMAIL COLUMN 추가
  ALTER TABLE PMSMEMBERS
  ADD PMB_EMAIL NVARCHAR2(100) NULL;

  

  ALTER TABLE PMSMEMBERS
--  DELETE PMS_EMAIL NVARCHAR2(100) NULL;
-- 2. ACCESSLOG(ASL) -- 중복 로그인 허용 X
CREATE TABLE ACCESSLOG(
  ASL_PMBCODE   NCHAR() NOT NULL,
  ASL_DATE      DATE DERAULT SYSDATE NOT NULL,
  ASL_PUBLICIP  NVARCHAR2(15)    NOT NULL, 
  ASL_PRIVATEIP NVARCHAR2(15)    NOT NULL, 
  ASL_ACTION    NUMBER(1)   NOT NULL
)TABLESPACE USERS;
ALTER TABLE ACCESSLOG DROP COLUMN ASL_DEVICE;
SELECT * FROM ACCESSLOG;

  -- CONSTRAINTS
  ALTER TABLE ACCESSLOG
  ADD CONSTRAINT ASL_PMBCODE_DATE_PIP_RIP_ACT_P PRIMARY KEY(ASL_PMBCODE, ASL_DATE, ASL_PRIVATEIP, ASL_PUBLICIP, ASL_ACTION)
  ADD CONSTRAINT ASL_PMBCODE_FK FOREIGN KEY(ASL_PMBCODE) REFERENCES PMSMEMBERS(PMB_CODE);
  
  -- SYNONYM 
  CREATE SYNONYM ASL FOR TEAM4.ACCESSLOG;
  SELECT*FROM ASL;

  -- GRANT
  GRANT SELECT, INSERT, UPDATE ON TEAM4.ACCESSLOG TO CJS, SHY, CHAEI;
  
  -- TABLE CHECK
  SELECT * FROM USER_TABLES;
select*from PMB;

/* ACCESSLOG INS */
INSERT INTO(ASL_PMBCODE, ASL_DATE, ASL_PUBLICIP, ASL_PRIVATEIP, ASL_ACTION)
VALUES(, DEFAULT, , ,);

CREATE OR REPLACE VIEW ACCESSINFO
AS
SELECT  PMB_CODE AS PMBCODE, 
        PMB_NAME AS PMBNAME, 
        PMB_MLVCODE AS PMBLEVEL, 
        PMB_EMAIL AS PMBEMAIL,
        MLV.MLV_NAME AS PMBLEVELNAME, 
        PMB_CLACODE AS PMBCLASS, 
        CLA.CLA_NAME AS PMBCLASSNAME,
        LAS.ASLDATE AS ASLDATE,
        LAS.ASLPUBLICIP AS ASLPUBLICIP,
        LAS.ASLPRIVATEIP AS ASLPRIVATEIP
FROM PMB INNER JOIN MLV ON PMB.PMB_MLVCODE = MLV.MLV_CODE
         INNER JOIN CLA ON PMB.PMB_CLACODE = CLA.CLA_CODE
         INNER JOIN LASTACCESS LAS ON PMB.PMB_CODE = LAS.PMBCODE;

SELECT*FROM ACCESSINFO WHERE PMBCODE = '';

SELECT
CREATE OR REPLACE VIEW LASTACCESS
AS
SELECT ASL_PMBCODE AS PMBCODE,
       TO_CHAR(MAX(ASL_DATE),'YYYYMMDDHH24MISS') AS ASLDATE
FROM ASL
WHERE  ASL_ACTION = 1
GROUP BY ASL_PMBCODE;


SELECT * FROM ACCESSINFO;
SELECT * FROM LASTACCESS;
SELECT * FROM PMB;
SELECT * FROM ASL;
--DELETE FROM PMB;
CREATE SYNONYM ACCESSINFO FOR TEAM4.ACCESSINFO;
CREATE SYNONYM LASTACCESS FOR TEAM4.LASTACCESS;


SYNONYM
GRANT SELECT,INSERT,UPDATE ON ACCESSINFO TO CJS,SHY,CHAE;
GRANT SELECT,INSERT,UPDATE ON LASTACCESS TO CJS,SHY,CHAE;

WHERE PMBCODE = '20220704';

--DELETE FROM ASL;

SELECT COALESCE (SUM(ASL_ACTION), 0) AS ACTIONSTATE FROM ASL WHERE ASL_PMBCODE = '20220701';

-----20220713
/* PROJECT TABLE(PRO) */
CREATE TABLE PROJECTS(
  PRO_CODE      NCHAR(20)       NOT NULL,  -- YYMMDDHH24MISS + PMBCODE
  PRO_NAME      NVARCHAR2(100)  NOT NULL,
  PRO_COMMENTS  NVARCHAR2(2000) NOT NULL,
  PRO_START     DATE            NOT NULL,
  PRO_END       DATE            NOT NULL,
  PRO_VISIBLE   NCHAR(1)        NOT NULL   -- T F
)TABLESPACE USERS;
  -- CONSTRAINTS
  ALTER TABLE PROJECTS
  ADD CONSTRAINT PRO_CODE_PK    PRIMARY KEY(PRO_CODE);
  -- SYNONYM
  CREATE SYNONYM PRO FOR TEAM4.PROJECTS;
  SELECT*FROM TEAM4.PROJECTS;
  SELECT*FROM PRO;
/* PROJECT CATEGORY CODE(PCC) */
CREATE TABLE CATEGORYCODE(
  PCC_CODE  NCHAR(2)        NOT NULL,
  PCC_NAME  NVARCHAR2(10)   NOT NULL,
)TABLESPACE USERS;
  -- CONSTRAINTS
  ALTER TABLE CATEGORYCODE 
  ADD CONSTRAINT PCC_CODE_PK    PRIMARY KEY(PCC_CODE);
  -- SYNONYM
  CREATE SYNONYM PCC FOR TEAM4.CATEGORYCODE;
  -- DATA
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('MG', 'MANAGER');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('PT', 'PART-MANAGER');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('MB', 'MEMBER');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('ST', '초청장 발송');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('AC', '수락');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('RF', '거부');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('NA', '인증 전');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('AU', '인증 완료');
  INSERT INTO PCC(PCC_CODE, PCC_NAME) VALUES('NN', '인증 실패');


/* PROJECT MEMBER TABLE(PRM) */
CREATE TABLE PROJECTMEMBERS(
  PRM_PROCODE   NCHAR(20)   NOT NULL,
  PRM_PMBCODE   NCHAR(8)    NOT NULL,
  PRM_POSITION  NCHAR(1)    NOT NULL,
  PRM_ACCEPT    NCHAR(2)    DEFAULT 'ST' NOT NULL
)TABLESPACE USERS;
  -- CONSTRAINTS
  ALTER TABLE PROJECTMEMBERS
  ADD CONSTRAINT PRM_PRO_PMB_CODE_PK    PRIMARY KEY(PRM_PROCODE, PRM_PMBCODE)
  ADD CONSTRAINT PRM_PROCODE_FK FOREIGN KEY(PRM_PROCODE) REFERENCES PROJECTS(PRO_CODE)
  ADD CONSTRAINT PRM_PMBCODE_FK FOREIGN KEY(PRM_PMBCODE) REFERENCES PMSMEMBERS(PMB_CODE)
  ADD CONSTRAINT PRM_POSITION_FK FOREIGN KEY(PRM_POSITION) REFERENCES CATEGORYCODE(PCC_CODE);
  ADD CONSTRAINT PRM_ACCEPT_FK FOREIGN KEY(PRM_ACCEPT) REFERENCES CATEGORYCODE(PCC_CODE);
  -- SYNONYM
  CREATE SYNONYM PRM FOR TEAM4.PROJECTMEMBERS;

  -- PRM_POSITION NULL로 변경
  ALTER TABLE PROJECTMEMBERS
  MODIFY PRM_POSITION NULL;
  

--  delete from aul;
  SELECT *FROM aul;
--delete from asl where asl_pmbcode='20220704';
--  delete from pmb where pmb_code='20220704';
  

  SELECT*FROM PRO;
INSERT INTO PRO(PRO_CODE,PRO_NAME,PRO_COMMENTS,PRO_START,PRO_END,PRO_VISIBLE)
VALUES((TO_CHAR(SYSDATE,'YYYYMMDDHH24MI')||'20220706'),'name','hi',SYSDATE,SYSDATE,'F');

CREATE OR REPLACE VIEW PMBMEMBERS
AS
SELECT PMB.PMB_CODE AS PMBCODE,
       PMB.PMB_NAME AS PMBNAME,
       PMB.PMB_EMAIL AS PMBEMAIL
       PMB.PMB_MLVCODE AS PMBLEVEL,
       MLV.MLV_NAME AS PMBLEVELNAME,
       PMB.PMB_CLACODE AS PMBCLASS,
       CLA.CLA_NAME AS PMBCLASSNAME
FROM PMB INNER JOIN MLV ON PMB.PMB_MLVCODE = MLV.MLV_CODE
         INNER JOIN CLA ON PMB.PMB_CLACODE = CLA.CLA_CODE;

CREATE SYNONYM PMBMEMBERS FOR TEAM4.PMBMEMBERS;
SELECT*FROM PMBMEMBERS;


--2022.07.18
/* AUTHLOG (AUL) */
CREATE TABLE AUTHLOG(
  AUL_SPMBCODE      NCHAR(8)   NOT NULL,
  AUL_RPMBCODE    NCHAR(8)   NOT NULL,
  AUL_INVITEDATE         DATE     DEFAULT SYSDATE NOT NULL,
  AUL_EXPIRE             NUMBER   DEFAULT 5,
  AUL_AUTHRESULT         NCHAR(2) DEFAULT 'NA' NOT NULL
)TABLESPACE USERS;

-- CONSTRAINTS
 ALTER TABLE AUTHLOG
 ADD CONSTRAINT AUL_SPMB_RPMB_INVITE_PK    PRIMARY KEY(AUL_SPMBCODE, AUL_RPMBCODE, AUL_INVITEDATE)
 ADD CONSTRAINT AUL_SPMBCODE_FK    FOREIGN KEY(AUL_SPMBCODE) REFERENCES PMSMEMBERS(PMB_CODE)
 ADD CONSTRAINT AUL_SPMBCODE_FK    FOREIGN KEY(AUL_RPMBCODE) REFERENCES PMSMEMBERS(PMB_CODE)
 ADD CONSTRAINT AUL_AUTHRESULT_FK  FOREIGN KEY(AUL_AUTHRESULT) REFERENCES CATEGORYCODE(PCC_CODE);
 

-- SYNONYM
 CREATE SYNONYM  AUL FOR TEAM4.AUTHLOG;
 
-- GRANT
GRANT SELECT, UPDATE, INSERT ON TEAM4.AUTHLOG TO CJS,SHY,CHAE;
select*from prm;
SELECT*FROM AUL;
INSERT INTO AUL(AUL_SPMBCODE,AUL_RPMBCODE,AUL_INVITEDATE,AUL_EXPIRE,AUL_AUTHRESULT)
		VALUES('20220701','20220702',default,default,default);
select aul_spmbcode, aul_rpmbcode, max(aul_invitedate)
from aul
where aul_spmbcode = '20220701' and aul_rpmbcode='20220703'
group by aul_spmbcode, aul_rpmbcode;

/* 로그인 한 계정의 초대장 알림체크 */
SELECT SYSDATE, SYSDATE + (5/(24*60)) FROM DUAL;

CREATE OR REPLACE VIEW RINVITEINFO
AS
SELECT  AUL.AUL_SPMBCODE AS SPMBCODE, 
        PMB.PMB_NAME  AS SENDERNAME,
        AUL.AUL_RPMBCODE AS RPMBCODE, 
        AUL.AUL_AUTHRESULT AS AUTHRESULT, 
        AUL.AUL_INVITEDATE AS INVITEDATE,
        AUL.AUL_INVITEDATE + (5 / (24*60)) AS EXPIREDATE
FROM AUL INNER JOIN PMB ON  AUL.AUL_SPMBCODE = PMB.PMB_CODE;

SELECT 	SENDER, SENDERNAME, RECEIVER, TO_CHAR(INVITEDATE,'YYYYMMDDHH24MISS') AS INVITEDATE, 
				TO_CHAR(EXPIREDATE, 'YYYYMMDDHH24MISS') AS EXPIREDATE, AUTHRESULT
		FROM RINVITEINFO 
		WHERE RECEIVER = '20220702' AND INVITEDATE >= (SYSDATE - 1);

CREATE SYNONYM SINVITEINFO FOR TEAM4.SINVITEINFO;
select*from RINVITEINFO;
grant select,delete,insert on team4.SINVITEINFO to shy,cjs,chae;


CREATE OR REPLACE VIEW SINVITEINFO
AS
SELECT  AUL.AUL_SPMBCODE AS SPMBCODE, 
        AUL.AUL_RPMBCODE AS RPMBCODE, 
        PMB.PMB_NAME  AS RECEIVERNAME, 
        AUL.AUL_AUTHRESULT AS AUTHRESULT, 
        AUL.AUL_INVITEDATE AS INVITEDATE,
        AUL.AUL_INVITEDATE + (5 / (24*60)) AS EXPIREDATE,
        PCC.PCC_NAME AS AUTHRESULTNAME
FROM AUL INNER JOIN PMB ON  AUL.AUL_RPMBCODE = PMB.PMB_CODE
         INNER JOIN PCC ON  AUL.AUL_AUTHRESULT = PCC.PCC_CODE;
/* 받은 초청장 정보 */
SELECT 	SENDER, SENDERNAME, RECEIVER, TO_CHAR(INVITEDATE,'YYYYMMDDHH24MISS') AS INVITEDATE, 
				TO_CHAR(EXPIREDATE, 'YYYYMMDDHH24MISS') AS EXPIREDATE
		FROM INVITEINFO 
		WHERE RECEIVER = '20220701' AND INVITEDATE >= (SYSDATE - 1)

/* 보낸 초청장 정보 */;
SELECT * FROM SINVITEINFO;
WHERE   SENDER = '20220701';

SELECT * FROM PRM;
select * from;
SELECT * FROM AUL;

SELECT PRM.PRM_PROCODE AS PROCODE
FROM PRM
INNER JOIN AUL ON PRM.PRM_PMBCODE = AUL.AUL_RPMBCODE
WHERE   PRM.PRM_ACCEPT = 'ST' AND PRM.PRM_PMBCODE ='20220701'
GROUP BY PRM.PRM_PROCODE;


SELECT  AUL.AUL_SPMBCODE AS SENDER, PMB.PMB_NAME  AS SENDERNAME,
        AUL.AUL_RPMBCODE AS RECEIVER, AUL.AUL_AUTHRESULT AS AUTHRESULT, 
        AUL.AUL_INVITEDATE AS INVITEDATE,
        AUL.AUL_INVITEDATE + (5 / (24*60)) AS EXPIREDATE
FROM AUL INNER JOIN PMB ON  AUL.AUL_SPMBCODE = PMB.PMB_CODE
WHERE AUL.AUL_RPMBCODE = '20220708';


		SELECT AUL.AUL_SPMBCODE AS SPMBCODE, PMB.PMB_NAME AS SENDERNAME,
			   AUL.AUL_RPMBCODE AS RPMBCODE, AUL.AUL_INVITEDATE AS INVITEDATE
		FROM AUL INNER JOIN PMB ON AUL.AUL_SPMBCODE = PMB.PMB_CODE
		WHERE AUL_RPMBCODE = '20220701' AND
		AUL_AUTHRESULT = 'NA' AND
		SYSDATE <= AUL_INVITEDATE + 1;
        
/* 2022.07.20 */
/* PROJECTMEMBERS UPDATE */
UPDATE PRM SET PRM_ACCEPT = '' WHERE PRM_PROCODE = '' AND PRM_PMBCODE = '';
/* AUTHLOG UPDATE */
UPDATE AUL SET AUL_AUTHRESULT = '' WHERE AUL_SPMBCODE = '' AND AUL_RPMBCODE = '' AND AUL_INVITEDATE = TO_DATE('','YYYYMMDDHH24MISS');

/* 2022.07.21 */

/* PROJECT INFO
    
   PROJECT NAME         >> PRO
   PROJECT DIRECTOR     >> PRM = PMB << MG
   PROJECT PERIOD       >> PRO
*/
CREATE OR REPLACE VIEW MYPROJECT
AS
SELECT PRO_CODE AS PROCODE,
       PRO_NAME AS PRONAME,
       PRM_PMBCODE AS PMBCODE,
       PRM_ACCEPT AS PRMACCEPT,
       TO_CHAR(PRO_START,'YYYY-MM-DD') || '~' || TO_CHAR(PRO_END,'YYYY-MM-DD') AS "PERIOD"
FROM PRO INNER JOIN PRM ON PRO.PRO_CODE = PRM.PRM_PROCODE
         INNER JOIN PMB ON PRM.PRM_PMBCODE = PMB.PMB_CODE;
WHERE PRM_PMBCODE = '20220701' AND PRM_ACCEPT = 'AC';
-- DATA
UPDATE PRM SET PRM_POSITION = 'MG' WHERE PRM_PMBCODE = '20220701' AND PRM_ACCEPT = '';

-- SYNONYM
 CREATE SYNONYM  MYPROJECT FOR TEAM4.MYPROJECT;
 
-- PRM_POSITION : NCHAR(2)로 변경
ALTER TABLE PROJECTMEMBERS
MODIFY PRM_POSITION NCHAR(2);
 
 -- MYBATIS
SELECT PROCODE, PRONAME, "PERIOD",
       PRM.PRM_PMBCODE AS DIRCODE,
       PMB.PMB_NAME AS DIRECTOR
FROM MYPROJECT MP INNER JOIN PRM ON MP.PROCODE = PRM.PRM_PROCODE
                  INNER JOIN PMB ON PRM.PRM_PMBCODE = PMB.PMB_CODE
WHERE MP_PMBCODE = '20220701' AND MP_ACCEPT = 'AC'
      AND PRM.PRM_POSITION = 'MG';

/* 2022.07.22 */
CREATE OR REPLACE VIEW PROJECTSUMMARY
SELECT PRO_CODE AS PROCODE, 
       PRO_NAME AS PRONAME,
       PRM_PMBCODE AS PMBCODE, --PMB 멤버코드 이용해서 NEAME 추출 
       PRM_ACCEPT AS PRMACCEPT,
       TO_CHAR(PRO_START,'YYYY-MM-DD')||'~'||TO_CHAR(PRO_END,'YYYY-MM-DD') AS "PERIOD"
FROM PRO INNER JOIN PRM ON PRO.PRO_CODE = PRM.PRM_PROCODE
        INNER JOIN PMB ON PRM.PRM_PMBCODE = PMB.PMB_CODE;
--DATE
UPDATE PRM SET PRM_POSITION ='MG' WHERE PRM_PMBCODE='20220703' AND PRM_ACCEPT='AC'
        
        
WHERE PRM_PMBCODE = '20220703' AND PRM_ACCEPT='AC'; --내 PMB코드, 그리고 승낙한 것     
    
SELECT * FROM PROJECTSUMMARY;
CREATE SYNONYM  PROJECTSUMMARY FOR TEAM4.PROJECTSUMMARY;

SELECT PROCODE, PRONAME, "PEFIOD" 
        PRM.PRM_PMBCODE AS DIRCODE,
        PMB.PMB_NAME AS DIRECTOR
FROM MYPROJECT MP
    INNER JOIN PRM ON MP.PROCODE = PRM.PRM_PROCODE
    INNER JOIN PMB ON PRM.PRM_PMBCODE = PMB.PMB_CODE
WHERE MP.PMBCODE = '20220703' AND MP.PRMACCEPT='AC'
    AND PRM_POSITION = 'MG';
    

/* 2022.07.27 */
SELECT*FROM MYPROJECT;
SELECT*FROM PRM;
/* MODULES(MOU) 서비스 하나하나가 모듈CODE
  PK FK 프로젝트코드
  PK    모듈코드
     NN 모듈명
        모듈설명
*/
CREATE TABLE MODULES(
  MOU_PROCODE   NCHAR(20)       NOT NULL,
  MOU_CODE      NCHAR(2)        NOT NULL,
  MOU_NAME      NVARCHAR2(100)  NOT NULL,
  MOU_COMMENTS  NVARCHAR2(200)  NOT NULL
)TABLESPACE USERS;

-- CONSTRAINTS
ALTER TABLE MODULES
ADD CONSTRAINT MOU_PROCODE_CODE_PK  PRIMARY KEY(MOU_PROCODE, MOU_CODE)
ADD CONSTRAINT MOU_PROCODE_FK   FOREIGN KEY(MOU_PROCODE) REFERENCES PROJECTS(PRO_CODE);

-- SYNONYM
CREATE SYNONYM MOU FOR TEAM4.MODULES; 
GRANT SELECT,DELETE,INSERT,UPDATE ON TEAM4.MODULES TO CHAE,SHY,CJS;

-- DATA
SELECT*FROM PRO;
select*from MOU;
update into prm();


INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '10', 'CERTIFICATION', '로그인,로그아웃,회원가입');
INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '30', 'DASHBOARD', '초대정보,내가참여한 프로젝트 정보');
INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '40', 'MY', '?');
INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '50', 'NOTICE', '?');
INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '20', 'PROJECT', '프로젝트 생성, 멤버 초대');
INSERT INTO MOU(MOU_PROCODE, MOU_CODE, MOU_NAME, MOU_COMMENTS) VALUES('22073121184020220701', '60', 'SETTING', '?');
/* JOB(JOB) 
  PK FK 프로젝트코드
  PK    업무코드
     NN 업무명
        업무설명
*/
CREATE TABLE JOBS(
 JOS_PROCODE    NCHAR(20)       NOT NULL,
 JOS_CODE       NCHAR(3)        NOT NULL, 
 JOS_NAME       NVARCHAR2(100)  NOT NULL,
 JOS_COMMENTS   NVARCHAR2(200)
)TABLESPACE USERS;

-- CONSTRAINTS
ALTER TABLE JOBS
ADD CONSTRAINT JOS_PROCODE_CODE_PK  PRIMARY KEY(JOS_PROCODE, JOS_CODE)
ADD CONSTRAINT JOS_PROCODE_FK   FOREIGN KEY(JOS_PROCODE) REFERENCES PROJECTS(PRO_CODE);

-- SYNONYM
CREATE SYNONYM  JOS FOR TEAM4.JOBS;
GRANT SELECT,DELETE,INSERT,UPDATE ON TEAM4.JOBS TO CHAE,SHY,CJS;

-- DATA
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22073121184020220701','101','FIRST','세션 O -> 대쉬보드페이지, 세션 X -> 로그인페이지');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','102','MOVEJOINFORM','회원가입 페이지로 이동');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','103','JOIN','회원가입 제어');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','104','AUTH','로그인 제어');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','105','LOGOUT','로그아웃');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','201','NEWPROJECT','프로젝트 생성 페이지 이동');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','203','INVITEMEMBER','프로젝트 생성 후 멤버 초대');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','301','DASHBOARD','대쉬보드 페이지 이동');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','302','EMAILCODECER','메일로받은 인증코드 확인 후 UPDATE');
INSERT INTO JOS(JOS_PROCODE, JOS_CODE, JOS_NAME, JOS_COMMENTS) VALUES('22080110153420220702','202','REGPROJECT','AJAX 방식으로 받은 데이터로 프로젝트 등록');
SELECT * FROM JOS;
/* MODULE_JOB (MODULE<->MOD 다대다 테이블):독립적,자유 1개의모듈이 여러개의 잡 가능, 1개의잡이 여러개의 모듈 가능
  PK FK FK FK 프로젝트코드   (1ST FK => MODULE을 쳐다봄, 2EN FK => JOB을 쳐다봄 3RD KF => PRM을 쳐다봄)
  PK FK       모듈코드
  PK    FK    업무코드
           FK 담당자 [PRM코드의 PK가 PROCODE,PMBCODE(담당자)두개이기때문에 프로젝트코드와 같이 FK가 됨]
*/
SELECT * FROM PRM;
CREATE TABLE MODULE_JOB(
 MJ_PROCODE     NCHAR(20)       NOT NULL,
 MJ_MOUCODE     NCHAR(2)        NOT NULL,
 MJ_JOSCODE     NCHAR(3)        NOT NULL,
 MJ_PRMPMBCODE  NCHAR(8)        NOT NULL
)TABLESPACE USERS;

-- CONSTRAINTS
ALTER TABLE MODULE_JOB
ADD CONSTRAINT MJ_PRO_MOU_JOS_CODE_PK   PRIMARY KEY(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE)
ADD CONSTRAINT MJ_PRO_MOU_CODE_FK   FOREIGN KEY(MJ_PROCODE, MJ_MOUCODE) 
    REFERENCES MODULES(MOU_PROCODE, MOU_CODE)
ADD CONSTRAINT MJ_PRO_JOS_CODE_FK   FOREIGN KEY(MJ_PROCODE, MJ_JOSCODE) 
    REFERENCES JOBS(JOS_PROCODE, JOS_CODE)
ADD CONSTRAINT MJ_PRO_PRM_CODE_FK   FOREIGN KEY(MJ_PROCODE, MJ_PRMPMBCODE) 
    REFERENCES PROJECTMEMBERS(PRM_PROCODE, PRM_PMBCODE);

-- SYNONYM
CREATE SYNONYM  MJ FOR TEAM4.MODULE_JOB;
GRANT SELECT,DELETE,INSERT,UPDATE ON TEAM4.MODULE_JOB TO CHAE,SHY,CJS;


SELECT*FROM MOU;
SELECT*FROM MJ;
-- DATA
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','20','202','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','10','101','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','10','102','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','10','103','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','10','104','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','10','105','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','20','201','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','20','203','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','30','301','20220701');
INSERT INTO MJ(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE, MJ_PRMPMBCODE) VALUES('22073121184020220701','30','302','20220701');



/* METHODCATEGORIES
  PK 분류코드
  NN 분류명
*/

CREATE TABLE METHODCATEGORIES(
 MCA_CODE   NCHAR(2) NOT NULL,
 MCA_NAME   NCHAR(20) NOT NULL
)TABLESPACE USERS;

-- CONSTRAINTS
ALTER TABLE METHODCATEGORIES
ADD CONSTRAINT MCA_CODE_PK   PRIMARY KEY(MCA_CODE);


-- SYNONYM
CREATE SYNONYM MCA FOR TEAM4.METHODCATEGORIES;
SELECT*FROM pro;
select*from mou;
-- DATA
		SELECT  MOU_PROCODE AS PROCODE,
		        MOU_CODE AS MOUCODE,
		        MOU_NAME AS MOUNAME,
		        MOU_COMMENTS AS MOUCOMMENTS
		FROM MOU 
		WHERE MOU_PROCODE = '22073121184020220701';

/* METHOD(MET) *MODULE_JOB의 자식
  PK 프로젝트코드
  PK 모듈코드
  PK 업무코드
  PK 메서드코드
  FK 분류코드    
*/
CREATE TABLE METHODS(
 MET_MJPROCODE   NCHAR(20)   NOT NULL,
 MET_MJMOUCODE   NCHAR(2)    NOT NULL,
 MET_MJJOSCODE   NCHAR(3)    NOT NULL,
 MET_CODE        NCHAR(4)    NOT NULL,
 MET_NAME        NVARCHAR2(2)NOT NULL,
 MET_MCCODE      NCHAR(2)    NOT NULL
)TABLESPACE USERS;



-- CONSTRAINTS
ALTER TABLE METHODS
ADD CONSTRAINT MET_PRO_MOU_JOS_CODE_PK   PRIMARY KEY(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE)
ADD CONSTRAINT MET_PRO_MOU_JOS_FK   FOREIGN KEY(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE) 
    REFERENCES MODULE_JOB(MJ_PROCODE, MJ_MOUCODE, MJ_JOSCODE)
ADD CONSTRAINT MET_MCCODE_FK   FOREIGN KEY(MET_MCCODE) 
    REFERENCES METHODCATEGORIES(MCA_CODE);
    
-- SYNONYM
CREATE SYNONYM MET FOR TEAM4.METHODS;

--DATA
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','10','101','1101', 'hm', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','10','102','1102', 'jf', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','10','103','1103', 'ji', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','10','104','1104', 'au', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','10','105','1105', 'lo', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','20','201','1201', 'np', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','20','202','1202', 'rp', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','20','203','1203', 'im', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','30','301','1301', 'db', 'CT');
INSERT INTO MET(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE, MET_NAME, MET_MCCODE) 
VALUES('22080110153420220702','30','302','1302', 'am', 'CT');



--DELETE FROM MOU;

/* TABLE CHECK */
SELECT * FROM PRO;
SELECT * FROM PRM;
SELECT * FROM MOU;
SELECT * FROM JOS;
SELECT * FROM MJ;
SELECT * FROM MET;
SELECT * FROM MC;



select count(*) as people from prm where prm_procode = '22072710334720220701' and prm_accept = 'AC';

/* 내가 참여하고 있는 프로젝트 정보 */
SELECT *
FROM PRO
WHERE PRO_CODE IN(SELECT PRM_PROCODE FROM PRM WHERE PRM_PMBCODE='20220701');

/* 내가 참여하고 있는 프로젝트의 멤버 리스트 */
SELECT * FROM PRM WHERE PRM_PROCODE = '';
--delete from jos;
select*from mj;
--delete from pro;


SELECT  MOU_PROCODE AS PROCODE,
        MOU_CODE AS MOUCODE,
        MOU_NAME AS MOUNAME,
        MOU_COMMENTS AS MOUCOMMENTS
FROM MOU 
WHERE MOU_PROCODE = '22080110153420220702';

SELECT  JOS_PROCODE AS PROCODE,
        JOS_CODE AS JOSCODE,
        JOS_NAME AS JOSNAME,
        JOS_COMMENTS AS JOSCOMMENTS
FROM JOS 
WHERE JOS_PROCODE = '22080110153420220702';

SELECT  MJ_PROCODE AS PROCODE,
        MJ_MOUCODE AS MOUCODE,
        MJ_JOSCODE AS JOSCODE,
        MJ_PRMPMBCODE AS PMBCODE 
FROM MJ 
WHERE MJ_PROCODE = '22080110153420220702';

SELECT  MET_MJPROCODE AS PROCODE,
        MET_MJMOUCODE AS MOUCODE,
        MET_MJJOSCODE AS JOSCODE,
        MET_CODE AS METCODE,
        MET_NAME AS METNAME,
        MET_MCCODE AS MCCODE
FROM MET 
WHERE MET_MJPROCODE = '22080110153420220702';

/* PROCESSINVO MJLIST,METHODLIST 띄울 때 사용 */
CREATE OR REPLACE VIEW PROCESSINFO AS
SELECT  MOU_PROCODE AS PROCODE,
                MOU_CODE AS MOUCODE,
                MOU_NAME AS MOUNAME,
                MOU_COMMENTS AS MOUCOMMENTS,
                JOS_CODE AS JOSCODE,
                JOS_NAME AS JOSNAME,
                JOS_COMMENTS AS JOSCOMMENTS,
                MJ_PRMPMBCODE AS PMBCODE,
                PMB_NAME AS PMBNAME,
                MET_CODE AS METCODE,
                MET_NAME AS METNAME,
                MET_MCCODE AS MCCODE,
                MCA_NAME AS MCNAME
FROM MOU        INNER JOIN MJ ON MOU_PROCODE = MJ_PROCODE AND MOU_CODE = mj.mj_moucode
                INNER JOIN JOS ON MOU_PROCODE = JOS_PROCODE AND mj.mj_joscode = jos.jos_code
                INNER JOIN MET ON MOU_PROCODE = MET_MJPROCODE AND MOU_CODE = met.met_mjmoucode AND jos.jos_code = met.met_mjjoscode
                INNER JOIN MCA ON MET_MCCODE = MCA_CODE 
                INNER JOIN PMB ON MJ_PRMPMBCODE = PMB_CODE;
 
/* MJ만을 위한 INFO */
CREATE OR REPLACE VIEW MJINFO AS
SELECT  MOU_PROCODE AS PROCODE,
                MOU_CODE AS MOUCODE,
                MOU_NAME AS MOUNAME,
                MOU_COMMENTS AS MOUCOMMENTS,
                JOS_CODE AS JOSCODE,
                JOS_NAME AS JOSNAME,
                JOS_COMMENTS AS JOSCOMMENTS,
                MJ_PRMPMBCODE AS PMBCODE,
                PMB_NAME AS PMBNAME
FROM MOU        INNER JOIN JOS ON MOU_PROCODE = JOS_PROCODE
                INNER JOIN MJ ON MOU_PROCODE = MJ_PROCODE AND MOU_CODE = mj.mj_moucode and jos.jos_code = mj.mj_joscode
                INNER JOIN PMB ON MJ_PRMPMBCODE = PMB_CODE;


/* 2022.08.03 */
SELECT * FROM PRO;
SELECT * FROM PRM;
SELECT * FROM MOU;
SELECT * FROM JOS;
SELECT * FROM MJ;
SELECT * FROM MET;

-- METHOD TABLE에 진행상태 컬럼 추가
ALTER TABLE METHODS
ADD MET_STATE  NCHAR(2) DEFAULT 'RD'; 

ALTER TABLE METHODS
ADD CONSTRAINT MET_STATE_FK FOREIGN KEY(MET_STATE) REFERENCES METHODCATEGORIES(MCA_CODE);

-- METHODCATAGORIES에 데이터 추가
INSERT INTO MCA(MCA_CODE, MCA_NAME) VALUES('RD', '개발전');
INSERT INTO MCA(MCA_CODE, MCA_NAME) VALUES('IN', '개발진행중');
INSERT INTO MCA(MCA_CODE, MCA_NAME) VALUES('CP', '개발완료');

SELECT*FROM MCA;
SELECT*FROM MET;
/* RESULTFILE TABLE */
CREATE TABLE RESULTFILES(
  FIL_METMJPROCODE  NCHAR(20)      NOT NULL,
  FIL_METMJMOUCODE  NCHAR(2)       NOT NULL,
  FIL_METMJJOSCODE  NCHAR(3)       NOT NULL,
  FIL_METCODE       NCHAR(4)       NOT NULL,
  FIL_CODE          NUMBER(2,0)    NOT NULL,
  FIL_NAME          NVARCHAR2(50)  NOT NULL,
  FIL_LOCATION      NVARCHAR2(100) NOT NULL
)TABLESPACE USERS;

  -- CONSTRAINTS
  ALTER TABLE RESULTFILES
  ADD CONSTRAINT FIL_PRO_MOU_JOS_MET_CODE_PK    
  PRIMARY KEY(FIL_METMJPROCODE, FIL_METMJMOUCODE, FIL_METMJJOSCODE, FIL_METCODE, FIL_CODE)
  ADD CONSTRAINT FIL_PRO_MOU_JOS_MET_FK FOREIGN KEY (FIL_METMJPROCODE, FIL_METMJMOUCODE, FIL_METMJJOSCODE, FIL_METCODE)
  REFERENCES METHODS(MET_MJPROCODE, MET_MJMOUCODE, MET_MJJOSCODE, MET_CODE);

--SYNONYM
CREATE SYNONYM FIL FOR RESULTFILES;

GRANT SELECT, INSERT, UPDATE ON TEAM4.RESULTFILES TO SHY, CHAE, CJS;


/* 진행관리 페이지 상단 정보 불러오기 select구문 */
/* 프로젝트 정보 */
SELECT PRO.PRO_NAME AS PRONAME,
       PRM.PRM_POSITION AS PRMPOSITION,
       PRM.PRM_PMBCODE AS PMBCODE,
       PMB.PMB_NAME AS PMBNAME,
       TO_CHAR(PRO.PRO_START, 'YYYY.MM.DD') AS PROSTART,
       TO_CHAR(PRO.PRO_END, 'YYYY.MM.DD') AS PROEND
FROM PRM INNER JOIN PRO ON PRO.PRO_CODE = PRM.PRM_PROCODE
         INNER JOIN PMB ON PMB_CODE = PRM.PRM_PMBCODE
WHERE PRO_CODE = '22073121184020220701' AND PRM_POSITION IS NOT NULL; 

/* 모듈,잡,모듈잡,메서드 갯수 불러오기 select구문 */
SELECT COUNT(*)
FROM MOU WHERE MOU_PROCODE = '';
SELECT COUNT(*)
FROM JOS WHERE JOS_PROCODE = '';
SELECT COUNT(*)
FROM MJ WHERE MJ_PROCODE = '';
SELECT COUNT(*)
FROM MET WHERE MET_MJPROCODE = '';

/* 2022.08.04 */
/* MC별로 메서드 갯수 가져오기 */
-- 전체 갯수
SELECT COUNT(*) FROM PROCESSINFO WHERE PROCODE=#{proCode} AND MCCODE=#{mcCode};
-- 내가 담당하고있는 메서드의 갯수
SELECT COUNT(*) FROM PROCESSINFO WHERE PROCODE=#{proCode} AND MCCODE=#{mcCode} AND PMBCODE=#{pmbCode}

/* RM을 눌렀을 때 n이라는 코드가 넘어오면 자신이 속한 프로젝트 중 가장 최신의 프로젝트를 불러옴 */
SELECT MAX(PRO_CODE) AS PROCODE
FROM PRO INNER JOIN PRM ON PRM_PROCODE=PRO_CODE
WHERE PRM_PMBCODE = '20220701' AND PRM_ACCEPT ='AC';

/* 내가 맡고있는 MJ 이름 전부 가져오기 */
SELECT (MOUNAME||'_'||JOSNAME) AS MJNAME,
        	PROCODE,
        	MOUCODE,
        	JOSCODE
FROM   MJINFO
WHERE  PROCODE=#{proCode} AND PMBCODE=#{pmbCode};
