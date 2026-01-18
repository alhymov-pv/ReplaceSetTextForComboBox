unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm27 = class(TForm)
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    procedure ReplaceWndProcForComboBox1;
  public
    { Public declarations }

  end;

var
  Form27: TForm27;

implementation

{$R *.dfm}

var
  FOriginalWndProc: TFarProc;
function NewComboBoxWndProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  Text: string;
  OldText: string;
  i: Integer;
begin
  if Msg = WM_SETTEXT then begin
    Text := PChar(lParam);
    OldText := Text;
    if Pos(',', Text) > 0 then begin
      i := Pos('Индекс ', Text);
      while i > 0 do begin
        Delete(Text, i, Length('Индекс '));
        i := Pos('Индекс ', Text);
      end;
      if Text <> OldText then  begin
        Result := CallWindowProc(FOriginalWndProc, hWnd, Msg, wParam, LongInt(PChar(Text)));
        Exit;
      end;
    end;
  end;
  Result := CallWindowProc( FOriginalWndProc, hWnd, Msg, wParam, lParam);
end;

procedure TForm27.FormCreate(Sender: TObject);
begin
  ReplaceWndProcForComboBox1;
end;

procedure TForm27.ReplaceWndProcForComboBox1; begin
  FOriginalWndProc := Pointer(SetWindowLong(ComboBox1.Handle, GWL_WNDPROC, LongInt(@NewComboBoxWndProc)));
end;

end.
