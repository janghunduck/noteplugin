library stringworker;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }


uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  nppplugin in 'lib\nppplugin.pas',
  scisupport in 'lib\SciSupport.pas',
  NppForms in 'lib\NppForms.pas' {NppForm},
  NppDockingForms in 'lib\NppDockingForms.pas' {NppDockingForm},
  stringworkerplugin in 'src\stringworkerplugin.pas',
  AboutForms in 'src\AboutForms.pas' {AboutForm},
  jsconsoleforms in 'src\jsconsoleforms.pas' {jsconsoledlg},
  KeFreeUtil in 'src\KefreeUtil.pas',
  consolefrm in 'src\consolefrm.pas' {consoleforms},
  cefconsole in 'src\cefconsole.pas',
  jsfuncfrm in 'src\jsfuncfrm.pas' {jsfuncdlg},
  hookfrm in 'src\hookfrm.pas' {HookDlg};

{$R *.res}

{$Include 'lib\NppPluginInclude.pas'}

begin
  { First, assign the procedure to the DLLProc variable }
  DllProc := @DLLEntryPoint;
  { Now invoke the procedure to reflect that the DLL is attaching to the process }
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
