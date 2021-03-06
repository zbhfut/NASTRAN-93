      SUBROUTINE PCOORD (PEN)        
C        
C     PLOTS A COORDINATE TRIAD AT THE LOWER RIGHT CORNER OF A STRUCTURAL
C     PLOT. THIS ROUTINE IS CALLED ONLY BY DRAW        
C        
C     WRITTEN BY G.CHAN/UNISYS      10/1990        
C        
      INTEGER         PEN,FPLTIT,SYM(2)        
      COMMON /XXPARM/ IDUMM(215),FPLTIT        
      COMMON /PLTDAT/ IDUM20(20),SIZE,IDUM2(2),CNTCHR(2)        
      COMMON /DRWAXS/ G(3,4)        
C        
C        
C     COMPUTE THE ORIGIN, WHICH IS A FUNCTION OF FRAME SIZE, CHARACTER  
C     VERTICAL AND HORIZONTAL SCALES, PRESENCE OF PTITLE LINE, AND THE  
C     OVERALL SIZE OF THE TRIAD        
C        
C     ALL THE NUMERIC MULTIPLIERS USED BELOW WERE WORKED OUT WITH FRAME 
C     SIZE OF 1023.0. THEY SHOULD BE APPLICABLE TO FRAME SIZE OF 3000.  
C        
      X2 = 0.0        
      Y2 = 0.0        
      Y1 = 0.0        
      DO 10 I = 1,3        
      IF (G(2,I) .GT. X2) X2 = G(2,I)        
      IF (G(3,I) .LT. Y2) Y2 = G(3,I)        
      IF (G(3,I) .GT. Y1) Y1 = G(3,I)        
   10 CONTINUE        
      DE = 1.8*CNTCHR(1)        
      SF = 2.7*CNTCHR(2)        
      IF (FPLTIT .EQ. 0) SF = 1.3*SF        
      SF = SF/(Y1-Y2)        
      X1 = SIZE - X2*SF - DE        
      Y1 = -Y2*SF        
      IF (FPLTIT .NE. 0) Y1 = Y1 + 0.8*CNTCHR(2)        
      EP = 0.0001        
      OF = -1.        
      IF (G(2,1).LE.EP .AND. G(2,2).LE.EP .AND. G(2,3).LE.EP) OF = +1.  
      IF (OF .EQ. +1.) X1 = X1 - DE        
C        
C     DRAW THE X-Y-Z COORDINATE TRIAD        
C     DRAW A CIRCLE AT THE ORIGIN IF ANY AXIS IS IN LINE WITH VIEWER    
C        
      SYM(1) = 6        
      SYM(2) = 0        
      DE = 0.8*CNTCHR(1)        
      OF = 1.3*OF*CNTCHR(1)        
      DO 30 I = 1,3        
      X2 = G(2,I)*SF + X1        
      Y2 = G(3,I)*SF + Y1        
      CALL LINE (X1,Y1,X2,Y2,PEN,0)        
      IF (ABS(G(2,I))+ABS(G(3,I)) .GE. EP) GO TO 20        
      CALL SYMBOL (X1,Y1,SYM,0)        
      CALL TIPE (X2+OF,Y2,1,G(I,4),1,0)        
      GO TO 30        
   20 IF (G(2,I) .GT. 0.0) CALL TIPE (X2+DE,Y2,1,G(I,4),1,0)        
      IF (G(2,I) .LE. 0.0) CALL TIPE (X2-DE,Y2,1,G(I,4),1,0)        
   30 CONTINUE        
C        
      RETURN        
      END        
