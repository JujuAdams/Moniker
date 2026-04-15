function __MonikerGetCharScriptFamily(_glyphIndex)
{
    static _system = __MonikerSystem();
    
    if (((_glyphIndex >= 32) && (_glyphIndex <= 127)) //ASCII Latin
    ||  ((_glyphIndex >= 128) && (_glyphIndex <= 591)))
    {
        return MONIKER_SCRIPT_FAMILY_LATIN;
    }
    
    if ((_glyphIndex >= 880) && (_glyphIndex <= 1023)) //Greek
    {
        return MONIKER_SCRIPT_FAMILY_GREEK;
    }
    
    if ((_glyphIndex >= 0x0E00) && (_glyphIndex <= 0x0E7F)) //Thai
    {
        return MONIKER_SCRIPT_FAMILY_THAI;
    }
    
    if ((_glyphIndex >= 0x0900) && (_glyphIndex <= 0x097F)) //Devanagari
    {
        return MONIKER_SCRIPT_FAMILY_DEVANAGARI;
    }
    
    if ((_glyphIndex >= 1024) && (_glyphIndex <= 1279)) //Cyrillic
    {
        return MONIKER_SCRIPT_FAMILY_CYRILLIC;
    }
    
    if ((_glyphIndex >= 1424) && (_glyphIndex <= 1535)) //Hebrew
    {
        return MONIKER_SCRIPT_FAMILY_HEBREW;
    }
    
    if (((_glyphIndex >=  1536) && (_glyphIndex <=  1791))  //Arabic
    ||  ((_glyphIndex >=  8216) && (_glyphIndex <=  8217))  //Arabic quotation marks
    ||  ((_glyphIndex >= 65136) && (_glyphIndex <= 65279))) //Arabic Presentation Forms B
    {
        return MONIKER_SCRIPT_FAMILY_ARABIC;
    }
    
    if (((_glyphIndex >= 0x3041) && (_glyphIndex <= 0x3096))  //Hiragana
    ||  ((_glyphIndex >= 0x30A0) && (_glyphIndex <= 0x30FF))) //Katakana
    {
        return MONIKER_SCRIPT_FAMILY_JAPANESE;
    }
    
    if (((_glyphIndex >= 0xAC00) && (_glyphIndex <= 0xD7A3))  //Hangul Syllables
    ||  ((_glyphIndex >= 0x1100) && (_glyphIndex <= 0x11FF))  //Hangul Jamo
    ||  ((_glyphIndex >= 0xA960) && (_glyphIndex <= 0xA97F))  //Hangul Jamo Extended-A
    ||  ((_glyphIndex >= 0xD7B0) && (_glyphIndex <= 0xD7FF))  //Hangul Jamo Extended-B
    ||  ((_glyphIndex >= 0x3130) && (_glyphIndex <= 0x318F))) //Hangul Compatibility Jamo
    {
        return MONIKER_SCRIPT_FAMILY_KOREAN;
    }
    
    if (ds_map_exists(_system.__chineseTradCharMap, _glyphIndex))
    {
        return MONIKER_SCRIPT_FAMILY_CHINESE_TRAD;
    }
    
    if (ds_map_exists(_system.__chineseSimpCharMap, _glyphIndex))
    {
        return MONIKER_SCRIPT_FAMILY_CHINESE_SIMP;
    }
    
    if (((_glyphIndex >= 0x3000) && (_glyphIndex <= 0x303F))  //CJK Symbols and Punctuation
    ||  ((_glyphIndex >= 0x4E00) && (_glyphIndex <= 0x9FFF))) //CJK Unified Ideographs (including Kanji)
    {
        return MONIKER_SCRIPT_FAMILY_CJK_SHARED;
    }
    
    return MONIKER_SCRIPT_FAMILY_FALLBACK;
}