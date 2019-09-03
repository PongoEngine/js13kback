package engine.display;

@:enum
abstract BlendMode(String) to String
{
    var NORMAL = "source-over";
    var MULTIPLY = "multiply";
    var SCREEN = "screen";
    var OVERLAY = "overlay";
    var DARKEN = "darken";
    var LIGHTEN = "lighten";
    var COLOR_DODGE = "color-dodge";
    var COLOR_BURN = "color-burn";
    var HARD_LIGHT = "hard-light";
    var SOFT_LIGHT = "soft-light";
    var DIFFERENCE = "difference";
    var EXCLUSION = "exclusion";
    var HUE = "hue";
    var SATURATION = "saturation";
    var COLOR = "color";
    var LUMINOSITY = "luminosity";
}