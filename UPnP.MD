```ps1
$upnp = New-Object -ComObject HNetCfg.NATUPnP
$upnp.StaticPortMappingCollection.Add(25565,"TCP",25565,"192.168.1.15",$true,"Minecraft Server")
$upnp.StaticPortMappingCollection.Add(19132,"UDP",19132,"192.168.1.15",$true,"Minecraft Bedrock")
```