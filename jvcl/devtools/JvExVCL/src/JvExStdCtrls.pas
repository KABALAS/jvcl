{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExStdCtrls.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas.Hausladen@gmx.de]
Portions created by Andreas Hausladen are Copyright (C) 2003 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

Last Modified: 2004-01-04

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$I jvcl.inc}

unit JvExStdCtrls;
interface
uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, StdCtrls,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Qt, QGraphics, QControls, QForms, QStdCtrls,
  {$ENDIF VisualCLX}
  Classes, SysUtils,
  JvExControls;

type
  JV_WINCONTROL_EVENTS(CustomGroupBox)
  JV_WINCONTROL_EVENTS(GroupBox)
  {$DEFINE HASAUTOSIZE}
  JV_CONTROL_EVENTS(CustomLabel)
  JV_CONTROL_EVENTS(Label)
  {$UNDEF HASAUTOSIZE}
  JV_WINCONTROL_EVENTS(CustomEdit)
  JV_WINCONTROL_EVENTS(Edit)
  JV_WINCONTROL_EVENTS(CustomMemo)
  JV_WINCONTROL_EVENTS(Memo)
{$IFDEF COMPILER6_UP}
 {$IFDEF VCL}
  JV_WINCONTROL_EVENTS(CustomCombo)
 {$ENDIF VCL}
{$ENDIF}
  JV_WINCONTROL_EVENTS(CustomComboBox)
  JV_WINCONTROL_EVENTS(ComboBox)
  JV_WINCONTROL_EVENTS(ButtonControl)
  JV_WINCONTROL_EVENTS(Button)
  JV_WINCONTROL_EVENTS(CustomCheckBox)
  JV_WINCONTROL_EVENTS(CheckBox)
  JV_WINCONTROL_EVENTS(RadioButton)
  JV_WINCONTROL_EVENTS(CustomListBox)
  JV_WINCONTROL_EVENTS(ListBox)
  JV_WINCONTROL_EVENTS(ScrollBar)
{$IFDEF VCL}
  JV_WINCONTROL_EVENTS(CustomStaticText)
  JV_WINCONTROL_EVENTS(StaticText)
{$ENDIF VCL}

implementation

JV_WINCONTROL_EVENTS_IMPL(CustomGroupBox)
JV_WINCONTROL_EVENTS_IMPL(GroupBox)
{$DEFINE HASAUTOSIZE}
JV_CONTROL_EVENTS_IMPL(CustomLabel)
JV_CONTROL_EVENTS_IMPL(Label)
{$UNDEF HASAUTOSIZE}
JV_WINCONTROL_EVENTS_IMPL(CustomEdit)
JV_WINCONTROL_EVENTS_IMPL(Edit)
JV_WINCONTROL_EVENTS_IMPL(CustomMemo)
JV_WINCONTROL_EVENTS_IMPL(Memo)
{$IFDEF COMPILER6_UP}
 {$IFDEF VCL}
JV_WINCONTROL_EVENTS_IMPL(CustomCombo)
 {$ENDIF VCL}
{$ENDIF}
JV_WINCONTROL_EVENTS_IMPL(CustomComboBox)
JV_WINCONTROL_EVENTS_IMPL(ComboBox)
JV_WINCONTROL_EVENTS_IMPL(ButtonControl)
JV_WINCONTROL_EVENTS_IMPL(Button)
JV_WINCONTROL_EVENTS_IMPL(CustomCheckBox)
JV_WINCONTROL_EVENTS_IMPL(CheckBox)
JV_WINCONTROL_EVENTS_IMPL(RadioButton)
JV_WINCONTROL_EVENTS_IMPL(CustomListBox)
JV_WINCONTROL_EVENTS_IMPL(ListBox)
JV_WINCONTROL_EVENTS_IMPL(ScrollBar)
{$IFDEF VCL}
JV_WINCONTROL_EVENTS_IMPL(CustomStaticText)
JV_WINCONTROL_EVENTS_IMPL(StaticText)
{$ENDIF VCL}

end.
