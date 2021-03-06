      SUBROUTINE OSCXRF (IOP,AVAIL)        
C        
      IMPLICIT INTEGER (A-Z)        
      EXTERNAL        LSHIFT,RSHIFT,ANDF,ORF,COMPLF        
      INTEGER         DBENT(3),BLOCK(6),LAB(6),IOUT(32),IHD1(32),       
     1                IHD2(32),IHD3(32),IHD4(32),IHD5(32)        
      COMMON /OUTPUT/ ITITL(96),IHEAD(96)        
      COMMON /MODDMP/ IFLG(5)        
      COMMON /SYSTEM/ KSYS(65)        
      COMMON /LNKLST/ I,NVAIL,ISEQN,KIND,ITYPE,MASK3,MASK4,MASK5        
CZZ   COMMON /ZZXGPI/ Z(1)        
      COMMON /ZZZZZZ/ Z(1)        
      COMMON /XVPS  / VPS(3)        
      EQUIVALENCE     (KSYS(2),OP), (KSYS(9),NLPP), (KSYS(12),NLINE)    
      DATA    IHD1  / 7*4H    ,4HCOSM,4HIC /,4H NAS,4HTRAN,4H DMA,      
     1                4HP CO  ,4HMPIL,4HER -,4H DMA,4HP CR,4HOSS ,      
     2                4HREFE  ,4HRENC,4HE LI,4HSTIN,4HG   ,9*4H    /    
      DATA    IHD2  / 32*4H     /        
      DATA    IHD3  / 4HMODU,4HLE N,4HAME ,4HDMAP,4H STA,4HTEME,        
     1                4HNT N,4HUMBE,4HRS  ,23*4H     /        
      DATA    IHD4  / 4HDATA,4H BLO,4HCK  ,4HDMAP,4H STA,4HTEME,        
     1                4HNT N,4HUMBE,4HRS  ,23*4H     /        
      DATA    IHD5  / 4HPARA,4HMETE,4HR   ,4HTYPE,4H    ,4HDMAP,        
     1                4H STA,4HTEME,4HNT N,4HUMBE,4HRS  ,21*4H     /    
      DATA    LAB   / 4HI   ,4HR   ,4HBCD ,4HRDP ,4HCSP ,4HCDP     /    
      DATA    POOL  / 4HPOOL  /        
      DATA    NBLANK/ 4H      /    ,IOUT  /32*4H     /        
      DATA    NASTK / 4H*     /    ,NOTAPP/4HN.A.    /        
C        
C     RESTRICT OPEN CORE DUE TO LIMITED FIELD SIZE FOR POINTERS        
C        
      NVAIL = AVAIL        
      IF (NVAIL .GT. 16350) NVAIL = 16350        
C        
C     PROCESS VARAIABLE PARAMETER LIST        
C        
      MASK2 = LSHIFT(1,16) - 1        
      MASK1 = ANDF(LSHIFT(1,20)-1,COMPLF(MASK2))        
      MASK3 = LSHIFT(1,14) - 1        
      MASK4 = LSHIFT(MASK3,14)        
      MASK5 = COMPLF(ORF(MASK3,MASK4))        
      NOSGN = COMPLF(LSHIFT(1,KSYS(40)-1))        
C        
      DO 14 I = 1,1600        
   14 Z(I) = 0        
      K = 3        
      I = 1        
      KIND  =-5        
      NPARAM= 1        
   20 ITYPE = ANDF(VPS(K+2),MASK1)        
      ITYPE = RSHIFT(ITYPE,16)        
      LEN   = ANDF(VPS(K+2),MASK2)        
      CALL LINKUP (*999,VPS(K))        
      K = K + LEN + 3        
      IF (K .GT. VPS(2)) GO TO 30        
      NPARAM = NPARAM + 1        
      GO TO 20        
C        
C     PROCESS NAMES OF MODULES AND DATA BLOCKS        
C        
   30 PSEQ = 0        
   40 CALL READ (*200,*998,POOL,BLOCK,6,0,Q)        
      IAUTO = 0        
      MI    = RSHIFT(BLOCK(3),16)        
      ITYPE = ANDF(MASK2,BLOCK(3))        
      ISEQN = ANDF(NOSGN,BLOCK(6))        
      KIND  = 1        
      IF (PSEQ.EQ.ISEQN .AND. (MI.EQ.3 .OR. MI.EQ.8)) IAUTO = 1        
      IF (IAUTO .EQ. 1) KIND = 2        
      PSEQ = ISEQN        
      CALL LINKUP (*999,BLOCK(4))        
      KIND = 3        
      GO TO (50,50,70,90), ITYPE        
C        
C     PROCESS FUNCTIONAL MODULE IO SECTIONS        
C        
   50 IRLH = 0        
   51 IRLH = IRLH + 1        
      CALL READ (*998,*998,POOL,NDB,1,0,Q)        
      DO 52 J = 1,NDB        
      CALL READ (*998,*998,POOL,DBENT,3,0,Q)        
      IF (DBENT(1) .EQ. 0) GO TO 52        
      CALL LINKUP (*999,DBENT)        
   52 CONTINUE        
      KIND = 4        
      IF (ITYPE.EQ.1 .AND. IRLH.EQ.1) GO TO 51        
      KIND = 5        
      CALL READ (*998,*998,POOL,NDB, -1,0,Q)        
      CALL READ (*998,*998,POOL,NPARM,1,0,Q)        
      IF (NPARM .EQ. 0) GO TO 80        
      DO 65 J = 1,NPARM        
      CALL READ (*998,*998,POOL,IL,1,0,Q)        
      IF (IL) 60,55,55        
   55 CALL READ (*998,*998,POOL,DBENT,-IL,0,Q)        
      GO TO 65        
   60 IL = ANDF(NOSGN,IL)        
      CALL LINKUP (*999,VPS(IL-3))        
   65 CONTINUE        
      GO TO 80        
   70 IF (MI .NE. 7) GO TO 80        
      KIND = 5        
      CALL READ (*998,*998,POOL,IL,1,0,Q)        
      IL = ANDF(MASK2,IL)        
      CALL LINKUP (*999,VPS(IL-3))        
   80 CALL FWDREC (*998,POOL)        
      GO TO 40        
   90 MI = MI - 7        
      IF (MI .LT. 0) MI = 4        
      GO TO (100,120,170,120) ,MI        
  100 CALL READ (*998,*998,POOL,NDB,1,0,Q)        
      KIND = 5        
      IF (IAUTO .EQ. 1) KIND = 6        
      DO 110 J = 1,NDB        
      CALL READ (*998,*998,POOL,DBENT,2,0,Q)        
      IL = DBENT(1)        
      CALL LINKUP (*999,VPS(IL-3))        
  110 CONTINUE        
      GO TO 80        
  120 CALL READ (*998,*40,POOL,NDB,1,0,Q)        
      KIND = 3        
  130 DO 140 J = 1,NDB        
      CALL READ (*998,*998,POOL,DBENT,2,0,Q)        
      IF (DBENT(1) .EQ. 0) GO TO 140        
      CALL LINKUP (*999,DBENT)        
  140 CONTINUE        
      IF (MI .EQ. 4) GO TO 80        
      CALL READ (*998,*998,POOL,IL,1,0,Q)        
      IF (IL) 160,160,150        
  150 KIND = 5        
      CALL LINKUP (*999,VPS(IL-3))        
  160 IF (MI .EQ. 2) GO TO 120        
  170 CALL READ (*998,*40,POOL,NDB,1,0,Q)        
      KIND = 3        
      CALL READ (*998,*998,POOL,DBENT,3,0,Q)        
      IF (DBENT(1) .EQ. 0) GO TO 180        
      CALL LINKUP (*999,DBENT)        
  180 NDB = NDB - 1        
      GO TO 130        
C        
C     SORT PARAMETER AND MODULE NAMES, 8-BCD WORD SORT        
C        
  200 NWDS = 4*NPARAM        
      CALL SORTA8 (0,0,4,1,Z(1),NWDS)        
      IST = NWDS + 1        
      J   = I - 1 - NWDS        
      CALL SORTA8 (0,0,4,1,Z(IST),J)        
      NWDS = I - 1        
C        
C     TRAVERSE LINKED LISTS AND GENERATE OUTPUT        
C        
      K   = 1        
      KDH = 0        
      DO 260 J = 1,32        
      IHEAD(J   ) = IHD1(J)        
      IHEAD(J+32) = IHD2(J)        
      IHEAD(J+64) = IHD5(J)        
  260 CONTINUE        
      CALL PAGE        
      WRITE (OP,900)        
      NLINE = NLINE + 1        
C        
C     PROCESS PARAMETER NAMES        
C        
  270 IOUT(2) = Z(K  )        
      IOUT(3) = Z(K+1)        
      NTYPE   = RSHIFT(Z(K+2),28)        
      IOUT(4) = NBLANK        
      IOUT(5) = LAB(NTYPE)        
      IF (NTYPE.EQ.0 .OR. NTYPE.GT.6) IOUT(5) = NOTAPP        
      IOUT(6) = NBLANK        
C        
C     TRACE THROUGH LINKED LIST        
C        
      II = 7        
  280 LINK = ANDF(MASK3,Z(K+2))        
  310 ISN  = ANDF(MASK3,Z(LINK))        
      IF (KDH .EQ. 0) ISN = -ISN        
      CALL OUTPAK (II,IOUT,ISN)        
      ITEMP = RSHIFT(Z(LINK),28)        
      IF (ITEMP.EQ.2 .OR. ITEMP.EQ.4 .OR. ITEMP.EQ.6) IOUT(II+1) = NASTK
      LINK = RSHIFT(ANDF(Z(LINK),MASK4),14)        
      IF (LINK .EQ. 0) GO TO 320        
      II = II + 2        
      GO TO 310        
C        
C     PRINT OUTPUT        
C        
  320 NLINE = NLINE + 1        
      IF (NLINE .LE. NLPP) GO TO 321        
      CALL PAGE        
      NLINE = NLINE + 1        
      WRITE (OP,900)        
      NLINE = NLINE + 1        
  321 WRITE (OP,902) (IOUT(LL),LL=2,32)        
      DO 325 LL = 2,32        
      IOUT(LL) = NBLANK        
  325 CONTINUE        
  328 K = K + 4        
      IF (K .GE. IST) GO TO 330        
      IF (KDH .EQ. 1) GO TO 337        
      IF (KDH .EQ. 2) GO TO 425        
      GO TO 270        
C        
C     PROCESS MODULE NAMES        
C        
  330 IF (KDH .GT. 0) GO TO 340        
      KDH = 1        
      DO 335 J = 1,32        
      IHEAD(J+64) = IHD3(J)        
  335 CONTINUE        
      WRITE (OP,910)        
      CALL PAGE        
      NLINE = NLINE + 1        
      WRITE (OP,900)        
      K   = IST        
      IST = NWDS        
  337 IF (RSHIFT(Z(K+3),28) .GE. 3) GO TO 328        
  339 IOUT(2) = Z(K  )        
      IOUT(3) = Z(K+1)        
      IOUT(4) = NBLANK        
      II = 5        
      GO TO 280        
C        
C     PROCESS DATA BLOCKS        
C        
  340 IF (KDH .GT. 1) GO TO 430        
      KDH = 2        
      DO 420 J = 1,32        
      IHEAD(J+64) = IHD4(J)        
  420 CONTINUE        
      WRITE (OP,905)        
      CALL PAGE        
      NLINE = NLINE + 1        
      WRITE (OP,900)        
      K   = 4*NPARAM + 1        
      IST = NWDS        
  425 IF (RSHIFT(Z(K+3),28) .GE. 3) GO TO 339        
      GO TO 328        
  430 WRITE (OP,906)        
      CALL REWIND (POOL)        
      CALL SKPFIL (POOL,IOP)        
      CALL FWDREC (*998,POOL)        
      GO TO 1000        
  998 CALL XGPIDG (59,0,0,0)        
      GO TO 1000        
  999 CALL XGPIDG (60,0,0,0)        
 1000 RETURN        
C        
  900 FORMAT (1H )        
  902 FORMAT (5X,31A4)        
  905 FORMAT (//6X,'* DENOTES AUTOMATICALLY GENERATED INSTRUCTIONS',    
     1        /8X,'STATEMENT NUMBER REFERS TO DMAP SEQUENCE NUMBER OF ',
     2        'PREVIOUS INSTRUCTION')        
  906 FORMAT (//6X,'* DENOTES STATEMENTS IN WHICH THE DATA BLOCK ',     
     1        'APPEARSRS AS OUTPUT.')        
  910 FORMAT (//6X,'* DENOTES APPEARANCE OF PARAMETER IN AUTOMATICALLY',
     1        ' GENERATED SAVE INSTRUCTION')        
      END        
