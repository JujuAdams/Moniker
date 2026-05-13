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
///            preload: true,
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
///            preload: true,
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
///            preload: true,
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
    
    __hasChineseSimpFont = false;
    __hasChineseTradFont = false;
    
    __fontConfigArray = [];
    __fontLookupMap   = ds_map_create();
    __cacheMap        = ds_map_create();
    
    
    
    _configData = variable_clone(_configData);
    
    var _i = 0;
    repeat(array_length(_configData))
    {
        var _fontConfig = _configData[_i];
        
        //Flesh out the font config with some state tracking and methods
        with(_fontConfig)
        {
            __sdf = other.__sdf;
            
            __font     = undefined;
            __fontInfo = undefined;
            
            __EnsureFont = function()
            {
                if (__font == undefined) 
                {
                    if (MONIKER_VERBOSE)
                    {
                        var _timer = current_time;
                    }
                    
                    var _oldAA = font_add_get_enable_aa();
                    font_add_enable_aa(MONIKER_ANTIALIAS);
                    
                    __font = font_add(path, size, false, false, 32, 127);
                    font_enable_sdf(__font, __sdf);
                    
                    font_add_enable_aa(_oldAA);
                    
                    if (MONIKER_VERBOSE)
                    {
                        show_debug_message($"Took {current_time - _timer}ms to load \"{path}\"");
                    }
                }
                
                return __font;
            }
            
            __EnsureInfo = function()
            {
                if (__fontInfo == undefined)
                {
                    __EnsureFont();
                    
                    if (MONIKER_VERBOSE)
                    {
                        var _timer = current_time;
                    }
                    
                    __fontInfo = font_get_info(__font);
                    
                    if (MONIKER_VERBOSE)
                    {
                        show_debug_message($"Took {current_time - _timer}ms to execute `font_get_info()` for \"{path}\"");
                    }
                }
                
                return __fontInfo;
            }
            
            if (not file_exists(path))
            {
                show_error($" \nMoniker:\nCould not find \"{path}\"\n ", true);
            }
            
            if (not struct_exists(self, "preload"))
            {
                preload = MONIKER_DEFAULT_PRELOAD;
            }
            
            if (preload)
            {
                __EnsureFont();
            }
        }
        
        //Turn the incoming font config into an array in case it's not already
        var _scriptFamilyArray = _fontConfig.scriptFamily;
        
        if (not is_array(_scriptFamilyArray))
        {
            _scriptFamilyArray = [_scriptFamilyArray];
        }
        
        //Store the font configs in an easy-to-look-up ds_map
        var _j = 0;
        repeat(array_length(_scriptFamilyArray))
        {
            var _scriptFamily = _scriptFamilyArray[_j];
            
            __fontLookupMap[? _scriptFamily] = _fontConfig;
            array_push(__fontConfigArray, _fontConfig);
            
            if (_scriptFamily == MONIKER_SCRIPT_FAMILY_CHINESE_SIMP)
            {
                __hasChineseSimpFont = true;
            }
            else if (_scriptFamily == MONIKER_SCRIPT_FAMILY_CHINESE_TRAD)
            {
                __hasChineseTradFont = true;
            }
            
            ++_j;
        }
        
        ++_i;
    }
    
    
    
    static EnsureFont = function(_scriptFamily)
    {
        var _font = __fontLookupMap[? _scriptFamily];
        if (_font == undefined)
        {
            show_debug_message($"Could not find data for script family {_scriptFamily}");
            return;
        }
        
        _font.__EnsureFont();
    }
    
    static EnsureAllFonts = function()
    {
        var _i = 0;
        repeat(array_length(__fontConfigArray))
        {
            __fontConfigArray[_i].__EnsureInfo();
            ++_i;
        }
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
        
        return _font.__EnsureFont();
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