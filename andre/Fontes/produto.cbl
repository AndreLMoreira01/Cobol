       IDENTIFICATION DIVISION.
       PROGRAM-ID.    PRODUTO.
       AUTHOR.        ANDRE.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TABPR ASSIGN TO 'TABPR.ARQ'
                  ORGANIZATION INDEXED
                  ACCESS MODE  DYNAMIC
                  LOCK MODE    AUTOMATIC
                  RECORD KEY   TDES-RECORDK-1
                  FILE STATUS  IS STAT-TABPR.

       DATA DIVISION.
       FILE SECTION.

       FD  TABPR  LABEL RECORD IS STANDARD.

       01  TDES-REGISTR-1.
           03  TDES-RECORDK-1.
               05 TDES-CODIGO-1          PIC  X(10).
           03  TDES-DESC-1             PIC  X(50).
           03  TDES-PRECO-1             PIC  9(03)V99.
           03  TDES-DMAX-1             PIC  9(09)V99.
           03  TDES-ESTOQM-1             PIC  9(09)V99.
           

       WORKING-STORAGE SECTION.
       77  SMALL-FONT                     HANDLE.
       78  EXCEPTION-GRAVAR               VALUE 02.
       78  EXCEPTION-EXCLUIR              VALUE 03.

       01  CAMPOS-W.
           03  STAT-TABPR                PIC  X(02).
               88 VALID-TABPR            VALUE '00' THRU '09'.

           03  CAMPOS-TELA-W.
               05 W-CODIGO-EDIT          PIC  X(60).
               05 W-DESC-EDIT          PIC  ZZ9.
               05 W-PRECO-EDIT          PIC  ZZ9,99.
               05 W-DMAX-EDIT          PIC  ZZ9,99.
               05 W-ESTOQM-EDIT          PIC  ZZ9,99.
               

               05 W-CODIGO         PIC  X(10).
            
       01  CAMPOS-ERRO-ARQUIVO-W.
           03  WS-EXTEND-STATUS           PIC  X(10).
           03  W-FSTATUS                  PIC  X(02).
           03  W-EXTSTAT                  PIC  X(08).
           03  W-ARQUIVO                  PIC  X(150).

       01  CAMPOS-CONTROLE-TELA-GRAFICA.
           03  EVENT-STATUS IS SPECIAL-NAMES EVENT STATUS.
               05 EVENT-TYPE              PIC X(4) COMP-X.
                  88 CA-CMD-CLOSE         VALUE 1.
                  88 CA-CMD-TABCHANGED    VALUE 7.
               05 EVENT-WINDOW-HANDLE     HANDLE OF WINDOW.
               05 EVENT-CONTROL-HANDLE    HANDLE.
               05 EVENT-CONTROL-ID        PIC XX COMP-X.
               05 EVENT-DATA-1            SIGNED-SHORT.
               05 EVENT-DATA-2            SIGNED-LONG.
               05 EVENT-ACTION            PIC X COMP-X.

           03  TECLA-ESCAPE IS SPECIAL-NAMES CRT STATUS
                                          PIC 9(4) VALUE 0.
               88 TECLOU-ESC              VALUE 27.

           03  W-SCREEN-CONTROL IS SPECIAL-NAMES SCREEN CONTROL.
               05 W-ACCEPT-CONTROL        PIC 9.
               05 W-CONTROL-VALUE         PIC 999.
               05 W-CONTROL-HANDLE        USAGE HANDLE.
               05 W-CONTROL-ID            PIC X(2) COMP-X.

       01  JANELA-PROGRAMA                PIC X(10).

           COPY "MAINRTN.MSG".
           COPY "ACUGUI.DEF".

           LINKAGE SECTION.
            01 CODIGO-L PIC 9(003).

       SCREEN SECTION.
       01  TELA-PRINCIPAL.
           03 LABEL       LINE 02 COL 05
                          TITLE "C�digo: "
                          ID 1
                          TRANSPARENT.

           03 ENTRY-FIELD USING W-CODIGO-EDIT
                          LINE 02
                          COL 30
                          3-D
                          BOXED
                          AUTO
                          ID 2
                          FONT SMALL-FONT.

           03 LABEL       LINE 06 COL 05
                          TITLE "Descricao: "
                          ID 6
                          TRANSPARENT.

           03 ENTRY-FIELD USING W-DESC-EDIT
                          SIZE 60
                          LINE 06
                          COL 30
                          3-D
                          BOXED
                          AUTO
                          ID 7
                          FONT SMALL-FONT.

           03 LABEL       LINE 08 COL 05
                          TITLE "Preco: "
                          ID 8
                          TRANSPARENT.
           
           03 ENTRY-FIELD USING W-PRECO-EDIT
                          LINE 09
                          COL 30
                          3-D
                          BOXED
                          AUTO
                          ID 9
                          FONT SMALL-FONT.

           03 LABEL       LINE 10 COL 05
                          TITLE "Desconto Maximo: "
                          ID 10
                          TRANSPARENT.

           03 ENTRY-FIELD USING W-DMAX-EDIT
                          LINE 11
                          COL 30
                          3-D
                          BOXED
                          AUTO
                          ID 11
                          FONT SMALL-FONT.

             03 LABEL     LINE 12 COL 05
                          TITLE "Estoque Disponivel: "
                          ID 10
                          TRANSPARENT.

           03 ENTRY-FIELD USING W-ESTOQM-EDIT
                          LINE 13
                          COL 30
                          3-D
                          BOXED
                          AUTO
                          ID 11
                          FONT SMALL-FONT.

            03 PUSH-BUTTON TITLE "&Gravar"
                          LINE 15,5
                          COL 05
                          SIZE 12
                          ID 14
                          EXCEPTION-VALUE EXCEPTION-GRAVAR.


       PROCEDURE DIVISION USING CODIGO-L.
       INICIO.
           OPEN I-O TABPR
           IF STAT-TABPR = '35'
              PERFORM PERGUNTA-INICIALIZA
              OPEN OUTPUT TABPR
              CLOSE TABPR
              OPEN I-O TABPR.
           IF NOT VALID-TABPR
              PERFORM ERRO-ARQUIVO.

           ACCEPT SMALL-FONT FROM STANDARD OBJECT "SMALL-FONT".
           
           DISPLAY FLOATING GRAPHICAL WINDOW
                            SIZE 95 LINES 16,5
                            CONTROL FONT SMALL-FONT
                            COLOR 257
                            TITLE "Manuten��o dE Tabela"
                            NO SCROLL
                            SYSTEM MENU
                            AUTO-RESIZE
                            BACKGROUND-LOW
                            HANDLE JANELA-PROGRAMA.

           MOVE CODIGO-L TO W-CODIGO-EDIT

           DISPLAY TELA-PRINCIPAL.

           PERFORM TEST AFTER UNTIL TECLOU-ESC
              ACCEPT TELA-PRINCIPAL
                     ON EXCEPTION PERFORM TRATA-EXCEPTION-TELA-PRINCIPAL
              END-ACCEPT
           END-PERFORM.

       FIM.
           CLOSE TABPR.

           CLOSE WINDOW JANELA-PROGRAMA.

           EXIT PROGRAM
           STOP RUN.

       TRATA-EXCEPTION-TELA-PRINCIPAL.
           IF EVENT-TYPE = CMD-CLOSE
              SET TECLOU-ESC TO TRUE
              EXIT PARAGRAPH.

           EVALUATE TECLA-ESCAPE
             WHEN EXCEPTION-GRAVAR
                  PERFORM ROTINA-GRAVAR
             WHEN EXCEPTION-EXCLUIR
                  PERFORM ROTINA-EXCLUIR
           END-EVALUATE.

       ROTINA-GRAVAR.
           MOVE W-CODIGO-EDIT TO W-CODIGO
           IF W-CODIGO = 0
              INITIALIZE CA-MESSAGE-LINK
              MOVE 'Tabela inv�lida.' TO CA-MESSAGE-1
              PERFORM MOSTRA-MSG-ERRO
              MOVE 4 TO W-ACCEPT-CONTROL
              MOVE 2 TO W-CONTROL-ID |* id do campo onde quero posicionar o cursor
              EXIT PARAGRAPH.

           INITIALIZE             TDES-REGISTR-1
           MOVE W-CODIGO-EDIT TO TDES-CODIGO-1
           READ TABPR
           IF STAT-TABPR = '23'
              INITIALIZE             TDES-REGISTR-1
              MOVE W-CODIGO-EDIT TO TDES-CODIGO-1
           ELSE
              IF NOT VALID-TABPR
                 PERFORM ERRO-ARQUIVO.

           MOVE W-DESC-EDIT      TO TDES-DESC-1
           MOVE W-DMAX-EDIT TO TDES-DMAX-1
           MOVE W-PRECO-EDIT TO TDES-PRECO-1

           INITIALIZE CA-MESSAGE-LINK

           IF STAT-TABPR = '23'
              WRITE TDES-REGISTR-1
              MOVE 'Registro gravado.' TO CA-MESSAGE-1
           ELSE
              REWRITE TDES-REGISTR-1
              MOVE 'Registro regravado.' TO CA-MESSAGE-1
           END-IF.

           IF NOT VALID-TABPR
              PERFORM ERRO-ARQUIVO.

           PERFORM MOSTRA-MSG-MENSAGEM.

       ROTINA-EXCLUIR.
           INITIALIZE             TDES-REGISTR-1
           MOVE W-CODIGO-EDIT TO TDES-CODIGO-1
           READ TABPR
           IF STAT-TABPR = '23'
              INITIALIZE CA-MESSAGE-LINK
              MOVE 'Funcion�rio n�o cadastrado.' TO CA-MESSAGE-1
              PERFORM MOSTRA-MSG-MENSAGEM
              EXIT PARAGRAPH
           ELSE
              IF NOT VALID-TABPR
                 PERFORM ERRO-ARQUIVO.

           INITIALIZE CA-MESSAGE-LINK
           MOVE 3 TO CA-MESSAGE-TYPE
           MOVE 22 TO CA-MESSAGE-RESP
           MOVE 'Deseja realmente excluir o registro?' TO CA-MESSAGE-1
           CALL 'CAMESSAG'
           CANCEL 'CAMESSAG'
           IF CA-MESSAGE-RESP = 1
              DELETE TABPR
              IF NOT VALID-TABPR
                 PERFORM ERRO-ARQUIVO
              END-IF
              INITIALIZE CA-MESSAGE-LINK
              MOVE 'Registro exclu�do.' TO CA-MESSAGE-1
              PERFORM MOSTRA-MSG-MENSAGEM

              INITIALIZE CAMPOS-TELA-W
              DISPLAY TELA-PRINCIPAL
           END-IF.

       EVENTO-BTN-LER-ARQUIVO.
           IF EVENT-TYPE <> CMD-GOTO AND CMD-CLICKED
              EXIT PARAGRAPH.

           INITIALIZE        TDES-REGISTR-1
           MOVE W-CODIGO-EDIT TO TDES-CODIGO-1
           READ TABPR
           IF STAT-TABPR = '99'
              INITIALIZE CA-MESSAGE-LINK
              MOVE 'Registro bloqueado.' TO CA-MESSAGE-1
              PERFORM MOSTRA-MSG-ATENCAO
              EXIT PARAGRAPH.
           IF STAT-TABPR = '23'
              INITIALIZE CA-MESSAGE-LINK
              MOVE 'Tabela n�o cadastrado.' TO CA-MESSAGE-1
              PERFORM MOSTRA-MSG-MENSAGEM
           ELSE
              IF NOT VALID-TABPR
                 PERFORM ERRO-ARQUIVO.

           MOVE TDES-DESC-1 TO W-DESC-EDIT
           MOVE TDES-PRECO-1 TO W-PRECO-EDIT
           MOVE TDES-DMAX-1 TO W-DMAX-EDIT

           DISPLAY TELA-PRINCIPAL.

       ERRO-ARQUIVO.
           CALL "C$RERR" USING WS-EXTEND-STATUS
           MOVE WS-EXTEND-STATUS(1:2) TO W-FSTATUS
           MOVE WS-EXTEND-STATUS(3:)  TO W-EXTSTAT
           CALL "C$RERRNAME" USING W-ARQUIVO.

           INITIALIZE CA-MESSAGE-LINK
           MOVE W-FSTATUS TO CA-MESSAGE-ID CONVERT
           MOVE W-ARQUIVO TO CA-ERR-FILE
           MOVE SPACES    TO CA-ERR-BUF
           MOVE 1 TO CA-MESSAGE-TYPE CA-MESSAGE-RESP
           CALL "CAMESSAG"
           CANCEL "CAMESSAG".

           PERFORM FIM.

       MOSTRA-MSG-ERRO.
           MOVE 1 TO CA-MESSAGE-TYPE CA-MESSAGE-RESP
           CALL "CAMESSAG"
           CANCEL "CAMESSAG".

       MOSTRA-MSG-ATENCAO.
           MOVE 2 TO CA-MESSAGE-TYPE
           MOVE 1 TO CA-MESSAGE-RESP
           CALL "CAMESSAG"
           CANCEL "CAMESSAG".

       MOSTRA-MSG-MENSAGEM.
           MOVE 3 TO CA-MESSAGE-TYPE
           MOVE 1 TO CA-MESSAGE-RESP
           CALL "CAMESSAG"
           CANCEL "CAMESSAG".

       PERGUNTA-INICIALIZA.
           CALL "C$RERRNAME" USING W-ARQUIVO.

           INITIALIZE CA-MESSAGE-LINK
           MOVE 'Deseja inicializar o arquivo' TO CA-MESSAGE-1
           MOVE W-ARQUIVO TO CA-MESSAGE-2
           MOVE 2 TO CA-MESSAGE-TYPE
           MOVE 22 TO CA-MESSAGE-RESP
           CALL 'CAMESSAG'
           CANCEL 'CAMESSAG'
           IF CA-MESSAGE-RESP = 2
              PERFORM ERRO-ARQUIVO.