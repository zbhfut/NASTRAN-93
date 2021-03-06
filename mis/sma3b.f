      SUBROUTINE SMA3B(IFLAG,IZK)        
C        
C     THIS ROUTINE PROCESSES A GENERAL ELEMENT FROM GEI        
C        
C     IT  PRODUCES A ZE MATRIX OR A ZINVS MATRIX AND A SE MATRIX        
C        
C     ASSUMES GEI SITS AT BEGINNING OF UI SET AND IS OPEN TO READ       
C        
      DOUBLE PRECISION D11        
      INTEGER SYSBUF,ZE,SE,GEI,SE1,ZE1,ZINVS        
      DIMENSION ZE(7),SE(7)        
C        
CZZ   COMMON  /ZZSM3B/ Z(1)        
      COMMON  /ZZZZZZ/ Z(1)        
      COMMON /SYSTEM/ SYSBUF        
      COMMON /ZBLPKX/D11(2),IDX        
      COMMON/GENELY/GEI,DUM1(2),ZE1,SE1,ID1,ZINVS,DUM2(22),ID(7),       
     1 DUM4(35),M,N        
C        
C     COMPUTE LENGTH OF VARIABLE CORE        
C        
      NZ  = KORSZ(Z)-SYSBUF        
      IFLAG=-1        
      NZ =NZ -SYSBUF        
C        
C SKIP M+N WORDS ON GEI FILE        
C        
      CALL FREAD(GEI,Z,M+N,0)        
C        
C READ FLAG VARIABLE FOR Z OR K MATRIX        
C        
      CALL FREAD(GEI,IZK,1,0)        
C        
C IF Z MATRIX INPUT,WRITE ON ZE1 FILE        
C IF K MATRIX INPUT,WRITE ON ZINVS FILE        
C        
      CALL MAKMCB(ZE,ZE1,M,6,2)        
      IF (IZK.EQ.2) ZE(1)=ZINVS        
      CALL MAKMCB(SE,SE1,N,2,2)        
C        
C READY FOR PACKING MATRICES        
C        
C        
C OPEN ZE MATRIX        
C        
      CALL GOPEN(ZE,Z(NZ+1),1)        
C        
C     LOOP ON M COLUMNS OF ZE        
C        
      DO 20 I=1,M        
      CALL BLDPK(2,2,ZE(1),0,0)        
      DO 10 J=1,M        
      CALL FREAD(GEI,Z,1,0)        
      D11(1) = Z(1)        
      IDX = J        
   10 CALL ZBLPKI        
      CALL BLDPKN(ZE(1),0,ZE)        
   20 CONTINUE        
      CALL CLOSE( ZE(1),1)        
      CALL WRTTRL( ZE )        
      IF(N .EQ. 0) GO TO 50        
      IFLAG =1        
C        
C     NOW BUILD SE TRANSPOSE        
C        
C        
C     OPEN AND WRITE HEADER        
C        
      CALL GOPEN(SE,Z(NZ+1),1)        
C        
C     LOOP ON N COLUMNS OF SE        
C     LOOP ON M COLUMNS OF SE  TRANSPOSE        
C        
      DO 40 I=1,M        
      CALL BLDPK(2,2,SE(1),0,0)        
      DO 30 J=1,N        
      CALL FREAD(GEI,Z,1,0)        
      D11(1) = -Z(1)        
      IDX = J        
   30 CALL ZBLPKI        
      CALL BLDPKN(SE(1),0,SE)        
   40 CONTINUE        
      CALL CLOSE(SE(1),1)        
      CALL WRTTRL(SE)        
C        
C     BACKSPACE GEI SO UD AND UI AVAILABLE LATER        
C        
   50 CALL BCKREC(GEI)        
      CALL CLOSE(GEI,2)        
      ID(1) = ID1        
      ID(2)=M        
      ID(3)=M        
      ID(4)=8        
      ID(5)=2        
      ID(6)=1        
      ID(7)=0        
      RETURN        
      END        
