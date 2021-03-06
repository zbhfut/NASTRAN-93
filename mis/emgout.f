      SUBROUTINE EMGOUT (RBUF,DBUF,LBUF,EOE,DICT,FILE,INPREC)        
C        
C     THIS ROUTINE OF THE -EMG- MODULE WRITES THE DATA IN -BUF- TO      
C     -FILE-.        
C        
C     BEFORE CALLING THIS ROUTINE THE CALLING ROUTINE SETS UP THE       
C     FOLLOWING ARGUMENTS.....        
C        
C     RBUF,DBUF  =  BOTH POINT TO THE SAME MATRIX ARRAY CONTAINING THE  
C                   MATRIX DATA TO BE OUTPUT.        
C        
C     LBUF   = NUMBER OF DATA VALUES TO BE OUTPUT ON CURRENT CALL NOT   
C              CONSIDERING THE PRECISION OF THE DATA VALUES.        
C        
C     EOE    = SEE BELOW.        
C        
C     DICT   = ARRAY OF SIZE NLOCS (SEE BELOW) + 5.  WORDS 1 THROUGH 5  
C              OF THIS ARRAY ARE SET BY THE CALLING ROUITNE.(SEE BELOW) 
C        
C     FILE   = SET TO 1 IF STIFFNESS MATRIX        
C              SET TO 2 IF MASS MATRIX        
C              SET TO 3 IF DAMPING MATRIX        
C        
C     INPREC = PRECISION OF THE DATA  RBUF AND DBUF POINT TO.        
C              SET = 1 IF SINGLE AND SET TO 2 IF DOUBLE.        
C        
C     --- IMPORTANT--- UNDER NO CIRCUMSTANCES SHOULD THE CALLING PROGRAM
C     MODIFY DATA IN COMMON BLOCK /EMGDIC/.        
C        
C     NOTE.  ON EACH CALL TO THIS ROUTINE THE CALLING ROUTINE MUST SEND 
C     AN AMOUNT OF DATA FOR ONE OR MORE GRID POINT-PARTITIONS OF THE    
C     TOTAL ELEMENT MATRIX.  THIS IS CONSIDERING DEGREES OF FREEDOM AND 
C     ANY CONDENSATION OF THE DATA IF A DIAGONAL MATRIX IS BEING SENT.) 
C        
C     IE. FOR A MATRIX WHERE 6 DEGREES OF FREEDOM ARE LISTED IN THE CODE
C     WORD OF THE DICTIONARY THEN THE FOLLWING WOULD BE CONSIDERED.     
C        
C     IF THE MATRIX WAS DIAGONAL THE VALUE OF LBUF WOULD BE SIMPLY      
C     (0 TO NLOCS) TIMES 6        
C        
C     IF THE MATRIX WAS SQUARE THEN LBUF WOULD BE        
C     (0 TO NLOCS) TIMES 6 TIMES NLOCS TIMES 6.  NOTE THE PRECISION DOES
C     NOT ENTER INTO THE CALCULATION OF LBUF BY THE CALLING ROUTINE)    
C        
C     IF -EOE- IS GREATER THAN 0, INDICATING END-OF-ELEMENT-DATA, THE   
C     DICTIONARY WILL BE WRITTEN TO THE APPROPRIATE COMPANION FILE      
C     OF -FILE-.  IF CONGRUENT LOGIC IS ACTIVE THE DICTIONARY WILL      
C     ALSO BE PLACED IN CORE IF POSSIBLE.        
C        
C     CHECKS TO INSURE THAT THE CALLING ROUTINE SENT A REASONABLY       
C     CORRECT AMOUNT OF MATRIX DATA ARE MADE BY THIS ROUTINE.        
C        
C     DICTIONARY FORMAT 1)ELEMENT-COUNTER-ID-POSITON-IN-EST        
C     ================= 2)F = 1 IF SQUARE, = 2 IF DIAGONAL FORMAT DATA. 
C     DICTIONARY        3)N = NUMBER OF CONNECTED GRID POINTS * FREEDOMS
C     CAN EXPAND        4)COMPONENT-CODE-WORD        
C     THROUGH THE       5)DAMPING CONSTANT        
C     MIDDLE.                    .        
C           LDICT-NLOC+1)GINO-LOC. (FIRST PARTITION)        
C                                .        
C                                .        
C                                . (NLOCS GINO-LOC VALUES)        
C                                .        
C                LDICT-1)GINO-LOC. (NEXT TO LAST PARTITION)        
C                  LDICT)GINO-LOC. (LAST PARTITION OF THIS ELEMENT IF   
C                                  ALL -NLOCS- GRID POINTS CONNECTED.)  
C        
C     THIS ROUTINE WILL WRITE PARTITIONS OF THE MATRIX WHERE THE NUMBER 
C     OF COLUMNS IN EACH PARTITION WRITTEN EQUALS ACTIVE FREEDOMS       
C     WHICH = NUMBER OF BITS ON IN THE CODE WORD ( DICT(4) ).        
C        
C     THE VALUES OF DICT(1), DICT(2), DICT(3), DICT(4), AND DICT(5) MUST
C     REMAIN CONSTANT BETWEEN CALLS TO THIS ROUTINE WITH RESPECT TO     
C     A PARTICULAR ELEMENT ID AND FILE TYPE.        
C        
C     ONE OR MORE PARTITIONS WILL BE WRITTEN ON EACH CALL.        
C        
      LOGICAL          ANYCON, ERROR, HEAT        
      INTEGER          LOCS(3), OUTPT, DICT(5), FILE, EOE, Z,        
     1                 DICTN, NLOCS, PART(3), ELTYPE, ELID, EOR, PRECIS,
     2                 ESTID, FLAGS, QFILE, FREDMS(3)        
      REAL             RBUF(LBUF)        
      DOUBLE PRECISION DBUF(LBUF), DA        
      CHARACTER        UFM*23, UWM*25, UIM*29, SFM*25        
      COMMON /XMSSG /  UFM, UWM, UIM, SFM        
      COMMON /BLANK /  XXXXX(3), NOK4GG        
      COMMON /SYSTEM/  KSYSTM(65)        
      COMMON /EMGDIC/  ELTYPE, LDICT, NLOCS, ELID, ESTID        
      COMMON /EMGFIL/  MISC(5), MATRIX(3), DICTN(3)        
      COMMON /EMGPRM/  ICORE, JCORE, NCORE, ICSTM, NCSTM, IMAT, NMAT,   
     1                 IHMAT, NHMAT, IDIT, NDIT, ICONG, NCONG, LCONG,   
     2                 ANYCON, FLAGS(3), PRECIS, ERROR, HEAT, ICMBAR,   
     3                 LCSTM, LMAT, LHMAT, KFLAGS(3)        
CZZ   COMMON /ZZEMGX/  Z(1)        
      COMMON /ZZZZZZ/  Z(1)        
      COMMON /IEMGOT/  NVAL(3)        
      EQUIVALENCE      (KSYSTM(2), OUTPT), (FFF,IFFF)        
      DATA    EOR   ,  NOEOR, MAXFIL / 1, 0, 3 /        
C        
      IF (ERROR) RETURN        
      IF (FILE.GE.1 .AND. FILE.LE.MAXFIL) GO TO 30        
C        
C     ILLEGAL FILE VALUE        
C        
      WRITE  (OUTPT,10) SFM,FILE        
   10 FORMAT (A25,' 3108, EMGOUT RECEIVES ILLEGAL FILE TYPE =',I10)     
   20 ERROR = .TRUE.        
      RETURN        
C        
C     ON FIRST CALL TO THIS ROUTINE FOR THIS ELEMENT THE SIZE OF COLUMN 
C     AND SIZE OF PARTITION BEING WRITTEN IS SET.        
C     IF NVAL(FILE) .GT. 0 THEN THIS IS NOT THE FIRST CALL.        
C        
   30 IF (KFLAGS(FILE) .EQ. 0) RETURN        
      IF (NVAL(FILE)) 40,40,80        
   40 NVAL(FILE) = DICT(3)        
C        
C     DETERMINE NUMBER OF ACTIVE FREEDOMS BY COUNTING BITS ON IN CODE   
C     WORD.  THIS CODE ADDED AS AN TEMPORARY NECESSITY.        
C        
      IF (DICT(4) .EQ. 63) GO TO 46        
      I = DICT(4)        
      ITEMP = 0        
      DO 45 J = 1,31        
      IF (MOD(I,2)) 44,44,43        
   43 ITEMP = ITEMP + 1        
   44 I = I / 2        
      IF (I) 47,47,45        
   45 CONTINUE        
      GO TO 47        
C        
   46 ITEMP = 6        
   47 FREDMS(FILE) = ITEMP        
C        
C     CHECK NUMBER OF ACTIVE GRID POINTS FOR THIS ELEMENT TO BE        
C     LESS THAN OR EQUAL TO NLOCS.        
C        
      IGRIDS = DICT(3)/FREDMS(FILE)        
      IF (IGRIDS .LE. NLOCS) GO TO 48        
      WRITE  (OUTPT,42) SFM,IGRIDS,ELID        
   42 FORMAT (A25,' 3122,  EMGOUT HAS DETERMINED THAT THERE ARE',I10,   
     1       ' CONNECTING GRID POINTS FOR ELEMENT ID =',I10, /5X,       
     2       'THIS IS GREATER THAN THE MAXIMUM AS PER /GPTA1/ TABLE ',  
     3       'FOR THE TYPE OF THIS ELEMENT. PROBABLE ERROR IN ELEMENT', 
     4       ' ROUTINE PROGRAM')        
      GO TO 20        
C        
   48 LOCS(FILE) = LDICT - NLOCS        
C        
C     ZERO ALL GINO-LOC SLOTS IN DICTIONARY.        
C        
      I = LDICT - NLOCS + 1        
      DO 49 J = I,LDICT        
      DICT(J) = 0        
   49 CONTINUE        
      IF (DICT(2) .EQ. 1) GO TO 60        
      IF (DICT(2) .EQ. 2) GO TO 70        
      WRITE  (OUTPT,50) SFM,DICT(2),ELID        
   50 FORMAT (A25,' 3109, EMGOUT HAS BEEN SENT AN INVALID DICTIONARY ', 
     1       'WORD-2 =',I10,' FROM ELEMENT ID =',I10)        
      GO TO 20        
C        
C     FULL SQUARE MATRIX WILL BE OUTPUT. (VALUES PER PARTITION TO WRITE)
C        
   60 PART(FILE) = DICT(3)*FREDMS(FILE)        
      GO TO 80        
C        
C     DIAGONAL MATRIX.  (VALUES PER PARTITION TO WRITE)        
C        
   70 PART(FILE) = FREDMS(FILE)        
C        
C     WRITE MATRIX DATA TO FILE DESIRED.        
C        
   80 NWORDS = PART(FILE)        
      IF (MOD(LBUF,NWORDS)) 90,110,90        
   90 WRITE  (OUTPT,100) SFM,ELID        
  100 FORMAT (A25,' 3110, EMGOUT HAS BEEN CALLED TO WRITE AN INCORRECT',
     1       ' NUMBER OF WORDS FOR ELEMENT ID =',I10)        
      GO TO 20        
C        
  110 ILOC = LOCS(FILE)        
      IF (LBUF .LE. 0) GO TO 130        
      QFILE = MATRIX(FILE)        
      IF (INPREC .NE. PRECIS) GO TO 121        
C        
C     INPUT AND OUTPUT PRECISIONS ARE THE SAME        
C        
      N2WORD = PRECIS*NWORDS        
      K = 1        
      DO 120 I = 1,LBUF,NWORDS        
      ILOC = ILOC + 1        
      CALL WRITE (QFILE,RBUF(K),N2WORD,EOR)        
      CALL SAVPOS (QFILE,DICT(ILOC))        
      K = K + N2WORD        
  120 CONTINUE        
      GO TO 129        
C        
C     INPUT PRECISION IS DIFFERENT FROM OUTPUT PRECISION        
C        
  121 K = 0        
      DO 126 I = 1,LBUF,NWORDS        
      K = K + NWORDS        
      IF (PRECIS .EQ. 2) GO TO 123        
C        
C     DOUBLE PRECISION INPUT AND SINGLE PRECISION OUTPUT        
C        
      DO 122 J = I,K        
      RA = DBUF(J)        
      CALL WRITE (QFILE,RA,1,NOEOR)        
  122 CONTINUE        
      GO TO 125        
C        
C     SINGLE PRECISION INPUT AND DOUBLE PRECISION OUTPUT        
C        
  123 DO 124 J = I,K        
      DA = RBUF(J)        
      CALL WRITE (QFILE,DA,2,NOEOR)        
  124 CONTINUE        
  125 ILOC = ILOC + 1        
      CALL WRITE (QFILE,0,0,EOR)        
      CALL SAVPOS (QFILE,DICT(ILOC))        
  126 CONTINUE        
C        
  129 LOCS(FILE) = ILOC        
C        
C     IF -EOE- .GT. 0 (IMPLYING END-OF-ELEMENT-DATA) WRITE        
C     OUT THE COMPLETED DICTIONARY.        
C        
  130 IF (EOE) 140,140,150        
  140 RETURN        
C        
C     OK -EOE- IS ON.  FIRST WRITE DICTIONARY OUT.        
C     INSURE ALL -LOCS- SET CONSIDERING THE NUMBER OF ACTIVE GRID POINTS
C     FOR THIS PARTICULAR ELEMENT.        
C        
  150 IF (LOCS(FILE) .EQ. LDICT-NLOCS+DICT(3)/FREDMS(FILE)) GO TO 170   
      WRITE  (OUTPT,160) SFM,ELID,FILE        
  160 FORMAT (A25,' 3111, INVALID NUMBER OF PARTITIONS WERE SENT EMGOUT'
     1,      ' FOR ELEMENT ID =',I10, /5X,'WITH RESPECT TO DATA BLOCK ',
     2       'TYPE =',I3,1H.)        
      GO TO 20        
C        
  170 IF (FLAGS(FILE) .GE. 0) GO TO 172        
      FLAGS(FILE) = IABS(FLAGS(FILE))        
      CALL WRITE (DICTN(FILE),ELTYPE,3,NOEOR)        
  172 FLAGS(FILE) = FLAGS(FILE) + 1        
      CALL WRITE (DICTN(FILE),DICT,LDICT,NOEOR)        
      NVAL(FILE)  = 0        
C        
C     EXISTENCE OF NON-ZERO DAMPING CONSTANT TURNS ON NOK4GG FLAG.      
C        
      IF (NOK4GG) 177,177,179        
  177 IFFF = DICT(5)        
      IF (FFF) 178,179,178        
  178 NOK4GG = 1        
C        
C     CHECK FOR THIS ELEMENT BEING IN CONGRUENT LIST.        
C        
C     EMGOUT WILL NEVER BE CALLED FOR AN ELEMENT WHICH IS IN THE        
C     CONGRUENT LIST AND ALREADY HAS A DICTIONARY.        
C        
  179 IF (.NOT. ANYCON) GO TO 140        
      CALL BISLOC (*140,ELID,Z(ICONG),2,LCONG/2,J)        
C        
C     OK ELEMENT IS CONGRUENT, FIND PRIMARY ID.        
C        
      IADD   = ICONG + J        
  180 IPRIME = Z(IADD)        
C        
C     IPRIME .GT. 0 POINTS TO PRIMARY ID        
C     IPRIME .EQ. 0 IS PRIMARY ID TABLE POINTER AND NO TABLE EXISTS     
C     IPRIME .LT. 0 IS TABLE POINTER NEGATED.        
C        
      IF (IPRIME) 260,210,200        
C        
C     IPRIME POINTS TO PRIMARY ID        
C        
  200 IADD = IPRIME + 1        
      GO TO 180        
C        
C     IPRIME IS TABLE POINTER AND NONE EXISTS YET.        
C     THUS ADD ONE TO CORE, FROM THE BOTTOM OF CORE.        
C        
  210 IF (NCORE-MAXFIL .GT. JCORE) GO TO 240        
C        
C     NOT ENOUGH CORE SO CONGRUENCY IS IGNORED.        
C        
      ICRQ = JCORE - NCORE + MAXFIL        
  220 CALL PAGE2 (4)        
      WRITE  (OUTPT,230) UIM,ELID        
  230 FORMAT (A29,' 3112, ELEMENTS CONGRUENT TO ELEMENT ID =',I10, /5X, 
     1       'WILL BE RE-COMPUTED AS THERE IS INSUFFICIENT CORE AT ',   
     2       'THIS MOMENT TO HOLD DICTIONARY DATA.')        
      WRITE  (OUTPT,232) ICRQ        
  232 FORMAT (5X,24HADDITIONAL CORE NEEDED =,I8,7H WORDS.)        
      GO TO 140        
C        
C     ALLOCATE SMALL TABLE FOR POINTERS TO DICTIONARY FOR EACH FILE TYPE
C     POSSIBLE.        
C        
C     NOTE THAT THE ELEMENT-ID (IF SECONDARY) WILL HAVE A POINTER TO THE
C     PRIMARY-ID.  THE PRIMARY-ID  THEN WILL HAVE A POINTER TO A TABLE  
C     OF SIZE -MAXFIL- POINTING TO -MAXFIL- DICTIONARYS.  (SOME OF WHICH
C     MAY NOT YET OR EVER BE CREATED).        
C     NO CORE IS USED UNTIL A DICTIONARY IS CREATED.        
C        
  240 I2    = NCORE        
      NCORE = NCORE - MAXFIL        
      I1    = NCORE + 1        
      DO 250 I = I1,I2        
      Z(I)  = 0        
  250 CONTINUE        
C        
C     STORE ZERO ADDRESS OF THIS TABLE WITH PRIMARY ID.        
C        
      Z(IADD) = -NCORE        
      IPRIME  = -NCORE        
C        
C     IPRIME IS NEGATIVE ZERO POINTER TO FILE-DICTIONARY-TABLE FOR THIS 
C     CONGRUENCY SET.        
C        
  260 ITAB = -IPRIME        
C        
C     ALLOCATE DICTIONARY SPACE IN CORE, IF THERE IS CORE,        
C     SET FILE POSITION IN TABLE TO POINT TO THIS DICTIONARY,        
C     AND STORE THE DICTIONARY.        
C        
      IF (NCORE-LDICT .GT. JCORE) GO TO 270        
C        
C     INSUFFICIENT CORE THUS IGNORE CONGRUENCY, AND FOR SAFETY        
C     PURGE THIS CONGRUENCY FOR ALL FILES.        
C        
      ICRQ = JCORE - NCORE + LDICT        
      Z(IADD) = 0        
      GO TO 220        
C        
C     ALLOCATE AND WRITE DICTIONARY        
C        
  270 NCORE = NCORE - LDICT        
      J = NCORE        
      DO 280 I = 1,LDICT        
      J = J + 1        
      Z(J) = DICT(I)        
  280 CONTINUE        
C        
C     STORE DICTIONARY ADDRESS IN TABLE(FILE), WHERE TABLE BEGINS       
C     AT Z(ITAB+1).        
C        
      Z(ITAB+FILE) = NCORE + 1        
      GO TO 140        
      END        
