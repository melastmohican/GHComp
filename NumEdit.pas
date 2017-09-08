unit NumEdit;

{$MODE Delphi}

{$IFNDEF VER100}
{$ObjExportAll On}
{$ENDIF}
{$R-}
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TEnterPressEvent = procedure(Sender: TObject) of object;

  TNumEdit = class(TWinControl)
  private
    FHex: Boolean;
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FIncrement: LongInt;
    FButton: TUpDown;
    FEdit: TEdit;
    FEditorEnabled: Boolean;
    FOnEnterPressed: TEnterPressEvent;
    FOnChange: TNotifyEvent;
    function GetMinHeight: Integer;
    function GetValue: LongInt;
    function CheckValue (NewValue: LongInt): LongInt;
    procedure SetValue (NewValue: LongInt);
    function GetEditorBorderStyle: TBorderStyle;
    procedure SetEditorBorderStyle(NewValue: TBorderStyle);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure EditorChange(Sender: TObject);
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure UpDownClick (Sender: TObject; Button: TUDBtnType); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    property Button: TUpDown read FButton;
  published
    property Color;
    property DragCursor;
    property DragMode;
    property EditorBorderStyle: TBorderStyle read GetEditorBorderStyle write SetEditorBorderStyle;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property Font;
    property Hexadecimal: Boolean read FHex write FHex;
    property Increment: LongInt read FIncrement write FIncrement default 1;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Value: LongInt read GetValue write SetValue;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange  write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnEnterPressed: TEnterPressEvent read FOnEnterPressed write FOnEnterPressed;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('GHComp', [TNumEdit]);
end;

constructor TNumEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEdit := TEdit.Create (Self);
  FButton := TUpDown.Create (Self);
  FButton.Min := -32768;
  FButton.Max := 32767;
  FButton.Position := 0;
  Width := FEdit.Width;
  Height := FEdit.Height;
  FEdit.Visible := True;
  FEdit.Parent := Self;
  FEdit.OnChange := EditorChange;
  FEdit.OnKeyDown := EditKeyDown;
  FEdit.OnKeyPress := EditKeyPress;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.OnClick := UpDownClick;
  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
  FIncrement := 1;
  FEditorEnabled := True;
  FHex := False;
end;

destructor TNumEdit.Destroy;
begin
  FEdit := nil;
  FButton := nil;
  inherited Destroy;
end;

procedure TNumEdit.SetFocus;
begin
  FEdit.SetFocus;
end;

procedure TNumEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TNumEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP then UpDownClick (Self,btNext)
  else if Key = VK_DOWN then UpDownClick (Self,btPrev)
  else if (Key = VK_RETURN) and Assigned(OnEnterPressed) then OnEnterPressed(Self);
  inherited KeyDown(Key, Shift);
end;

procedure TNumEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TNumEdit.IsValidChar(Key: Char): Boolean;
begin
  if FHex then
   Result := (Key in [DecimalSeparator, '+', '-', '0'..'9', 'A'..'F']) or ((Key < #32) and (Key <> Chr(VK_RETURN)))
  else
   Result := (Key in [DecimalSeparator, '+', '-', '0'..'9']) or ((Key < #32) and (Key <> Chr(VK_RETURN)));
  if not FEditorEnabled and Result and ((Key >= #32) or
      (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;

end;

procedure TNumEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TNumEdit.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure TNumEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
  if Height < MinHeight then
    Height := MinHeight
  else if FButton <> nil then
  begin
   FEdit.SetBounds (0, 1, Width - FButton.Width, Height);
   FButton.SetBounds (Width - FButton.Width, 0, FButton.Width, Height);
  end;
end;

function TNumEdit.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  //I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  //I := SysMetrics.tmHeight;
  //if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight {+ I div 4 }+ GetSystemMetrics(SM_CYBORDER) * 2 {+ 2};
end;


procedure TNumEdit.UpDownClick (Sender: TObject;  Button: TUDBtnType);
begin
  if Button = btNext then
    Value := Value + FIncrement
  else
    Value := Value - FIncrement;
end;

procedure TNumEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  if CheckValue (Value) <> Value then
    SetValue (Value);
end;

function TNumEdit.GetValue: LongInt;
begin
  try
    if FHex then
      Result := StrToInt ('$'+FEdit.Text)
    else
      Result := StrToInt (FEdit.Text);
  except
    Result := FMinValue;
  end;
end;

procedure TNumEdit.SetValue (NewValue: LongInt);
begin
  if FHex then
   FEdit.Text := Format('%X',[CheckValue (NewValue)])
  else
   FEdit.Text := IntToStr (CheckValue (NewValue));
end;

function TNumEdit.CheckValue (NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

function TNumEdit.GetEditorBorderStyle: TBorderStyle;
begin
 result := FEdit.BorderStyle;
end;

procedure TNumEdit.SetEditorBorderStyle(NewValue: TBorderStyle);
begin
  FEdit.BorderStyle := NewValue;
end;

procedure TNumEdit.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  KeyDown(Key,Shift);
end;

procedure TNumEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
  KeyPress(Key);
end;

procedure TNumEdit.EditorChange(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

end.
