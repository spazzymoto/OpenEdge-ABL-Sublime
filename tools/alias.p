DEFINE STREAM sAlias.

DEFINE VARIABLE cAliasFile          AS LONGCHAR    NO-UNDO INITIAL "":U.           
DEFINE VARIABLE cLine               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPreviousTabTrigger AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTabTrigger         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cContent            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTemplate           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cToolsDirectory     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cBuildDirectory     AS CHARACTER   NO-UNDO.

ASSIGN
  cToolsDirectory = REPLACE(THIS-PROCEDURE:FILENAME, "~\":U, "/":U)
  ENTRY(NUM-ENTRIES(cToolsDirectory, "/":U), cToolsDirectory, "/":U) = "":U

  cBuildDirectory = cToolsDirectory
  ENTRY(NUM-ENTRIES(cBuildDirectory, "/":U) - 1, cBuildDirectory, "/":U) = "build":U

  cTemplate = "<snippet>~n  <content><![CDATA[~n&1~n$0~n]]></content>~n  <tabTrigger>&2</tabTrigger>~n  <scope>source.abl</scope>~n</snippet>":U
  .

INPUT STREAM sAlias FROM VALUE(cToolsDirectory + "p4gl.als":U).

REPEAT:
  IMPORT STREAM sAlias UNFORMATTED cLine.
  
  cAliasFile = "":U.
   
  IF SUBSTRING(cLine, 1, 1) <> " ":U 
  THEN
  DO:
    cTabTrigger = ENTRY(1, cLine, " ":U).
    cContent    = SUBSTRING(cLine, LENGTH(cTabTrigger) + 2).
  END.
  ELSE
    cContent = cContent + cLine.
  
  
  IF cTabTrigger <> cPreviousTabTrigger 
  THEN
  DO:
    cAliasFile = SUBSTITUTE(cTemplate, REPLACE(cContent, "%\c":U, "$~{1~}":U), LC(cTabTrigger)).
    COPY-LOB FROM cAliasFile TO FILE (cBuildDirectory + LC(cTabTrigger) + ".sublime-snippet").
    cPreviousTabTrigger = cTabTrigger.
  END.
END.
  
FINALLY:
  INPUT STREAM sAlias CLOSE.
END FINALLY.

