/// Returns a cached struct constructed by `Moniker()`. Each font pack has a separate cache. If no
/// font pack is specified then this function will use the default font pack (the font pack that
/// was first created).
/// 
/// N.B. You should not call `.SetFontPack()` on the struct that this function returns.
/// 
/// @param name
/// @param [fontPack]

function MonikerCache(_name, _fontPack = undefined)
{
    static _system = __MonikerSystem();
    
    _fontPack ??= _system.__defaultFontPack;
    
    var _cacheMap = _fontPack.__cacheMap;
    var _monikerStruct = _cacheMap[? _name];
    if (_monikerStruct == undefined)
    {
        _monikerStruct = new Moniker(_name, _fontPack);
        _cacheMap[? _name] = _monikerStruct;
    }
    
    return _monikerStruct;
}