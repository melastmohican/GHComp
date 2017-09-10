
Unit NumEdit;

{$MODE Delphi}

{$IFNDEF VER100}
{$ObjExportAll On}
{$ENDIF}
{$R-}

Interface

Uses 
LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs,
StdCtrls, ComCtrls;

Type 
  TEnterPressEvent = Procedure (Sender: TObject) Of object;

  TNumEdit = Class(TWinControl)
    Private 
      FHex: Boolean;
      FMinValue: LongInt;
      FMaxValue: LongInt;
      FIncrement: LongInt;
      FButton: TUpDown;
      FEdit: TEdit;
      FEditorEnabled: Boolean;
      FOnEnterPressed: TEnterPressEvent;
      FOnChange: TNotifyEvent;
      Function GetMinHeight: Integer;
      Function GetValue: LongInt;
      Function CheckValue (NewValue: LongInt): LongInt;
      Procedure SetValue (NewValue: LongInt);
      Function GetEditorBorderStyle: TBorderStyle;
      Procedure SetEditorBorderStyle(NewValue: TBorderStyle);
      Procedure EditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
      Procedure EditKeyPress(Sender: TObject; Var Key: Char);
      Procedure WMSize(Var Message: TWMSize);
      message WM_SIZE;
      Procedure CMExit(Var Message: TCMExit);
      message CM_EXIT;
    Protected 
      Procedure EditorChange(Sender: TObject);
      Procedure GetChildren(Proc: TGetChildProc; Root: TComponent);
      override;
      Function IsValidChar(Key: Char): Boolean;
      virtual;
      Procedure UpDownClick (Sender: TObject; Button: TUDBtnType);
      virtual;
      Procedure KeyDown(Var Key: Word; Shift: TShiftState);
      override;
      Procedure KeyPress(Var Key: Char);
      override;
      Procedure CreateParams(Var Params: TCreateParams);
      override;
      Procedure CreateWnd;
      override;
    Public 
      constructor Create(AOwner: TComponent);
      override;
      destructor Destroy;
      override;
      Procedure SetFocus;
      override;
      property Button: TUpDown read FButton;
    Published 
      property Color;
      property DragCursor;
      property DragMode;
      property EditorBorderStyle: TBorderStyle read GetEditorBorderStyle write
                                  SetEditorBorderStyle;
      property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled
                              default True;
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
      property OnEnterPressed: TEnterPressEvent read FOnEnterPressed write
                               FOnEnterPressed;
  End;

Procedure Register;

Implementation

Procedure Register;
Begin
  RegisterComponents('GHComp', [TNumEdit]);
End;

constructor TNumEdit.Create(AOwner: TComponent);
Begin
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
End;

destructor TNumEdit.Destroy;
Begin
  FEdit := Nil;
  FButton := Nil;
  inherited Destroy;
End;

Procedure TNumEdit.SetFocus;
Begin
  FEdit.SetFocus;
End;

Procedure TNumEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
Begin
End;

Procedure TNumEdit.KeyDown(Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_UP Then UpDownClick (Self,btNext)
  Else If Key = VK_DOWN Then UpDownClick (Self,btPrev)
  Else If (Key = VK_RETURN) And Assigned(OnEnterPressed) Then OnEnterPressed(
                                                                            Self
         );
  inherited KeyDown(Key, Shift);
End;

Procedure TNumEdit.KeyPress(Var Key: Char);
Begin
  If Not IsValidChar(Key) Then
    Begin
      Key := #0;
    End;
  If Key <> #0 Then inherited KeyPress(Key);
End;

Function TNumEdit.IsValidChar(Key: Char): Boolean;
Begin
  If FHex Then
    Result := (Key In [DecimalSeparator, '+', '-', '0'..'9', 'A'..'F']) Or ((Key
              < #32) And (Key <> Chr(VK_RETURN)))
  Else
    Result := (Key In [DecimalSeparator, '+', '-', '0'..'9']) Or ((Key < #32)
              And (Key <> Chr(VK_RETURN)));
  If Not FEditorEnabled And Result And ((Key >= #32) Or
     (Key = Char(VK_BACK)) Or (Key = Char(VK_DELETE))) Then
    Result := False;

End;

Procedure TNumEdit.CreateParams(Var Params: TCreateParams);
Begin
  inherited CreateParams(Params);
  Params.Style := Params.Style Or ES_MULTILINE Or WS_CLIPCHILDREN;
End;

Procedure TNumEdit.CreateWnd;
Begin
  inherited CreateWnd;
End;

Procedure TNumEdit.WMSize(Var Message: TWMSize);

Var 
  MinHeight: Integer;
Begin
  inherited;
  MinHeight := GetMinHeight;
  If Height < MinHeight Then
    Height := MinHeight
  Else If FButton <> Nil Then
         Begin
           FEdit.SetBounds (0, 1, Width - FButton.Width, Height);
           FButton.SetBounds (Width - FButton.Width, 0, FButton.Width, Height);
         End;
End;

Function TNumEdit.GetMinHeight: Integer;

Var 
  DC: HDC;
  SaveFont: HFont;
  //I: Integer;
  SysMetrics, Metrics: TTextMetric;
Begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  //I := SysMetrics.tmHeight;
  //if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight {+ I div 4 }+ GetSystemMetrics(SM_CYBORDER) * 2
            {+ 2};
End;


Procedure TNumEdit.UpDownClick (Sender: TObject;  Button: TUDBtnType);
Begin
  If Button = btNext Then
    Value := Value + FIncrement
  Else
    Value := Value - FIncrement;
End;

Procedure TNumEdit.CMExit(Var Message: TCMExit);
Begin
  inherited;
  If CheckValue (Value) <> Value Then
    SetValue (Value);
End;

Function TNumEdit.GetValue: LongInt;
Begin
  Try
    If FHex Then
      Result := StrToInt ('$'+FEdit.Text)
    Else
      Result := StrToInt (FEdit.Text);
  Except
    Result := FMinValue;
End;
End;

Procedure TNumEdit.SetValue (NewValue: LongInt);
Begin
  If FHex Then
    FEdit.Text := Format('%X',[CheckValue (NewValue)])
  Else
    FEdit.Text := IntToStr (CheckValue (NewValue));
End;

Function TNumEdit.CheckValue (NewValue: LongInt): LongInt;
Begin
  Result := NewValue;
  If (FMaxValue <> FMinValue) Then
    Begin
      If NewValue < FMinValue Then
        Result := FMinValue
      Else If NewValue > FMaxValue Then
             Result := FMaxValue;
    End;
End;

Function TNumEdit.GetEditorBorderStyle: TBorderStyle;
Begin
  result := FEdit.BorderStyle;
End;

Procedure TNumEdit.SetEditorBorderStyle(NewValue: TBorderStyle);
Begin
  FEdit.BorderStyle := NewValue;
End;

Procedure TNumEdit.EditKeyDown(Sender: TObject; Var Key: Word; Shift:
                               TShiftState);
Begin
  KeyDown(Key,Shift);
End;

Procedure TNumEdit.EditKeyPress(Sender: TObject; Var Key: Char);
Begin
  KeyPress(Key);
End;

Procedure TNumEdit.EditorChange(Sender: TObject);
Begin
  If Assigned(FOnChange) Then FOnChange(Self);
End;

End.
