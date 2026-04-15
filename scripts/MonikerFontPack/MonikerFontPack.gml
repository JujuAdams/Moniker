/// Constructor that returns a collection of fonts that can be used to draw names. The first font
/// pack that you create will be used as the default font pack for all `Moniker()` structs.
/// 
/// @param sdfFonts
/// @param configData
/// 
/// An example of use would be:
/// 
///    var _size = 32;
///    new MonikerFontPack(true, [
///        {
///            scriptFamily: [MONIKER_SCRIPT_FAMILY_FALLBACK, MONIKER_SCRIPT_FAMILY_LATIN, MONIKER_SCRIPT_FAMILY_VIETNAMESE],
///            path: "Montserrat-BlackItalic.ttf",
///            size: _size,
///            xOffset: 0,
///            yOffset: 0,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_CHINESE_TRAD,
///            path: "NotoSansTC-Black.otf",
///            size: _size,
///            xOffset: 0,
///            yOffset: -0.25*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_CHINESE_SIMP,
///            path: "NotoSansSC-Black.ttf",
///            size: _size,
///            xOffset: 0,
///            yOffset: -0.25*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_JAPANESE,
///            path: "NotoSansJP-Black.otf",
///            size: _size,
///            xOffset: 0,
///            yOffset: -0.25*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_KOREAN,
///            path: "NotoSansKR-Black.otf",
///            size: _size,
///            xOffset: 0,
///            yOffset: -0.25*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_ARABIC,
///            path: "NotoKufiArabic-Bold.ttf",
///            size: 1.2*_size,
///            xOffset: 0,
///            yOffset: 0,
///        },
///        {
///            scriptFamily: [MONIKER_SCRIPT_FAMILY_CYRILLIC, MONIKER_SCRIPT_FAMILY_GREEK],
///            path: "NotoSans-BlackItalic.ttf",
///            size: 1.1*_size,
///            xOffset: 0,
///            yOffset: -0.28*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_HEBREW,
///            path: "RubikBoldItalic.ttf",
///            size: 1.1*_size,
///            xOffset: 0,
///            yOffset: 0,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_THAI,
///            path: "Waree-BoldOblique.ttf",
///            size: 1.2*_size,
///            xOffset: 0,
///            yOffset: -0.6*_size,
///        },
///        {
///            scriptFamily: MONIKER_SCRIPT_FAMILY_DEVANAGARI,
///            path: "KRDEV370.TTF",
///            size: 1.5*_size,
///            xOffset: +0.10*_size,
///            yOffset: -0.45*_size,
///        },
///    ]);

function MonikerFontPack(_sdf, _configData) constructor
{
    static _system = __MonikerSystem();
    
    if (_system.__defaultFontPack == undefined)
    {
        _system.__defaultFontPack = self;
    }
    
    __sdf = _sdf;
    __fontLookupMap = ds_map_create();
    
    var _funcUnpackGlyphsToMap = function(_fontInfo, _map)
    {
        var _glyphArray = struct_get_names(_fontInfo.glyphs);
        var _i = 0;
        repeat(array_length(_glyphArray))
        {
            _map[? ord(_glyphArray[_i])] = true;
            ++_i;
        }
    }
    
    _configData = variable_clone(_configData);
    
    var _i = 0;
    repeat(array_length(_configData))
    {
        var _fontConfig = _configData[_i];
        
        var _font = font_add(_fontConfig.path, _fontConfig.size, false, false, 32, 127);
        font_enable_sdf(_font, __sdf);
        
        var _fontInfo = font_get_info(_font);
        _fontConfig.__font = _font;
        _fontConfig.__fontInfo = _fontInfo;
        
        var _scriptFamilyArray = _fontConfig.scriptFamily;
        
        if (not is_array(_scriptFamilyArray))
        {
            _scriptFamilyArray = [_scriptFamilyArray];
        }
        
        var _j = 0;
        repeat(array_length(_scriptFamilyArray))
        {
            var _scriptFamily = _scriptFamilyArray[_j]
            __fontLookupMap[? _scriptFamily] = _fontConfig;
            
            if (_scriptFamily == MONIKER_SCRIPT_FAMILY_CHINESE_TRAD)
            {
                _funcUnpackGlyphsToMap(_fontInfo, _system.__chineseTradCharMap);
            }
            else if (_scriptFamily == MONIKER_SCRIPT_FAMILY_CHINESE_SIMP)
            {
                _funcUnpackGlyphsToMap(_fontInfo, _system.__chineseSimpCharMap);
            }
            
            ++_j;
        }
        
        ++_i;
    }
    
    static __GetFont = function(_scriptFamily)
    {
        var _font = __fontLookupMap[? _scriptFamily];
        if (_font == undefined)
        {
            show_debug_message($"Could not find data for script family {_scriptFamily}");
            _font = __fontLookupMap[? MONIKER_SCRIPT_FAMILY_FALLBACK];
        }
        
        if (_font == undefined)
        {
            show_debug_message($"Cannot find valid font for script family {_scriptFamily}");
            return -1;
        }
        
        return _font.__font;
    }
    
    static __GetXOffset = function(_scriptFamily)
    {
        var _font = __fontLookupMap[? _scriptFamily];
        if (_font == undefined)
        {
            show_debug_message($"Could not find data for script family {_scriptFamily}");
            _font = __fontLookupMap[? MONIKER_SCRIPT_FAMILY_FALLBACK];
        }
        
        if (_font == undefined)
        {
            show_debug_message($"Cannot find x-offset for script family {_scriptFamily}");
            return -1;
        }
        
        return _font[$ "xOffset"] ?? 0;
    }
    
    static __GetYOffset = function(_scriptFamily)
    {
        var _font = __fontLookupMap[? _scriptFamily];
        if (_font == undefined)
        {
            show_debug_message($"Could not find data for script family {_scriptFamily}");
            _font = __fontLookupMap[? MONIKER_SCRIPT_FAMILY_FALLBACK];
        }
        
        if (_font == undefined)
        {
            show_debug_message($"Cannot find y-offset for script family {_scriptFamily}");
            return -1;
        }
        
        return _font[$ "yOffset"] ?? 0;
    }
}