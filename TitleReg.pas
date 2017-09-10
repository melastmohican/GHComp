
Unit TitleReg;

{$MODE Delphi}

Interface

Uses Classes, GraphPropEdits, Graphics, PropEdits, Title;

Procedure Register;

Implementation

Procedure Register;
Begin
  RegisterPropertyEditor(TypeInfo(TFont),TTitle,'',TFontProperty);
  RegisterPropertyEditor(TypeInfo(TColor),TTitle,'',TColorProperty);
  RegisterComponents('GHComp', [TTitle]);
End;


End.
