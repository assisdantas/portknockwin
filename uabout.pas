unit uabout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, WinAPI.ShellAPI, Registry,
  Vcl.ExtCtrls;

type
  Tfrmabout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmabout: Tfrmabout;

implementation

{$R *.dfm}

uses
udisplaytext, umain;

function BrowseURL(const URL: string) : boolean;
var
   Browser: string;
begin
   Result := True;
   Browser := '';
   with TRegistry.Create do
   try
     RootKey := HKEY_CLASSES_ROOT;
     Access := KEY_QUERY_VALUE;
     if OpenKey('\htmlfile\shell\open\command', False) then
       Browser := ReadString('') ;
     CloseKey;
   finally
     Free;
   end;
   if Browser = '' then
   begin
     Result := False;
     Exit;
   end;
   Browser := Copy(Browser, Pos('"', Browser) + 1, Length(Browser)) ;
   Browser := Copy(Browser, 1, Pos('"', Browser) - 1) ;
   ShellExecute(0, 'open', PChar(Browser), PChar(URL), nil, SW_SHOW) ;
end;

procedure Tfrmabout.Button1Click(Sender: TObject);
begin
Close;
end;

procedure Tfrmabout.Button2Click(Sender: TObject);
begin
frmloadtext.memo1.Lines.Clear;
frmloadtext.Memo1.Lines.LoadFromFile('LICENSE');
frmloadtext.ShowModal;
end;

procedure Tfrmabout.Button3Click(Sender: TObject);
begin
frmloadtext.memo1.Lines.Clear;
frmloadtext.Memo1.Lines.LoadFromFile('CREDITS');
frmloadtext.ShowModal;
end;

procedure Tfrmabout.Label6Click(Sender: TObject);
begin
BrowseURL('https://github.com/assisdantas/portknockwin');
end;

end.
