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

class HttpServer extends Object {

  public String Name="";
  public String Host="";
  public String Port="";
  public String KPort="";
  public String Authorization="";
  public int Timeout=0;
          
  public HttpServer(String Name, String Host, String Port, String KPort, 
                    String Authorization, int Timeout) {
    super();
    this.Name=Name.toString();
    this.Host=Host.toString();
    this.Port=Port.toString();
    this.KPort=KPort.toString();
    this.Authorization=Authorization.toString();
    this.Timeout=Timeout;
  }
  
}

class HttpServers extends Vector {

  public HttpServers() {
    super();
  }

  public HttpServer AddServer(String Name, String Host, String Port, String KPort, 
                              String Authorization, int Timeout) {
    HttpServer s=new HttpServer(Name,Host,Port,KPort,Authorization,Timeout);
    addElement(s);
    return s;
  }
  
  public void CopyFrom(HttpServers Source)  {
    for (int i=0; i<Source.size(); i++) {
      HttpServer s=(HttpServer)Source.elementAt(i);
      addElement(s);  
    }
  }
}  

class MenuCommandItem extends Object {

  public String Name="";
  public String Desc="";
  public String Text="";
  public String Phone="";
  public String Mode="0";
  public int Index=-1;
  public boolean Enabled=false;

  public MenuCommandItem(String Name, String Desc, String Text, String Phone, boolean Enabled, String Mode) {
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
    Obj.UpdateInterface(false);
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
  
  public void CopyFrom(MenuCommands Source)  {
    for (int i=0; i<Source.size(); i++) {
      MenuCommand m=(MenuCommand)Source.elementAt(i);
      addElement(m);  
    }
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

class Gradient
{
  public static final int VERTICAL = 0;
  public static final int HORIZONTAL = 1;
 
  public static void gradientBox(Graphics g, int color1, int color2, int left, int top, int width, int height, int orientation) {
    
    int max = orientation == VERTICAL ? height : width;
 
    for(int i = 0; i < max; i++) {
     
      int color = midColor(color1, color2, max * (max - 1 - i) / (max - 1), max);
      g.setColor(color);
 
      if(orientation == VERTICAL)
	g.drawLine(left, top + i, left + width - 1, top + i);
      else
	g.drawLine(left + i, top, left + i, top + height - 1);
    }
  }
 
  static int midColor(int color1, int color2, int prop, int max) {
    
    int red = (((color1 >> 16) & 0xff) * prop +
	      ((color2 >> 16) & 0xff) * (max - prop)) / max;
    int green = (((color1 >> 8) & 0xff) * prop +
		((color2 >> 8) & 0xff) * (max - prop)) / max;
    int blue = (((color1 >> 0) & 0xff) * prop +
	       ((color2 >> 0) & 0xff) * (max - prop)) / max;
    int color = red << 16 | green << 8 | blue;
 
    return color;
  }
}

interface Worker {
  void Cancel();
  void Work();
}

class WaitSplash extends Canvas {

  private TaxiMobileClient Obj;
  private String Caption1="";
  private String Caption2="";
  private String Caption3="";
  private int Timeout=0;
  private int MaxTimeout=0;
  private int Interval=100;
  private Worker Worker;
  private Timer Timer;
  private TimerTask Task=null;
          
  public WaitSplash(TaxiMobileClient Obj, Worker W) {
    super();
    this.Obj=Obj;
    this.Worker=W;
    this.setCommandListener(Obj);
    this.Timer=new Timer();
  } 
  
  public void Stop() {
    if (Task!=null) {
      this.removeCommand(Obj.CommandBack);    
      Worker.Cancel();
      Task.cancel();
      Timeout=0; 
      Task=null;
      repaint();
    }
  }
  
  public void Start() {
    
    Stop();
    
    if (Task==null) { 
  
      this.addCommand(Obj.CommandBack);    
      
      Task = new TimerTask() {
        public void run() {
          Timeout = Timeout+Interval;
          repaint();
          if (Timeout>=MaxTimeout) {
            Stop();
          }
        }
      };
      Timer.schedule(Task,0,Interval); 
    }          
  }
  
  public void SetCaptions(String S1, String S2, String S3, int Timeout) {
    Caption1=S1.toString();
    Caption2=S2.toString();
    Caption3=S3.toString();
    this.MaxTimeout=Timeout;
    repaint();
  }
  
  public void paint(Graphics g) {
    
    int w=g.getClipWidth();
    int h=g.getClipHeight();
    int fh=Font.getDefaultFont().getHeight();
    
    g.setColor(0xFFFFFF);
    g.fillRect(0,0,w,h);
    
    Gradient.gradientBox(g,0xFFFFFF,0xFFC300,0,h/2,w,h,Gradient.VERTICAL);

    int x=0;
    int y=0;

    x=w/2;
    
    if (Caption1.equals("")==false) {
      y=h/2-(int)(fh*1.5);
      g.setColor(0x0000FF);
      g.drawString(Caption1.toString(),x,y,Graphics.TOP|Graphics.HCENTER);
    }
    
    
    if (Caption2.equals("")==false) {
      y=h/2;  
      g.setColor(0x000000);
      g.drawString(Caption2.toString(),x,y,Graphics.TOP|Graphics.HCENTER);
    }
    
    if (Caption3.equals("")==false) {
      y=h/2+(int)(fh*1.5);
      g.setColor(0xFF0000);
      g.drawString(Caption3.toString(),x,y,Graphics.TOP|Graphics.HCENTER);
    }  
    
    x=0;
    y=h-fh;

    if ((Timeout<MaxTimeout)&&(Task!=null)) {
      g.setColor(0xCCCCCC);
      int t=(int)Timeout/100;
      g.drawString(Integer.toString(t),x,y,Graphics.TOP|Graphics.LEFT);
    }  
    
  }
    
}

class SendWorker extends Thread implements Worker {

  private TaxiMobileClient Obj;
  private int Mode;
  private String ResponseResult="";
  private boolean ResponseExists=false;
  private MenuResponses Responses=null;
  private String Destination="";
  private WaitSplash Splash=null; 
  private boolean Trucking=true;
  private boolean Canceled=false;
  private HttpConnection Connection=null;
  
  public SendWorker(TaxiMobileClient Obj)  {
    this.Obj=Obj;
    Responses = new MenuResponses();
    this.start();
  }
  
  public void SetSplash(WaitSplash Splash) {
    this.Splash=Splash;
  }
  
  public void SetMode(int Mode) {
    this.Mode=Mode;
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

  public boolean HttpServeSend(HttpServer Server) {
    String s="";
    boolean ret=false;
    HttpConnection c=null;
    OutputStream os=null;
    DataInputStream dis=null;
    Reader r=null;
    Writer w=null;
    StringBuffer b = new StringBuffer();
    try {
      try {
        
        String url=Obj.HttpUrl.toString();
        url=Obj.Replace(url.toString(),"%HOST",Server.Host.toString()).toString();
        url=Obj.Replace(url.toString(),"%PORT",Server.Port.toString()).toString();
        
        String xml="<d><u>"+Obj.Login.toString().trim()+"</u><t>"+Obj.CurrentText.toString()+"</t>";

        xml=CompressRequest(xml.toString()).toString();
        xml=EncodeRequest(xml.toString()).toString();

        c=(HttpConnection)Connector.open(url);
        c.setRequestMethod(HttpConnection.POST);
        c.setRequestProperty("Content-Length",Integer.toString(xml.length()));
        
        if (Server.Authorization.equals("")==false) {
          c.setRequestProperty("Authorization",Server.Authorization.toString());
        }  

        Connection=c;
        if (Splash!=null) {
          s=Obj.CurrentName.toString();
          if (s.equals("")) {
            s=Obj.CurrentText.toString();
          }
          Splash.SetCaptions(Server.Name.toString(),
                             Obj.HttpCaption.toString(), 
                             s.toString(),Server.Timeout);
          Splash.Start();           
        }
                
        os=c.openOutputStream();

        w=new OutputStreamWriter(os,Obj.Encoding.toString());
        w.write(xml.toString());

        int respCode=c.getResponseCode();
        if (respCode==HttpConnection.HTTP_OK) {
          try {
            ResponseExists=false;
            dis=c.openDataInputStream();
            r=new InputStreamReader(dis,Obj.Encoding.toString());
            int ch;
            while((ch = r.read()) != -1) {
              b.append((char)ch);
            }
            s=b.toString();
            s=DecodeResponse(s.toString()).toString();
            s=DecompressResponse(s.toString()).toString();
            if (s.equals("".toString())==false) {
              try {
                ByteArrayInputStream bis=new ByteArrayInputStream(s.getBytes(Obj.Encoding.toString()));
                InputStreamReader Reader=new InputStreamReader(bis,Obj.Encoding.toString());
                XmlParser Parser = new XmlParser(Reader);
                ReadResponse(Parser,"");
                ret=true;
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
        } else {
          ResponseResult=Integer.toString(respCode)+" "+c.getResponseMessage().toString();
        }
      } finally {
        if (Splash!=null) {
          Splash.Stop();
        }
        if (Canceled==false) {
          if (os!=null) { os.close(); os=null; }
          if (c!=null) { c.close(); c=null; }
          Connection=null; 
        } else 
          Canceled=false; 
      }
    } catch(Exception e) {
      ResponseResult=e.getMessage();
    }
    return ret;
  }

  public boolean HttpSend() throws Exception {
 
    boolean ret=false;

    for (int i=0; i<Obj.Servers.size(); i++) {
      HttpServer s=(HttpServer)Obj.Servers.elementAt(i);
      Destination=s.Name.toString();
      ret=HttpServeSend(s);
      if (ret) {
        Obj.CurrentServer=s;
        Obj.Servers.removeElementAt(i);
        Obj.Servers.insertElementAt(s,0);
        break;
      }
    }
    
    return ret;
   
  }
  
  public boolean SmsSend() throws Exception {
    boolean ret=false;
    MessageConnection c=null;
    try {
      String url=Obj.SmsUrl.toString();
      String text=Obj.SmsText.toString();
      text=Obj.Replace(text.toString(),"%TEXT",Obj.CurrentText.toString()).toString();
      c=(MessageConnection)Connector.open(url.toString());
      TextMessage msg=(TextMessage)c.newMessage(MessageConnection.TEXT_MESSAGE);
      msg.setAddress(url.toString());
      msg.setPayloadText(text.toString());

      if (Splash!=null) {
        String s=Obj.CurrentName.toString();
        if (s.equals("")) {
          s=Obj.CurrentText.toString();
        }
        Splash.SetCaptions(Obj.MainServer.toString(),
                           Obj.SmsCaption.toString(), 
                           s.toString(),Obj.DefaultTimeout);
        Splash.Start();           
      }
      
      c.send(msg);
      ret=true;
    } finally {
      if (Splash!=null) {
        Splash.Stop();
      }
      if (c!=null) {
        c.close();
      }
    }
    return ret;
  }

  public boolean Call() throws Exception {
    boolean ret=false;
    String url=Obj.CallUrl.toString();
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

  public void Work() {
    String Message="";
    boolean Success=false;
    ResponseResult="";
    Responses.removeAllElements();
    Destination="";
    try {
      switch (Mode) {
        case 0:
          Message=Obj.SmsMessage.toString();
          Success=SmsSend();
          break;
        case 1:
          Message=Obj.HttpMessage.toString();
          Success=HttpSend();
          break;
        case 2:
          Message=Obj.CallMessage.toString();
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

    Alert a=new Alert(AlertTitle.toString(),AlertText.toString(),null,at);
    a.addCommand(Obj.CommandOK);
    a.setCommandListener(Obj);
    a.setTimeout(Obj.AlertTimeOut);
    Display.getDisplay(Obj).setCurrent(a);
  }
  
  public void Cancel() {
    try {
      Canceled=true;      
      if (Connection!=null) {
        Connection.close();
        Connection=null;
      }
    }
    catch (Exception e) {}     
  }
  
  public synchronized void run() {
    while (Trucking) {
      try { wait(); }
      catch (InterruptedException ie) {}
      if (Trucking) Work();
    }
  }
  
  public synchronized void Go() {
    notify();
  }
  
  public synchronized void Stop() {
    Trucking = false;
    notify();
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
        if ((Obj.Keep==true)&&(Obj.CurrentServer!=null)) {
          try {
            if (First==false) {
              sleep(5000);
            } else {
              First=false;
            }
            String url=Obj.HttpKeepUrl.toString();
            url=Obj.Replace(url.toString(),"%HOST",Obj.CurrentServer.Host.toString()).toString();
            url=Obj.Replace(url.toString(),"%KPORT",Obj.CurrentServer.KPort.toString()).toString();
            
            try {
              sc=(SocketConnection)Connector.open(url.toString());
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
              if (sc!=null) {
                sc.close();
                sc=null;
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

class AudioPlayer extends Object implements Runnable {
  
  private Thread current;
  private Player player=null;
  private TaxiMobileClient Obj;

  public AudioPlayer(TaxiMobileClient Obj)  {
    this.Obj=Obj;
  }

  public void Stop() {
    try {
      try {
       if (player != null) {
         if (player.getState() == Player.STARTED) {
           player.stop();
         }
         if (player.getState() == Player.PREFETCHED) {
           player.deallocate();
         }
         if (player.getState() == Player.REALIZED || 
	     player.getState() == Player.UNREALIZED) {
           player.close();
         }
        }
      } finally {
        player = null;  
      }  
    } catch (Exception e) {
    }
  }
  
  public void Start() {
    current = new Thread(this);
    current.start();
  }
  
  public void run() {
 
    try {
      
      Stop(); 
      
      player = Manager.createPlayer(getClass().getResourceAsStream("message.mp3"),"audio/mpeg");
      player.realize(); 
      
      VolumeControl vc=(VolumeControl)player.getControl("VolumeControl");
      
      if (vc!=null) {
        vc.setMute(false);
        vc.setLevel(100);
      }

      player.setLoopCount(3); 
      player.prefetch(); 
      player.start(); 
      
      Display.getDisplay(Obj).vibrate(3); 
      
    } catch (Exception e) {
      
      e.printStackTrace();
      
    }  
  }

}

public class TaxiMobileClient extends MIDlet implements CommandListener, Runnable, MessageListener {

  public Vector Commands;
  public Vector History;
  public TextBox TextBoxText;
  public Form FormSetup;
  public Form FormUpdate;
  public List ListResponse;
  public List ListResponses;
  private KeepConnection KConnection;
  private MessageConnection MConnection=null;
  private AudioPlayer Player=null;
  public String Login="";
  public int Mode=1;
  public int AlertKind=0;
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
  private Alert AlertMenuNotFound;
  public HttpServers Servers;
  public HttpServer CurrentServer=null;
  private SendWorker Worker=null;
  private WaitSplash Splash;
  
  public int AlertTimeOut=5000;
  public boolean Keep=false;
  private int ResponsesMaxCount=10;
  public int DefaultTimeout=10000;
  
  private boolean ConfigExists=false;
  private String Config="";
  private String UpdateUrl="http://server:port/config.xml";
 // private String UpdateUrl="http://ataxi24.ru/cfg_15.xml";
 // private String UpdateUrl="http://109.195.67.214:50000/files/config.xml";

  public String SmsCaption="сообщение";
  public String SmsUrl="";
  public String SmsText="";
  public String SmsMessage="";
  public String SmsWaitUrl="";

  public String HttpCaption="запрос";
  public String HttpUrl="";
  public String HttpMessage="";
  public String HttpKeepUrl="";
  
  public String CallCaption="вызов";
  public String CallUrl="";
  public String CallMessage="";
  
  public String ErrorCaption="Ошибка";
  private String InfoCaption="Информация";
  private String WarnCaption="Предупреждение";
  private String MenuNotFound="Меню не найдено";
  private String UnknownMessage="Неизвестный формат";
  private String ConfigSuccessLoaded="Конфигурация успешно загружена";
  private String InvalidVersion="Неверная версия";

  private String OKCaption="ОК";
  private String CancelCaption="Отмена";
  private String BackCaption="Назад";
  private String ExitCaption="Выход";
  private String UpdateCaption="Обновление";
  private String UrlCaption="Адрес";
  private String LoginCaption="Логин";
  private String ResponseCaption="Ответ";
  private String ResponsesCaption="Ответы";
  private String ConnectionCaption="Соединение";
  private String CodeCaption="Текст";
  private String ModeCaption="Режим";
  private String SetupCaption="Настройка";
  private String KeepCaption="Постоянно";
  private String MessageCaption="Message";
  private String VersionCaption="Версия";
  
  public String Encoding="UTF-8";
  private String GeneralStore="GeneralStore";
  private String ConfigStore="ConfigStore";
  private String ConfigVersion="";
  private String AppVersion="";
  public String MainServer="Основной сервер";

  public TaxiMobileClient()
  {
    Menus=new MenuCommands();
    Servers=new HttpServers();
    Commands=new Vector();
    Lists=new Vector();
    History=new Vector();
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
    if (ListResponses.size()>=ResponsesMaxCount) {
      int C=ListResponses.size();
      for (int i=C; i>=ResponsesMaxCount; i--) {
        ListResponses.delete(i-1);
      }
    }
  }

  private void LoadFromStore() {

    RecordStore rec = null;
    DataInputStream dis = null;
    try {
      rec = RecordStore.openRecordStore(GeneralStore.toString(),true);
      if (rec.getNumRecords() > 0) {
        dis = new DataInputStream(new ByteArrayInputStream(rec.getRecord(1)));

        UpdateUrl=dis.readUTF();
        Login=dis.readUTF();
        Mode=dis.readInt();
        Keep=dis.readBoolean();
        int c=dis.readInt();
        for (int i=0; i<c; i++) {
          String s=dis.readUTF();
          ListResponses.append(s.toString(),null);
        }
        
        dis.close();
        dis=null;
      }
      rec.closeRecordStore();
      rec=null;
      
      rec = RecordStore.openRecordStore(ConfigStore.toString(),true);
      if (rec.getNumRecords() > 0) {
        dis = new DataInputStream(new ByteArrayInputStream(rec.getRecord(1)));

        String s1=dis.readUTF();
        ConfigExists=TryParseConfig(s1.toString());
        if (ConfigExists) {
          Config=s1.toString();
        }
        
        dis.close();
        dis=null;
      }
      rec.closeRecordStore();
      rec=null;
      
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

  private void DeleteRecord(String name) {
    String[] array = RecordStore.listRecordStores();
    if (array != null) {
      for (int i = 0; i < array.length; i++) {
        if (name.equals(array[i])) {
          try {
            RecordStore.deleteRecordStore(array[i]);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  private void SaveToStore() {

    RecordStore rec = null;
    ByteArrayOutputStream bos = null;
    DataOutputStream dos = null;
    try {
      
      bos = new ByteArrayOutputStream();
      dos = new DataOutputStream(bos);

      dos.writeUTF(UpdateUrl.toString());
      dos.writeUTF(Login.toString());
      dos.writeInt(Mode);
      dos.writeBoolean(Keep);
      
      dos.writeInt(ListResponses.size());
      for (int i=0; i<ListResponses.size(); i++) {
        String s=ListResponses.getString(i).toString();  
        dos.writeUTF(s.toString());
      }
      
      dos.flush();
      
      DeleteRecord(GeneralStore.toString());      
      rec = RecordStore.openRecordStore(GeneralStore.toString(), true);
      byte[] b1 = bos.toByteArray();
      rec.addRecord(b1, 0, b1.length);
      rec.closeRecordStore();
      dos.close();
      bos.close();
      b1 = null;
      dos = null;
      bos = null;

      
      bos = new ByteArrayOutputStream();
      dos = new DataOutputStream(bos);

      String s1="";
      if (ConfigExists) {
        s1=Config.toString();
      }
      dos.writeUTF(s1.toString());
      dos.flush();
      
      DeleteRecord(ConfigStore.toString());
      rec = RecordStore.openRecordStore(ConfigStore.toString(), true);
      byte[] b2 = bos.toByteArray();
      rec.addRecord(b2, 0, b2.length);
      rec.closeRecordStore();
      dos.close();
      bos.close();
      b2 = null;
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

  private String GetConfig() throws Exception {
    String ret="";
    HttpConnection c=null;
    OutputStream os=null;
    DataInputStream dis=null;
    Reader r=null;
    StringBuffer b = new StringBuffer();
    try {
      String url=UpdateUrl.toString();

      c=(HttpConnection)Connector.open(url);
      c.setRequestMethod(HttpConnection.GET);

      os=c.openOutputStream();
      
      int respCode=c.getResponseCode();
      if (respCode==HttpConnection.HTTP_OK) {
        try {
          dis=c.openDataInputStream();
          r=new InputStreamReader(dis,Encoding.toString());
          int ch;
          while((ch = r.read()) != -1) {
            b.append((char)ch);
          }
          ret=b.toString();
        } finally {
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
 
  public void ParseConfig(XmlParser Parser, String Ident, MenuCommands Ms, HttpServers Hs) throws Exception {
 
    boolean leave = false;
    do {
      ParseEvent Event = Parser.read();
      String n="";
      String d="";
      String s="";
      String c="";
      String e="";
      String v="";
      String md="0";
      int t=0;
      switch ( Event.getType() ) {
        case Xml.START_TAG:
	  if ("config".equals(Event.getName())) {
            ConfigVersion=Event.getValueDefault("version","").toString();
            ParseConfig(Parser,"",Ms,Hs);
          } else if ("sms".equals(Event.getName())) {
            SmsCaption=Event.getValueDefault("name",SmsCaption.toString()).toString();
            SmsUrl=Event.getValueDefault("url",SmsUrl.toString()).toString();
            SmsText=Event.getValueDefault("text",SmsText.toString()).toString();
            SmsMessage=Event.getValueDefault("message",SmsMessage.toString()).toString();
            SmsWaitUrl=Event.getValueDefault("waiturl",SmsWaitUrl.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("http".equals(Event.getName())) {
            HttpCaption=Event.getValueDefault("name",HttpCaption.toString()).toString();
            HttpUrl=Event.getValueDefault("url",HttpUrl.toString()).toString();
            HttpMessage=Event.getValueDefault("message",HttpMessage.toString()).toString();
            HttpKeepUrl=Event.getValueDefault("keepurl",HttpKeepUrl.toString()).toString();
            ParseConfig(Parser,"http",Ms,Hs);
          } else if ("http".equals(Ident.toString())) {   
  	    if ("server".equals(Event.getName())) {
              n=Event.getValueDefault("name","").toString();
              d=Event.getValueDefault("host","").toString();
              s=Event.getValueDefault("port","").toString();
              c=Event.getValueDefault("kport","").toString();
              e=Event.getValueDefault("authorization","").toString();
              v=Event.getValueDefault("timeout",Integer.toString(DefaultTimeout)).toString();
              t=Integer.parseInt(v);
              Hs.AddServer(n,d,s,c,e,t);
              ParseConfig(Parser,Ident,Ms,Hs);
            } else   
              ParseConfig(Parser,"",Ms,Hs);
          } else if ("call".equals(Event.getName())) {
            CallCaption=Event.getValueDefault("name",CallCaption.toString()).toString();
            CallUrl=Event.getValueDefault("url",CallUrl.toString()).toString();
            CallMessage=Event.getValueDefault("message",CallMessage.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("login".equals(Event.getName())) {
            LoginCaption=Event.getValueDefault("name",LoginCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("response".equals(Event.getName())) {
            ResponseCaption=Event.getValueDefault("name",ResponseCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("mode".equals(Event.getName())) {
            ModeCaption=Event.getValueDefault("name",ModeCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("ok".equals(Event.getName())) {
            OKCaption=Event.getValueDefault("name",OKCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("cancel".equals(Event.getName())) {
            CancelCaption=Event.getValueDefault("name",CancelCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("back".equals(Event.getName())) {
            BackCaption=Event.getValueDefault("name",BackCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("process".equals(Event.getName())) {
            //ProcessCaption=Event.getValueDefault("name",ProcessCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("connection".equals(Event.getName())) {
            ConnectionCaption=Event.getValueDefault("name",ConnectionCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("keep".equals(Event.getName())) {
            KeepCaption=Event.getValueDefault("name",KeepCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("message".equals(Event.getName())) {
            MessageCaption=Event.getValueDefault("name",MessageCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("exit".equals(Event.getName())) {
            ExitCaption=Event.getValueDefault("name",ExitCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("version".equals(Event.getName())) {
            VersionCaption=Event.getValueDefault("name",VersionCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("url".equals(Event.getName())) {
            UrlCaption=Event.getValueDefault("name",UrlCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("error".equals(Event.getName())) {
            ErrorCaption=Event.getValueDefault("name",ErrorCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("info".equals(Event.getName())) {
            InfoCaption=Event.getValueDefault("name",InfoCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("warn".equals(Event.getName())) {
            WarnCaption=Event.getValueDefault("name",WarnCaption.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("menunotfound".equals(Event.getName())) {
            MenuNotFound=Event.getValueDefault("name",MenuNotFound.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("unknownmessage".equals(Event.getName())) {
            UnknownMessage=Event.getValueDefault("name",UnknownMessage.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("configsuccessloaded".equals(Event.getName())) {
            ConfigSuccessLoaded=Event.getValueDefault("name",ConfigSuccessLoaded.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("invalidversion".equals(Event.getName())) {
            InvalidVersion=Event.getValueDefault("name",InvalidVersion.toString()).toString();
            ParseConfig(Parser,"",Ms,Hs);
	  } else if ("menu".equals(Event.getName())) {
            ParseConfig(Parser,Event.getName(),Ms,Hs);
	  } else if ("menu".equals(Ident.toString())) {
  	    if ("code".equals(Event.getName())) {
              n=Event.getValueDefault("name",CodeCaption.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              CodeCaption=n.toString();
              Ms.AddCommand(n,d,0);
              ParseConfig(Parser,Ident,Ms,Hs);
	    } else if ("list".equals(Event.getName()))  {
              n=Event.getValueDefault("name","").toString();
              d=Event.getValueDefault("desc","").toString();
              Ms.AddCommand(n,d,1);
              ParseConfig(Parser,Event.getName(),Ms,Hs);
            } else if ("responses".equals(Event.getName())) {
              n=Event.getValueDefault("name",ResponsesCaption.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              ResponsesCaption=n.toString();
              s=Event.getValueDefault("maxcount",Integer.toString(ResponsesMaxCount)).toString();
              ResponsesMaxCount=Integer.parseInt(s) ;
              Ms.AddCommand(n,d,2);
              ParseConfig(Parser,Ident,Ms,Hs);
	    } else if ("setup".equals(Event.getName())) {
              n=Event.getValueDefault("name",SetupCaption.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              SetupCaption=n.toString();
              Ms.AddCommand(n,d,3);
              ParseConfig(Parser,Ident,Ms,Hs);
	    } else if ("update".equals(Event.getName())) {
              n=Event.getValueDefault("name",UpdateCaption.toString()).toString();
              d=Event.getValueDefault("desc","").toString();
              UpdateCaption=n.toString();
              UpdateUrl=Event.getValueDefault("url",UpdateUrl.toString()).toString();
              Ms.AddCommand(n,d,4);
              ParseConfig(Parser,Ident,Ms,Hs);
	    } else 
              ParseConfig(Parser,"",Ms,Hs);
          } else if ("list".equals(Ident.toString())) {
            if ("item".equals(Event.getName())) {
              n=Event.getValueDefault("name","Item").toString();
              d=Event.getValueDefault("desc","").toString();
              c=Event.getValueDefault("text","").toString();
              s=Event.getValueDefault("phone","").toString();
              e=Event.getValueDefault("enabled","1").toString();
              md=Event.getValueDefault("mode",md.toString()).toString();
              MenuCommand m=(MenuCommand)Ms.lastElement();
              if (e.equals("1")) {
                m.AddItem(n,d,c,s,true,md);
              } else {
                m.AddItem(n,d,c,s,false,md);
              }
              ParseConfig(Parser,Ident,Ms,Hs);
            } else 
              ParseConfig(Parser,"menu",Ms,Hs);
          } else
             ParseConfig(Parser,"",Ms,Hs); 

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
  
  private boolean TryParseConfig(String s) throws Exception {
    
    boolean ret=false;

    if (s.trim().equals("")==false) {
      
      ByteArrayInputStream bis=new ByteArrayInputStream(s.getBytes(Encoding.toString()));
      InputStreamReader r=new InputStreamReader(bis,Encoding.toString());
      XmlParser p=new XmlParser(r);
      
      MenuCommands Ms=new MenuCommands();
      HttpServers Hs=new HttpServers();
      
      ParseConfig(p,"",Ms,Hs);
      
      ret=AppVersion.equals(ConfigVersion.toString());
      
      if (ret) {
        ListResponses.removeCommand(CommandOK);
        ListResponses.removeCommand(CommandBack);
        ListResponses.setTitle(ResponsesCaption.toString());
      
        Commands.removeAllElements();
        
        CommandExit=new Command(ExitCaption.toString(),Command.EXIT,99);
        Commands.addElement(CommandExit);
        
/*        CommandTest=new Command("Test",Command.SCREEN,98);
        Commands.addElement(CommandTest); */
  
        CommandOK=new Command(OKCaption.toString(),Command.OK,1);
        CommandCancel=new Command(CancelCaption.toString(),Command.CANCEL,2);
        CommandBack=new Command(BackCaption.toString(),Command.BACK,3);

        Lists.removeAllElements();
 
        Menus.removeAllElements();
        Menus.CopyFrom(Ms);
        
        Servers.removeAllElements();;
        Servers.CopyFrom(Hs);
        
        
      } else {
        Alert a=new Alert(WarnCaption.toString(),InvalidVersion.toString(),null,AlertType.WARNING);
        a.addCommand(CommandOK);
        a.setCommandListener(this);
        Display.getDisplay(this).setCurrent(a);
      }
      
    }
    
    return ret;
  }
  
  private boolean TryGetConfig() {
    
    boolean ret=false;
    try {

      String s=GetConfig().toString(); 
      ConfigExists=TryParseConfig(s);
      if (ConfigExists) {
        Config=s.toString();
        SaveToStore();

      }
      ret=ConfigExists;
      
    } catch (Exception e) {
      Alert a=new Alert(ErrorCaption.toString(),e.getMessage().toString(),null,AlertType.ERROR);
      a.addCommand(CommandOK);
      a.setCommandListener(this);
      Display.getDisplay(this).setCurrent(a);
    }  
    return ret;
  }
  
  public void UpdateInterface(boolean First) {
    
    if (FormUpdate!=null) { FormUpdate=null; }
      
    FormUpdate=new Form(UpdateCaption.toString());
    StringItem i=new StringItem(VersionCaption.toString(),AppVersion.toString());
    FormUpdate.append(i);
    
    TextField t1=new TextField(UrlCaption.toString(),UpdateUrl.toString(),250,TextField.ANY);
    FormUpdate.append(t1);

    FormUpdate.addCommand(CommandOK);
    if (First) {
      FormUpdate.addCommand(CommandExit);
    } else {
      FormUpdate.addCommand(CommandBack);
    }  
    FormUpdate.setCommandListener(this);

    Display.getDisplay(this).setCurrent(FormUpdate);
    History.addElement(FormUpdate);
  }
  
  private void DefaultInterface(boolean First) {

    try {

      if (TextBoxText!=null) { TextBoxText=null; }
      
      TextBoxText=new TextBox(CodeCaption.toString(),"",256,TextField.NUMERIC&TextField.DECIMAL);
      TextBoxText.addCommand(CommandOK);
      TextBoxText.addCommand(CommandBack);
      TextBoxText.setCommandListener(this);

      ChoiceGroup cg=new ChoiceGroup(ModeCaption.toString(),ChoiceGroup.EXCLUSIVE);
      cg.append(SmsCaption.toString(),null);
      cg.append(HttpCaption.toString(),null);
  //     cg.append(CallCaption.toString(),null);
      cg.setSelectedIndex(Mode,true);

      if (FormSetup!=null) { FormSetup=null; }

      FormSetup=new Form(SetupCaption.toString());
      FormSetup.append(cg);
      TextField t1=new TextField(LoginCaption.toString(),Login.toString(),100,TextField.ANY);
      FormSetup.append(t1);
      ChoiceGroup cg2=new ChoiceGroup(ConnectionCaption.toString(),ChoiceGroup.MULTIPLE);
      cg2.append(KeepCaption.toString(),null);
      boolean get[]=new boolean[cg2.size()];
      get[0]=Keep;
      cg2.setSelectedFlags(get);
      FormSetup.append(cg2);

      FormSetup.addCommand(CommandOK);
      FormSetup.addCommand(CommandBack);
      FormSetup.setCommandListener(this);

      if (ListResponse!=null) { ListResponse=null; }
              
      ListResponse=new List(ResponseCaption,List.IMPLICIT);
      ListResponse.addCommand(CommandOK);
      ListResponse.addCommand(CommandBack);
      ListResponse.setCommandListener(this);

      ListResponses.addCommand(CommandOK);
      ListResponses.addCommand(CommandBack);
      ListResponses.setCommandListener(this);

      if (KConnection!=null) {  KConnection=null; }

      KConnection=new KeepConnection(this);

      if (SmsWaitUrl.trim().equals("".toString())==false) {
        if (MConnection!=null) {
          MConnection.close();
          MConnection=null;
        }
        MConnection=(MessageConnection)Connector.open(SmsWaitUrl.toString(),Connector.READ);
        MConnection.setMessageListener(this);
      }  
      
      if (Worker!=null) { Worker=null; }
      
      Worker=new SendWorker(this);
      
      if (Splash!=null) { Splash=null; }
      
      Splash=new WaitSplash(this,Worker);
        
      Menus.BuildCommands(Commands);
      Menus.BuildLists(Lists);

      MenuCommand Item=Menus.FirstList();
      if (Item!=null) {
        Item.BuildListItems(this);
        Item.SetCommands(Commands);
        Item.GetList().setCommandListener(this);
        Display.getDisplay(this).setCurrent(Item.GetList());
        History.addElement(Item.GetList());
      } else {
        AlertMenuNotFound=new Alert(ErrorCaption.toString(),MenuNotFound.toString(),null,AlertType.ERROR);
        AlertMenuNotFound.addCommand(CommandOK);
        AlertMenuNotFound.setCommandListener(this);
        Display.getDisplay(this).setCurrent(AlertMenuNotFound);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
          
          
  public void startApp() 
  {
    try {

      CommandExit=new Command(ExitCaption.toString(),Command.EXIT,99);
      Commands.addElement(CommandExit);

      CommandOK=new Command(OKCaption.toString(),Command.OK,1);
      CommandCancel=new Command(CancelCaption.toString(),Command.CANCEL,2);
      CommandBack=new Command(BackCaption.toString(),Command.BACK,3);
      
      AppVersion=this.getAppProperty("MIDlet-Version"); 
      
      ListResponses=new List(ResponsesCaption.toString(),List.IMPLICIT);
      
      Player=new AudioPlayer(this);
      
      LoadFromStore();
      
      if (ConfigExists==false)  
        UpdateInterface(true);
      else
        DefaultInterface(true);
      

    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void pauseApp() {  }

  public void destroyApp(boolean unconditional) {
    if (Worker!=null)  {
      Worker.Stop();
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
    } else if (c==CommandOK) {
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
        if (Splash!=null) {
          Display.getDisplay(this).setCurrent(Splash);
        }
        if (Worker!=null) {
          Worker.SetSplash(Splash);
          Worker.SetMode(Mode);
          Worker.Go();
        }  
      } else if (s==FormUpdate) {
        UpdateUrl=((TextField)FormUpdate.get(1)).getString(); 
        if (TryGetConfig()) {
          DefaultInterface(false);
        }
      } else if (s==FormSetup) {
        Mode=((ChoiceGroup)FormSetup.get(0)).getSelectedIndex();
        Login=((TextField)FormSetup.get(1)).getString();
        ChoiceGroup cg=((ChoiceGroup)FormSetup.get(2));
        boolean get[]=new boolean[cg.size()];
        cg.getSelectedFlags(get);
        Keep=get[0];
        if (Keep==false) {
          KConnection.stop();
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
      if (s==FormUpdate) {
        HistoryBack(1);
      } else if ((s==FormSetup)||(s==ListResponse)||(s==ListResponses)) {
        HistoryBack(1);
      } else if (s==Splash) {
        if (Worker!=null) {
          Worker.Cancel();
        } 
        if (Splash!=null) {
          Splash.Stop();
        }  
      } else {
        if (s instanceof Alert) {
          if (s==AlertMenuNotFound) 
            commandAction(CommandExit,s);
          else {
            HistoryBack(0);
          /*  switch (AlertKind) {
              case 1: 
                Player.Start(); 
                break;
              default: ;
            }           
            AlertKind=0;*/
          }  
        } else {
          if (Mode!=2) {
            HistoryBack(1);
          } else {
            HistoryBack(0);
          }
        }
      }
    } else if (c==CommandTest) {

      Player.Start();
      
/*      try {
        MessageConnection mc=null;
        try {
          //String url="sms://6260001:5000";
           String url="sms://123456789:55555";
          // String url="sms://6260000:55555";
          //String url="sms://+79504248277:5003";
          //String url="sms://+79029232332:5003";
          mc=(MessageConnection)Connector.open(url.toString());
          TextMessage msg1=(TextMessage)mc.newMessage(MessageConnection.TEXT_MESSAGE);
          msg1.setAddress(url.toString());
          msg1.setPayloadText("qwerty".toString());
          mc.send(msg1);
        } finally {
          if (mc!=null) {
          //  TestMessage(mc);  
            mc.close();
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }*/

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

  public void ReceiveMessage(MessageConnection MConn) {

    Message msg=null;
    MenuResponses res=new MenuResponses();
    try {
      msg=MConn.receive();
      if (msg!=null) {
        String s="";  
        if (msg instanceof TextMessage) {
          s=((TextMessage)msg).getPayloadText();
          res.AddResponse(s.toString(),false);
        } else {
          res.AddResponse(UnknownMessage.toString(),false);
        }
      }

      if (res.size()>0) {

        DeleteResponses();
          
        if (res.size()>1) {
            
          ListResponse.deleteAll();

          for (int i=0; i<res.size(); i++) {
            MenuResponse m=(MenuResponse)res.elementAt(i);
            ListResponse.append(m.Value.toString(),null);
            ListResponses.insert(0,m.Value.toString(),null);
          }

          if (ListResponse.size()>0) {
            ListResponse.setTitle(CurrentName.toString());
            Display.getDisplay(this).setCurrent(ListResponse);
            History.addElement(ListResponse);
          }
            
        } else {
            
          String s=((MenuResponse)res.elementAt(0)).Value.toString();
          ListResponses.insert(0,s.toString(),null);
            
          Alert a=new Alert(MessageCaption.toString(),s.toString(),null,AlertType.INFO);
          a.addCommand(CommandOK);
          a.setCommandListener(this);
          a.setTimeout(AlertTimeOut);
          Display.getDisplay(this).setCurrent(a);
          
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  public void notifyIncomingMessage(MessageConnection conn) {

    synchronized (this) {
      AlertKind=1;
      ReceiveMessage(conn);
      Player.Start();
    }
      
  }

  public void run() {
  }
}