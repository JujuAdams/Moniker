function __MonikerBuildLookUpTable()
{
    var _funcUnpackGlyphsToMap = function(_fontInfo, _map)
    {
        var _timer = current_time;
        
        var _glyphArray = struct_get_names(_fontInfo.glyphs);
        var _i = 0;
        repeat(array_length(_glyphArray))
        {
            _map[? ord(_glyphArray[_i])] = true;
            ++_i;
        }
    
        show_debug_message($"Took {current_time - _timer}ms to unpack glyphs");
    }
    
    var _chineseSimpCharMap = ds_map_create();
    var _chineseTradCharMap = ds_map_create();
    
    with(__defaultFontPack)
    {
        var _chineseSimpFontConfig = __fontLookupMap[? MONIKER_SCRIPT_FAMILY_CHINESE_SIMP];
        if (_chineseSimpFontConfig != undefined)
        {
            _funcUnpackGlyphsToMap(_chineseSimpFontConfig.__EnsureInfo(), _chineseSimpCharMap);
        }
        
        var _chineseTradFontConfig = __fontLookupMap[? MONIKER_SCRIPT_FAMILY_CHINESE_TRAD];
        if (_chineseTradFontConfig != undefined)
        {
            _funcUnpackGlyphsToMap(_chineseTradFontConfig.__EnsureInfo(), _chineseTradCharMap);
        }
    }
    
    var _buffer = buffer_create(0x10_000, buffer_fixed, 1);
    var _i = 0;
    repeat(0x10_000)
    {
        var _scriptFamily = __MonikerGetCharScriptFamilyRaw(_i) & __MONIKER_BINARY_SCRIPT_FAMILY_MASK;
        
        if (ds_map_exists(_chineseSimpCharMap, _i))
        {
            _scriptFamily |= __MONIKER_BINARY_CHINESE_SIMP;
        }
        
        if (ds_map_exists(_chineseTradCharMap, _i))
        {
            _scriptFamily |= __MONIKER_BINARY_CHINESE_TRAD;
        }
        
        buffer_write(_buffer, buffer_u8, _scriptFamily);
        ++_i;
    }
    
    buffer_save(_buffer, "moniker_lut.bin");
    buffer_delete(_buffer);
    
    ds_map_destroy(_chineseSimpCharMap);
    ds_map_destroy(_chineseTradCharMap);
}

function __MonikerGetCharScriptFamilyRaw(_glyphIndex)
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
    
    if (((_glyphIndex >= 0x3000) && (_glyphIndex <= 0x303F))  //CJK Symbols and Punctuation
    ||  ((_glyphIndex >= 0x4E00) && (_glyphIndex <= 0x9FFF))) //CJK Unified Ideographs (including Kanji)
    {
        return MONIKER_SCRIPT_FAMILY_CJK_SHARED;
    }
    
    return MONIKER_SCRIPT_FAMILY_FALLBACK;
}