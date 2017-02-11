//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZylGSM"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ZylGSMConnect(TObject *Sender, TCommPort Port)
{
  Memo->Lines->Add("Connected to " + ZylGSM->CommPortToString(Port));        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ZylGSMDisconnect(TObject *Sender, TCommPort Port)
{
  Memo->Lines->Add("Disconnected from " + ZylGSM->CommPortToString(Port));        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ZylGSMReceive(TObject *Sender, AnsiString Buffer)
{
  Memo->Lines->Add(Buffer);        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ZylGSMRing(TObject *Sender,
      AnsiString CallerNumber)
{
  Memo->Lines->Add("RING EVENT: " + CallerNumber);        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnOpenClick(TObject *Sender)
{
  ZylGSM->Port = TCommPort(lstPort->ItemIndex + 1);
  ZylGSM->BaudRate = ZylGSM->IntToBaudRate(
    StrToInt(lstBaudRate->Items->Strings[lstBaudRate->ItemIndex]));
  ZylGSM->Open();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnCloseClick(TObject *Sender)
{
  ZylGSM->Close();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnDialClick(TObject *Sender)
{
  ZylGSM->DialVoice(txtNo->Text);        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSendSMSTextClick(TObject *Sender)
{
  ZylGSM->SendSmsAsText(txtNo->Text, "", txtMessage->Text);        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnAnswerClick(TObject *Sender)
{
  ZylGSM->AnswerCall();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSendSMSPDUClick(TObject *Sender)
{
  ZylGSM->SendSmsAsPDU(txtNo->Text, "", txtMessage->Text);        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnTerminateClick(TObject *Sender)
{
  ZylGSM->TerminateCall();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSendStrClick(TObject *Sender)
{
  ZylGSM->SendString(txtMessage->Text + char(13));
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  lstBaudRate->ItemIndex = 6;        
}
//---------------------------------------------------------------------------
