      SUBROUTINE DMPFIL (IFILE,Z,LZ)        
C        
C     DUMPS A FILE ON DIAG 20 SETTING.        
C        
      INTEGER         SYSBUF,OUTPT,BUF,Z(2),FILE,NAME(2)        
      COMMON /SYSTEM/ SYSBUF,OUTPT        
      COMMON /NAMES / RD,RDREW,WRT,WRTREW,CLSREW,CLS        
      COMMON /UNPAKX/ IOUT,IROW,NROW,INCR        
      DATA    NAME  / 4HDMPF,2HIL  /        
C        
    1 FORMAT (1H0,I5,10(1X,I10,1X))        
    2 FORMAT (1H ,5X,10(1X,1P,E11.4))        
    3 FORMAT (1H ,5X,10(4X,A4,4X))        
C        
      CALL SSWTCH (20,L)        
      IF (L .EQ. 0) RETURN        
C        
      FILE = IABS(IFILE)        
      BUF  = LZ - SYSBUF + 1        
      IF (BUF .LT. 6) GO TO 91        
      LCORE = (BUF-1)/5        
      LCORE = LCORE*5        
      CALL OPEN (*90,FILE,Z(BUF),RDREW)        
      WRITE  (OUTPT,10) FILE        
   10 FORMAT (14H1DUMP OF FILE ,I3)        
      IF (IFILE .LE. 0) GO TO 100        
C        
      IREC = 0        
   20 WRITE  (OUTPT,30) IREC        
   30 FORMAT (8H0RECORD ,I6,6X,100(1H-))        
   40 CALL READ (*70,*60,FILE,Z,LCORE,0,IWORDS)        
C        
      I1 = -9        
   50 I1 = I1 + 10        
      I2 = MIN0(I1+9,LCORE)        
      WRITE (OUTPT,1) I1,(Z(I),I=I1,I2)        
      WRITE (OUTPT,2)    (Z(I),I=I1,I2)        
      WRITE (OUTPT,3)    (Z(I),I=I1,I2)        
      IF (LCORE-I2) 40,40,50        
C        
   60 I1 = -9        
   65 I1 = I1 + 10        
      I2 = MIN0(I1+9,IWORDS)        
      WRITE (OUTPT,1) I1,(Z(I),I=I1,I2)        
      WRITE (OUTPT,2)    (Z(I),I=I1,I2)        
      WRITE (OUTPT,3)    (Z(I),I=I1,I2)        
      IF (IWORDS .GT. I2) GO TO 65        
      IREC = IREC + 1        
      GO TO 20        
C        
   70 Z(1) = FILE        
      CALL CLOSE (FILE,CLSREW)        
      CALL RDTRL (Z)        
      WRITE  (OUTPT,80) (Z(I),I=1,7)        
   80 FORMAT (4H0EOF ,//,8H0TRAILER  ,/,7(1X,I12 /))        
   90 RETURN        
C        
   91 CALL MESAGE (8,0,NAME)        
      GO TO 90        
C        
  100 CALL READ (*70,*101,FILE,Z,2,1,IWORDS)        
  101 WRITE  (OUTPT,102) Z(1),Z(2)        
  102 FORMAT (14H0HEADER RECORD  ,/1H0,2A4)        
      Z(1) = FILE        
      CALL RDTRL (Z)        
      NCOLS = Z(2)        
      IF (NCOLS .GT. 300) NCOLS = 100        
      IOUT = 1        
      INCR = 1        
      IF (NCOLS) 70,70,110        
  110 DO 150 J = 1,NCOLS        
      WRITE  (OUTPT,115) J        
  115 FORMAT (7H0COLUMN  ,I5)        
      IROW = 0        
      NROW = 0        
      CALL UNPACK (*140,FILE,Z)        
      WRITE  (OUTPT,118) IROW,NROW        
  118 FORMAT (1H+,20X,3HROW  ,I4,11H   THRU ROW   ,I5)        
      IF (NROW .GT. 300) NROW = 100        
      NELS = NROW - IROW + 1        
      IF (NELS .LE. 0) GO TO 150        
      WRITE  (OUTPT,119) (Z(K),K=1,NELS)        
  119 FORMAT (1P,10E13.4)        
      GO TO 150        
  140 WRITE  (OUTPT,141)        
  141 FORMAT (13H NULL COLUMN  )        
  150 CONTINUE        
      GO TO 70        
C        
      END        
