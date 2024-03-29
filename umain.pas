unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Vcl.ComCtrls,
  IdAntiFreezeBase, IdAntiFreeze, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  IdUDPBase, IdUDPClient, IniFiles, WinApi.ShellAPI;

type
  aStrings = Array Of String; // Utilize um Tipo de Matriz para Par�metros de Rotinas
  TfrmMain = class(TForm)
    IdTCPClient1: TIdTCPClient;
    Button1: TButton;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    IdAntiFreeze1: TIdAntiFreeze;
    Button2: TButton;
    Button3: TButton;
    Image1: TImage;
    IdUDPClient1: TIdUDPClient;
    GroupBox1: TGroupBox;
    lbledtName: TLabeledEdit;
    lbledtHost: TLabeledEdit;
    lbledtPorts: TLabeledEdit;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    GroupBox4: TGroupBox;
    lbledtprogram: TLabeledEdit;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure loadaddrs;
    procedure clearapp;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Ports: aStrings;
  numport, knostep: integer;
  savedname: string;
  dirapp: string;

implementation

{$R *.dfm}

uses uabout;

Procedure Quebra( Input: String; Separador: String; Var ListString: aStrings);
Var
   Resultado: TStringList;
   idLst: Integer;
Begin
   // Previne que exista elementos maiores que Resultado.Count
   // uma vez que se trata de vari�vel externa.
   SetLength(ListString, 0);

   Resultado := TStringList.Create;
   Try
      // Possibilita que seja utilizada uma sequencia de caracteres como delimitador
      Resultado.Text := StringReplace( Input, Separador, #13#10, [ rfReplaceAll ] );

      // Define novo tamanho para a matriz
      SetLength(ListString, Resultado.Count);
      numport := Resultado.Count;

      For idLst := 0 To Pred( Resultado.Count ) Do
         ListString[ idLst ] := Resultado[ idLst ];
   Finally
      Resultado.Free;
   End;

End;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
if (lbledthost.Text = '') or (lbledtports.Text = '') then
begin
  Application.MessageBox('Some field is empty. Enter the address and ports.', 'Empty', MB_ICONERROR + MB_OK);
  lbledthost.SetFocus;
end else
begin
  ProgressBar1.Position := 0;
  Quebra(lbledtports.Text, ' ', Ports);
  idtcpclient1.Host := lbledthost.text;
  Timer1.Interval := (numport * 100);
  progressbar1.Max := numport;
  knostep := 0;
  memo1.Clear;
  memo1.Lines.Add('[' + FormatDateTime('hh:mm:ss', now) + '] Knocking ports send to: ' + lbledthost.Text);
  timer1.Enabled := True;
end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
arqini: TIniFile;
begin
if (lbledthost.Text = '') or (lbledtports.Text = '') or (lbledtname.Text = '') then
begin
  Application.MessageBox('Some field is empty. Enter the address and ports.', 'Empty', MB_ICONERROR + MB_OK);
  lbledthost.SetFocus;
end else
begin
  arqini := TIniFile.Create(dirapp+'addrs.list');
  arqini.WriteString(lbledtname.Text, 'host', lbledthost.Text);
  arqini.WriteString(lbledtname.Text, 'ports', lbledtports.Text);
  arqini.WriteString(lbledtname.Text, 'program', lbledtprogram.Text);
  arqini.Free;
  loadaddrs();
end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
arqini: TIniFile;
begin
arqini := TIniFile.Create(dirapp+'addrs.list');
if (savedname <> '') then
begin
arqini.EraseSection(savedname);
arqini.Free;

clearapp();
loadaddrs();
end else
begin
  Application.MessageBox('First select a saved item.', 'Select item', MB_ICONASTERISK + MB_OK);
end;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
if OpenDialog1.Execute then
lbledtprogram.Text := OpenDialog1.FileName;
end;

procedure TfrmMain.clearapp;
begin
savedname := '';
lbledtName.Clear;
lbledtHost.Clear;
lbledtPorts.Clear;
lbledtProgram.Clear;
memo1.Clear;
end;

procedure TfrmMain.loadaddrs;
var
arqini: TIniFile;
begin
listbox1.Clear;
arqini := TIniFile.Create(dirapp+'addrs.list');
arqini.ReadSections(ListBox1.Items); //le todas as se��es para o listbox
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
dirapp := ExtractFilePath(Application.ExeName);
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
arqini: TIniFile;
begin
if not FileExists(dirapp+'addrs.list') then
begin
  arqini := TIniFile.Create(dirapp+'addrs.list');
  arqini.Free;
end;
clearapp();
loadaddrs();
lbledtname.SetFocus;
end;

procedure TfrmMain.Image1Click(Sender: TObject);
begin
frmabout.ShowModal;
end;

procedure TfrmMain.ListBox1Click(Sender: TObject);
var
arqini: TIniFile;
begin
savedname := ListBox1.Items[ListBox1.ItemIndex];
lbledtName.Text := savedname;

arqini := TIniFile.Create(dirapp+'addrs.list');

lbledthost.Text := arqini.ReadString(savedname, 'host', 'Could not read the file');
lbledtports.Text := arqini.ReadString(savedname, 'ports', 'Could not read the file');
lbledtprogram.Text := arqini.ReadString(savedname, 'program', 'Could not read the file');

arqini.Free;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
if (knostep < numport) then
begin
  idtcpclient1.Port := StrToInt(Ports[knostep]);

  try
    Memo1.Lines.Add('[' + FormatDateTime('hh:mm:ss', now) + '] Sending packet to port ' + Ports[knostep]);
    idtcpclient1.Connect;
  except
    idtcpclient1.Disconnect;
  end;

  knostep := knostep + 1;
  progressbar1.position := knostep;
end else
begin
  Timer1.Enabled := False;
  memo1.Lines.Add('[' + FormatDateTime('hh:mm:ss', now) + '] Knocking complete! ' + IntToStr(knostep) + ' packets send.');
  Application.MessageBox('Port knock completed.', 'Completed', MB_ICONINFORMATION + MB_OK);

  if (lbledtprogram.Text <> '') then
  begin
    ShellExecute(Application.Handle, 'open', PChar(lbledtprogram.Text), nil, nil, SW_SHOWNORMAL);
    memo1.Lines.Add('[' + FormatDateTime('hh:mm:ss', now) + '] Open program ');
  end;
end;

end;

end.
