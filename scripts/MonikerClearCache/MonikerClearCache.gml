/// Clears the cache for a font pack. If no font pack is specified then this function will use the
/// default font pack (the font pack that was first created).
/// 
/// @param [fontPack]

function MonikerClearCache(_fontPack = undefined)
{
    static _system = __MonikerSystem();
    
    _fontPack ??= _system.__defaultFontPack;
    
    if (_fontPack != undefined)
    {
        ds_map_clear(_fontPack.__cacheMap);
    }
}