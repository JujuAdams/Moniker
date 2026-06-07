function __MonikerGetCharScriptFamily(_glyphIndex, _hasSimplifiedChineseFont, _hasTraditionalChineseFont)
{
    static _system = __MonikerSystem();
    static _lookUpBuffer = _system.__lookUpBuffer;
    
    if ((_glyphIndex < 0) || (_glyphIndex > 0xFFFF))
    {
        return MONIKER_SCRIPT_FAMILY_FALLBACK;
    }
    
    var _data = buffer_peek(_lookUpBuffer, _glyphIndex, buffer_u8);
    if (_data == MONIKER_SCRIPT_FAMILY_FALLBACK)
    {
        return MONIKER_SCRIPT_FAMILY_FALLBACK;
    }
    
    var _scriptFamily = _data & __MONIKER_BINARY_SCRIPT_FAMILY_MASK;
    if ((_scriptFamily > MONIKER_SCRIPT_FAMILY_FALLBACK) && (_scriptFamily != MONIKER_SCRIPT_FAMILY_CJK_SHARED))
    {
        return _scriptFamily;
    }
    else
    {
        //Not a non-Chinese font, not empty. This must be a Chinese character of some description
        
        if (_hasSimplifiedChineseFont)
        {
            if (_hasTraditionalChineseFont)
            {
                //We have a font for both types of Chinese. Choose one of them for the script family
                
                if (_system.__preferSimplifiedChinese)
                {
                    if (_data & __MONIKER_BINARY_CHINESE_SIMP)
                    {
                        return MONIKER_SCRIPT_FAMILY_CHINESE_SIMP;
                    }
                    else if (_data & __MONIKER_BINARY_CHINESE_TRAD)
                    {
                        return MONIKER_SCRIPT_FAMILY_CHINESE_TRAD;
                    }
                }
                else
                {
                    if (_data & __MONIKER_BINARY_CHINESE_TRAD)
                    {
                        return MONIKER_SCRIPT_FAMILY_CHINESE_TRAD;
                    }
                    else if (_data & __MONIKER_BINARY_CHINESE_SIMP)
                    {
                        return MONIKER_SCRIPT_FAMILY_CHINESE_SIMP;
                    }
                }
            }
            else
            {
                return MONIKER_SCRIPT_FAMILY_CHINESE_SIMP;
            }
        }
        else
        {
            if (_hasTraditionalChineseFont)
            {
                return MONIKER_SCRIPT_FAMILY_CHINESE_TRAD;
            }
        }
    }
    
    return _scriptFamily;
}