/// Returns whether simplified Chinese should be preferred when rendering Chinese characters that
/// might have different forms in traditional and simplified scripts.

function MonikerGetPreferSimplifiedChinese()
{
    static _system = __MonikerSystem();
    return _system.__preferSimplifiedChinese;
}