// Feather disable all

/// Constructor that returns a struct that can be used to draw player names. You should create a
/// font pack with `MonikerFontPack()` before calling this function.
/// 
/// @param name
/// @param [fontPack]
/// 
/// The constructed struct has the following methods:
/// 
/// `.Draw(x, y, [scale=1])`
///     Draws the name at the given coordinates and scale. This will respect global horizontal and
///     vertical alignment.
/// 
/// `.GetWidth()`
///     Returns the width of the name when drawn.
/// 
/// `.GetHeight()`
///     Returns the height of the name when drawn.
/// 
/// `.SetFontPack([fontPack])`
///     Sets the font pack for the name when drawn.

function Moniker(_name, _fontPack = undefined) constructor
{
    static _system = __MonikerSystem();
    
    rawName  = _name;
    fontPack = _fontPack ?? _system.__defaultFontPack;
    
    if (fontPack == undefined)
    {
        show_error(" \nMoniker:\nYou must create a font pack using `MonikerFontPack()` before calling `Moniker()`\n ", true);
    }
    
    substringArray = [];
    
    __width  = 0;
    __height = 0;
    
    if (rawName != "")
    {
        var _workingName = rawName;
        _workingName = __MonikerParseThai(_workingName);
        _workingName = __MonikerParseArabic(_workingName);
        //Devanagari is handled when creating a substring class
        
        var _charArray = __MonikerDecompose(_workingName);
        
        var _substringStart = 0;
        var _currentScriptFamily = __MonikerGetCharScriptFamily(_charArray[0]);
        
        var _i = 1;
        repeat(array_length(_charArray)-1)
        {
            var _scriptFamily = __MonikerGetCharScriptFamily(_charArray[_i]);
            if (_scriptFamily != _currentScriptFamily)
            {
                var _substring = __MonikerRecompose(_charArray, true, _substringStart, _i - _substringStart);
                array_push(substringArray, new __MonikerSubstringClass(_substring, _currentScriptFamily).__Recalculate(fontPack));
                
                _currentScriptFamily = _scriptFamily;
                _substringStart = _i;
            }
            
            ++_i;
        }
        
        var _substring = __MonikerRecompose(_charArray, true, _substringStart, _i - _substringStart);
        array_push(substringArray, new __MonikerSubstringClass(_substring, _currentScriptFamily).__Recalculate(fontPack));
        
        __Recalculate();
    }
    
    
    
    static Draw = function(_x, _y, _scale = 1)
    {
        var _fontPack = fontPack;
        var _substringArray = substringArray;
        
        var _oldFont   = draw_get_font();
        var _oldHAlign = draw_get_halign();
        var _oldVAlign = draw_get_valign();
        
        if (_oldHAlign == fa_center)
        {
            _x -= floor(GetWidth() / 2);
        }
        else if (_oldHAlign == fa_right)
        {
            _x -= GetWidth();
        }
        
        if (_oldVAlign == fa_middle)
        {
            _y -= floor(GetHeight() / 2);
        }
        else if (_oldVAlign == fa_bottom)
        {
            _y -= GetHeight();
        }
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _i = 0;
        repeat(array_length(_substringArray))
        {
            with(_substringArray[_i])
            {
                draw_set_font(_fontPack.__GetFont(__scriptFamily));
                draw_text_transformed(_x + _fontPack.__GetXOffset(__scriptFamily),
                                      _y + _fontPack.__GetYOffset(__scriptFamily),
                                      __substring,
                                      _scale, _scale, 0);
                _x += _scale*__width;
            }
            
            ++_i;
        }
        
        draw_set_font(_oldFont);
        draw_set_halign(_oldHAlign);
        draw_set_valign(_oldVAlign);
    }
    
    static SetFontPack = function(_fontPack = undefined)
    {
        fontPack = _fontPack ?? _system.__defaultFontPack;
        
        __Recalculate();
        
        return self;
    }
    
    static GetWidth = function()
    {
        return __width;
    }
    
    static GetHeight = function()
    {
        return __height;
    }
    
    static __Recalculate = function()
    {
        var _fontPack = fontPack;
        
        var _totalWidth  = 0;
        var _totalHeight = 0;
        
        var _i = 0;
        repeat(array_length(substringArray))
        {
            with(substringArray[_i])
            {
                __Recalculate(_fontPack);
                _totalWidth  += __width;
                _totalHeight  = max(_totalHeight, __height);
            }
            
            ++_i;
        }
        
        __width  = _totalWidth;
        __height = _totalHeight;
    }
}