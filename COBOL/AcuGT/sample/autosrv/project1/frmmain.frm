VERSION 5.00
Begin VB.Form frmMainWindow 
   Caption         =   "Automation Server Sample"
   ClientHeight    =   4935
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4725
   LinkTopic       =   "Form1"
   ScaleHeight     =   4935
   ScaleWidth      =   4725
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkDebug 
      Caption         =   "Run with ACUCOBOL-GT Debugger"
      Height          =   495
      Left            =   120
      TabIndex        =   11
      Top             =   3720
      Width           =   2415
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "E&xit"
      Height          =   615
      Left            =   2880
      TabIndex        =   10
      Top             =   3840
      Width           =   1575
   End
   Begin VB.CommandButton CallCobol 
      Caption         =   "Call Cobol"
      Height          =   615
      Left            =   1320
      TabIndex        =   0
      Top             =   240
      Width           =   2055
   End
   Begin VB.Label Label1 
      Caption         =   " "
      Height          =   255
      Left            =   2280
      TabIndex        =   9
      Top             =   1680
      Width           =   2175
   End
   Begin VB.Label Label2 
      Height          =   255
      Left            =   2280
      TabIndex        =   8
      Top             =   2040
      Width           =   2175
   End
   Begin VB.Label Label3 
      Height          =   255
      Left            =   2280
      TabIndex        =   7
      Top             =   2400
      Width           =   2175
   End
   Begin VB.Label Label4 
      Height          =   255
      Left            =   2280
      TabIndex        =   6
      Top             =   2760
      Width           =   2175
   End
   Begin VB.Label Label8 
      Caption         =   "Float"
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   2760
      Width           =   1935
   End
   Begin VB.Label Label7 
      Caption         =   "Long Number"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   2400
      Width           =   1935
   End
   Begin VB.Label Label6 
      Caption         =   "String"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   2040
      Width           =   1935
   End
   Begin VB.Label Label5 
      Caption         =   "Number"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   1680
      Width           =   1935
   End
   Begin VB.Label Label9 
      Caption         =   "Before COBOL Call"
      Height          =   255
      Left            =   1560
      TabIndex        =   1
      Top             =   1200
      Width           =   1575
   End
End
Attribute VB_Name = "frmMainWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Cobol test variables
Public testNum As Variant
Public testStr As Variant
Public testLongNum As Variant
Public testfloatNum As Variant

Private Sub CallCobol_Click()
    Dim CobolApp As Object
    Set CobolApp = New AcuGT

    ' Set up config and error files
    If chkDebug.Value = 1 Then
        strCommandLine = _
        "-c ..\sample\autosrv\project1\acuvb.cfg -dle ..\sample\autosrv\project1\acuerr.log"
    Else
        strCommandLine = _
        "-c ..\sample\autosrv\project1\acuvb.cfg -le ..\sample\autosrv\project1\acuerr.log"
    End If
    
    '
    ' Call COBOL Program
    '
    
    On Error GoTo ErrHandler
    
    CobolApp.Initialize strCommandLine
     
    returnValue = CobolApp.Call("astest", testNum, testStr, testLongNum, testfloatNum)
    
    Label1.Caption = testNum
    Label2.Caption = testStr
    Label3.Caption = testLongNum
    Label4.Caption = testfloatNum
    Label9.Caption = "After Cobol Call"
 
    
    CobolApp.Shutdown

    Exit Sub

ErrHandler:
    myval = MsgBox(Err.Description, vbOKOnly, "Call not successful")

End Sub


Private Sub cmdExit_Click()
    End
End Sub

Private Sub Form_Initialize()

' Set initial values
testNum = 123
testStr = "qwertyuiopasdfghjklzxcvbnm"
testLongNum = 1234567890
testfloatNum = 23.4
Label1.Caption = testNum
Label2.Caption = testStr
Label3.Caption = testLongNum
Label4.Caption = testfloatNum
End Sub


