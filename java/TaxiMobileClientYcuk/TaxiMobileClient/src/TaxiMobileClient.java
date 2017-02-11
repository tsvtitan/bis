/* */

import javax.microedition.midlet.*;
import javax.microedition.lcdui.*;
import javax.microedition.io.*;
import javax.microedition.rms.*;
import javax.wireless.messaging.*;
import javax.microedition.media.*;
import javax.microedition.media.control.*;
import java.io.*;
import java.util.*;
import org.kxml.*;
import org.kxml.parser.*;

class MenuCommandItem extends Object {

  public String Name="";
  public String Desc="";
  public String Text="";
  public String Phone="";
  public String Mode="0";
  public int Index=-1;
  public boolean Enabled=false;

  public MenuCommandItem(String Name, String Desc, String Text, String Phone, 
                         boolean Enabled, String Mode) {
    super();
    this.Name=Name.toString();
    this.Desc=Desc.toString();
    this.Text=Text.toString();
    this.Phone=Phone.toString();
    this.Enabled=Enabled;
    this.Mode=Mode.toString();
  }
}

class MenuCommand extends Vector {

  public String Name="";
  public String Desc="";
  public int Type=0;
  private List L=null;
  private Command C=null;

  public MenuCommand(String Name, String Desc, int Type) {
    super();
    this.Name=Name.toString();
    this.Desc=Desc.toString();
    this.Type=Type;
  }

  public void SetCommands(Vector Commands) {
    if (L!=null) {
      for (int i=0; i<Commands.size(); i++) {
        L.removeCommand((Command)Commands.elementAt(i));
        L.addCommand((Command)Commands.elementAt(i));
      }
    }
  }

  public List GetList() {
    return L;
  }

  public void SetList(List L) {
    this.L=L;
  }

  public Command GetCommand() {
    return C;
  }

  public void SetCommand(Command C) {
    this.C=C;
  }

  public void AddItem(String Name, String Desc, String Text, String Phone, 
                      boolean Enabled, String Mode) {
    MenuCommandItem m=new MenuCommandItem(Name,Desc,Text,Phone,Enabled,Mode);
    addElement(m);
  }

  public void BuildListItems(TaxiMobileClient Obj) {
    if (L!=null) {
      L.deleteAll();
      for (int i=0; i<size(); i++) {
        MenuCommandItem m=(MenuCommandItem)elementAt(i);
        boolean Flag=true;
        if (Obj.Mode==2) {
          if ("".equals(m.Phone.toString())) {
            Flag=false;
          } else {
            Flag="0".equals(m.Mode.toString())||
                 "3".equals(m.Mode.toString())||
                 "5".equals(m.Mode.toString())||
                 "6".equals(m.Mode.toString());
          }
        } else {
          if (Obj.Mode==1) {
            if ("".equals(m.Text.toString())) {
              Flag=false;
            } else {
              Flag="0".equals(m.Mode.toString())||
                   "1".equals(m.Mode.toString())||
                   "4".equals(m.Mode.toString())||
                   "5".equals(m.Mode.toString());
            }
          }
          if (Obj.Mode==0) {
            if ("".equals(m.Text.toString())) {
              Flag=false;
            } else {
              Flag="0".equals(m.Mode.toString())||
                   "2".equals(m.Mode.toString())||
                   "4".equals(m.Mode.toString())||
                   "6".equals(m.Mode.toString());
            }
          }
        }
        if ((m.Enabled)&&(Flag==true)) {
          m.Index=L.append(m.Name.toString(),null);
        }
      }
    }
  }

  public MenuCommandItem FindItemByIndex(int Index) {
    MenuCommandItem ret=null;
    for (int i=0; i<size(); i++) {
      MenuCommandItem m=(MenuCommandItem)elementAt(i);
      if (m.Index==Index) {
        ret=m;
        break;
      }
    }
    return ret;
  }

  public void ExecuteTextOrPhone(TaxiMobileClient Obj, String Title, String Name,
                                 String Text, String Phone, boolean AsText) {
    Obj.CurrentName=Name.toString();
    Obj.CurrentText=Text.toString();
    Obj.CurrentPhone=Phone.toString();
    if (AsText==false) {
      Obj.commandAction(Obj.CommandOK,Obj.TextBoxText);
    } else {
      
      Obj.TextBoxText.setTitle(Title.toString());
      Obj.TextBoxText.setString(Text.toString());
      if ("".equals(Text.toString())) {
        Display.getDisplay(Obj).setCurrent(Obj.TextBoxText);
        Obj.History.addElement(Obj.TextBoxText);
      } else {
        Obj.commandAction(Obj.CommandOK,Obj.TextBoxText);
      }
    }
  }
  
  public void ExecuteList(TaxiMobileClient Obj, boolean Force) {
    if ((L!=Obj.LastList)||(Force==true)) {
      BuildListItems(Obj);
      SetCommands(Obj.Commands);
      L.setCommandListener(Obj);
      Obj.LastList=L;
      Obj.History.addElement(L);
    }
    Display.getDisplay(Obj).setCurrent(L);
  }

  public void ExecuteResponses(TaxiMobileClient Obj) {
    Display.getDisplay(Obj).setCurrent(Obj.ListResponses);
    Obj.History.addElement(Obj.ListResponses);
  }

  public void ExecuteSetup(TaxiMobileClient Obj) {
    Display.getDisplay(Obj).setCurrent(Obj.FormSetup);
    ((ChoiceGroup)Obj.FormSetup.get(0)).setSelectedIndex(Obj.Mode,true);
    ((TextField)Obj.FormSetup.get(1)).setString(Obj.Login);
    Obj.History.addElement(Obj.FormSetup);
  }

  public void ExecuteUpdate(TaxiMobileClient Obj) {
    try {
      Obj.platformRequest(Obj.SUpdateUrl);
    } catch(Exception e) {
      Alert a=new Alert(Name.toString(),e.getMessage(),null,AlertType.ERROR);
      a.addCommand(Obj.CommandOK);
      a.setCommandListener(Obj);
      a.setTimeout(Obj.AlertTimeOut);
      Display.getDisplay(Obj).setCurrent(a);
    }
  }

  public boolean Execute(TaxiMobileClient Obj) {
    boolean ret=false;
    switch (Type) {
      case 0:
        if (Obj.Mode!=2) {
          ExecuteTextOrPhone(Obj,Name,"","","",true);
        }
        break;
      case 1: 
        ExecuteList(Obj,false);
        break;
      case 2: 
        ExecuteResponses(Obj);
        break;
      case 3:
        ExecuteSetup(Obj);
        break;
      case 4:
        ExecuteUpdate(Obj);
        ret=true;
        break;
      default: ;
    }
    return ret;
  }
}

class MenuCommands extends Vector {

  public MenuCommands() {
    super();
  }

  public MenuCommand AddCommand(String Name, String Desc, int Mode) {
    MenuCommand m=new MenuCommand(Name,Desc,Mode);
    addElement(m);
    return m;
  }

  public void BuildCommands(Vector Commands) {
    MenuCommand m=null;
    for (int i=0; i<size(); i++) {
      m=(MenuCommand)elementAt(i);
      Command c=new Command(m.Name.toString(),Command.SCREEN,i+1);
      m.SetCommand(c);
      Commands.addElement(c);
    }
  }

  public void BuildLists(Vector Lists) {
    MenuCommand m=null;
    for (int i=0; i<size(); i++) {
      m=(MenuCommand)elementAt(i);
      if (m.size()>0) {
        List l=new List(m.Name.toString(),List.IMPLICIT);
        m.SetList(l);
        Lists.addElement(l);
      }
    }
  }

  public MenuCommand FirstList() {
    MenuCommand ret=null;
    for (int i=0; i<size(); i++) {
      MenuCommand m=(MenuCommand)elementAt(i);
      if (m.GetList()!=null) {
        ret=m;
        break;
      }
    }
    return ret;
  }

  public MenuCommand FindByCommand(Command C) {
    MenuCommand ret=null;
    for (int i=0; i<size(); i++) {
      MenuCommand m=(MenuCommand)elementAt(i);
      if (m.GetCommand()==C) {
        ret=m;
        break;
      }
    }
    return ret;
  }

  public MenuCommand FindByList(List L) {
    MenuCommand ret=null;
    for (int i=0; i<size(); i++) {
      MenuCommand m=(MenuCommand)elementAt(i);
      if (m.GetList()==L) {
        ret=m;
        break;
      }
    }
    return ret;
  }
  
}

class MenuResponse extends Object {

  public String Value="";

  public MenuResponse(String Value) {
    super();
    this.Value=Value.toString();
  }
}

class MenuResponses extends Vector {

  public MenuResponses() {
    super();
  }

  public MenuResponse AddResponse(String Value, boolean Last) {
    MenuResponse m=new MenuResponse(Value);
    if (Last) {
      addElement(m);
    } else {
      insertElementAt(m,0);
    }
    return m;
  }
}

class SplashProcess extends Canvas implements Runnable {

  private Thread current;
  private TaxiMobileClient Obj;
  private int Mode;
  private String ResponseResult="";
  private boolean ResponseExists=false;
  private MenuResponses Responses=null;

  public SplashProcess(TaxiMobileClient Obj, int Mode)  {
    this.Obj=Obj;
    this.Mode=Mode;
    this.addCommand(Obj.CommandBack);
    //this.addCommand(Obj.CommandExit);
    this.setCommandListener(Obj);
    Responses = new MenuResponses();
    current = new Thread(this);
    current.start();
  }

  public void paint(Graphics g) {
    int w=g.getClipWidth();
    int h=g.getClipHeight();
    int fh=Font.getDefaultFont().getHeight();
    int x=w/2;
    int y=h/2-fh/2-7;
    g.setColor(0xFFFFFF);
    g.fillRect(0,0,w,h);
    g.setColor(0x000000);
    g.drawString(Obj.SProcess.toString(),x,y,Graphics.TOP|Graphics.HCENTER);
    g.setColor(0xFF0000);
    String s=Obj.CurrentName.toString();
    if (s.equals("".toString())) {
      if (Mode!=2) {
        s=Obj.CurrentText.toString();
      } else {
        s=Obj.CurrentPhone.toString();
      }
    }
    g.drawString(s.toString(),x,y+fh/2+10,Graphics.TOP|Graphics.HCENTER);
  }

  public void sleep(int msec) {
    try {
      Thread.currentThread().sleep(msec);
    } catch (Exception e) { }
  }

  public String CompressRequest(String S) {
    return S.toString();
  }

  public String DecompressResponse(String S) {
    return S.toString();
  }

  public String EncodeRequest(String S) {
    return S.toString();
  }

  public String DecodeResponse(String S) {
    return S.toString();
  }

  public void ReadResponse(XmlParser Parser, String Ident) throws Exception
  {
    boolean leave = false;
    do {
      ParseEvent Event=Parser.read();
      ParseEvent pe=null;
      String v="";
      switch ( Event.getType() ) {
        case Xml.START_TAG:
	  if ("r".equals(Event.getName())) {
            pe=Parser.read();
            ResponseResult=pe.getText();
            if (ResponseResult==null) {
              ResponseResult="";
            }
            ResponseExists=true;
            ReadResponse(Parser,"");
          }
          if ("m".equals(Event.getName())) {
            ReadResponse(Parser,Event.getName());
	  }
          if (Ident.toString().equals("m")) {
            if ("i".equals(Event.getName())) {
              pe=Parser.read();
              v=pe.getText();
              if (v==null) {
                v="";
              }
              if (v.equals("".toString())==false) {
                Responses.AddResponse(v,true);
              }
            }
            ReadResponse(Parser,"m");
          }
	  break;
	case Xml.END_TAG:
	  leave = true;
	  break;
        case Xml.END_DOCUMENT:
	  leave = true;
	  break;
	case Xml.TEXT:
	  break;
	case Xml.WHITESPACE:
	  break;
	  default:
      }
    } while( !leave );
  }

  public boolean HttpSend() throws Exception {
    String s="";
    boolean ret=false;
    HttpConnection c=null;
    OutputStream os=null;
    DataInputStream dis=null;
    Reader r=null;
    Writer w=null;
    StringBuffer b = new StringBuffer();
    String Encoding="UTF-8";
    try {
      String url=Obj.SHttpUrl.toString();
      String xml="<d><u>"+Obj.Login.toString().trim()+"</u><t>"+Obj.CurrentText.toString()+"</t>";

      xml=CompressRequest(xml.toString()).toString();
      xml=EncodeRequest(xml.toString()).toString();

      c=(HttpConnection)Connector.open(url);
      c.setRequestMethod(HttpConnection.POST);
      c.setRequestProperty("Content-Length",Integer.toString(xml.length()));
//      c.setRequestProperty("User-Agent",Obj.getAppProperty("MIDlet-Name")+" "+Obj.getAppProperty("MIDlet-Version"));

      os=c.openOutputStream();
      
      w=new OutputStreamWriter(os,Encoding.toString());
      w.write(xml.toString());

      int respCode=c.getResponseCode();
      if (respCode==HttpConnection.HTTP_OK) {
        try {
          ResponseExists=false;
          dis=c.openDataInputStream();
          r=new InputStreamReader(dis,Encoding.toString());
          int ch;
          while((ch = r.read()) != -1) {
            b.append((char)ch);
          }
          s=b.toString();
          s=DecodeResponse(s.toString()).toString();
          s=DecompressResponse(s.toString()).toString();
          if (s.equals("".toString())==false) {
            try {
              ByteArrayInputStream bis=new ByteArrayInputStream(s.getBytes(Encoding.toString()));
              InputStreamReader Reader=new InputStreamReader(bis,Encoding.toString());
              XmlParser Parser = new XmlParser(Reader);
              ReadResponse(Parser,"");
              ret=ResponseExists;
            } catch(Exception e) {
            }
          }
        } finally {
          if (ret==false) {
            ResponseResult=s.toString();
          }
          if (r!=null) { r.close(); }
          if (dis!=null) { dis.close(); }
        }
      }
    } finally {
      if (os!=null) { os.close(); }
      if (c!=null) { c.close(); }
    }
    return ret;
  }

  public boolean SmsSend() throws Exception {
    boolean ret=false;
    MessageConnection c=null;
    try {
      String url=Obj.SSmsUrl.toString();
      String text=Obj.SSmsText.toString();
      text=Obj.Replace(text.toString(),"%TEXT",Obj.CurrentText.toString()).toString();
      c=(MessageConnection)Connector.open(url.toString());
      TextMessage msg=(TextMessage)c.newMessage(MessageConnection.TEXT_MESSAGE);
      msg.setAddress(url.toString());
      msg.setPayloadText(text.toString());
      c.send(msg);
      ret=true;
    } finally {
      if (c!=null) {
        c.close();
      }
    }
    return ret;
  }

  public boolean Call() throws Exception {
    boolean ret=false;
    String url=Obj.SCallUrl.toString();
    url=Obj.Replace(url.toString(),"%PHONE",Obj.CurrentPhone.toString()).toString();
    Obj.platformRequest(url.toString());
    return ret;
  }

  public void BuildAndShowListResponse() {
    Obj.DeleteResponses();
    Obj.ListResponse.deleteAll();
    for (int i=0; i<Responses.size(); i++) {
      MenuResponse m=(MenuResponse)Responses.elementAt(i);
      Obj.ListResponse.append(m.Value.toString(),null);
      Obj.ListResponses.insert(0,m.Value.toString(),null);
    }
    if (Obj.ListResponse.size()>0) {
      Obj.ListResponse.setTitle(Obj.CurrentName.toString());
      Display.getDisplay(Obj).setCurrent(Obj.ListResponse);
      Obj.History.addElement(Obj.ListResponse);
    }
  }

  public void run() {
    String Message="";
    boolean Success=false;
    ResponseResult="";
    Responses.removeAllElements();
    repaint();
    sleep(100);
    try {
      switch (Mode) {
        case 0:
          Message=Obj.SSmsMessage.toString();
          Success=SmsSend();
          break;
        case 1:
          Message=Obj.SHttpMessage.toString();
          Success=HttpSend();
          break;
        case 2:
          Message=Obj.SCallMessage.toString();
          Success=Call();
          break;
        default: ;
      }
    } catch(Exception e) {
      ResponseResult=e.getMessage();
    }
    AlertType at=AlertType.INFO;
    String AlertText="";
    String AlertTitle=Obj.CurrentName.toString();
    if (Success==true) {
      if (ResponseResult.equals("".toString())==false) {
        Responses.AddResponse(ResponseResult.toString(),false);
      }
      if (Responses.size()>1) {
        BuildAndShowListResponse();
        return;
      } else if (Responses.size()==1) {
        AlertText=((MenuResponse)Responses.elementAt(0)).Value.toString();
      } else {
        at=AlertType.WARNING;
        AlertText=Message.toString();
      }
    } else {
      at=AlertType.ERROR;
      AlertText=ResponseResult.toString();
    }
    AlertText=AlertText.trim();
    Obj.DeleteResponses();
    Obj.ListResponses.insert(0,AlertText.toString(),null);

    //Obj.PlayMessage();

    Alert a=new Alert(AlertTitle.toString(),AlertText.toString(),null,at);
    a.addCommand(Obj.CommandOK);
    a.setCommandListener(Obj);
    a.setTimeout(Obj.AlertTimeOut);
    Display.getDisplay(Obj).setCurrent(a);
  }

}

class KeepConnection extends Object implements Runnable {
  
  private Thread current;
  private TaxiMobileClient Obj;
  private SocketConnection sc=null;
  private InputStream is=null;
  private boolean First=true;

  public KeepConnection(TaxiMobileClient Obj)  {
    this.Obj=Obj;
    current = new Thread(this);
    current.start();
  }

  public void sleep(int msec) {
    try {
      Thread.currentThread().sleep(msec);
    } catch (Exception e) { }
  }

  public void run() {
    boolean ExitRun=false;
    while (ExitRun==false) {
      try {
        sleep(100);
        if (Obj.Keep==true) {
          try {
            if (First==false) {
              sleep(5000);
            } else {
              First=false;
            }
            sc=(SocketConnection)Connector.open(Obj.SHttpKeepUrl);
            sc.setSocketOption(SocketConnection.KEEPALIVE,1);
            sc.setSocketOption(SocketConnection.DELAY,0);
            is=sc.openInputStream();
            while (Obj.Keep) {
              StringBuffer sb=new StringBuffer();
              int c=0;
              while (((c = is.read())!= -1) && Obj.Keep) {
                sb.append((char)c);
              }
              if (c == -1) {
                break;
              }
            }
          } finally {
            stop();
          }
        }
      } catch (Exception e) {
      }
    }
  }

  public void stop() {
    try {
      if (is!=null) { is.close(); is=null; }
      if (sc!=null) { sc.close(); sc=null; }
    } catch (Exception e) {
    }
  }

}

public class TaxiMobileClient extends MIDlet implements CommandListener, Runnable, MessageListener {

  public Vector Commands;
  public Vector History;
  public TextBox TextBoxText;
  public Form FormSetup;
  public List ListResponse;
  public List ListResponses;
  private KeepConnection Connection;
  private MessageConnection MConnection=null;
  private Player MPlayer=null;
  private VolumeControl VControl=null;
  public String XmlConf="";
  public String XmlConfVer="1";
  public String Login="";
  public int Mode=1;
  public Font FontList;
  public String CurrentName="";
  public String CurrentText="";
  public String CurrentPhone="";
  
  public Command CommandOK;
  public Command CommandCancel;
  public Command CommandBack;
  public Command CommandExit;
  private Command CommandTest;

  private MenuCommands Menus;
  private Vector Lists;
  public List LastList=null;

  private String SHttp="http";
  public String SHttpUrl="";
  public String SHttpMessage="";
  public String SHttpKeepUrl="";
  private String SSms="sms";
  public String SSmsUrl="";
  public String SSmsText="";
  public String SSmsMessage="";
  public String SSmsWaitUrl="";
  private String SCall="call";
  public String SCallUrl="";
  public String SCallMessage="";
  public String SProcess="Sending";
  public String SConfVer="Version";
  
  private String SLogin="Login";
  public String SResponse="Response";
  private String SMode="Mode";
  private String SCode="Text";
  private String SSetup="Setup";
  private String SOK="OK";
  private String SCancel="Cancel";
  private String SBack="Back";
  private String SExit="Exit";
  private String SUpdate="Update";
  public String SUpdateUrl="";
  private String SResponses="Responses";
  private String SConnection="Connection";
  private String SKeep="Keep";
  private String SMessage="Message";
  private String SWait="Wait";

  public int AlertTimeOut=Alert.FOREVER/*5000*/;
  public boolean Keep=false;

  public Thread TempThread;
  
  public TaxiMobileClient()
  {
    Menus=new MenuCommands();
    Commands=new Vector();
    Lists=new Vector();
    History=new Vector();
  }

  public void PlayMessage() {
    try {
      Display.getDisplay(this).vibrate(3);
      MPlayer.setLoopCount(2);
      if (VControl!=null) {
        VControl.setMute(false);
        VControl.setLevel(100);
      }
      MPlayer.start();
      Thread.currentThread().sleep(8000);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  public String Replace(String text, String from, String to) {
    int fromSize = from.length();
    int toSize = to.length();
    int pos = 0;
    for (;;) {
      pos = text.indexOf(from, pos);
      if (pos == -1) break;
      text = text.substring(0, pos) + to  + text.substring(pos + fromSize, text.length());
      pos += toSize;
    }
    return text;
  }

  public void DeleteResponses() {
    int MaxRes=10;
    if (ListResponses.size()>=MaxRes) {
      int C=ListResponses.size();
      for (int i=C; i>=MaxRes; i--) {
        ListResponses.delete(i-1);
      }
    }
  }

  public void ReadConfig(XmlParser Parser, String Ident) throws Exception
  {
    boolean leave = false;
    do {
      ParseEvent Event = Parser.read();
      String n="";
      String d="";
      String s="";
      String c="";
      String e="";
      String md="0";
      switch ( Event.getType() ) {
        case Xml.START_TAG:
	  if ("sms".equals(Event.getName())) {
            SSms=Event.getValueDefault("name",SSms.toString()).toString();
            SSmsUrl=Event.getValueDefault("url",SSmsUrl.toString()).toString();
            SSmsText=Event.getValueDefault("text",SSmsText.toString()).toString();
            SSmsMessage=Event.getValueDefault("message",SSmsMessage.toString()).toString();
            SSmsWaitUrl=Event.getValueDefault("waiturl",SSmsWaitUrl.toString()).toString();
            ReadConfig(Parser,"");
	  }
	  if ("http".equals(Event.getName())) {
            SHttp=Event.getValueDefault("name",SHttp.toString()).toString();
            SHttpUrl=Event.getValueDefault("url",SHttpUrl.toString()).toString();
            SHttpMessage=Event.getValueDefault("message",SHttpMessage.toString()).toString();
            SHttpKeepUrl=Event.getValueDefault("keepurl",SHttpKeepUrl.toString()).toString();
            ReadConfig(Parser,"");
          }
	  if ("call".equals(Event.getName())) {
            SCall=Event.getValueDefault("name",SCall.toString()).toString();
            SCallUrl=Event.getValueDefault("url",SCallUrl.toString()).toString();
            SCallMessage=Event.getValueDefault("message",SCallMessage.toString()).toString();
            ReadConfig(Parser,"");
	  }
          if ("login".equals(Event.getName())) {
            SLogin=Event.getValueDefault("name",SLogin.toString()).toString();
            //Login=Event.getValueDefault("value",Login.toString()).toString();
            ReadConfig(Parser,"");
	  }
          if ("confver".equals(Event.getName())) {
            SConfVer=Event.getValueDefault("name",SConfVer.toString()).toString();
            ReadConfig(Parser,"");
	  }
          if ("response".equals(Event.getName())) {
            SResponse=Event.getValueDefault("name",SResponse.toString()).toString();
            ReadConfig(Parser,"");
	  }
          if ("mode".equals(Event.getName())) {
            SMode=Event.getValueDefault("name",SMode.toString()).toString();
            ReadConfig(Parser,"");
	  }
          if ("ok".equals(Event.getName())) {
            SOK=Event.getValueDefault("name",SOK.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("cancel".equals(Event.getName())) {
            SCancel=Event.getValueDefault("name",SCancel.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("back".equals(Event.getName())) {
            SBack=Event.getValueDefault("name",SBack.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("process".equals(Event.getName())) {
            SProcess=Event.getValueDefault("name",SProcess.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("connection".equals(Event.getName())) {
            SConnection=Event.getValueDefault("name",SConnection.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("keep".equals(Event.getName())) {
            SKeep=Event.getValueDefault("name",SKeep.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("message".equals(Event.getName())) {
            SMessage=Event.getValueDefault("name",SMessage.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("wait".equals(Event.getName())) {
            SWait=Event.getValueDefault("name",SWait.toString()).toString();
            ReadConfig(Parser,"");
	  }
  	  if ("exit".equals(Event.getName())) {
            SExit=Event.getValueDefault("name",SExit.toString()).toString();
            CommandExit=new Command(SExit.toString(),Command.EXIT,0);
            ReadConfig(Parser,"");
	  }

          if ("commands".equals(Event.getName())) {
            ReadConfig(Parser,Event.getName());
	  }

          if (Ident.toString().equals("commands")) {
  	    if ("code".equals(Event.getName())) {
              n=Event.getValueDefault("name",SCode.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              SCode=n.toString();
              Menus.AddCommand(n,d,0);
              ReadConfig(Parser,Ident);
	    }
            if ("list".equals(Event.getName()))  {
              n=Event.getValueDefault("name","").toString();
              d=Event.getValueDefault("desc","").toString();
              Menus.AddCommand(n,d,1);
              ReadConfig(Parser,"list");
            }
  	    if ("responses".equals(Event.getName())) {
              n=Event.getValueDefault("name",SResponses.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              SResponses=n.toString();
              Menus.AddCommand(n,d,2);
              ReadConfig(Parser,Ident);
	    }
  	    if ("setup".equals(Event.getName())) {
              n=Event.getValueDefault("name",SSetup.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              SSetup=n.toString();
              Menus.AddCommand(n,d,3);
              ReadConfig(Parser,Ident);
	    }
  	    if ("update".equals(Event.getName())) {
              n=Event.getValueDefault("name",SUpdate.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              SUpdate=n.toString();
              SUpdateUrl=Event.getValueDefault("url",SUpdateUrl.toString()).toString();
              Menus.AddCommand(n,d,4);
              ReadConfig(Parser,Ident);
	    }
            ReadConfig(Parser,Ident);
          }

          if (Ident.toString().equals("list")) {
            if ("item".equals(Event.getName())) {
              n=Event.getValueDefault("name","Item").toString();
              d=Event.getValueDefault("desc","").toString();
              c=Event.getValueDefault("text","").toString();
              s=Event.getValueDefault("phone","").toString();
              e=Event.getValueDefault("enabled","1").toString();
              md=Event.getValueDefault("mode",md.toString()).toString();
              MenuCommand m=(MenuCommand)Menus.lastElement();
              if (e.equals("1")) {
                m.AddItem(n,d,c,s,true,md);
              } else {
                m.AddItem(n,d,c,s,false,md);
              }
            }
            ReadConfig(Parser,"commands");
          }

	  break;
	case Xml.END_TAG:
	  leave = true;
	  break;
        case Xml.END_DOCUMENT:
	  leave = true;
	  break;
	case Xml.TEXT:
	  break;
	case Xml.WHITESPACE:
	  break;
	  default:
      }
    } while( !leave );
  }

  public void LoadFromStore() {

    RecordStore rec = null;
    DataInputStream dis = null;
    try {
      String s=this.getClass().getName();
      rec = RecordStore.openRecordStore(s,true);
      if (rec.getNumRecords() > 0) {
        dis = new DataInputStream(new ByteArrayInputStream(rec.getRecord(1)));

        Login=dis.readUTF();
        //System.out.println("login: " + Login);
        Mode=dis.readInt();
        Keep=dis.readBoolean();
        
        
        dis = null;
        rec.closeRecordStore();
        rec = null;
        
        rec = RecordStore.openRecordStore(s + "conf",true);
        
        if (rec.getNumRecords() > 0) {
            dis = new DataInputStream(new ByteArrayInputStream(rec.getRecord(1)));
            XmlConf=dis.readUTF();
        }
        
        dis = null;
        rec.closeRecordStore();
        rec = null;
        
        rec = RecordStore.openRecordStore(s + "confver",true);
        
        if (rec.getNumRecords() > 0) {
            dis = new DataInputStream(new ByteArrayInputStream(rec.getRecord(1)));
            XmlConfVer=dis.readUTF();
        }

      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (rec != null) {
        try {
          rec.closeRecordStore();
        } catch (Exception e) { }

        rec = null;
      }
      if (dis != null) {
        try {
          dis.close();
        } catch (Exception e) { }
        rec = null;
      }
    }
  }

  public void DeleteRecords() {
    String[] array = RecordStore.listRecordStores();
    if (array != null) {
      for (int i = 0; i < array.length; i++) {
          try {
            RecordStore.deleteRecordStore(array[i]);
          } catch (Exception e) {
            e.printStackTrace();
          }
      }
    }
  }

  public void SaveToStore() {

    RecordStore rec = null;
    ByteArrayOutputStream bos = null;
    DataOutputStream dos = null;
    try {
      String s=this.getClass().getName();
      DeleteRecords();
      bos = new ByteArrayOutputStream();
      dos = new DataOutputStream(bos);

      dos.writeUTF(Login);
      //System.out.println("login save: " + Login);
      dos.writeInt(Mode);
      dos.writeBoolean(Keep);
      
      dos.flush();
      rec = RecordStore.openRecordStore(s, true);
      byte[] b = bos.toByteArray();
      rec.addRecord(b, 0, b.length);
      b = null;
      dos = null;
      bos = null;
      rec.closeRecordStore();
      
      
      bos = new ByteArrayOutputStream();
      dos = new DataOutputStream(bos);
      dos.writeUTF(XmlConf);
      dos.flush();
      rec = RecordStore.openRecordStore(s + "conf", true);
      b = bos.toByteArray();
      rec.addRecord(b, 0, b.length);
      b = null;
      dos = null;
      bos = null;
      rec.closeRecordStore();
      
      
      bos = new ByteArrayOutputStream();
      dos = new DataOutputStream(bos);
      dos.writeUTF(XmlConfVer);
      dos.flush();
      rec = RecordStore.openRecordStore(s + "confver", true);
      b = bos.toByteArray();
      rec.addRecord(b, 0, b.length);
      b = null;
      dos = null;
      bos = null;
      
      

    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (rec != null) {
        try {
          rec.closeRecordStore();
        } catch (Exception e) { }
        rec = null;
      }
    }

    if (dos != null) {
      try {
        dos.close();
      } catch (IOException e) { }
    }
    if (bos != null) {
       try {
         bos.close();
       } catch (IOException e) { }
    }
  }  

  public void startApp() 
  {
    try {

      MPlayer=Manager.createPlayer(getClass().getResourceAsStream("message.mid"),"audio/midi");
      MPlayer.realize();
      VolumeControl VControl=(VolumeControl)MPlayer.getControl("VolumeControl");
      MPlayer.prefetch();
      
      LoadFromStore();
      

        String s="";
        String ss="";
        boolean ret=false;
        HttpConnection c=null;
        OutputStream os=null;
        DataInputStream dis=null;
        Reader r=null;
        Writer w=null;
        StringBuffer b = new StringBuffer();
        String Encoding="UTF-8";
        try {
          c=(HttpConnection)Connector.open("http://ataxi24.ru/_confver");
          c.setRequestMethod(HttpConnection.GET);
          os=c.openOutputStream();
          w=new OutputStreamWriter(os,Encoding.toString());
          w.write("");

          int respCode=c.getResponseCode();
          if (respCode==HttpConnection.HTTP_OK) {
            try {
              dis=c.openDataInputStream();
              r=new InputStreamReader(dis,Encoding.toString());
              int ch;
              while((ch = r.read()) != -1) {
                b.append((char)ch);
              }
              ss=b.toString();
            } finally {
              if (r!=null) { r.close(); }
              if (dis!=null) { dis.close(); }
            }
          }
        } finally {
          if (os!=null) { os.close(); }
          if (c!=null) { c.close(); }
        }
        
        
        
      if (!ss.equals(XmlConfVer)) 
      { 
        try {
          c=(HttpConnection)Connector.open("http://ataxi24.ru/_config.xml");
          c.setRequestMethod(HttpConnection.GET);
          os=c.openOutputStream();
          w=new OutputStreamWriter(os,Encoding.toString());
          w.write("");

          int respCode=c.getResponseCode();
          if (respCode==HttpConnection.HTTP_OK) {
            try {
              dis=c.openDataInputStream();
              r=new InputStreamReader(dis,Encoding.toString());
              int ch;
              b.setLength(0);
              while((ch = r.read()) != -1) {
                b.append((char)ch);
              }
              s=b.toString();
              b.setLength(0);
              XmlConf = s.toString();
              ret = true;
            } finally {
              if (r!=null) { r.close(); }
              if (dis!=null) { dis.close(); }
            }
          }
        } finally {
          if (os!=null) { os.close(); }
          if (c!=null) { c.close(); }
        }
      }
      
      XmlConfVer = ss;
      
      if (ret) {
          ByteArrayInputStream bis=new ByteArrayInputStream(s.getBytes(Encoding.toString()));
          InputStreamReader Reader=new InputStreamReader(bis,Encoding.toString());
          XmlParser Parser = new XmlParser(Reader);
          ReadConfig(Parser,"");
          //System.out.println("http");
      } else {
          if (XmlConf.length() < 100) {
            InputStreamReader Reader = new InputStreamReader(this.getClass().getResourceAsStream("config.xml"),"UTF-8");
            XmlParser Parser = new XmlParser(Reader);
            ReadConfig(Parser,"");
            //System.out.println("xml");
            
            Reader rr=null;
            StringBuffer bbb = new StringBuffer();
            rr=new InputStreamReader(this.getClass().getResourceAsStream("config.xml"),Encoding.toString());
            int ch;
            while((ch = rr.read()) != -1) {
                bbb.append((char)ch);
            }
            XmlConf=bbb.toString();
          } else {
              ByteArrayInputStream bis=new ByteArrayInputStream(XmlConf.getBytes(Encoding.toString()));
              InputStreamReader Reader=new InputStreamReader(bis,Encoding.toString());
              XmlParser Parser = new XmlParser(Reader);
              ReadConfig(Parser,"");
              //System.out.println("store");
          }
      }
      

      if (CommandExit==null) {
        CommandExit=new Command(SExit.toString(),Command.EXIT,99);
      }
      Commands.addElement(CommandExit);

      CommandOK=new Command(SOK.toString(),Command.OK,1);
      CommandCancel=new Command(SCancel.toString(),Command.CANCEL,2);
      CommandBack=new Command(SBack.toString(),Command.BACK,3);
      //CommandTest=new Command("Test",Command.SCREEN,3);
      //Commands.addElement(CommandTest);

      TextBoxText=new TextBox(SCode.toString(),"",256,TextField.NUMERIC&TextField.DECIMAL);
      TextBoxText.addCommand(CommandOK);
      TextBoxText.addCommand(CommandBack);
      TextBoxText.setCommandListener(this);

      ChoiceGroup cg=new ChoiceGroup(SMode.toString(),ChoiceGroup.EXCLUSIVE);
      cg.append(SSms.toString(),null);
      cg.append(SHttp.toString(),null);
 //     cg.append(SCall.toString(),null);
      cg.setSelectedIndex(Mode,true);
      
      FormSetup=new Form(SSetup.toString());
      FormSetup.append(cg);
      TextField t1=new TextField(SLogin.toString(),Login.toString(),100,TextField.NUMERIC);
      FormSetup.append(t1);
      ChoiceGroup cg2=new ChoiceGroup(SConnection.toString(),ChoiceGroup.MULTIPLE);
      cg2.append(SKeep.toString(),null);
      boolean get[]=new boolean[cg2.size()];
      get[0]=Keep;
      cg2.setSelectedFlags(get);
      FormSetup.append(cg2);
      
      StringItem cver = new StringItem(SConfVer + ": ", XmlConfVer.toString());
      FormSetup.append(cver);
      

      FormSetup.addCommand(CommandOK);
      FormSetup.addCommand(CommandBack);
      FormSetup.setCommandListener(this);

      ListResponse=new List(SResponse,List.IMPLICIT);
      ListResponse.addCommand(CommandOK);
      ListResponse.addCommand(CommandBack);
      ListResponse.setCommandListener(this);

      ListResponses=new List(SResponses,List.IMPLICIT);
      ListResponses.addCommand(CommandOK);
      ListResponses.addCommand(CommandBack);
      ListResponses.setCommandListener(this);

      Connection=new KeepConnection(this);
 
      MConnection=(MessageConnection)Connector.open(SSmsWaitUrl.toString(),Connector.READ);
      MConnection.setMessageListener(this);

      Menus.BuildCommands(Commands);
      Menus.BuildLists(Lists);

      MenuCommand First=Menus.FirstList();
      if (First!=null) {
        First.BuildListItems(this);
        First.SetCommands(Commands);
        First.GetList().setCommandListener(this);
        Display.getDisplay(this).setCurrent(First.GetList());
        History.addElement(First.GetList());
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void pauseApp() {  }

  public void destroyApp(boolean unconditional) {
      try {
          MConnection.close();
      } catch (Exception e) {
          e.printStackTrace();
      }
    SaveToStore();
  }

  public Displayable HistoryBack(int Offset) {
    Displayable d=null;
    if ((History.size()-Offset)>0) {
      int NewSize=History.size()-Offset;
      for (int i=(History.size()-1); i>(NewSize-1); i--) {
        History.removeElementAt(i);
      }
    }
    if (History.size()>0) {
      d=(Displayable)History.lastElement();
      Display.getDisplay(this).setCurrent(d);
    }
    return d;
  }

  public String GetNameByText(String Text) {
    String ret=Text.toString();
    for (int i=0; i<Menus.size(); i++) {
      MenuCommand m=(MenuCommand)Menus.elementAt(i);
      for (int j=0; j<m.size(); j++) {
        MenuCommandItem mi=(MenuCommandItem)m.elementAt(j);
        if (mi.Text.equals(Text.toString())) {
          ret=mi.Name.toString();
          return ret;
        }
      }
    }
    return ret;
  }

  public String GetNameByPhone(String Phone) {
    String ret="";
    for (int i=0; i<Menus.size(); i++) {
      MenuCommand m=(MenuCommand)Menus.elementAt(i);
      for (int j=0; j<m.size(); j++) {
        MenuCommandItem mi=(MenuCommandItem)m.elementAt(j);
        if (mi.Phone.equals(Phone.toString())) {
          ret=mi.Name.toString();
          return ret;
        }
      }
    }
    return ret;
  }

  public void commandAction(Command c, Displayable s)
  {
    if (c==CommandExit) {
      this.destroyApp( false );
      this.notifyDestroyed();
    } else 
    if (c==CommandOK) {
      if (s==TextBoxText) {
        if (Mode!=2) {
          if (CurrentText.equals("".toString())||(CurrentText.equals(TextBoxText.getString())==false)) {
            CurrentText=TextBoxText.getString();
            CurrentName=GetNameByText(CurrentText.toString()).toString();
          }
        } else {
          if (CurrentText.equals("".toString())) {
             //
          }
        }
        SplashProcess sp=new SplashProcess(this,Mode);
        Display.getDisplay(this).setCurrent(sp);
      } else 
      if (s==FormSetup) {
        Mode=((ChoiceGroup)FormSetup.get(0)).getSelectedIndex();
        Login=((TextField)FormSetup.get(1)).getString();
        ChoiceGroup cg=((ChoiceGroup)FormSetup.get(2));
        boolean get[]=new boolean[cg.size()];
        cg.getSelectedFlags(get);
        Keep=get[0];
        if (Keep==false) {
          Connection.stop();
        }
        SaveToStore();
        Displayable d=HistoryBack(1);
        if ((d!=null)&&(d instanceof List)) {
          MenuCommand m3=Menus.FindByList((List)d);
          if (m3!=null) {
            m3.ExecuteList(this,true);
          }
        }
      } else if (s==ListResponse) {
        commandAction(null,s);
      } else if (s==ListResponses) {
        commandAction(null,s);
      } else if (s instanceof Alert) {
        commandAction(CommandBack,s);
      }
    } else if ((c==CommandCancel)||(c==CommandBack)) {
      if ((s==FormSetup)||(s==ListResponse)||(s==ListResponses)) {
        HistoryBack(1);
      } else {
        if (s instanceof Alert) {
          HistoryBack(0);
        } else {
          if (Mode!=2) {
            HistoryBack(1);
          } else {
            HistoryBack(0);
          }
        }
      }
      if (s instanceof SplashProcess) {
        s=null;
      }
    } else if (c==CommandTest) {
      PlayMessage();

 /*     try {
        MessageConnection mc=null;
        try {
          //String url="sms://6260001:5000";
           String url="sms://123456789:55555";
          //String url="sms://+79504248277:5003";
          //String url="sms://+79029232332:5003";
          mc=(MessageConnection)Connector.open(url.toString());
          TextMessage msg1=(TextMessage)mc.newMessage(MessageConnection.TEXT_MESSAGE);
          msg1.setAddress(url.toString());
          msg1.setPayloadText("qwerty".toString());
          mc.send(msg1);
        } finally {
          if (mc!=null) {
            mc.close();
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
*/
    } else if (s==TextBoxText) {
      Alert a=new Alert(c.toString());
      a.setTimeout(AlertTimeOut);
      Display.getDisplay(this).setCurrent(a);
    } else if (s==ListResponse) {
       int Index=ListResponse.getSelectedIndex();
       if (Index!=-1) {
         String t=ListResponse.getString(Index).toString();
         Alert a=new Alert(ListResponse.getTitle(),t.toString(),null,AlertType.INFO);
         a.addCommand(CommandOK);
         a.setCommandListener(this);
         a.setTimeout(AlertTimeOut);
         Display.getDisplay(this).setCurrent(a);
       }
    } else if (s==ListResponses) {
       int Index=ListResponses.getSelectedIndex();
       if (Index!=-1) {
         String t=ListResponses.getString(Index).toString();
         Alert a=new Alert(ListResponses.getTitle(),t.toString(),null,AlertType.INFO);
         a.addCommand(CommandOK);
         a.setCommandListener(this);
         a.setTimeout(AlertTimeOut);
         Display.getDisplay(this).setCurrent(a);
       }
    } else {
      MenuCommand m1=Menus.FindByCommand(c);
      if (m1!=null) {
        if (m1.Execute(this)==true) {
          commandAction(CommandExit,null);
        }
      } else {
        if (s!=null) {
          if (s instanceof List) {
            MenuCommand m2=Menus.FindByList((List)s);
            if (m2!=null) {
              MenuCommandItem m3=m2.FindItemByIndex(((List)s).getSelectedIndex());
              if (m3!=null) {
                m2.ExecuteTextOrPhone(this,m2.Name,m3.Name,m3.Text,m3.Phone,Mode!=2);
              }
            }
          }
        }
      }
    }
  }

  public void notifyIncomingMessage(MessageConnection conn) {
    if (TempThread==null)  {
      TempThread=new Thread(this);
      TempThread.start();
    }
  }

  public void run() {
    try {
      try {
        Message msg=MConnection.receive();
        if (msg!=null) {
          if (msg instanceof TextMessage) {
            DeleteResponses();
            String s=((TextMessage)msg).getPayloadText();
            ListResponses.insert(0,s.toString(),null);

            PlayMessage();

            Alert a=new Alert(SMessage.toString(),s.toString(),null,AlertType.INFO);
            a.addCommand(CommandOK);
            a.setCommandListener(this);
            a.setTimeout(AlertTimeOut);
            Display.getDisplay(this).setCurrent(a);
            
          } else {
            //
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } finally {
      TempThread=null;
    }
  }
}