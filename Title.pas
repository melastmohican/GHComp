{$IFNDEF VER100}
{$ObjExportAll On}
{$ENDIF}
unit Title;

{$MODE Delphi}

{$R-}
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TTitle = class(TWinControl)
  private
    { Private declarations }
    FText: String;
    FTextNormal: TLabel;
    FTextShadow: TLabel;
    FTextHighlight: TLabel;
    FColorNormal: TColor;
    FColorShadow: TColor;
    FColorHighlight: TColor;
    procedure SetText(const AStr: String);
    procedure SetNormalColor(const AColor: TColor);
    procedure SetShadowColor(const AColor: TColor);
    procedure SetHighlightColor(const AColor: TColor);
    procedure ReSizeMe (var W: Integer; var H: Integer);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Font;
    property TitleText : String read FText write SetText;
    property NormalColor : TColor read FColorNormal write SetNormalColor default clNavy;
    property ShadowColor : TColor read FColorShadow write SetShadowColor default clGray;
    property HighlightColor : TColor read FColorHighlight write SetHighlightColor default clWhite;
  end;

implementation

constructor TTitle.Create(AOwner: TComponent);
begin
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
end;

procedure TTitle.CreateWnd;
var
  W, H: Integer;
begin
 inherited CreateWnd;
 W := Width;
 H := Height;
 ReSizeMe(W,H);
end;

procedure TTitle.SetText(const AStr: String);
begin
 FText:= AStr;
 FTextShadow.Caption := FText;
 FTextHighlight.Caption := FText;
 FTextNormal.Caption := FText;
 SetBounds(Left,Top,FTextShadow.Width,FTextShadow.Height);
 Invalidate;
end;

procedure TTitle.SetNormalColor(const AColor: TColor);
begin
 FColorNormal := AColor;
 FTextNormal.Font.Color := FColorNormal;
 Invalidate;
end;

procedure TTitle.SetShadowColor(const AColor: TColor);
begin
 FColorShadow := AColor;
 FTextShadow.Font.Color := FColorShadow;
 Invalidate;
end;

procedure TTitle.SetHighlightColor(const AColor: TColor);
begin
 FColorHighlight := AColor;
 FTextHighlight.Font.Color := FColorHighlight;
 Invalidate;
end;

procedure TTitle.ReSizeMe (var W: Integer; var H: Integer);
begin
  FTextShadow.SetBounds (0, 0, W, H);
  FTextNormal.SetBounds (0, 1, W, H - 1);
  FTextHighlight.SetBounds (0, 2, W, H - 2);
end;

procedure TTitle.CMFontChanged(var Message: TMessage);
begin
 FTextShadow.Font.Assign(Self.Font);
 FTextNormal.Font.Assign(Self.Font);
 FTextHighlight.Font.Assign(Self.Font);
 FTextShadow.Font.Color := FColorShadow;
 FTextNormal.Font.Color := FColorNormal;
 FTextHighlight.Font.Color := FColorHighlight;
 SetBounds(Left,Top,FTextShadow.Width,FTextShadow.Height);
 Invalidate;
end;

procedure TTitle.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  ReSizeMe (W,H);
end;

procedure TTitle.Loaded;
var
  W, H: Integer;
begin
 inherited Loaded;
 W := Width;
 H := Height;
 ReSizeMe(W,H);
end;

end.
