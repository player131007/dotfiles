{ config, inputs, ... }: {
    programs.foot.settings.main = {
        include = config.scheme inputs.base16-foot;
    };
}
