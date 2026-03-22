{ config, ... }: {
  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    useDHCP = false;
    useNetworkd = true;
    usePredictableInterfaceNames = true;

    # Point to systemd-resolved stub
    nameservers = [ "127.0.0.53" ];

    # Keep search domains for local resolution
    search = [
      "dev.sarw.dev"
    ];
  };
}