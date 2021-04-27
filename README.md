# Photoshop Plugin Starter

This is a basic environment written in CMake for Photoshop plug-in development.
[PhotoShop SDK](https://console.adobe.io/downloads/ps) is not included. (*Just in case, licensing issue.*) You can find how to download it through more information.

Unfortunately, it doesn't support macOS yet. ~~Because I don't have a mac...😥~~

[More information.](https://phruse.com/pat1/)

## Required

### Required CMake argument
* -DCERT_PASSWORD=password

### Required file list
* "./tool" folder (Cnvtpipl.exe, ZXPSignCmd.exe - for release)
* "./cert" folder (cert.p12) - for release
* "./sdk" folder ([PhotoShop SDK](https://console.adobe.io/downloads/ps))
  
  pluginsdk/samplecode/common -> sdk/common
  
  pluginsdk/photoshopapi/photoshop -> sdk/photoshop
  
  pluginsdk/photoshopapi/pica_sp -> sdk/pica_sp

## Referance

* [PhotoShop SDK](https://console.adobe.io/downloads/ps) documentation (PICA.pdf)
* [PhotoShop SDK](https://console.adobe.io/downloads/ps) -> pluginsdk/samplecode