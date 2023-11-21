{ inputs, ... }:
{
    imports = [
        inputs.impermanence.nixosModule
    ];

    environment.persistence."/persist" = {
        directories = [
            "/etc/NetworkManager/system-connections"
        ];
        files = [
            "/etc/adjtime"
            "/etc/machine-id"
            "/etc/resolv.conf"
        ];
    };

}
