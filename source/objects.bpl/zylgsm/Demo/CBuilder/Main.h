//---------------------------------------------------------------------------

#ifndef MainH
#define MainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZylGSM.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TMemo *Memo;
        TButton *btnOpen;
        TEdit *txtNo;
        TButton *btnSendStr;
        TButton *btnClose;
        TListBox *lstPort;
        TListBox *lstBaudRate;
        TButton *btnDial;
        TButton *btnAnswer;
        TButton *btnSendSMSText;
        TMemo *txtMessage;
        TButton *btnTerminate;
        TButton *btnSendSMSPDU;
        TZylGSM *ZylGSM;
        void __fastcall ZylGSMConnect(TObject *Sender, TCommPort Port);
        void __fastcall ZylGSMDisconnect(TObject *Sender, TCommPort Port);
        void __fastcall ZylGSMReceive(TObject *Sender, AnsiString Buffer);
        void __fastcall ZylGSMRing(TObject *Sender,
          AnsiString CallerNumber);
        void __fastcall btnOpenClick(TObject *Sender);
        void __fastcall btnCloseClick(TObject *Sender);
        void __fastcall btnDialClick(TObject *Sender);
        void __fastcall btnSendSMSTextClick(TObject *Sender);
        void __fastcall btnAnswerClick(TObject *Sender);
        void __fastcall btnSendSMSPDUClick(TObject *Sender);
        void __fastcall btnTerminateClick(TObject *Sender);
        void __fastcall btnSendStrClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
