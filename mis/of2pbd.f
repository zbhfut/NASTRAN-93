      BLOCK DATA OF2PBD        
COF2PBD        
C        
C     C ARRAY FOR COMPLEX STRESSES SORT1        
C        
      INTEGER        C1,C21,C41,C61,C81        
      COMMON /OFPB2/ C1(240),C21(240),C41(240),C61(240),C81(240)        
C        
C                 IX,L1,L2,L3,L4,L5         , IX,L1,L2,L3,L4,L5        
C        
C                 REAL/IMAG  L3=125         , MAG/PHASE  L3=126        
C                     (L1 IS SET FOR FREQ ALWASYS = 104)        
C        
      DATA C1  /  473,104,136,125,  0,165   , 483,104,136,126,  0,165   
     2          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     3          , 473,104,144,125,  0,165   , 483,104,144,126,  0,165   
     4          , 473,104,137,125,  0,166   , 483,104,137,126,  0,166   
     5          , 473,104,145,125,  0,166   , 483,104,145,126,  0,166   
     6          , 515,104,139,125,  0,168   , 540,104,139,126,  0,168   
     7          , 515,104,138,125,  0,168   , 540,104,138,126,  0,168   
     8          , 515,104,143,125,  0,168   , 540,104,143,126,  0,168   
     9          , 448,104,142,125,  0,169   , 461,104,142,126,  0,169   
     O          , 473,104,131,125,  0,165   , 483,104,131,126,  0,165   
     1          , 493,104,128,125,  0,171   , 504,104,128,126,  0,171   
     2          , 493,104,129,125,  0,171   , 504,104,129,126,  0,171   
     3          , 493,104,130,125,  0,171   , 504,104,130,126,  0,171   
     4          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     5          , 515,104,133,125,  0,168   , 540,104,133,126,  0,168   
     6          , 448,104,132,125,  0,169   , 461,104,132,126,  0,169   
     7          , 515,104,140,125,  0,168   , 540,104,140,126,  0,168   
     8          , 515,104,135,125,  0,168   , 540,104,135,126,  0,168   
     9          , 515,104,134,125,  0,168   , 540,104,134,126,  0,168   
     O          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0 / 
      DATA C21 /    0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     2          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     3          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     4          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     5          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     6          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     7          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     8          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     9          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     O          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     1          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     2          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     3          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     4          , 565,104,127,125,  0,164   , 595,104,127,126,  0,164   
     5          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     6          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     7          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     8          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     9          ,1162,104,222,125,  0,219   ,1197,104,222,126,  0,219   
     O          ,1162,104,224,125,  0,219   ,1197,104,224,126,  0,219 / 
      DATA C41 / 1162,104,226,125,  0,219   ,1197,104,226,126,  0,219   
     2          ,1162,104,228,125,  0,219   ,1197,104,228,126,  0,219   
     3          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     4          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     5          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     6          ,   0,  0,  0, -1,  0,  0   ,   0,  0,  0, -1,  0,  0   
     7          ,1468,104,236,125,  0,250   ,1480,104,236,126,  0,250   
     8          ,1254,104,237,125,  0,241   ,1276,104,237,126,  0,241   
     9          ,4154,104,238,125,  0,451   ,4180,104,238,126,  0,451   
     O          , 668,104,239,125,  0,247   , 683,104,239,126,  0,247   
     1          ,1396,104,240,125,  0,244   ,1412,104,240,126,  0,244   
     2          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     3          ,1254,104,266,125,  0,264   ,1276,104,266,126,  0,264   
     4          ,1254,104,267,125,  0,264   ,1276,104,267,126,  0,264   
     5          ,1254,104,268,125,  0,264   ,1276,104,268,126,  0,264   
     6          ,1254,104,269,125,  0,264   ,1276,104,269,126,  0,264   
     7          ,1254,104,270,125,  0,264   ,1276,104,270,126,  0,264   
     8          ,1254,104,288,125,  0,264   ,1276,104,288,126,  0,264   
     9          ,1254,104,289,125,  0,264   ,1276,104,289,126,  0,264   
     O          ,1254,104,290,125,  0,264   ,1276,104,290,126,  0,264  /
      DATA C61 / 1254,104,291,125,  0,264   ,1276,104,291,126,  0,264   
     2          , 448,104,305,125,  0,169   , 461,104,305,126,  0,169   
     3          , 448,104,307,125,  0,324   , 461,104,307,126,  0,324   
     4          , 515,104,448,125,  0,449   , 540,104,448,126,  0,449   
     5          ,1852,104,331,125,329,332   ,1852,104,331,126,329,332   
     6          ,1852,104,331,125,329,332   ,1852,104,331,126,329,332   
     7          ,1921,104,331,125,329,332   ,1921,104,331,126,329,332   
     8          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     9          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     O          ,2657,104,393,125,  0,348   ,2657,104,393,126,  0,348   
     1          ,2756,104,395,125,  0,348   ,2756,104,395,126,  0,348   
     2          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     3          , 448,104,454,125,  0,169   , 461,104,454,126,  0,169   
     4          , 515,104,456,125,  0,168   , 540,104,456,126,  0,168   
     5          , 515,104,458,125,  0,168   , 540,104,458,126,  0,168   
     6          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     7          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     8          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     9          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     O          ,3313,104,412,125,  0,413   ,3313,104,412,126,  0,413 / 
      DATA C81 / 3906,104,426,125,  0,164   ,3601,104,426,126,  0,164   
     2          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     3          , 515,104,466,125,  0,449   , 540,104,466,126,  0,449   
     4          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     5          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     6          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     7          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     8          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     9          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     O          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     1          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     2          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     3          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     4          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     5          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     6          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     7          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     8          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     9          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0   
     O          ,   0,  0,  0,  0,  0,  0   ,   0,  0,  0,  0,  0,  0 / 
      END        