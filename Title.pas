{$IFNDEF VER100}
{$ObjExportAll On}
{$ENDIF}

Unit Title;

{$MODE Delphi}

{$R-}

Interface

Uses 
LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
Forms, Dialogs,
ExtCtrls, StdCtrls;

Type 
  TTitle = Class(TWinControl)
    Private 
    { Private declarations }
      FText: String;
      FTextNormal: TLabel;
      FTextShadow: TLabel;
      FTextHighlight: TLabel;
      FColorNormal: TColor;
      FColorShadow: TColor;
      FColorHighlight: TColor;
      Procedure SetText(Const AStr: String);
      Procedure SetNormalColor(Const AColor: TColor);
      Procedure SetShadowColor(Const AColor: TColor);
      Procedure SetHighlightColor(Const AColor: TColor);
      Procedure ReSizeMe (Var W: Integer; Var H: Integer);
      Procedure WMSize(Var Message: TWMSize);
      message WM_SIZE;
      Procedure CMFontChanged(Var Message: TMessage);
      message CM_FONTCHANGED;
    Protected 
    { Protected declarations }
      Procedure CreateWnd;
      override;
      Procedure Loaded;
      override;
    Public 
    { Public declarations }
      constructor Create(AOwner: TComponent);
      override;
    Published 
    { Published declarations }
      property Font;
      property TitleText : String read FText write SetText;
      property NormalColor : TColor read FColorNormal write SetNormalColor
                             default clNavy;
      property ShadowColor : TColor read FColorShadow write SetShadowColor
                             default clGray;
      property HighlightColor : TColor read FColorHighlight write
                                SetHighlightColor default clWhite;
  End;

Implementation

constructor TTitle.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
                  [csOpaque];
  Caption := '';
  FTextShadow := TLabel.Create(self);
  FTextShadow.Parent := self;
  FTextShadow.Visible := True;
  FTextShadow.Enabled := True;
  FTextShadow.Transparent := True;
  FTextShadow.ParentFont := True;
  FTextHighlight := TLabel.Create(self);
  FTextHighlight.Parent := self;
  FTextHighlight.Visible := True;
  FTextHighlight.Enabled := True;
  FTextHighlight.Transparent := True;
  FTextHighlight.ParentFont := True;
  FTextNormal := TLabel.Create(self);
  FTextNormal.Parent := self;
  FTextNormal.Visible := True;
  FTextNormal.Enabled := True;
  FTextNormal.Transparent := True;
  FTextNormal.ParentFont := True;
  FTextShadow.Font.Assign(Self.Font);
  FTextNormal.Font.Assign(Self.Font);
  FTextHighlight.Font.Assign(Self.Font);
  FColorShadow := clGray;
  FColorNormal := clNavy;
  FColorHighlight := clWhite;
  FTextShadow.Font.Color := FColorShadow;
  FTextNormal.Font.Color := FColorNormal;
  FTextHighlight.Font.Color := FColorHighlight;
  Width := FTextShadow.Width;
  Height := FTextShadow.Height;
End;

Procedure TTitle.CreateWnd;

Var 
  W, H: Integer;
Begin
  inherited CreateWnd;
  W := Width;
  H := Height;
  ReSizeMe(W,H);
End;

Procedure TTitle.SetText(Const AStr: String);
Begin
  FText := AStr;
  FTextShadow.Caption := FText;
  FTextHighlight.Caption := FText;
  FTextNormal.Caption := FText;
  SetBounds(Left,Top,FTextShadow.Width,FTextShadow.Height);
  Invalidate;
End;

Procedure TTitle.SetNormalColor(Const AColor: TColor);
Begin
  FColorNormal := AColor;
  FTextNormal.Font.Color := FColorNormal;
  Invalidate;
End;

Procedure TTitle.SetShadowColor(Const AColor: TColor);
Begin
  FColorShadow := AColor;
  FTextShadow.Font.Color := FColorShadow;
  Invalidate;
End;

Procedure TTitle.SetHighlightColor(Const AColor: TColor);
Begin
  FColorHighlight := AColor;
  FTextHighlight.Font.Color := FColorHighlight;
  Invalidate;
End;

Procedure TTitle.ReSizeMe (Var W: Integer; Var H: Integer);
Begin
  FTextShadow.SetBounds (0, 0, W, H);
  FTextNormal.SetBounds (0, 1, W, H - 1);
  FTextHighlight.SetBounds (0, 2, W, H - 2);
End;

Procedure TTitle.CMFontChanged(Var Message: TMessage);
Begin
  FTextShadow.Font.Assign(Self.Font);
  FTextNormal.Font.Assign(Self.Font);
  FTextHighlight.Font.Assign(Self.Font);
  FTextShadow.Font.Color := FColorShadow;
  FTextNormal.Font.Color := FColorNormal;
  FTextHighlight.Font.Color := FColorHighlight;
  SetBounds(Left,Top,FTextShadow.Width,FTextShadow.Height);
  Invalidate;
End;

Procedure TTitle.WMSize(Var Message: TWMSize);

Var 
  W, H: Integer;
Begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  ReSizeMe (W,H);
End;

Procedure TTitle.Loaded;

Var 
  W, H: Integer;
Begin
  inherited Loaded;
  W := Width;
  H := Height;
  ReSizeMe(W,H);
End;

End.
