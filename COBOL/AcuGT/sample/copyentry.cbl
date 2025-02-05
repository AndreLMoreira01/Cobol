      *{Bench}prg-comment
      * copyentry.cbl
      * copyentry.cbl is generated from C:\Users\Usuario\Documents\Acu-Exemplos\copyandpaste\copyentry.Psf
      *{Bench}end
       IDENTIFICATION              DIVISION.
      *{Bench}prgid
       PROGRAM-ID. copyentry.
       AUTHOR. Usuario.
       DATE-WRITTEN. ter�a-feira, 5 de abril de 2011 16:52:30.
       REMARKS.
      *{Bench}end
       ENVIRONMENT                 DIVISION.
       CONFIGURATION               SECTION.
       SPECIAL-NAMES.
      *{Bench}activex-def
      *{Bench}end
      *{Bench}decimal-point
           DECIMAL-POINT IS COMMA.
      *{Bench}end
       INPUT-OUTPUT                SECTION.
       FILE-CONTROL.
      *{Bench}file-control
      *{Bench}end
       DATA                        DIVISION.
       FILE                        SECTION.
      *{Bench}file
      *{Bench}end
       WORKING-STORAGE             SECTION.
      *{Bench}acu-def
       COPY "acugui.def".
       COPY "acucobol.def".
       COPY "crtvars.def".
      *COPY "showmsg.def".
      *{Bench}end

      *{Bench}copy-working
       77 Quit-Mode-Flag PIC S9(5) COMP-4 VALUE 0. 
       77 Key-Status IS SPECIAL-NAMES CRT STATUS PIC 9(4) VALUE 0.
           88 Exit-Pushed VALUE 27.
           88 Message-Received VALUE 95.
           88 Event-Occurred VALUE 96.
           88 Screen-No-Input-Field VALUE 97.
           88 Screen-Time-Out VALUE 99.
      * property-defined variable

      * user-defined variable
       77 tela-Handle
                  USAGE IS HANDLE OF WINDOW.
       77 tela-Ef-1-Value  PIC  X(30).
       77 tela-Ef-2-Value  PIC  X(30).

      *{Bench}end
       LINKAGE                     SECTION.
      *{Bench}linkage
      *{Bench}end
       SCREEN                      SECTION.
      *{Bench}copy-screen
       01 tela.
           03 tela-Ef-1, Entry-Field, 
              COL 16,00, LINE 4,50, LINES 3,00 CELLS, SIZE 19,00 CELLS, 
              3-D, ID IS 1, VALUE tela-Ef-1-Value.
           03 tela-Ef-2, Entry-Field, 
              COL 16,00, LINE 9,50, LINES 3,00 CELLS, SIZE 19,00 CELLS, 
              3-D, ID IS 2, VALUE tela-Ef-2-Value.
           03 tela-Pb-2, Push-Button, 
              COL 16,00, LINE 17,00, LINES 3,00 CELLS, 
              SIZE 18,00 CELLS, 
              EXCEPTION-VALUE 27, ID IS 4, SELF-ACT, 
              TITLE "Sair".

      *{Bench}end

      *{Bench}linkpara
       PROCEDURE DIVISION.
      *{Bench}end
      *{Bench}declarative
      *{Bench}end

       Acu-Main-Logic.
      *{Bench}entry-befprg
      *    Before-Program
      *{Bench}end
           PERFORM Acu-Initial-Routine
      * run main screen
      *{Bench}run-mainscr
           PERFORM Acu-tela-Routine
      *{Bench}end
           PERFORM Acu-Exit-Rtn
           .

      *{Bench}copy-procedure
      *COPY "showmsg.cpy".

       Acu-Initial-Routine.
      *    Before-Init
      * get system information
           ACCEPT System-Information FROM System-Info
      * get terminal information
           ACCEPT Terminal-Abilities FROM Terminal-Info
      *    After-Init
           .

       Acu-Exit-Rtn.
      *    After-Program
           EXIT PROGRAM
           STOP RUN
           .

       Acu-tela-Routine.
      *    Before-Routine
           PERFORM Acu-tela-Scrn
           PERFORM Acu-tela-Proc
      *    After-Routine
           .

       Acu-tela-Scrn.
           PERFORM Acu-tela-Create-Win
           PERFORM Acu-tela-Init-Data
           .

       Acu-tela-Create-Win.
      *    Before-Create
      * display screen
              DISPLAY Standard GRAPHICAL WINDOW
                 LINES 23,00, SIZE 48,00, CELL HEIGHT 10, 
                 CELL WIDTH 10, AUTO-MINIMIZE, COLOR IS 65793, 
                 LABEL-OFFSET 0, LINK TO THREAD, MODELESS, NO SCROLL, 
                 WITH SYSTEM MENU, 
                 TITLE "COPY/CUT/REPLACE", TITLE-BAR, NO WRAP, 
                 EVENT PROCEDURE tela-Event-Proc, 
                 HANDLE IS tela-Handle
      * toolbar
           DISPLAY tela UPON tela-Handle
      *    After-Create
           .

       Acu-tela-Init-Data.
      *    Before-Initdata
           PERFORM tela-Aft-Initdata
           .
      * tela
       Acu-tela-Proc.
           PERFORM UNTIL Exit-Pushed
              ACCEPT tela  
                 ON EXCEPTION PERFORM Acu-tela-Evaluate-Func
              END-ACCEPT
           END-PERFORM
           DESTROY tela-Handle
           INITIALIZE Key-Status
           .

      * tela
       Acu-tela-Evaluate-Func.
           EVALUATE TRUE
              WHEN Exit-Pushed
                 PERFORM Acu-tela-Exit
              WHEN Event-Occurred
                 IF Event-Type = Cmd-Close
                    PERFORM Acu-tela-Exit
                 END-IF
      * tela-Pb-2 Link To
              WHEN Key-Status = 27
                 PERFORM Acu-tela-Exit
           END-EVALUATE
           PERFORM tela-Link
           MOVE 1 TO Accept-Control
           . 

       Acu-tela-Exit.
           SET Exit-Pushed TO TRUE
           .



       Acu-tela-Event-Extra.
           EVALUATE Event-Type
           WHEN Msg-Close
              PERFORM Acu-tela-Msg-Close
           END-EVALUATE
           .

       Acu-tela-Msg-Close.
           ACCEPT Quit-Mode-Flag FROM ENVIRONMENT "QUIT_MODE"
           IF Quit-Mode-Flag = ZERO
              PERFORM Acu-tela-Exit
              PERFORM Acu-Exit-Rtn
           END-IF
           .

       tela-Event-Proc.
      * 
           PERFORM Acu-tela-Event-Extra
           .
      ***   start event editor code   ***
      *
       tela-Aft-Initdata.
           set environment "KEYSTROKE" to "Exception=1001 ^X"
                           "KEYSTROKE" to "Exception=1002 ^C"
                           "KEYSTROKE" to "Exception=1003 ^V"    
                           "KEYSTROKE" to "Exception=1004 ^Z"    
           set exception values 1001 to cut-selection
           set exception values 1002 to copy-selection
           set exception values 1003 to paste-selection
           set exception values 1004 to undo
          
 
           .
      *
       tela-Link.
           .

       

      *{Bench}end
       REPORT-COMPOSER SECTION.
