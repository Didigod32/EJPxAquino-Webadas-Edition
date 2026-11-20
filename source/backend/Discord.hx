package backend;

class DiscordClient
{
    public static var isInitialized:Bool = false;

    public static function check() {}

    public static function prepare() {}

    public static function initialize() {}

    public static function shutdown() {}

    public static function changePresence(details:String, ?state:String, ?smallImageKey:String, ?hasStartTimestamp:Bool = false, ?endTimestamp:Float = 0) {}

    public static function resetClientID() {}

    public static function runCallbacks() {}

    public static function addLuaCallbacks(lua:Dynamic) {}

    public static function loadModRPC() {}
}