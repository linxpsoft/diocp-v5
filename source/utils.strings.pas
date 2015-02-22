(*
 *	 Unit owner: d10.�����
 *	       blog: http://www.cnblogs.com/dksoft
 *     homePage: www.diocp.org
 *
 *   2015-02-22 08:29:43
 *     DIOCP-V5 ����
 *
 *)
 
unit utils.strings;

interface

uses
  Classes, SysUtils;


/// <summary>
///   �����ַ�
/// </summary>
/// <returns>
///   �����������ַ�
/// </returns>
/// <param name="p"> ��ʼ���λ�� </param>
/// <param name="pvChars"> ������Щ�ַ���ֹͣ��Ȼ�󷵻� </param>
function SkipUntil(var p:PChar; pvChars: TSysCharSet): Integer;


/// <summary>
///   �����ַ�
/// </summary>
/// <returns> Integer
/// </returns>
/// <param name="p"> (PChar) </param>
/// <param name="pvChars"> (TSysCharSet) </param>
function SkipChars(var p:PChar; pvChars: TSysCharSet): Integer;


/// <summary>
///   ����߿�ʼ��ȡ�ַ�
/// </summary>
/// <returns> Integer
/// </returns>
/// <param name="p"> (PChar) </param>
/// <param name="pvChars"> (TSysCharSet) </param>
function LeftUntil(var p:PChar; pvChars: TSysCharSet): string;

/// <summary>
///   ����SpliterChars���ṩ���ַ������зָ��ַ��������뵽Strings��
///     * �����ַ�ǰ��Ŀո�
/// </summary>
/// <returns>
///   ���طָ�ĸ���
/// </returns>
/// <param name="s"> Դ�ַ��� </param>
/// <param name="pvStrings"> ��������ַ����б� </param>
/// <param name="pvSpliterChars"> �ָ��� </param>
function SplitStrings(s:String; pvStrings:TStrings; pvSpliterChars
    :TSysCharSet): Integer;

/// <summary>
///   URL���ݽ���,
///    Get��Post�����ݶ�������url����
/// </summary>
/// <returns>
///   ���ؽ�����URL����
/// </returns>
/// <param name="ASrc"> ԭʼ���� </param>
/// <param name="pvIsPostData"> Post��ԭʼ������ԭʼ�Ŀո񾭹�UrlEncode����+�� </param>
function URLDecode(const ASrc: String; pvIsPostData: Boolean = true): String;

/// <summary>
///  �����ݽ���URL����
/// </summary>
/// <returns>
///   ����URL����õ�����
/// </returns>
/// <param name="S"> ��Ҫ��������� </param>
/// <param name="pvIsPostData"> Post��ԭʼ������ԭʼ�Ŀո񾭹�UrlEncode����+�� </param>
function URLEncode(S: string; pvIsPostData: Boolean = true): string;



implementation

{$if CompilerVersion < 20}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ifend}


function SkipUntil(var p:PChar; pvChars: TSysCharSet): Integer;
var
  ps: PChar;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if CharInSet(p^, pvChars) then
      Break
    else
      Inc(P);
  end;
  Result := p - ps;
end;

function LeftUntil(var p:PChar; pvChars: TSysCharSet): string;
var
  ps: PChar;
  l:Integer;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if CharInSet(p^, pvChars) then
      Break
    else
      Inc(P);
  end;
  l := p-ps;
  if l = 0 then
  begin
    Result := '';
  end else
  begin
    SetLength(Result, l);
    if SizeOf(Char) = 1 then
    begin
      Move(ps^, PChar(Result)^, l);
    end else
    begin
      l := l shl 1;
      Move(ps^, PChar(Result)^, l);
    end;
  end;
end;

function SkipChars(var p:PChar; pvChars: TSysCharSet): Integer;
var
  ps: PChar;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if CharInSet(p^, pvChars) then
      Inc(P)
    else
      Break;
  end;
  Result := p - ps;
end;


function SplitStrings(s:String; pvStrings:TStrings; pvSpliterChars
    :TSysCharSet): Integer;
var
  p:PChar;
  lvValue : String;
begin
  p := PChar(s);
  Result := 0;
  while True do
  begin
    // �����հ�
    SkipChars(p, [' ']);
    lvValue := LeftUntil(P, pvSpliterChars);
    if lvValue = '' then exit;
    // �����ָ���
    SkipChars(p, pvSpliterChars);

    // ���ӵ��б���
    pvStrings.Add(lvValue);
    inc(Result);
  end;
end;


function URLDecode(const ASrc: String; pvIsPostData: Boolean = true): String;
var
  i, j: integer;
  ESC: string;
begin
  i := 1;
  SetLength(Result, Length(ASrc));   // Ԥ������һ���ַ���������־
  j := 1;
  while i <= Length(ASrc) do
  begin
    if (pvIsPostData) and (ASrc[i] = '+') then   // + �ű�ɿո�, Post��ԭʼ����������� �ո�ʱ���� +��
    begin
      Result[j] := ' ';
    end else if ASrc[i] <> '%' then
    begin
      Result[j] := ASrc[i];
    end else 
    begin
      Inc(i); // skip the % char
      ESC := ASrc[i] + ASrc[i+1];
      Inc(i, 1); // Then skip it.
      try
        Result[j] := Char(StrToInt('$' + ESC));  {do not localize}
      except end;
    end;
    Inc(i);
    Inc(j);
  end;
  SetLength(Result, j - 1);
end;




function URLEncode(S: string; pvIsPostData: Boolean = true): string;
var
  i: Integer; // loops thru characters in string
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    case S[i] of
      'A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '.':
        Result := Result + S[i];
      ' ':
        if pvIsPostData then
        begin     // Post��������ǿո���Ҫ����� +
          Result := Result + '+';
        end else
        begin
          Result := Result + '%20';
        end
    else
      Result := Result + '%' + SysUtils.IntToHex(Ord(S[i]), 2);
    end;
  end;
end;

end.