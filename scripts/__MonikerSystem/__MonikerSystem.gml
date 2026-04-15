function __MonikerSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    
    with(_system)
    {
        show_debug_message("Moniker: Welcome to Moniker by Juju Adams! This is version 1.0.0, 2026-02-24");
        
        __defaultFontPack    = undefined;
        __chineseTradCharMap = ds_map_create();
        __chineseSimpCharMap = ds_map_create();
    }
    
    return _system;
}