{ ... }:

{
  # This file contains common settings used across different hosts

  environment.shellAliases = {
    lsblk = "lsblk -o name,fstype,size,fsused,fsavail,fsuse%,mountpoints";
    ls = "eza -lghHbm --git --icons --time-style=long-iso --group-directories-first";
    dps = "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'";
  };
}
