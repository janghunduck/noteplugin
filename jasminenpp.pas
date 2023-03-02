unit jasminenpp;

interface

type
  TJasminePlugin = class(TNppPlugin)
  private
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer; lParam:integer): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer):Integer; overload;
    function sendScintilla(msg: LongWord):Integer; overload;

    function getCurScintilla(): Thandle;
    function getSelectedText(): string;
    function getLineCount(): integer;
    function getLineLength(linenumber: integer): integer;
    function getCurrentFile(): string;
  public
    constructor Create;
    procedure FuncHelloWorld;
    procedure FuncHelloWorldDocking;
    procedure FuncAbout;
    procedure DoNppnToolbarModification; override;

    procedure FuncDoubleQuotToSingle;
    procedure FuncConbineQQPlusCR;
    procedure SlashComment;
    procedure SlashCommentRemove;
    procedure FuncTest;

    procedure JsConsoleDock;
    procedure JsConsole;
    procedure JsWinConsole;
  end;

implementation

end.
