      SUBROUTINE SAVPOS (NAMEI,IPOS)        
      INTEGER         IDUM1(1),INCT(2)        
      COMMON /ZZZZZZ/ ICORE(1)        
      COMMON /GINOX / LENGTH,IFILEX,IEOR,IOP,IENTRY,LSTNAM,N,NAME       
C*****        
      NAME = NAMEI        
      IENTRY = 10        
      CALL INIT (*10,IRDWRT,JBUFF)        
      CALL GINO (*10,*10,ICORE(JBUFF),IDUM1,INCT,IRDWRT)        
      IPOS = INCT(1)        
      RETURN        
C        
C     ERROR IN INIT OR GINO        
C        
   10 CALL VAXEND        
      RETURN        
      END        
