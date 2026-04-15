function __MonikerParseHebrew(_string)
{
    var _glyphArray = __MonikerDecompose(_string);
    array_push(_glyphArray, 0x00);
    __MonikerGlyphArrayBiDiReorder(_glyphArray, true, false);
    return __MonikerRecompose(_glyphArray, false);
}