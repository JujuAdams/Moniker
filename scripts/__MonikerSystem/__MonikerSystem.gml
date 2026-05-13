__MonikerSystem();

#macro __MONIKER_BINARY_SCRIPT_FAMILY_MASK  0b0011_1111
#macro __MONIKER_BINARY_CHINESE_SIMP        0b0100_0000
#macro __MONIKER_BINARY_CHINESE_TRAD        0b1000_0000

function __MonikerSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    
    with(_system)
    {
        show_debug_message($"Moniker: Welcome to Moniker by Juju Adams! This is version {MONIKER_VERSION}, {MONIKER_DATE}");
        
        if (not file_exists("moniker_lut.bin"))
        {
            show_error(" \nMoniker:\nCould not find \"moniker_lut.bin\". Please reimport the library\n ", true);
            return;
        }
        
        __lookUpBuffer = buffer_load("moniker_lut.bin");
        if (not buffer_exists(__lookUpBuffer))
        {
            show_error(" \nMoniker:\nFailed to load \"moniker_lut.bin\". Please reimport the library\n ", true);
            return;
        }
        
        __defaultFontPack = undefined;
    }
    
    return _system;
}