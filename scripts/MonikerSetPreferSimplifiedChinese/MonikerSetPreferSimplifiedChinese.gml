/// @param state

function MonikerSetPreferSimplifiedChinese(_state)
{
    static _system = __MonikerSystem();
    _system.__preferSimplifiedChinese = _state;
}