final: prev:{
    spder-custom = prev.spyder.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [
            prev.python3
            prev.python3Packages.spyder-kernels
            prev.python3Packages.jupyter
        ];
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [] ++ [
            prev.python3Packages.spyder-kernels
            prev.python3Packages.jupyter
        ];
    });
}