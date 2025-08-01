
set (platform_libs)
if (APPLE)
 list (APPEND platform_libs
   "-framework WebKit \
   -framework CoreServices \
   -framework CoreAudio \
   -framework CoreMIDI \
   -framework Cocoa \
   -framework CoreFoundation \
   -framework CoreGraphics")
endif (APPLE)