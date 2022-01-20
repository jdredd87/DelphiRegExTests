(*
  Simple test program to test finding the word "bad" in a regex string.

  Comparing multiple regex engines speeds.

  This is not A great test but it gives you an idea.
  Chaning up conditions would most likely skew results more towards one library than another.

  Reason for this was A project I had using Delphi TRegEx took 1.5 hours to run 338 million reg ex calls.
  While others took 15 minutes or less once I moved away from it.

  You will need to change up the code to fit your needs depending on what your regex string is and
  what you are trying to accomplish.

  Libraries used

  RegExBuddy  | https://www.regexbuddy.com/delphi.html  | https://www.regular-expressions.info/download/TPerlRegEx.zip
  ^-- I had to rename/edit unit name files to PCRE.pas to regexbuddypcre.pas because conflicted with another PCRE.pas

  TRegExpr  | https://github.com/andgineer/TRegExpr

  TJclRegEx  | https://github.com/project-jedi/jcl

  .NET TRegEx | http://bilsen.com/regularexpressions/index.shtml?fbclid=IwAR3BtNohPoUrRh-RXPn7WWaU2znED-gSWCQU_ezQjuAXRcZWyuIdz_IF1_c
  | http://bilsen.com/regularexpressions/RegularExpressions1.1.zip
  ^----- I had to rename/edit unit name files for PCRE.pas to dontnetPCRE.pas and RegularExpressions.pas to dontnetRegularExpressions.pas
  As these file names conflicted with others.

  TRegEx | Built into Delphi

*)

unit frm_Main;

interface

uses
  // regex engines
  System.RegularExpressions,
  System.Diagnostics,
  dotnetRegularExpressions,
  regexpr,
  JclPCRE,
  regexbuddypcre,
  perlregex,
  ////////////////////////////
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Samples.Spin;

const
  dataStr = 'bad this is bad so bad it is so bad bad bad';
  expressionStr = '\b(bad)\b';
  loopCount =  1024 * 1024;

type
  TfrmMain = class(TForm)
    mDelphiTRegEx: TMemo;
    mTRegExpr: TMemo;
    mTJclRegEx: TMemo;
    btnPCRE: TButton;
    btnRegexpr: TButton;
    btnJedi: TButton;
    btnDotNetPCRE: TButton;
    btnRegExBuddy: TButton;
    mDotNetTRegEx: TMemo;
    mTPerlRegEx: TMemo;
    edRegEx: TEdit;
    lblRegEx: TLabel;
    edDataStr: TEdit;
    lblDataStr: TLabel;
    spLoops: TSpinEdit;
    lblLoops: TLabel;
    procedure btnPCREClick(Sender: TObject);
    procedure btnRegexprClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnJediClick(Sender: TObject);
    procedure btnDotNetPCREClick(Sender: TObject);
    procedure btnRegExBuddyClick(Sender: TObject);
  private
    procedure ToggleButtons;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edRegEx.text := expressionStr;
  edDataStr.text := dataStr;
  spLoops.Value := loopCount;
end;

procedure TfrmMain.ToggleButtons;
begin
  btnPCRE.Enabled := not btnPCRE.Enabled;
  btnRegexpr.Enabled := not btnRegexpr.Enabled;
  btnJedi.Enabled := not btnJedi.Enabled;
  btnDotNetPCRE.Enabled := not btnDotNetPCRE.Enabled;
  btnRegExBuddy.Enabled := not btnRegExBuddy.Enabled;
end;

procedure TfrmMain.btnPCREClick(Sender: TObject);
begin
  ToggleButtons;

  mDelphiTRegEx.Clear;
  mDelphiTRegEx.Lines.Add('Running PCRE Test');

  tthread.CreateAnonymousThread(
    procedure
    var
      badcount: integer;
      procedure DelphiPCRE;
      var
        mycoll: TMatchCollection;
      begin
        // TRegEx as A created variable, you have to specify input data and expression on Create
        // and can't change it afterwards.
        // So if you have LOTS of data and morphing expressions, you can't just reuse the same TRegEx variable
        // It has to be re-created every time ?

        // Having to create over and over and over via the below code
        // is most likely the bottle neck here

        // Only thing I can hope for is a way to create once
        // and can change data and expression as needed like I can with
        // TRegExpr object but not sure that is possible?

        // This replicates my issue where the code that runs the Regex pops in and out of scope.

        // Delphi's TRegEx is a RECORD not an object. Same with TMatchCollection.

        mycoll := System.RegularExpressions.TRegEx.Matches(dataStr, expressionStr,
          [System.RegularExpressions.TRegExOption.roIgnoreCase]);
        inc(badcount, mycoll.Count);
      end;

    var
      sw: tstopwatch;
      idx: integer;
    begin

      badcount := 0;
      sw := tstopwatch.StartNew;

      for idx := 1 to loopCount do
        DelphiPCRE;

      sw.Stop;
      tthread.Synchronize(tthread.CurrentThread,
        procedure
        begin
          mDelphiTRegEx.Lines.Add('Elapsed : ' + sw.ElapsedMilliseconds.ToString + 'ms');
          mDelphiTRegEx.Lines.Add('"bad" Count = ' + badcount.ToString);
          ToggleButtons;
        end);

    end).Start;
end;

procedure TfrmMain.btnRegExBuddyClick(Sender: TObject);
begin
  ToggleButtons;

  mTPerlRegEx.Clear;
  mTPerlRegEx.Lines.Add('Running TRegExpr Test');

  tthread.CreateAnonymousThread(
    procedure
    var
      badcount: integer;
      // I can create TPerlRegEx once and re-use it over and over.
      // Create once, free once.
      regexpr: TPerlRegEx;

      procedure perlregex;
        function matchCount: integer;
        // There is no simple, give me the # count in TRegExpr
        // at least that i can find?
        // So this function just countes and returns
        begin
          Result := 0;
          if regexpr.Match then
            repeat
              inc(Result);
            until not regexpr.MatchAgain;
        end;

      begin
        regexpr.RegEx := expressionStr;
        regexpr.Subject := dataStr;
        inc(badcount, matchCount);
      end;

    var
      sw: tstopwatch;
      idx: integer;
    begin
      badcount := 0;

      // create once and free once
      // no need to create over and over

      regexpr := TPerlRegEx.Create;
      regexpr.Options := [preCaseLess];

      sw := tstopwatch.StartNew;

      for idx := 1 to loopCount do
        perlregex;

      sw.Stop;
      tthread.Synchronize(tthread.CurrentThread,
        procedure
        begin
          mTPerlRegEx.Lines.Add('Elapsed : ' + sw.ElapsedMilliseconds.ToString + 'ms');
          mTPerlRegEx.Lines.Add('"bad" Count = ' + badcount.ToString);
          ToggleButtons;
        end);
      regexpr.Free;

    end).Start;
end;

procedure TfrmMain.btnRegexprClick(Sender: TObject);
begin
  ToggleButtons;

  mTRegExpr.Clear;
  mTRegExpr.Lines.Add('Running TRegExpr Test');

  tthread.CreateAnonymousThread(
    procedure

    var
      badcount: integer;
      // I can create TRegExpr once and re-use it over and over.
      // Create once, free once.
      regexpr: TRegExpr;

      procedure Delphiregexpr;
        function matchCount: integer;
        // There is no simple, give me the # count in  TRegExpr
        // at least that i can find?
        // So this function just countes and returns
        begin
          Result := 0;
          regexpr.ExecPos(1);
          repeat
            inc(Result);
          until not regexpr.ExecNext;
        end;

      begin
        regexpr.expression := expressionStr;
        regexpr.Exec(dataStr);
        inc(badcount, matchCount);
      end;

    var
      sw: tstopwatch;
      idx: integer;
    begin
      badcount := 0;

      // create once and free once
      // no need to create over and over

      regexpr := TRegExpr.Create;
      regexpr.ModifierI := true;

      sw := tstopwatch.StartNew;

      for idx := 1 to loopCount do
        Delphiregexpr;

      sw.Stop;
      tthread.Synchronize(tthread.CurrentThread,
        procedure
        begin
          mTRegExpr.Lines.Add('Elapsed : ' + sw.ElapsedMilliseconds.ToString + 'ms');
          mTRegExpr.Lines.Add('"bad" Count = ' + badcount.ToString);
          ToggleButtons;
        end);

      regexpr.Free;
    end).Start;
end;

procedure TfrmMain.btnDotNetPCREClick(Sender: TObject);
begin

  ToggleButtons;

  mDotNetTRegEx.Clear;
  mDotNetTRegEx.Lines.Add('Running dotnetPCRE Test');

  tthread.CreateAnonymousThread(
    procedure

    var
      badcount: integer;
      // I can create netRegularExpressions.TRegEx once and re-use it over and over.
      // Create once, free once.
      RegEx: dotnetRegularExpressions.TRegEx;

      procedure dotnetPCRE;
      var
        mycoll: IMatchCollection;
      begin
        mycoll := RegEx.Matches(dataStr, expressionStr, [dotnetRegularExpressions.TRegExOption.roIgnoreCase]);
        inc(badcount, mycoll.Count);
      end;

    var
      sw: tstopwatch;
      idx: integer;
    begin

      // create once and free once
      // no need to create over and over
      RegEx := dotnetRegularExpressions.TRegEx.Create;

      badcount := 0;
      sw := tstopwatch.StartNew;

      for idx := 1 to loopCount do
        dotnetPCRE;

      sw.Stop;
      tthread.Synchronize(tthread.CurrentThread,
        procedure
        begin
          mDotNetTRegEx.Lines.Add('Elapsed : ' + sw.ElapsedMilliseconds.ToString + 'ms');
          mDotNetTRegEx.Lines.Add('"bad" Count = ' + badcount.ToString);
          ToggleButtons;
        end);
      RegEx.Free;
    end).Start;
end;

procedure TfrmMain.btnJediClick(Sender: TObject);
begin
  ToggleButtons;

  mTJclRegEx.Clear;
  mTJclRegEx.Lines.Add('Running TJclRegExBase Test');

  tthread.CreateAnonymousThread(
    procedure

    var
      badcount: integer;

      procedure JediPCRE;
      var
        matchCount: integer;
        midx: integer;
        JclPCRE: TJclRegEx;
        // oddly I can't create once and reuse TJclRegEx
        // Always get integer over flow
        // Maybe something I am missing to clear cached data or something?

        // oddly can't use MadExcept resource leak check with TJclRegEx test.
        // All kinds of bad stuff blows up!
      begin
        matchCount := 0;
        midx := 0;
        JclPCRE := TJclRegEx.Create;
        JclPCRE.Options := [TJclRegExOption.roIgnoreCase];
        JclPCRE.Compile(expressionStr, false, false, false);
        repeat
          midx := JclPCRE.CaptureRanges[0].LastPos + 1;
          inc(matchCount);
        until not JclPCRE.Match(dataStr, midx);
        dec(matchCount);
        inc(badcount, matchCount);
        JclPCRE.Free;
      end;

    var
      sw: tstopwatch;
      idx: integer;
    begin
      badcount := 0;
      sw := tstopwatch.StartNew;
      for idx := 1 to loopCount do
        JediPCRE;
      sw.Stop;
      tthread.Synchronize(tthread.CurrentThread,
        procedure
        begin
          mTJclRegEx.Lines.Add('Elapsed : ' + sw.ElapsedMilliseconds.ToString + 'ms');
          mTJclRegEx.Lines.Add('"bad" Count = ' + badcount.ToString);
          ToggleButtons;
        end);
    end).Start;
end;

end.
