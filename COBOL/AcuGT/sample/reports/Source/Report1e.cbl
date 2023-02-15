      *{Bench}prg-comment
      * Report1e.cbl
      * Report1e.cbl is generated from C:\Acucorp\Acucbl720\AcuGT\sample\reports\Report1e.Psf
      *{Bench}end
       IDENTIFICATION              DIVISION.
      *{Bench}prgid
       PROGRAM-ID. Report1e.
       AUTHOR. bob.
       DATE-WRITTEN. Friday, May 12, 2006 2:53:21 PM.
       REMARKS. 
           A Report with 2  Breakpoints, Sales-State and Sales-Branch-No,
           marked by the inclusion of both Group Headers and 
           Group Footers. 
           * The Group Footer for Sales-Branch-No contains TOTALS for 
           the Branch for Heavy-Equipment-Sales and Supplies-Sales
           * The Group Footer for Sales-State contains TOTALS for the 
           State for Heavy-Equipment-Sales and Supplies-Sales
           * Note the usage of the Group Header After-Print paragraph to 
           save the Group Footer title.
           * Note the usage of the Detail Before-Print paragraph to perform 
           the ADD operation, accumulating totals for Branch, and State
           Footers
           * Note the usage of the Total-Field Before-Print paragraph to 
           move the numeric Total field into a Formatted field for printing.
      *{Bench}end

       ENVIRONMENT                 DIVISION.
       CONFIGURATION               SECTION.
       SPECIAL-NAMES.
      *{Bench}activex-def
      *{Bench}end
      *{Bench}decimal-point
      *{Bench}end
       INPUT-OUTPUT                SECTION.
       FILE-CONTROL.
      *{Bench}file-control
       COPY "Salesdata.sl".
      * print sl
       SELECT PRINTF
              ASSIGN TO PRINT PTR-DEV-NAME
              FILE   STATUS   IS STAT-PRINTF.
      *{Bench}end
       DATA                        DIVISION.
       FILE                        SECTION.
      *{Bench}file
       COPY "Salesdata.fd".
      * print fd
       FD PRINTF    LABEL   RECORD  OMITTED.
       01 PRINTF-R.
          05 PRINTF-01              PIC X OCCURS 1024 TIMES.
      *{Bench}end
       WORKING-STORAGE             SECTION.
      *{Bench}acu-def
       COPY "acugui.def".
       COPY "acucobol.def".
       COPY "crtvars.def".
       COPY "acureport.def".
       COPY "showmsg.def".
      *{Bench}end

      *{Bench}copy-working
       COPY "Report1e.wrk".
      *{Bench}end
       LINKAGE                     SECTION.
      *{Bench}linkage
      *{Bench}end
       SCREEN                      SECTION.
      *{Bench}copy-screen
       COPY "Report1e.scr".
      *{Bench}end

      *{Bench}linkpara
       PROCEDURE DIVISION.
      *{Bench}end
      *{Bench}declarative
       DECLARATIVES.
       INPUT-ERROR SECTION.
           USE AFTER STANDARD ERROR PROCEDURE ON INPUT.
       0100-DECL.
           EXIT.
       I-O-ERROR SECTION.
           USE AFTER STANDARD ERROR PROCEDURE ON I-O.
       0200-DECL.
           EXIT.
       OUTPUT-ERROR SECTION.
           USE AFTER STANDARD ERROR PROCEDURE ON OUTPUT.
       0300-DECL.
           EXIT.
       Salesdata-ERROR SECTION.
           USE AFTER STANDARD EXCEPTION PROCEDURE ON Salesdata.
       END DECLARATIVES.
      *{Bench}end

       Acu-Main-Logic.
      *{Bench}entry-befprg
      *    Before-Program
      *{Bench}end
           PERFORM Acu-Initial-Routine
      *     Acu-Report1e-PRINT-TOFILE writes the HTML file to disk
      *     PERFORM Acu-Report1e-PRINT-TOFILE

      *     Acu-Report1e-PRINT writes and PRINTs the HTML file
      *     PERFORM Acu-Report1e-PRINT

      *     Acu-Report1e-PREVIEW writes and PREVIEWs the HTML file
           PERFORM Acu-Report1e-Preview
      * run main screen
      *{Bench}run-mainscr
      *{Bench}end
           PERFORM Acu-Exit-Rtn
           .

      *{Bench}copy-procedure
       COPY "showmsg.cpy".
       COPY "Report1e.prd".
       COPY "Report1e.evt".
       COPY "Report1e.rpt".
      *{Bench}end



      *{Bench}Report1e-masterprintpara
       Acu-RPT-Report1e-MASTER-PRINT-LOOP.
      *{Bench}end
      *
           PERFORM Before-Master-Print-Loop.
           PERFORM UNTIL NOT Valid-Salesdata
             PERFORM Acu-RPT-Report1e-DO-PRINT-RTN
             PERFORM End-Master-Print-Loop
           END-PERFORM
           .

