      SUBROUTINE PLA1        
C        
C     THIS FUNCTIONAL MODULE IS THE FIRST OF FOUR FUNCTIONAL MODULES    
C     UNIQUE TO THE PIECE-WISE LINEAR ANALYSIS (DISPLACEMENT METHOD)    
C     RIGID FORMAT        
C        
C        
C     PLA1   CSTM,MPT,ECPT,GPCT,DIT,CASECC,EST /KGGL,ECPTNL,ESTL,ESTNL/ 
C            V,N,KGGLPG/V,N,NPLALIM/V,N,ECPTNLPG/V,N,PLSETNO/        
C            V,N,NONLSTR/V,N,PLFACT/ $        
C        
C     THE OUTPUT DATA BLOCKS AND PARAMETERS ARE DEFINED AS FOLLOWS -    
C        
C     KGGL   IS THE STIFFNESS MATRIX OF LINEAR (NON-STRESS DEPENDENT)   
C            ELEMENTS        
C     ECPTNL IS A SUBSET OF THE ECPT WHICH CONTAINS ECPT PLUS STRESS    
C            INFORMATION FOR THE NON-LINEAR (STRESS DEPENDENT) ELEMENTS 
C     ESTL,  A SUBSET OF THE EST, CONTAINS ALL LINEAR ELEMENTS        
C     ESTNL, THE COMPLEMENT OF THE ESTL, CONTAINS INFORMATION FOR THE   
C            NON-LINEAR ELEMENTS        
C        
C     PARAMETER NAMES BELOW ARE FORTRAN VARIABLE NAMES RATHER THAN DMAP 
C     PARAMETER NAMES        
C        
C     KGGLPG IS THE PURGE FLAG FOR THE KGGL AND ESTL DATA BLOCKS.  IT IS
C            SET = -1 (PURGE=YES) IF ALL ELEMENTS ARE STRESS DEPENDENT  
C     NPLALP IS THE NUMBER OF PASSES THAT WILL BE MADE THRU THE PLA LOOP
C     KICKOF IS SET = -1 (KICK THE USER OFF THE MACHINE = YES) IF THE   
C            DIT IS PURGED OR ALL ELEMENTS ARE NON-STRESS DEPENDENT     
C     PLASET IS THE SET NUMBER ON THE PLFACT CARD THAT IS OBTAINED FROM 
C            THE FIRST RECORD OF CASECC        
C     NONLST IS THE FLAG SUCH THAT IF IT IS A -1 THE USER DOES NOT WISH 
C            TO OUTPUT HIS NON-LINEAR STRESSES.  HENCE PLA3 WILL NOT BE 
C            CALLED        
C     PLFACT IS THE FIRST PIECE-WISE LINEAR FACTOR TO BE USED FROM      
C            PLASET        
C        
      LOGICAL          PHASE1,ALL,HEAT        
      INTEGER          BUFR1,BUFR2,BUFR3,BUFR4,BUFSZ,IZ(1),EOR,CLSRW,   
     1                 CLSNRW,OUTRW,FROWIC,TNROWS,CSTM,DIT,ECPT,GPCT,   
     2                 ECPTNL,ESTL,ESTNL,PLAARY(90),FILE,TRAIL,PLASET,  
     3                 PLANOS(2),SETNO,OUTFIL,IECPT(100),ESTLTR(7),     
     4                 ESTNLT(7),YESSD,EST,CASECC        
      DOUBLE PRECISION DZ(1),DPDUM,DPWORD        
      DIMENSION        NAME(2),INPVT(2)        
      CHARACTER        UFM*23,UWM*25        
      COMMON /XMSSG /  UFM,UWM        
      COMMON /BLANK /  KGGLPG,NPLALP,KICKOF,PLASET,NONLST,PLFACT(2)     
      COMMON /SYSTEM/  BUFSZ,ISYSPT,ISP1(37),NBPW,ISP2(14),IPREC        
      COMMON /SMA1IO/  CSTM,MPT,DIT,BUFR1,ECPT,BUFR2,GPCT,BUFR3,BUFR4,  
     1                 ITYPE,KGGL,ESTNL,ECPTNL,DUM1,ESTL,DUM2,INRW,     
     2                 OUTRW,CLSNRW,CLSRW,NEOR,EOR,MCBKGG(7),TRAIL(7)   
CZZ   COMMON /ZZSMA1/  Z(1)        
      COMMON /ZZZZZZ/  Z(1)        
      COMMON /SMA1BK/  ICSTM,NCSTM,IGPCT,NGPCT,IPOINT,NPOINT,I6X6K,     
     1                 DUM4,DUM5,DUM6        
      COMMON /SMA1CL/  IOPT4,DUM7,NPVT,LEFT,FROWIC,LROWIC,NROWSC,       
     1                 TNROWS,JMAX,NLINKS,LINK(10),DUM8,DUM9,NOGO       
      COMMON /GPTA1 /  NELEMS,LAST,INCR,NE(1)        
      COMMON /SMA1ET/  XECPT(100)        
      COMMON /SMA1DP/  DPDUM(300)        
      COMMON /SMA1HT/  HEAT        
      COMMON /ZBLPKX/  DPWORD,LLLLLL(2),INDEX        
      COMMON /MATIN /  MATID,INFLAG,FILLER(4)        
      COMMON /MATOUT/  INDSTR,YYYYYY(19)        
      EQUIVALENCE      (Z(1),IZ(1),DZ(1)) ,(IECPT(1),XECPT(1)),        
     1                 (MCBKGG(1),ESTLTR(1)), (TRAIL(1),ESTNLT(1)),     
     2                 (TRAIL(2),NNLEL), (ESTLTR(2),NLEL),        
     3                 (FNN,NN), (INDSTR,E)        
      DATA             CASECC,JSTSET,JPLSET,JSYM /106,23,164,200 /      
      DATA             NAME  / 4HPLA1,4H    /, HMPT  / 4HMPT     /      
      DATA             PLANOS/ 1103, 11     /        
      DATA             PLAARY/ 1,  0,  1,  0,  0,    1,  0,  0,  1,  1, 
     1                         0,  0,  0,  0,  0,    1,  1,  1,  1,  0, 
     2                         0,  0,  0,  0,  0,    0,  0,  0,  0,  0, 
     3                         0,  0,  0,  1,  0,    0,  0,  0,  0,  0, 
     4                         0,  0,  0,  0,  0,    0,  0,  0,  0,  0, 
     5                         0,  0,  0,  0,  0,    0,  0,  0,  0,  0, 
     6                      30*0 /        
C        
C     IF THE DIT HAS BEEN PURGED, WE CANNOT PROCEED FURTHER        
C        
      IPR = IPREC        
      CALL DELSET        
      TRAIL(1) = DIT        
      CALL RDTRL (TRAIL)        
      IF (TRAIL(1) .LT. 0) CALL MESAGE (-1,DIT,NAME)        
C        
C     INITIALIZE HEAT PARAMETER        
C        
      HEAT = .FALSE.        
C        
C     INITIALIZE MODULE PARAMETERS AND SET IOPT4 = 0, SO THAT ELEMENT   
C     ROUTINES WILL NOT CALCULATE STRUCTURAL DAMPING MATRICES.        
C        
      KGGLPG =-1        
      NPLALP = 1        
      KICKOF =-1        
      PLASET =-1        
      NONLST = 1        
      PLFACT(1) = 1.0        
      IOPT4  = 0        
      ESTNL  = 204        
      EST    = 107        
      PHASE1 = .TRUE.        
      ASSIGN 290 TO NOSD        
C        
C     SET UP BUFFERS AND INITIALIZE FILE TRAILERS.        
C        
      IZMAX = KORSZ (Z)        
      BUFR1 = IZMAX - BUFSZ        
      BUFR2 = BUFR1 - BUFSZ        
      BUFR3 = BUFR2 - BUFSZ        
      BUFR4 = BUFR3 - BUFSZ        
      LEFT  = BUFR4 - 1        
      CALL MAKMCB (MCBKGG,KGGL,0,6,IPR)        
      CALL MAKMCB (TRAIL,ECPTNL,0,0,0)        
C        
C     CHECK PLAARY SIZE        
C        
      IF (NELEMS .GT. 90) WRITE (ISYSPT,1) UWM        
    1 FORMAT (A25,' 2151, -PLAARY- ARRAY IS SMALLER THAN MAXIMUM ',     
     1       'NUMBER OF ELEMENT TYPES.')        
C        
C     OPEN THE KGGL FILE FOR OUTPUT        
C        
      CALL GOPEN (KGGL,Z(BUFR1),1)        
C        
C     ATTEMPT TO READ THE CSTM INTO CORE        
C        
      ICSTM = 0        
      NCSTM = 0        
      FILE  = CSTM        
      CALL OPEN (*20,CSTM,Z(BUFR2),INRW)        
      CALL FWDREC (*870,CSTM)        
      CALL READ (*870,*10,CSTM,Z(ICSTM+1),LEFT,EOR,NCSTM)        
C        
C     INSUFFICIENT CORE - CALL MESAGE        
C        
      CALL MESAGE (-8,0,NAME)        
   10 LEFT = LEFT - NCSTM        
      CALL CLOSE (CSTM,CLSRW)        
C        
C     CALL PRETRD TO SET UP FUTURE CALLS TO TRANSD.        
C        
      CALL PRETRD (Z(ICSTM+1),NCSTM)        
      CALL PRETRS (Z(ICSTM+1),NCSTM)        
C        
C     CALL PREMAT TO READ THE MPT AND THE DIT AND TO SET UP FUTURE CALLS
C     TO SUBROUTINE MAT.  NOTE NEGATIVE ISGN FOR DIT TO TRIGGER PLA FLAG
C     IN MAT.        
C        
   20 IMAT  = NCSTM        
      CALL PREMAT (IZ(IMAT+1),Z(IMAT+1),Z(BUFR2-3),LEFT,MUSED,MPT,-DIT) 
      LEFT  = LEFT  - MUSED        
      IGPCT = NCSTM + MUSED        
C        
C     OPEN THE INPUT FILES ECPT AND GPCT AND THE OUTPUT FILE ECPTNL.    
C        
      CALL GOPEN (ECPT,  Z(BUFR2),0)        
      CALL GOPEN (GPCT,  Z(BUFR3),0)        
      CALL GOPEN (ECPTNL,Z(BUFR4),1)        
      ILEFT = LEFT        
C        
C     BEGIN MAIN LOOP FOR PROCESSING THE ECPT.        
C        
   30 CALL READ (*650,*630,GPCT,INPVT(1),2,NEOR,IFLAG)        
      NGPCT = INPVT(2)        
      LEFT  = ILEFT - 2*NGPCT        
      IF (LEFT .LE. 0) CALL MESAGE (-8,0,NAME)        
      CALL FREAD (GPCT,IZ(IGPCT+1),NGPCT,EOR)        
C        
C     FROWIC IS THE FIRST ROW IN CORE (1 .LE. FROWIC .LE. 6)        
C        
      FROWIC = 1        
      IPOINT = IGPCT  + NGPCT        
      NPOINT = NGPCT        
      I6X6K  = IPOINT + NPOINT        
C        
C     MAKE I6X6K A DOUBLE PRECISION INDEX (I6X6K POINTS TO THE 0TH      
C     LOCATION OF THE 6 X 6 SUBMATRIX OF KGGL IN CORE)        
C        
      I6X6K = (I6X6K-1)/2 + 2        
C        
C     CONSTRUCT THE POINTER TABLE WHICH WILL ENABLE SUBROUTINE SMA1B TO 
C     ADD THE ELEMENT STIFFNESS MATRICES TO KGGL.        
C        
      IZ(IPOINT+1) = 1        
      I1 = 1        
      I  = IGPCT        
      J  = IPOINT + 1        
   40 I1 = I1 + 1        
      IF (I1 .GT. NGPCT) GO TO 50        
      I  = I + 1        
      J  = J + 1        
      INC= 6        
      IF (IZ(I) .LT. 0) INC = 1        
      IZ(J) = IZ(J-1) + INC        
      GO TO 40        
C        
C     JMAX = THE NO. OF COLUMNS OF KGGL THAT WILL BE GENERATED WITH THE 
C     CURRENT PIVOT POINT.        
C        
   50 INC   = 5        
      ILAST = IGPCT  + NGPCT        
      JLAST = IPOINT + NPOINT        
      IF (IZ(ILAST) .LT. 0) INC = 0        
      JMAX  = IZ(JLAST) + INC        
C        
C     TNROWS = TOTAL NO. OF ROWS OF THE MATRIX TO BE GENERATED        
C        
      TNROWS = 6        
      IF (INPVT(1) .LT. 0) TNROWS = 1        
      IF (2*TNROWS*JMAX .LT. LEFT) GO TO 70        
C        
C     THE WHOLE SUBMATRIX CANNOT FIT IN CORE        
C        
      IF (TNROWS .EQ. 1) CALL MESAGE (-8,0,NAME)        
      NROWSC = 3        
      PLAARY(39) = NAME(1)        
   60 PLAARY(40) = NPVT        
      CALL MESAGE (30,85,PLAARY(39))        
      IF (2*NROWSC*JMAX .LT. LEFT) GO TO 80        
      NROWSC = NROWSC - 1        
      IF (NROWSC .EQ. 0) CALL MESAGE (-8,0,NAME)        
      GO TO 60        
   70 NROWSC = TNROWS        
   80 FROWIC = 1        
      LROWIC = FROWIC + NROWSC - 1        
C        
C     ZERO OUT THE KGGL SUBMATRIX IN CORE.        
C        
      LOW = I6X6K + 1        
      LIM = I6X6K + JMAX*NROWSC        
      DO 90 I = LOW,LIM        
   90 DZ(I) = 0.0D0        
C        
C     INITIALIZE THE LINK VECTOR TO -1        
C        
      DO 100 I = 1,NLINKS        
  100 LINK(I) = -1        
      LINCOR  =  1        
      FILE = ECPT        
C        
C     TURN FIRST PASS, FIRST ELEMENT READ ON THE CURRENT PASS OF THE    
C     ECPT RECORD, AND PIVOT POINT WRITTEN INDICATORS ON.        
C        
      IPASS  = 1        
      NPVTWR = 0        
  110 IFIRST = 1        
C        
C     READ THE FIRST WORD OF THE ECPT RECORD, THE PIVOT POINT, INTO NPVT
C        
      CALL FREAD (ECPT,NPVT,1,NEOR)        
C        
C     READ THE NEXT ELEMENT TYPE INTO ITYPE, AND READ THE PRESCRIBED NO.
C     OF WORDS INTO THE XECPT ARRAY.        
C        
  120 CALL READ (*870,*520,ECPT,ITYPE,1,NEOR,IFLAG)        
      IDX = (ITYPE-1)*INCR        
      NN  = NE(IDX+12)        
      CALL FREAD (ECPT,XECPT,NN,NEOR)        
      ITEMP = NE(IDX+22)        
      IF (IPASS .NE. 1) GO TO 290        
C        
C     THIS IS THE FIRST PASS.  IF THE ELEMENT IS IN THE PLA SET, CALL   
C     THE MAT ROUTINE TO FIND OUT IF ANY OF THE MATERIAL PROPERTIES IS  
C     STRESS DEPENDENT.        
C        
C        
C              CROD      CBEAM     CTUBE     CSHEAR    CTWIST    CTRIA1 
C                 1        2         3          4         5         6   
C              CTRBSC    CTRPLT    CTRMEM    CONROD    ELAS1     ELAS2  
C               7           8         9        10        11        12   
C              ELAS3     ELAS4     CQDPLT    CQDMEM    CTRIA2    CQUAD2 
C               13        14         15        16        17        18   
C              CQUAD1    CDAMP1    CDAMP2    CDAMP3    CDAMP4    CVISC  
C               19        20        21         22        23        24   
C              MASS1     CMASS2    CMASS3    CMASS4    CONM1     CONM2  
C                25        26        27        28        29        30   
C              PLOTEL    REACT     QUAD3     CBAR      CCONE        
C                31        32        33       34         35        
      IF (ITYPE .GT. 35) GO TO 120        
      GO TO (130,890,150,290,290,160,290,290,170,130,        
     1       290,290,290,290,290,180,190,200,210,120,        
     2       120,120,120,120,120,120,120,120,120,120,        
     3       120,890,890,220,290), ITYPE        
C        
C     ROD        
C        
  130 MATID = IECPT(4)        
      ASSIGN 140 TO YESSD        
      GO TO 230        
  140 XECPT(18) = 0.0        
      XECPT(19) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(20) = E        
      IF (PHASE1) GO TO 145        
      XECPT(21) = 0.0        
      NWDS = 21        
      GO TO 765        
  145 NWDS = 20        
      GO TO 260        
C        
C     TUBE        
C        
  150 MATID = IECPT(4)        
      ASSIGN 155 TO YESSD        
      GO TO 230        
  155 XECPT(17) = 0.0        
      XECPT(18) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(19) = E        
      IF (PHASE1) GO TO 157        
      XECPT(20) = 0.0        
      NWDS = 20        
      GO TO 765        
  157 NWDS = 19        
      GO TO 260        
C        
C     TRIA1        
C        
  160 MATID = IECPT(6)        
      ASSIGN 165 TO YESSD        
      GO TO 230        
  165 DO 166 I = 28,33        
  166 XECPT(I) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(30) = E        
      IF (PHASE1) GO TO 168        
      DO 167 I = 34,38        
  167 XECPT(I) = 0.0        
      NWDS = 38        
      GO TO 765        
  168 NWDS = 33        
      GO TO 260        
C        
C     TRMEM        
C        
  170 MATID = IECPT(6)        
      ASSIGN 175 TO YESSD        
      GO TO 230        
  175 DO 176 I = 22,27        
  176 XECPT(I) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(24) = E        
      NWDS = 27        
      IF (PHASE1) GO TO 260        
      GO TO 765        
C        
C     QDMEM        
C        
  180 MATID = IECPT(7)        
      ASSIGN 185 TO YESSD        
      GO TO 230        
  185 DO 186 I = 27,32        
  186 XECPT(I) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(29) = E        
      NWDS = 32        
      IF (PHASE1) GO TO 260        
      GO TO 765        
C        
C     TRIA2        
C        
  190 MATID = IECPT(6)        
      ASSIGN 195 TO YESSD        
      GO TO 230        
  195 DO 196 I = 22,27        
  196 XECPT(I) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(24) = E        
      IF (PHASE1) GO TO 198        
      DO 197 I = 28,32        
  197 XECPT(I) = 0.0        
      NWDS = 32        
      GO TO 765        
  198 NWDS = 27        
      GO TO 260        
C        
C     QUAD2        
C        
  200 MATID = IECPT(7)        
      ASSIGN 205 TO YESSD        
      GO TO 230        
  205 DO 206 I = 27,32        
  206 XECPT(I) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(29) = E        
      IF (PHASE1) GO TO 208        
      DO 207 I = 33,37        
  207 XECPT(I) = 0.0        
      NWDS = 37        
      GO TO 765        
  208 NWDS = 32        
      GO TO 260        
C        
C     QUAD1        
C        
  210 MATID = IECPT(7)        
      ASSIGN 215 TO YESSD        
      GO TO 230        
  215 DO 216 I = 33,38        
  216 XECPT(I) =0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(35) = E        
      IF (PHASE1) GO TO 218        
      DO 217 I = 39,43        
  217 XECPT(I) = 0.0        
      NWDS = 43        
      GO TO 765        
  218 NWDS = 38        
      GO TO 260        
C        
C     BAR - IF COORDINATE 1 OF EITHER PT. A OR PT. B IS PINNED THE      
C           ELEMENT IS TREATED AS LINEAR (NON-STRESS DEPENDENT)        
C        
  220 IF (IECPT(8).EQ.0 .AND. IECPT(9).EQ.0) GO TO 224        
      KA = IECPT(8)        
      KB = IECPT(9)        
  222 IF (MOD(KA,10).EQ.1 .OR. MOD(KB,10).EQ.1) GO TO 290        
      KA = KA/10        
      KB = KB/10        
      IF (KA.LE.0 .AND. KB.LE.0) GO TO 224        
      GO TO 222        
  224 MATID = IECPT(16)        
      ASSIGN 226 TO YESSD        
      GO TO 230        
  226 XECPT(43) = 0.0        
      XECPT(44) = 0.0        
      INFLAG = 1        
      CALL MAT (IECPT(1))        
      XECPT(45) = E        
      IF (PHASE1) GO TO 228        
      DO 227 I = 46,50        
  227 XECPT(I) = 0.0        
      NWDS = 50        
      GO TO 765        
  228 NWDS = 45        
      GO TO 260        
C        
C     TEST TO SEE IF ELEMENT IS STRESS DEPENDENT.        
C        
  230 INFLAG = 5        
      CALL MAT (IECPT(1))        
      IF (INDSTR) 240,240,250        
  240 GO TO NOSD,  (290,820)        
  250 GO TO YESSD, (140,155,165,175,185,195,205,215,226)        
C        
C     WRITE AN ENTRY ONTO ECPTNL        
C        
  260 IF (NPVTWR) 270,270,280        
  270 NPVTWR = 1        
      CALL WRITE (ECPTNL,NPVT,1,NEOR)        
      KICKOF = 1        
  280 CALL WRITE (ECPTNL,ITYPE,1,NEOR)        
      CALL WRITE (ECPTNL,XECPT,NWDS,NEOR)        
      NNLEL = NNLEL + 1        
      GO TO 120        
C        
C     IF THIS IS THE 1ST ELEMENT READ ON THE CURRENT PASS OF THE ECPT,  
C     CHECK TO SEE IF THIS ELEMENT IS IN A LINK THAT HAS ALREADY BEEN   
C     PROCESSED.        
C        
  290 KGGLPG = 1        
      IF (IFIRST .EQ. 1) GO TO 300        
C        
C     THIS IS NOT THE FIRST PASS.  IF ITYPE(TH) ELEMENT ROUTINE IS IN   
C     CORE, PROCESS IT.        
C        
      IF (ITEMP .EQ. LINCOR) GO TO 310        
C        
C     THE ITYPE(TH) ELEMENT ROUTINE IS NOT IN CORE.  IF THIS ELEMENT    
C     ROUTINE IS IN A LINK THAT ALREADY HAS BEEN PROCESSED READ THE NEXT
C     ELEMENT.        
C        
      IF (LINK(ITEMP) .EQ. 1) GO TO 120        
C        
C     SET A TO BE PROCESSED LATER FLAG FOR THE LINK IN WHICH THE ELEMENT
C     RESIDES        
C        
      LINK(ITEMP) = 0        
      GO TO 120        
C        
C     SINCE THIS IS THE FIRST ELEMENT TYPE TO BE PROCESSED ON THIS PASS 
C     OF THE ECPT RECORD, A CHECK MUST BE MADE TO SEE IF THIS ELEMENT   
C     IS IN A LINK THAT HAS ALREADY BEEN PROCESSED.  IF IT IS SUCH AN   
C     ELEMENT, WE KEEP IFIRST = 1 AND READ THE NEXT ELEMENT.        
C        
  300 IF (LINK(ITEMP) .EQ. 1) GO TO 120        
C        
C     SET THE CURRENT LINK IN CORE = ITEMP AND IFIRST = 0        
C        
      LINCOR = ITEMP        
      IFIRST = 0        
C        
C     CALL THE PROPER ELEMENT ROUTINE.        
C        
C            CROD  CBEAM  CTUBE  CSHEAR  CTWIST  CTRIA1  CTRBSC        
C              1     2      3       4       5       6       7        
C          CTRPLT  CTRMEM  CONROD  ELAS1  ELAS2  ELAS3  ELAS4        
C             8       9      10      11     12     13     14        
C          CQDPLT  CQDMEM  CTRIA2  CQUAD2 CQUAD1  CDAMP1  CDAMP2        
C            15      16      17      18      19     20      21        
C          CDAMP3  CDAMP4  CVISC  CMASS1  CMASS2  CMASS3  CMASS4        
C            22      23      24     25      26      27      28        
C           CONM1  CONM2   PLOTEL REACT   QUAD3   CBAR    CCONE        
C             29     30      31     32      33     34       35        
  310 IF (ITYPE .GT. 35) GO TO 120        
      GO TO (320,890,340,350,360,370,380,390,400,320,        
     1       410,420,430,440,450,460,470,480,490,120,        
     2       120,120,120,120,120,120,120,120,120,120,        
     3       120,890,890,500,510), ITYPE        
  320 CALL KROD        
      GO TO 120        
  340 CALL KTUBE        
      GO TO 120        
  350 CALL KPANEL (4)        
      GO TO 120        
  360 CALL KPANEL (5)        
      GO TO 120        
  370 CALL KTRIQD (1)        
      GO TO 120        
  380 CALL KTRBSC (0)        
      GO TO 120        
  390 CALL KTRPLT        
      GO TO 120        
  400 CALL KTRMEM (0)        
      GO TO 120        
  410 CALL KELAS (1)        
      GO TO 120        
  420 CALL KELAS (2)        
      GO TO 120        
  430 CALL KELAS (3)        
      GO TO 120        
  440 CALL KELAS (4)        
      GO TO 120        
  450 CALL KQDPLT        
      GO TO 120        
  460 CALL KQDMEM        
      GO TO 120        
  470 CALL KTRIQD (2)        
      GO TO 120        
  480 CALL KTRIQD (4)        
      GO TO 120        
  490 CALL KTRIQD (3)        
      GO TO 120        
  500 CALL KBAR        
      GO TO 120        
  510 IF (NBPW .LE. 32) CALL KCONED        
      IF (NBPW .GT. 32) CALL KCONES        
      GO TO 120        
C        
C     AN END OF LOGICAL RECORD HAS BEEN HIT ON THE ECPT.  IF NPVTWR = 0,
C     THE PIVOT POINT HAS NOT BEEN WRITTEN ON ECPTNL AND NO ELEMENTS IN 
C     THE CURRENT ECPT RECORD ARE PLASTIC.        
C        
  520 IF (IPASS .NE. 1) GO TO 550        
      IF (NPVTWR) 530,530,540        
  530 CALL WRITE (ECPTNL,-NPVT,1,EOR)        
      GO TO 550        
  540 CALL WRITE (ECPTNL,0,0,EOR)        
  550 IPASS = 2        
      LINK(LINCOR) = 1        
      DO 560 I = 1,NLINKS        
      IF (LINK(I) .EQ. 0) GO TO 570        
  560 CONTINUE        
      GO TO 580        
C        
C     SINCE AT LEAST ONE LINK HAS NOT BEEN PROCESSED THE ECPT FILE MUST 
C     BE BACKSPACED        
C        
  570 CALL BCKREC (ECPT)        
      GO TO 110        
C        
C     WRITE THE NO. OF ROWS IN CORE UNTO THE KGGL FILE USING ZBLPKI.    
C        
  580 I1  = 0        
  590 I2  = 0        
      IBEG = I6X6K + I1*JMAX        
      CALL BLDPK (2,IPR,KGGL,0,0)        
  600 I2  = I2 + 1        
      IF (I2 .GT. NGPCT) GO TO 620        
      JJ  = IGPCT + I2        
      INDEX = IABS(IZ(JJ)) - 1        
      LIM = 6        
      IF (IZ(JJ) .LT. 0) LIM = 1        
      JJJ = IPOINT + I2        
      KKK = IBEG + IZ(JJJ) - 1        
      I3  = 0        
  610 I3  = I3 + 1        
      IF (I3 .GT. LIM) GO TO 600        
      INDEX = INDEX + 1        
      KKK = KKK + 1        
      DPWORD = DZ(KKK)        
      IF (DPWORD .NE. 0.0D0) CALL ZBLPKI        
      GO TO 610        
  620 CALL BLDPKN (KGGL,0,MCBKGG)        
      I1  = I1 + 1        
      IF (I1 .LT. NROWSC) GO TO 590        
C        
C     IF LROWIC = TNROWS, PROCESSING OF THE CURRENT ECPT RECORD HAS BEEN
C     COMPLETED.        
C        
      IF (LROWIC .EQ. TNROWS) GO TO 30        
      CALL BCKREC (ECPT)        
      FROWIC = FROWIC + NROWSC        
      LROWIC = LROWIC + NROWSC        
      IPASS  = 2        
      GO TO 110        
C        
C     NO ELEMENTS ARE CONNECTED TO THE PIVOT POINT.  OUTPUT ZERO        
C     COLUMN(S).  ALSO, WRITE NEGATIVE PIVOT POINT ON ECPTNL.        
C        
  630 LIM = 6        
      IF (INPVT(1) .LT. 0) LIM = 1        
      DO 640 I = 1,LIM        
      CALL BLDPK (2,IPR,KGGL,0,0)        
  640 CALL BLDPKN (KGGL,0,MCBKGG)        
      CALL SKPREC (ECPT,1)        
      CALL WRITE (ECPTNL,-IABS(INPVT(1)),1,EOR)        
      GO TO 30        
C        
C     ECPT PROCESSING HAS BEEN COMPLETED SINCE AN EOF HAS BEEN READ ON  
C     GPCT.        
C        
  650 CALL CLOSE (GPCT,CLSRW)        
      CALL CLOSE (ECPT,CLSRW)        
      CALL CLOSE (KGGL,CLSRW)        
      CALL CLOSE (ECPTNL,CLSRW)        
      IF (KICKOF   .EQ. -1) GO TO 865        
      IF (MCBKGG(6) .NE. 0) GO TO 654        
      DO 652 I = 2,7        
  652 MCBKGG(I) = 0        
      GO TO 656        
  654 MCBKGG(3) = MCBKGG(2)        
  656 CALL WRTTRL (MCBKGG)        
      CALL WRTTRL (TRAIL)        
C        
C     BEGIN EST PROCESSING        
C        
      LEFT = BUFR4 - 1        
      ICC  = NCSTM +  MUSED        
      ALL  = .FALSE.        
      PHASE1 = .FALSE.        
C        
C     READ THE FIRST RECORD OF CASECC INTO CORE.        
C        
      FILE = CASECC        
      CALL GOPEN (CASECC,Z(BUFR1),0)        
      CALL READ (*870,*658,CASECC,IZ(ICC+1),LEFT,EOR,NCC)        
      CALL MESAGE (-8,0,NAME)        
  658 IPLSET = ICC + JPLSET        
      PLASET = IZ(IPLSET)        
      ISTSET = ICC + JSTSET        
      IF (IZ(ISTSET)) 660,670,680        
  660 ALL = .TRUE.        
      GO TO 705        
  670 NONLST = -1        
      GO TO 705        
C        
C     THE USER HAS REQUESTED A PROPER SUBSET OF HIS SET OF ELEMENTS FOR 
C     WHICH HE WANTS STRESS OUTPUT.  FIND THE SET IN OPEN CORE AND      
C     DETERMINE ZERO POINTER AND LENGTH OF THE SET.        
C        
  680 ISYM = ICC + JSYM        
      ISETNO = ISYM + IZ(ISYM) + 1        
      LSET = IZ(ISETNO+1)        
  690 ISET = ISETNO + 2        
      NSET = IZ(ISETNO+1) + ISET - 1        
      IF (IZ(ISETNO) .EQ. IZ(ISTSET)) GO TO 700        
      ISETNO = NSET + 1        
      IF (ISETNO .LT. NCC) GO TO 690        
      ALL = .TRUE.        
  700 IZ(NSET+1) = 2**14 + 1        
  705 CALL CLOSE (CASECC,CLSRW)        
      IF (PLASET .NE. -1) GO TO 706        
      JJ = 1        
      PLFACT(1) = 1.0        
      GO TO 731        
  706 CONTINUE        
C        
C     SEARCH THE MPT FOR THE PLA SET        
C        
      FILE = MPT        
      CALL PRELOC (*860,Z(BUFR1-3),MPT)        
      CALL LOCATE (*895,Z(BUFR1-3),PLANOS,IFLAG)        
C        
C     READ A PLA SET NO.        
C        
  710 CALL READ (*895,*895,MPT,SETNO,1,NEOR,IFLAG)        
      JJ = 0        
  720 CALL READ (*895,*895,MPT,NN,1,NEOR,IFLAG)        
      IF (NN .EQ. -1) GO TO 730        
      JJ = JJ + 1        
      IF (JJ .EQ. 1) PLFACT(1) = FNN        
      GO TO 720        
  730 IF (SETNO .NE. PLASET) GO TO 710        
      NPLALP = JJ        
      PLFACT(2) = 0.0        
      CALL CLOSE (MPT,CLSRW)        
  731 CONTINUE        
C        
C     PROCESS THE EST        
C        
      ESTLTR(1) = ESTL        
      ESTNLT(1) = ESTNL        
      DO 740 I = 2,7        
      ESTLTR(I) = 0        
  740 ESTNLT(I) = 0        
      ASSIGN 820 TO NOSD        
      CALL GOPEN (  EST,Z(BUFR1),0)        
      CALL GOPEN ( ESTL,Z(BUFR2),1)        
      CALL GOPEN (ESTNL,Z(BUFR3),1)        
      FILE = EST        
C        
C     READ THE ELEMENT TYPE.  IF THE ELEMENT TYPE IS ADMISSIBLE TO      
C     PIECEWISE LINEAR ANALYSIS, WRITE IT TWICE.  OTHERWISE GO TO NEXT  
C     RECORD.        
C        
  750 CALL READ (*850,*880,EST,ITYPE,1,NEOR,IFLAG)        
      IF (PLAARY(ITYPE) .EQ. 1) GO TO 755        
      CALL SKPREC (EST,1)        
      GO TO 750        
  755 CALL WRITE (ESTL, ITYPE,1,NEOR)        
      CALL WRITE (ESTNL,ITYPE,1,NEOR)        
C        
C     READ THE EST ENTRY        
C        
  760 IDX  = (ITYPE-1)*INCR        
      NWDS = NE(IDX+12)        
      CALL READ (*870,*840,EST,XECPT,NWDS,NEOR,IFLAG)        
      IF (PLAARY(ITYPE) .EQ. 0) GO TO 820        
      IF (ITYPE .GT. 38) GO TO 820        
C              CROD      CBEAM     CTUBE     CSHEAR    CTWIST        
C                1         2         3         4         5        
      GO TO (   130,      820,      150,      820,      820,        
C              CTRIA1    CTRBSC    CTRPLT    CTRMEM    CONROD        
C                6         7         8          9       10        
     1          160,      820,      820,      170,      130,        
C              CELAS1    CELAS2    CELAS3    CELAS4    CQDPLT        
C                11        12        13        14        15        
     2          820,      820,      820,      820,      820,        
C              CQDMEM    CTRIA2    CQUAD2    CQUAD1    CDAMP1        
C                16        17        18        19        20        
     3          180,      190,      200,      210,      820,        
C              CDAMP2    CDAMP3    CDAMP4    CVISC     CMASS1        
C                21        22        23        24        25        
     4          820,      820,      820,      820,      820,        
C              CMASS2    CMASS3    CMASS4    CONM1     CONM2        
C                26        27        28        29        30        
     5          820,      820,      820,      820,      820,        
C              PLOTEL    REACT     QUAD3     CBAR      CCONE        
C                31        32        33        34        35        
     6          820,      820,      820,      220,      820,        
C              CTRIARG   CTRAPRG   CTORDRG        
C                36        37        38        
     7          820,      820,      820), ITYPE        
C        
C     THE ELEMENT IS STRESS DEPENDENT.  DETERMINE IF STRESS OUTPUT IS   
C     REQUESTED.        
C     AN EXAMPLE... IF WE HAVE IN CASE CONTROL        
C     SET 5 = 1,2,3,98THRU100,4THRU15,81,18,82,90,92        
C     THEN THE WORDS IN CASE CONTROL ARE...        
C       IZ(ISETNO) = 5,12,1,2,3,4,-15,18,81,82,90,92,98,-100 = IZ(NSET) 
C        
  765 IF (ALL) GO TO 800        
      IF (NONLST .EQ. -1) GO TO 760        
      IELID = IECPT(1)        
      I = ISET        
  770 IF (I    .GT. NSET) GO TO 760        
      IF (IZ(I+1) .LT. 0) GO TO 780        
      IF (IELID .EQ. IZ(I)) GO TO 800        
      IF (IELID .LT. IZ(I)) GO TO 760        
      I = I + 1        
      GO TO 790        
  780 IF (IELID.GE.IZ(I) .AND. IELID.LE.IABS(IZ(I+1))) GO TO 800        
      IF (IELID .LT. IZ(I)) GO TO 760        
      I = I + 2        
  790 IF (IZ(I) .GT. 0) GO TO 770        
      ALL = .TRUE.        
      LLLLLL(1) = IZ(ISTSET)        
      LLLLLL(2) = IZ(I)        
      CALL MESAGE (30,92,LLLLLL)        
  800 OUTFIL = ESTNL        
      NNLEL  = NNLEL + 1        
      GO TO 830        
  820 OUTFIL = ESTL        
      NLEL   = NLEL + 1        
  830 CALL WRITE (OUTFIL,XECPT,NWDS,NEOR)        
      GO TO 760        
  840 CALL WRITE (ESTL,0,0,EOR)        
      CALL WRITE (ESTNL,0,0,EOR)        
      GO TO 750        
C        
C     WRAP UP ROUTINE        
C        
  850 CALL CLOSE  (EST,CLSRW)        
      CALL CLOSE  (ESTL,CLSRW)        
      CALL CLOSE  (ESTNL,CLSRW)        
      CALL WRTTRL (ESTLTR)        
      CALL WRTTRL (ESTNLT)        
  865 RETURN        
C        
C     FATAL ERRORS        
C        
  860 CALL MESAGE (-1,FILE,NAME)        
  870 CALL MESAGE (-2,FILE,NAME)        
  880 CALL MESAGE (-3,FILE,NAME)        
  890 CALL MESAGE (-30,87,ITYPE)        
C        
C     UNABLE TO FIND PLFACT CARD IN THE MPT WHICH WAS CHOSEN BY THE USER
C     IN CASECC.        
C        
  895 TRAIL(1) = HMPT        
      TRAIL(2) = NAME(1)        
      CALL MESAGE (-32,PLASET,TRAIL)        
      RETURN        
      END        
