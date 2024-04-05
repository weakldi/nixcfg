{
    pkgs,
    system,
    inputs,
    config,
    lib,
    myLib,
}:

{
    options = {

    };

    config = {
        wayland.windowManager.hyperland = {
            enable = true;
        }
    };

}