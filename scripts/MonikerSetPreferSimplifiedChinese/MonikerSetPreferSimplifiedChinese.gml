/// Sets whether simplified Chinese should be preferred when rendering Chinese characters that
/// might have different forms in traditional and simplified scripts.
/// 
/// @param state

function MonikerSetPreferSimplifiedChinese(_state)
{
    static _system = __MonikerSystem();
    _system.__preferSimplifiedChinese = _state;
}