DEFINE STREAM sKeywords.

DEFINE TEMP-TABLE ttKeywords NO-UNDO
  FIELD cKeyword  AS CHARACTER
  FIELD cRegex    AS CHARACTER
  FIELD iLength   AS INTEGER
  INDEX idx-length iLength .

DEFINE VARIABLE cOutput         AS LONGCHAR    NO-UNDO INITIAL "":U.           
           
DEFINE VARIABLE cLine             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cKeyword          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cBaseKeyword      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cKeywordRegex     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cToolsDirectory   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iKeyword          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iBaseKeyword      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER     NO-UNDO.

ASSIGN
  cToolsDirectory = REPLACE(THIS-PROCEDURE:FILENAME, "~\":U, "/":U)
  ENTRY(NUM-ENTRIES(cToolsDirectory, "/":U), cToolsDirectory, "/":U) = "":U
  .

INPUT STREAM sKeywords FROM VALUE(cToolsDirectory + "keywords.csv":U).

REPEAT:
  IMPORT STREAM sKeywords UNFORMATTED cLine.
   
  ASSIGN
    cLine         = TRIM(cLine)
    cKeyword      = ENTRY(1,cLine, " ":U)
    cBaseKeyword  = IF NUM-ENTRIES(cLine, " ":U) > 1 THEN ENTRY(2,cLine, " ":U) ELSE "":U
    iKeyword      = LENGTH(cKeyword)
    iBaseKeyword  = LENGTH(cBaseKeyword) + 1
    .
     
  IF cBaseKeyword <> "":U 
  THEN
  DO:
    ASSIGN
      cKeywordRegex = CAPS(cBaseKeyword).
      
    DO i = iBaseKeyword TO iKeyword:
      cKeywordRegex = cKeywordRegex + SUBSTRING(cKeyword, i, 1) + "?":U. 
    END.
    
  END.
  ELSE 
    cKeywordRegex = CAPS(cKeyword).
    
  CREATE ttKeywords.
  ASSIGN
    ttKeywords.cKeyword = cKeyword
    ttKeywords.cRegex   = cKeywordRegex
    ttKeywords.iLength  = LENGTH(cKeyword)
    .
END.

FOR EACH ttKeywords
  BY ttKeywords.iLength DESCENDING:            
  cOutput = cOutput + (IF cOutput = "":U THEN "":U ELSE "|":U) + ttKeywords.cRegex.
END.

  
COPY-LOB FROM cOutput TO FILE cToolsDirectory + "keywords.regex":U.

FINALLY:
  INPUT STREAM sKeywords CLOSE.
END FINALLY.
