program PortKnock;

uses
  Vcl.Forms,
  uprincipal in 'uprincipal.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  uabout in 'uabout.pas' {frmabout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tfrmabout, frmabout);
  Application.Run;
end.
