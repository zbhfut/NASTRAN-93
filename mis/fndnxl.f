      SUBROUTINE FNDNXL (NAME,NEWNM)        
C        
C     THE SUBROUTINE LOOKS FOR A HIGHER LEVEL SUBSTRUCTURE TO THE       
C     SUBSTRUCTURE NAME.  IF NAME DOES HAVE A HIGHER LEVEL SUBSTRUCTURE,
C     THE NAME OF THE HIGHER LEVEL SUBSTRUCTURE WILL BE RETURNED IN     
C     NEWNM.  IF NAME DOES NOT HAVE A HIGHER LEVEL SUBSTRUCTURE, NAME   
C     WILL BE RETURNED IN NEWNM.  IF NAME IS NOT KNOWN TO THE SYSTEM,   
C     BLANKS WILL BE RETURNED IN NEWNM.        
C        
      EXTERNAL        ANDF        
      LOGICAL         DITUP,MDIUP        
      INTEGER         ANDF,BUF,DIT,DITPBN,DITLBN,DITSIZ,DITNSB,DITBL,   
     1                MDI,MDIPBN,MDILBN,MDIBL,HL        
      DIMENSION       NAME(2),NEWNM(2),NMSBR(2)        
CZZ   COMMON /SOFPTR/ BUF(1)        
      COMMON /ZZZZZZ/ BUF(1)        
      COMMON /SOF   / DIT,DITPBN,DITLBN,DITSIZ,DITNSB,DITBL,IODUM(8),   
     1                MDI,MDIPBN,MDILBN,MDIBL,NXTDUM(15),DITUP,MDIUP    
      DATA    HL    / 2     /        
      DATA    IEMPTY/ 4H    /, NMSBR /4HFNDN,4HXL  /        
C        
      CALL CHKOPN (NMSBR(1))        
      CALL FDSUB  (NAME(1),K)        
      IF (K .NE. -1) GO TO 10        
      NEWNM(1) = IEMPTY        
      NEWNM(2) = IEMPTY        
      RETURN        
C        
C     FIND THE HIGHER LEVEL SUBSTRUCTURE TO NAME.        
C        
   10 CALL FMDI (K,IMDI)        
      I = ANDF(BUF(IMDI+HL),1023)        
      IF (I .EQ. 0) GO TO 20        
C        
C     NAME DOES HAVE A HIGHER LEVEL SUBSTRUCTURE.        
C        
      CALL FDIT (I,JDIT)        
      NEWNM(1) = BUF(JDIT  )        
      NEWNM(2) = BUF(JDIT+1)        
      RETURN        
C        
C     NAME DOES NOT HAVE A HIGHER LEVEL SUBSTRUCTURE.        
C        
   20 NEWNM(1) = NAME(1)        
      NEWNM(2) = NAME(2)        
      RETURN        
      END        
