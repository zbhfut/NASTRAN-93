      SUBROUTINE XRGSST (NEWSOL)        
C        
C     PURPOSE - XRGSST PROCESSES SUBSTRUCTURE CONTROLS CARDS IN        
C               A RIGID FORMAT (I.E., THE ****PHS- CARDS)        
C        
C     AUTHOR  - RPK CORPORATION; DECEMBER, 1983        
C        
C     INPUT        
C       ARGUMENTS        
C           NEWSOL     SOLUTION NUMBER        
C       OTHER        
C         /SYSTEM/        
C           OPTAPE     UNIT NUMBER CONTAINING THE PRINT FILE        
C         /XRGDXX/        
C           ICHAR      CONTAINS THE CARD IMAGE IN 80A1 FORMAT        
C           IDMAP      CURRENT DMAP SEQUENCE NUMBER        
C           IPHASE     PHASE NUMBER        
C           RECORD     CARD IMAGE IN 20A4 FORMAT        
C        
C     OUTPUT        
C         /XRGDXX/        
C           ICOL       COLUMN NUMBER LAST PROCESSED        
C           IERROR     ERROR FLAG - NON-ZERO IF AN ERROR OCCURRED       
C        
C     LOCAL VARIABLES        
C         BEGIN        CONTAINS THE VALUE 1HB        
C         BLANK        CONTAINS THE VALUE 1H        
C         DELETE       CONTAINS THE VALUE 1HD        
C         EIGHT        CONTAINS THE VALUE 1H8        
C         END          CONTAINS THE VALUE 1HE        
C         FIVE         CONTAINS THE VALUE 1H5        
C         ICFLAG       FLAG TO DISTINGUISH WHICH COMMON BLOCK IS        
C                      BEING PROCESSED        
C                      =1, /PHAS11/ ; =2, /PHAS25/ ; =3, /PHAS28/       
C                      =4, /PHAS31/ ; =5, /PHAS37/        
C         IFLAG        FLAG FOR THE KIND OF COMMAND BEING PROCESSED     
C                      =1, FOR INSERT; =2, FOR DELETE;        
C                      =3, FOR DELETE BEGIN; =4 FOR DELETE END        
C         IMAP         2 WORD ARRAY FOR DMAP NUMBERS        
C         IND11        INDEX FOR COMMON /PHAS11/        
C         IND25        INDEX FOR COMMON /PHAS25/        
C         IND28        INDEX FOR COMMON /PHAS28/        
C         IND31        INDEX FOR COMMON /PHAS31/        
C         IND37        INDEX FOR COMMON /PHAS37/        
C         LFLAG        ARRAY USED FOR THE LAST FLAG (I.E., IFLAG)       
C                      THAT WAS APPLIED TO A GIVEN COMMON - THIS        
C                      IS USED TO CHECK FOR MATCHING 'DB' AND 'DE'      
C                      SUBCOMMANDS        
C         NMAP         NUMBER OF DMAP NUMBERS IN THE ARRAY IMAP        
C         ONE          CONTAINS THE VALUE 1H1        
C         SEVEN        CONTAINS THE VALUE 1H7        
C        
C     FUNCTIONS        
C       XRGSST PROCESSES SUBSTRUCTURE CONTROL COMMANDS WITHIN THE       
C       RIGID FORMAT.  THE COMMANDS ARE OF THE FOLLOWING FORMAT;        
C       ****PHS- I=   (OR INSTEAD OF I=; D=, DB= OR DE= ) WHERE        
C       THE '-' OF PHS IS THE PHASE NUMBER AND = REFERS TO THE        
C       APPROPIATE ASCM== SUBROUTINE.  FOR THE I= SUBCOMMAND,        
C       TWO NUMBERS ( N AND 0 ) ARE ADDED TO THE APPROPIATE        
C       COMMON.  FOR THE D= SUBCOMMAND, TWO NUMBERS ( N1 AND N1 )       
C       ARE ADDED TO THE APPROPIATE COMMON.  FOR THE DB=        
C       SUBCOMMAND, ONE NUMBER IS ADDED TO THE COMMON AND        
C       FOR THE DE= SUBCOMMAND, ONE NUMBER IS ADDED TO THE COMMON.      
C       THE NUMBER THAT IS ADDED TO THE COMMONS        
C       IS THE CURRENT DMAP SEQUENCE NUMBER AS FOUND IN THE        
C       VARIABLE IDMAP.        
C       THE I= COMMAND CORRESPONDS TO A DMAP ALTER INSERT        
C       OF THE FORM ALTER N,0.  THE D= SUBCOMMAND CORRESPONDS        
C       TO THE DMAP DELETE COMMAND  ALTER N1,N1.  THE DB=        
C       SUBCOMMAND GIVES THE FIRST OF A RANGE OF DMAP NUMBERS        
C       STATEMENTS TO BE DELETED AND THE DE= GIVES THE LAST        
C       VALUE OF THE RANGE OF DMAP STATEMENTS TO BE DELETED.        
C       THE COMMONS ARE NAMED PHAS== WHERE THE FIRST = REFERS        
C       TO THE PHASE NUMBER AND THE SECOND = REFERS TO THE        
C       APPROPIATE ASCM== SUBROUTINE.        
C        
C     SUBROUTINES CALLED - XDCODE        
C        
C     CALLING SUBROUTINES - XRGDFM        
C        
C     ERRORS        
C       ERROR MESSAGES 8031,8032,8033,8035 ARE ISSUED        
C        
      INTEGER         RECORD,DELETE,BLANK,BEGIN,END,ICFLAG,OPTAPE,      
     1                LFLAG(5),IMAP(2),ONE,FIVE,SEVEN,EIGHT        
      CHARACTER       UFM*23        
      COMMON /XMSSG / UFM        
      COMMON /XRGDXX/ IRESTR,NSUBST,IPHASE,ICOL,NUMBER,ITYPE,ISTATE,    
     1                IERROR,NUM(2),IND,NUMENT,RECORD(20),ICHAR(80),    
     2                LIMIT(2),ICOUNT,IDMAP,ISCR,NAME(2),MEMBER(2),     
     3                IGNORE        
      COMMON /PHAS11/ IPAS11( 8)        
      COMMON /PHAS25/ IPAS25(14)        
      COMMON /PHAS28/ IPAS28(14)        
      COMMON /PHAS31/ IPAS31( 2)        
      COMMON /PHAS37/ IPAS37( 6)        
      COMMON /SYSTEM/ ISYSBF,OPTAPE,DUM(98)        
      DATA    BLANK / 1H  /, DELETE/ 1HD /, BEGIN / 1HB /        
      DATA    END   / 1HE /, LFLAG / 5*0 /        
      DATA    ONE   / 1H1 /, FIVE  / 1H5 /, SEVEN / 1H7 /, EIGHT / 1H8 /
      DATA    IND11 / 0   /, IND25 / 0   /, IND28 / 0   /, IND31 / 0   /
      DATA    IND37 / 0   /, INSERT/ 1HI /        
C        
      CALL XDCODE        
      ICOL  = 9        
 10   IF (ICHAR(ICOL) .EQ. BLANK ) GO TO 50        
      IF (ICHAR(ICOL) .NE. INSERT) GO TO 20        
      IFLAG = 1        
      NMAP  = 2        
      IMAP(1) = IDMAP        
      IMAP(2) = 0        
      GO TO 100        
 20   IF (ICHAR(ICOL) .NE. DELETE) GO TO 710        
      ICOL  = ICOL + 1        
      IF (ICHAR(ICOL) .EQ. BEGIN) GO TO 30        
      IF (ICHAR(ICOL) .EQ. END  ) GO TO 40        
      IFLAG = 2        
      NMAP  = 2        
      IMAP(1) = IDMAP        
      IMAP(2) = IDMAP        
      GO TO 110        
 30   IFLAG = 3        
      NMAP  = 1        
      IMAP(1) = IDMAP        
      GO TO 100        
 40   IFLAG = 4        
      NMAP  = 1        
      IMAP(1) = IDMAP        
      GO TO 100        
 50   IF (ICOL .GE. 80) GO TO 800        
      ICOL  = ICOL + 1        
      GO TO 10        
 100  ICOL  = ICOL + 1        
 110  IF (IPHASE .NE. 1) GO TO 120        
      IF (ICHAR(ICOL) .NE. ONE) GO TO 710        
      ICFLAG = 1        
      GO TO 200        
 120  IF (IPHASE .NE. 2) GO TO 140        
      IF (ICHAR(ICOL) .NE. FIVE) GO TO 130        
      ICFLAG = 2        
      GO TO 200        
 130  IF (ICHAR(ICOL) .NE. EIGHT) GO TO 710        
      ICFLAG = 3        
      GO TO 200        
 140  IF (ICHAR(ICOL) .NE. ONE) GO TO 150        
      ICFLAG = 4        
      GO TO 200        
 150  IF (ICHAR(ICOL) .NE. SEVEN) GO TO 710        
      ICFLAG = 5        
 200  IF (IFLAG.EQ.4 .AND. LFLAG(ICFLAG).NE.3) GO TO 730        
      IF (IFLAG.EQ.3 .AND. LFLAG(ICFLAG).EQ.3) GO TO 740        
      IF (IFLAG.LE.2 .AND. LFLAG(ICFLAG).EQ.3) GO TO 740        
      LFLAG(ICFLAG) = IFLAG        
      ICOL = ICOL + 1        
      GO TO (210,220,230,240,250), ICFLAG        
 210  IF (IND11+NMAP .GT. 8) GO TO 720        
      DO 215 K = 1,NMAP        
      IND11 = IND11 + 1        
      IPAS11(IND11) = IMAP(K)        
 215  CONTINUE        
      GO TO 800        
 220  IF (IND25+NMAP .GT. 14) GO TO 720        
      DO 225 K = 1,NMAP        
      IND25 = IND25 + 1        
      IPAS25(IND25) = IMAP(K)        
 225  CONTINUE        
      GO TO 800        
 230  IF (IND28+NMAP .GT. 14) GO TO 720        
      DO 235 K = 1,NMAP        
      IND28 = IND28 + 1        
      IPAS28(IND28) = IMAP(K)        
 235  CONTINUE        
      GO TO 800        
 240  IF (IND31+NMAP .GT. 2) GO TO 720        
      DO 245 K = 1,NMAP        
      IND31 = IND31 + 1        
      IPAS31(IND31) = IMAP(K)        
 245  CONTINUE        
      GO TO 800        
 250  IF (IND37+NMAP .GT. 6) GO TO 720        
      DO 255 K = 1,NMAP        
      IND37 = IND37 + 1        
      IPAS37(IND37) = IMAP(K)        
 255  CONTINUE        
      GO TO 800        
C        
C     ERRORS        
C        
 710  J = 0        
      K = 1        
      WRITE  (OPTAPE,715) UFM,ICOL,RECORD,J,(I,I=1,8),K,(J,I=1,8)       
 715  FORMAT (A23,' 8031, INVALID PARAMETER NEAR COLUMN ',I3,        
     1       ' IN THE FOLLOWING CARD', //20X,20A4, /,(20X,I1,I9,7I10))  
      IERROR = 1        
      GO TO 770        
 720  WRITE  (OPTAPE,725) UFM,IPHASE,RECORD        
 725  FORMAT (A23,' 8032, ',19H' TOO MANY '****PHS,I1, 9H' ENTRIES,     
     1       ' ERROR OCCURRED ON CARD', //20X,20A4)        
      GO TO 770        
 730  WRITE  (OPTAPE,735) UFM,RECORD        
 735  FORMAT (A23,' 8033, ',34H A 'DE' ENTRY HAS NO MATCHING 'DB',      
     1       ' ENTRY - ERROR ON CARD', //20X,20A4)        
      GO TO 770        
 740  WRITE  (OPTAPE,745) UFM,RECORD        
 745  FORMAT (A23,' 8035, ',        
     1        41H ATTEMP TO NEST 'DB'S OR NO MATCHING 'DE',        
     2        ' - ERROR OCCURRED ON THE FOLLOWING CARD', /20X,20A4)     
 770  IERROR = 1        
 800  RETURN        
      END        
