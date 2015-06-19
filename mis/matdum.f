      SUBROUTINE MATDUM (IA,IPRC,NPL,NOUT)        
C        
C     THIS ROUTINE IS CALLED ONLY BY MATPRN TO PRINT UP TO 5 MATRICES   
C        
C     IF IPRC = 0, MATRICES ARE PRINTED IN THEIR ORIG. PRECISION FORMAT 
C     IF IPRC = 1, MATRICES ARE PRINTED IN SINGLE PRECISION E FORMAT    
C     IF IPRC = 2, MATRICES ARE PRINTED IN DOUBLE PRECISION D FORMAT    
C     IF IPRC =-1, ONLY THE DIAGONAL ELEMENTS OF THE MATRICES ARE       
C                  PRINTED IN THEIR ORIG. PRECISION FORMAT        
C        
C     INPUT MATRIX IA(1) CAN BE IN S.P., D.P., S.P.CMPLX OR D.P.CMPLX   
C        
C     NPL IS THE NO. OF DATA VALUES PRINTED PER OUTPUT LINE        
C     FOR S.P. REAL  DEFAULT IS 8, MAX IS 14        
C     FOR D.P. REAL  DEFAULT IS 6, MAX IS 12        
C     EVEN NUMBER ONLY FOR COMPLEX        
C        
C     P3, P4, P5 ARE PRINTOUT CONTROLS        
C     P3 = m, MATRIX COLUMNS, 1 THRU m, WILL BE PRINTED.        
C             DEFAULT = 0, ALL MATRIX COLUMNS WILL BE PRINTED.        
C        =-m, SEE P4 = -n        
C     P4 = n, LAST n MATRIX COLUMNS ARE PRINTED. DEFAULT = 0        
C        =-n, AND P3 = -m, EVERY OTHER n MATRIX COLUMNS WILL BE PRINTED,
C             STARTIN FROM COLUMN m.        
C     P5 = k, EACH PRINTED COLUMN WILL NOT EXCEED k LINES LONG AND THE  
C             REMAINING DATA WILL BE OMITTED.        
C     NOUT = P6, FORTRAN UNIT (SEE MATPRN)        
C        
      LOGICAL          JUMP        
      INTEGER          SYSBUF,IBLNK,P12,P3,P4,P5,PX(5),ICOL(1),FILE(14) 
      DOUBLE PRECISION DCOL(1)        
      DIMENSION        IA(7),TYPE(10),FORM(18)        
      CHARACTER*15     RFMT,FMTR(2,7)        
      CHARACTER*35     CFMT,FMTC(2,4)        
      CHARACTER        UFM*23,UWM*25,UIM*29        
      COMMON /XMSSG /  UFM,UWM,UIM        
      COMMON /BLANK /  P12(2),P3,P4,P5        
CZZ   COMMON /ZZTBPR/  COL(1)        
      COMMON /ZZZZZZ/  COL(1)        
      COMMON /UNPAKX/  IT,K,L,INCR        
      COMMON /SYSTEM/  SYSBUF,IOUT,INX(6),NLPP,INX1(2),LINE        
      COMMON /OUTPUT/  HEAD1(96),HEAD2(96)        
      EQUIVALENCE      (COL(1),DCOL(1),ICOL(1)), (IBLNK,BLANK)        
      DATA    TYPE  /  4HS.P.,4HREAL,4HD.P.,4HREAL,4HCOMP,4HLEX ,4HCMP ,
     1                 4HD.P.,4HILL ,4HDEFN       /        
      DATA    FORM  /  4HSQUA,4HRE  ,4HRECT,4HANG ,4HDIAG,4HONAL,4HLOW ,
     1                 4HTRI ,4HUPP ,4HTRI ,4HSYMM,4HETRC,4HVECT,4HOR  ,
     2                 4HIDEN,4HTITY,4HILL ,4HDEFN/        
      DATA    BLANK ,  XMATR ,XIX   ,CONT  ,XINUE ,DDX   /        
     1        4H    ,  4HMATR,4HIX  ,4HCONT,4HINUE,4HD   /        
      DATA    FILE  /  4HUT1 ,4HUT2 ,4HN/A ,4HINPT,4HINP1,4HINP2,4HINP3,
     1                 4HINP4,4HINP5,4HINP6,4HINP7,4HINP8,4HINP9,4HINPT/
      DATA    FMTR  /  '(1X,1P, 8E16.8)',  '(1X,1P,6D21.12)',        
     2                 '(1X,1P, 9E14.6)',  '(1X,1P,7D18.10)',        
     3                 '(1X,1P,10E13.5)',  '(1X,1P, 8D16.8)',        
     4                 '(1X,1P,11E11.3)',  '(1X,1P, 9D14.6)',        
     5                 '(1X,1P,12E10.2)',  '(1X,1P,10D13.4)',        
     6                 '(1X,1P,13E10.2)',  '(1X,1P,11D11.3)',        
     7                 '(1X,1P,14E 9.1)',  '(1X,1P,12D10.2)'/        
      DATA    FMTC  /  '(4(1X,1P,E14.7,1HR,  1P,E15.7,1HI))',        
     1                 '(3(1X,1P,D20.13,1HR,1P,D21.13,1HI))',        
     2                 '(5(1X,1P,E11.4,1HR,  1P,E12.4,1HI))',        
     2                 '(4(1X,1P,D14.7,1HR,  1P,D15.7,1HI))',        
     3                 '(6(1X,1P,E 9.2,1HR,  1P,E10.2,1HI))',        
     3                 '(5(1X,1P,D11.4,1HR,  1P,D12.4,1HI))',        
     4                 '(7(1X,1P,E 7.0,1HR,  1P,E 8.0,1HI))',        
     4                 '(6(1X,1P,D 9.2,1HR,  1P,D10.2,1H)))'/        
C        
      NAMEA= IA(1)        
      NCOL = IA(2)        
      NROW = IA(3)        
      IF   = IA(4)        
      IT   = IA(5)        
      IF (IF .NE. 7) GO TO 5        
C        
C     ROW VECTOR        
C     A ROW OF MATRIX ELEMENTS STORED IN COLUMN FORMAT        
C     INTERCHANGE ROW AND COLUMN FOR PRINTING        
C        
      J    = NCOL        
      NCOL = NROW        
      NROW = J        
    5 IF (IT.LE.0 .OR. IT.GT.4) IT = 5        
      IF (IF.LE.0 .OR. IF.GT.8) IF = 9        
      IF (NOUT .NE. IOUT) WRITE (IOUT,7) UIM,FILE(NOUT-10),NOUT        
    7 FORMAT (A29,', MATRIX PRINTOUT SAVED IN ',A4,' (FORTRAN UNIT',I4, 
     1        1H))        
      IF (IPRC .EQ. -1) GO TO 80        
C        
C     SET UP FORMAT FOR OUTPUT PRINT LINE        
C        
      J = IPRC        
      IF (IT .GE. 3) J = IPRC + 2        
      GO TO (10,20,30,40), J        
   10 J = NPL - 7        
      RFMT = FMTR(1,J)        
      GO TO 50        
   20 J = NPL - 5        
      RFMT = FMTR(2,J)        
      GO TO 50        
   30 J = (NPL/2) - 3        
      CFMT = FMTC(1,J)        
      GO TO 50        
   40 J = (NPL/2) - 2        
      CFMT = FMTC(2,J)        
   50 NPL1 = NPL - 1        
C        
C     SET UP P3 AND P4 PRINTOUT OPTIONS        
C        
      MM = P3        
      NN = IA(2)        
      IF (P3 .LE. 0) MM = IA(2)        
      IF (P4 .LT. 0) GO TO 60        
      JUMP = .FALSE.        
      NN = IA(2) - P4        
      GO TO 70        
   60 JUMP = .TRUE.        
      JMP4 = -P4        
      JMP3 = IABS(P3)        
      IF (P3 .EQ. 0) JMP3 = 1        
   70 NPLP5 = IA(3)        
      IF (P5 .NE. 0) NPLP5 = NPL*P5        
C        
   80 DO 85 I = 1,96        
   85 HEAD2(I) = BLANK        
      HEAD2(1) = XMATR        
      HEAD2(2) = XIX        
      HEAD2(6) = CONT        
      HEAD2(7) = XINUE        
      HEAD2(8) = DDX        
      LCOL = KORSZ(COL) - SYSBUF        
      INCR = 1        
      CALL GOPEN (NAMEA,COL(LCOL+1),0)        
      CALL PAGE1        
      CALL FNAME (NAMEA,HEAD2(3))        
      WRITE (NOUT,90) HEAD2(3),HEAD2(4),NAMEA,TYPE(2*IT-1),TYPE(2*IT),  
     1                NCOL,NROW,FORM(2*IF-1),FORM(2*IF)        
   90 FORMAT (1H0,6X,7HMATRIX ,2A4,11H (GINO NAME,I4,2H ),6H IS A ,2A4, 
     1        1X,I6,10H COLUMN X ,I6,5H ROW ,2A4,8H MATRIX.)        
      IF (IT.EQ.5 .OR. NCOL.EQ.0 .OR. NROW.EQ.0) GO TO 460        
C        
C     IF = 3, DIAGONAL MATRIX        
C        = 7, ROW VECTOR        
C        = 8, IDENTITY MATRIX        
C        
      IF (IF-8) 100,440,460        
  100 IF (IPRC .EQ. -1) GO TO 510        
      IF (IF.NE.3 .AND. IF.NE.7) GO TO 110        
      NCOL = 1        
      NROW = IA(3)        
  110 INULL= 0        
      ASSIGN 150 TO IHOP        
      JJ = 1        
  120 K  = 0        
      L  = 0        
      CALL UNPACK (*330,NAMEA,COL)        
      IF (JJ.LE.MM .OR. JJ.GE.NN) GO TO 130        
      K  = NN - MM - 1        
      JJ = JJ + K        
      IF (JJ .GT. NCOL) GO TO 340        
      CALL SKPREC (NAMEA,K)        
      GO TO 340        
  130 IF (.NOT.JUMP) GO TO 140        
      IF (MOD(JJ,JMP4) .NE. JMP3) GO TO 340        
  140 IF (INULL .EQ. 1) GO TO 490        
  150 NROW = L - K + 1        
      GO TO (160,160,360,160,160,160,380), IF        
  160 WRITE (NOUT,170) JJ,K,L        
      LINE = LINE + 3        
      IF (LINE .GE. NLPP) CALL PAGE        
  170 FORMAT (8H0COLUMN ,I6,5X,6H ROWS ,I6,6H THRU ,I6,5X,50(1H-),/,1H )
      IF (IT .GT. 2) NROW = 2*NROW        
  180 K = 0        
  190 J = K + 1        
      IF (J .GT.  NROW) GO TO 340        
      K = J + NPL1        
      IF (K .GT.  NROW) K = NROW        
      IF (K .GT. NPLP5) GO TO 340        
      KJ = K - J        
      GO TO (210,240,270,300), IT        
C        
  200 LN = (KJ+NPL1)/NPL        
      LINE = LINE + LN        
      IF (LINE .GE. NLPP) CALL PAGE        
      GO TO 190        
C        
C     REAL SINGLE PRECISION        
C        
  210 IF (IPRC .EQ. 2) GO TO 220        
      WRITE  (NOUT,RFMT) (COL(I),I=J,K)        
C 215 FORMAT (1X,1P,10E13.5)        
C     LN = (KJ+10)/10        
      GO TO 200        
  220 I = K        
      DO 230 LN = J,K        
      DCOL(I) = COL(I)        
  230 I = I - 1        
C        
C     REAL DOUBLE PRECISION        
C        
  240 IF (IPRC .EQ. 1) GO TO 250        
      WRITE  (NOUT,RFMT) (DCOL(I),I=J,K)        
C 245 FORMAT (1X,1P,8D16.8)        
C     LN = (KJ+8)/8        
      GO TO 200        
  250 DO 260 I = J,K        
  260 COL(I) = DCOL(I)        
      GO TO 210        
C        
C     COMPLEX SINGLE        
C        
  270 IF (IPRC .EQ. 2) GO TO 280        
      WRITE  (NOUT,CFMT) (COL(I),I=J,K)        
C 275 FORMAT (1X,5(1P,E12.4,1HR,1P,E12.4,1HI))        
C     LN = (KJ+10)/10        
      GO TO 200        
  280 I = K        
      DO 290 LN = J,K        
      DCOL(I) = COL(I)        
  290 I = I - 1        
C        
C     COMPLEX DOUBLE        
C        
  300 IF (IPRC .EQ. 1) GO TO 310        
      WRITE  (NOUT,CFMT) (DCOL(I),I=J,K)        
C 305 FORMAT (1X,4(1P,D15.8,1HR,1P,D15.8,1HI))        
C     LN = (KJ+8)/8        
      GO TO 200        
  310 DO 320 I = J,K        
  320 COL(I) = DCOL(I)        
      GO TO 270        
C        
  330 IF (INULL .EQ. 1) GO TO 340        
      INULL = 1        
      IBEGN = JJ        
  340 JJ    = JJ + 1        
      IF (JJ  .LE. NCOL) GO TO 120        
      ASSIGN 350 TO IHOP        
      IF (INULL .EQ. 1) GO TO 490        
  350 CALL CLOSE (NAMEA,1)        
      GO TO 400        
  360 WRITE (NOUT,370) K,L        
      LINE = LINE + 2        
  370 FORMAT ('0DIAGONAL ELEMENTS FOR COLUMNS',I6,4H TO ,I6,4H ARE,///) 
      GO TO 180        
  380 WRITE (NOUT,390) K,L        
      LINE = LINE + 2        
  390 FORMAT ('0ROW ELEMENTS FOR COLUMNS',I6,4H TO ,I6,4H ARE,///)      
      GO TO 180        
  400 WRITE  (NOUT,410) IA(6)        
  410 FORMAT ('0THE NUMBER OF NON-ZERO WORDS IN THE LONGEST RECORD =',  
     1       I8)        
      IA7A = IA(7) / 100        
      IA7C = IA(7) - 100*IA7A        
      IA7B = IA7C / 10        
      IA7C = IA7C - 10*IA7B        
      WRITE  (NOUT,420) IA7A,IA7B,IA7C        
  420 FORMAT ('0THE DENSITY OF THIS MATRIX IS ',I3,1H.,2I1,' PERCENT.') 
      GO TO 750        
C        
  440 WRITE  (NOUT,450)        
  450 FORMAT ('0IDENTITY MATRIX')        
  460 CALL CLOSE (NAMEA,1)        
C        
C     FUNNY MATRIX - SAVE MODULE PARAMETERS AND TABLE PRINT IT        
C        
      DO 470 I = 1,5        
  470 PX(I) = P12(I)        
      P12(1) = IBLNK        
      P12(2) = IBLNK        
      P3     = 3        
      P4     = 3        
      CALL TABPRT (NAMEA)        
      DO 480 I = 1,5        
  480 P12(I) = PX(I)        
      GO TO 750        
  490 IFIN = JJ - 1        
      WRITE (NOUT,500) IBEGN,IFIN        
      INULL = 0        
      LINE  = LINE + 2        
      IF (LINE .GE. NLPP) CALL PAGE        
  500 FORMAT ('0COLUMNS ',I7,6H THRU ,I7,' ARE NULL.')        
      GO TO IHOP, (150,350)        
C        
C     PRINT ONLY THE DIAGONAL ELEMENTS, IPRC = -1        
C     TO CHECKOUT THE DIAGONALS FOR POSSIBLE MATRIX SINGULARITY        
C        
  510 WRITE  (NOUT,520)        
  520 FORMAT (/23X,'(ELEMENTS ON DIAGONAL ONLY)')        
      IF (NCOL .NE. NROW) WRITE (NOUT,530)        
  530 FORMAT (23X,'*** MATRIX IS NOT SQUARE ***')        
      WRITE  (NOUT,540)        
  540 FORMAT (1X)        
      NN = MIN0(NCOL,NROW)        
      JJ = 0        
      DO 570 I = 1,NN        
      K  = I        
      L  = I        
      CALL UNPACK (*550,NAMEA,COL(JJ+1))        
      GO TO 570        
  550 DO 560 J = 1,IT        
  560 COL(JJ+J) = 0.0        
  570 JJ = JJ + IT        
      CALL CLOSE (NAMEA,1)        
      GO TO (580,600,620,640), IT        
  580 WRITE  (NOUT,590) (COL(J),J=1,JJ)        
  590 FORMAT (1X,1P,10E13.6)        
      GO TO 660        
  600 JJ = JJ/2        
      WRITE  (NOUT,610) (DCOL(J),J=1,JJ)        
  610 FORMAT (1X,1P,10D13.6)        
      GO TO 660        
  620 WRITE  (NOUT,630) (COL(J),J=1,JJ)        
  630 FORMAT ((1X,5(1P,E12.5,1HR,1P,E12.5,1HI)))        
      GO TO 660        
  640 JJ = JJ/2        
      WRITE  (NOUT,650) (DCOL(J),J=1,JJ)        
  650 FORMAT ((1X,5(1P,D12.5,1HR,1P,D12.5,1HI)))        
  660 KJ = IT        
      IF (IT .GE. 3) KJ = IT - 2        
      NN = 0        
      MM = 1        
      DO 680 J = 1,JJ        
      LN = MM + IT - 1        
      DO 670 I = MM,LN        
      IF (COL(I) .NE. 0.0) GO TO 680        
  670 CONTINUE        
      NN = NN + 1        
      ICOL(NN) = J        
  680 MM = MM + KJ        
      IF (NN .EQ. 0) GO TO 710        
      MM = MIN0(NN,200)        
      WRITE  (NOUT,690) (ICOL(I),I=1,MM)        
  690 FORMAT ('0*** ZERO DIAGONALS IN THE FOLLOWING COLUMNS -',        
     1       /,(1X,20I6))        
      IF (NN .GT. 200) WRITE (NOUT,700)        
  700 FORMAT (' ...AND MORE')        
      GO TO 730        
  710 WRITE  (NOUT,720)        
  720 FORMAT ('0*** NO ZERO ON DIAGONALS')        
  730 WRITE  (NOUT,740) IA        
  740 FORMAT (/5X,'GINO FILE',I5,'   TRAILER =',6I7)        
      LINE = LINE + NLPP        
C        
  750 RETURN        
      END        