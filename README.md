# Photoshop Plugin Starter

This is a basic environment written in CMake for Photoshop plug-in development.
[PhotoShop SDK](https://console.adobe.io/downloads/ps) is not included. (*Just in case, licensing issue.*) 
You can find how to download it through more information. 
If you need code signing, modify the POST_BUILD part.

[More information.](https://phruse.com/pat1/)

Now, This Starter supports Windows and macOS and has no code use conditions (Unlicense).

## Required
### Required CMake argument
Release build only
* -DCERT_PASSWORD=password 

### Required files
#### Common
* "./sdk" folder ([PhotoShop SDK](https://console.adobe.io/downloads/ps))
  
  pluginsdk/samplecode/common -> sdk/common
  
  pluginsdk/photoshopapi/photoshop -> sdk/photoshop
  
  pluginsdk/photoshopapi/pica_sp -> sdk/pica_sp

  pluginsdk/photoshopapi/resources -> sdk/resources  - macOS build only

#### Windows
* "./tools" folder (Cnvtpipl.exe, ZXPSignCmd.exe - for release)
* "./cert" folder (cert.p12) - for release

### Required tools
#### Windows
* MSVC v141 
* Cnvtpipl.exe - include [PhotoShop SDK](https://console.adobe.io/downloads/ps)
* ZXPSignCmd.exe
#### macOS
* clang - include Xcode
* Rez - include Xcode

## Referance

* [PhotoShop SDK](https://console.adobe.io/downloads/ps) documentation (PICA.pdf)
* [PhotoShop SDK](https://console.adobe.io/downloads/ps) -> pluginsdk/samplecode
