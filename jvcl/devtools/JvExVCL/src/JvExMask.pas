{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExMask.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas.Hausladen@gmx.de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

Last Modified: 2004-01-12

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$I jvcl.inc}

unit JvExMask;
interface
uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Mask,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  Qt, QGraphics, QControls, QForms, QMask,
  {$ENDIF VisualCLX}
  Classes, SysUtils,
  JvThemes, JvExControls;

{$IFDEF VCL}
 {$DEFINE NeedMouseEnterLeave}
{$ELSE}
 {$IF not declared(PatchedVCLX)}
  {$DEFINE NeedMouseEnterLeave}
 {$IFEND}
{$ENDIF VCL}

type
  JV_WINCONTROL_EVENTS_FEATURE_BEGIN(CustomMaskEdit)
  private
    FBeepOnError: Boolean;
  protected
    property BeepOnError: Boolean read FBeepOnError write FBeepOnError default True;
  JV_WINCONTROL_EVENTS_FEATURE_END(CustomMaskEdit)

  JV_WINCONTROL_EVENTS_FEATURE_BEGIN(MaskEdit)
  private
    FBeepOnError: Boolean;
  protected
    property BeepOnError: Boolean read FBeepOnError write FBeepOnError default True;
  JV_WINCONTROL_EVENTS_FEATURE_END(CustomMaskEdit)

implementation

{$UNDEF CONSTRUCTOR_CODE}
{$DEFINE CONSTRUCTOR_CODE
  FBeepOnError := True;
}
JV_WINCONTROL_EVENTS_IMPL(CustomMaskEdit)
JV_WINCONTROL_EVENTS_IMPL(MaskEdit)

{$UNDEF CONSTRUCTOR_CODE} // undefine at file end
end.
