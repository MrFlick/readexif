
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readexif

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The readexif package is an R package that allows you to read Exif
metadata from jpeg image files.

The existing [exifr](https://cran.r-project.org/package=exifr) package
can extract more detailed information and can translate more of the
“raw” values found in the Exif data but it requires that you also
install [ExifTool](https://exiftool.org/) as a system dependency. While
readexif is not as full-featured, it does not require this separate
program to be installed.

## Installation

You can install the latest version of readexif from
[GitHub](https://github.com/) with:

``` r
remotes::install_github("MrFlick/readexif")
```

This package is currently a work-in-progress and is not yet available on
CRAN.

## Example

The primary useful function for extracting data is `exif_df` which can
take a list of file names and will return a `data.frame` containing the
Exif tags for all those images.

``` r
library(readexif)
sample_dir <- system.file("extdata", package="readexif")
sample_files <- file.path(sample_dir, 
                          c("Iguana_iguana_male_head.jpg", 
                            "Red-headed_Rock_Agama.jpg"))
transform(exif_df(sample_files), file=basename(file))
#>                          file                  Make
#> 1 Iguana_iguana_male_head.jpg                 Canon
#> 2   Red-headed_Rock_Agama.jpg EASTMAN KODAK COMPANY
#>                              Model Orientation XResolution YResolution
#> 1                    Canon EOS 40D           1       72, 1       72, 1
#> 2 KODAK CX7530 ZOOM DIGITAL CAMERA           1       72, 1       72, 1
#>   ResolutionUnit   Software            DateTime YCbCrPositioning ExifOffset
#> 1              2 GIMP 2.4.5 2008:07:31 10:38:11                2        214
#> 2              2 GIMP 2.4.5 2008:07:31 10:39:26                1        248
#>   GPSInfo ExposureTime FNumber ExposureProgram ISO  ExifVersion
#> 1     978       1, 160  71, 10               1 100 30, 32, ....
#> 2     816       1, 250   23, 5               2  NA 30, 32, ....
#>      DateTimeOriginal   DateTimeDigitized ComponentsConfiguration
#> 1 2008:05:30 15:56:01 2008:05:30 15:56:01            01, 02, ....
#> 2 2005:08:13 09:47:23 2005:08:13 09:47:23              01, 02, 03
#>   ShutterSpeedValue ApertureValue ExposureCompensation MeteringMode Flash
#> 1      483328, ....  368640, ....                 0, 1            5     9
#> 2              8, 1         22, 5                 0, 1            5    24
#>   FocalLength  UserComment SubSecTime SubSecTimeOriginal SubSecTimeDigitized
#> 1      135, 1 00, 00, ....         00                 00                  00
#> 2       84, 5           NA       <NA>               <NA>                <NA>
#>   FlashpixVersion ColorSpace PixelXDimension PixelYDimension InteropOffset
#> 1    30, 31, ....          1             100              68           948
#> 2    30, 31, ....          1          100, 0           78, 0           786
#>   FocalPlaneXResolution FocalPlaneYResolution FocalPlaneResolutionUnit
#> 1          3888000, 876          2592000, 583                        2
#> 2                    NA                    NA                       NA
#>   CustomRendered ExposureMode WhiteBalance SceneCaptureType
#> 1              0            1            0                0
#> 2              0            0            0                0
#>   ThumbnailCompression ThumbnailXResolution ThumbnailYResolution
#> 1                    6                72, 1                72, 1
#> 2                    6                   NA                   NA
#>   ThumbnailResolutionUnit ThumbnailOffset ThumbnailByteCount MaxApertureValue
#> 1                       2            1090               1378               NA
#> 2                      NA             972               1918            22, 5
#>   LightSource xA215 SensingMethod FileSource SceneType DigitalZoomRatio
#> 1          NA    NA            NA         NA        NA               NA
#> 2           0 80, 1             2         03        01             0, 1
#>   FocalLengthIn35mmFilm GainControl Contrast Saturation Sharpness
#> 1                    NA          NA       NA         NA        NA
#> 2                   102           0        0          0         0
#>   SubjectDistanceRange
#> 1                   NA
#> 2                    0
```

Another useful function is `scan_jpeg`. This is the function will return
the positions for each of the different sections in the jpeg file.

``` r
sample_file <- system.file("extdata", "Iguana_iguana_male_head.jpg", package="readexif")
toc <- scan_jpeg(sample_file)
toc
#>        marker section          id offset length   other
#> [[1]]  0xFFE0    APP0        JFIF      4     16 Yes (7)
#> [[2]]  0xFFE1    APP1        Exif     22   2476 Yes (3)
#> [[3]]  0xFFE2    APP2 ICC_PROFILE   2500   3160        
#> [[4]]  0xFFDB     DQT          NA   5662     67        
#> [[5]]  0xFFDB     DQT          NA   5731     67        
#> [[6]]  0xFFC0    SOF0          NA   5800     17 Yes (4)
#> [[7]]  0xFFC4     DHT          NA   5819     26        
#> [[8]]  0xFFC4     DHT          NA   5847     54        
#> [[9]]  0xFFC4     DHT          NA   5903     24        
#> [[10]] 0xFFC4     DHT          NA   5929     33        
#> [[11]] 0xFFDA     SOS          NA   5964     12
toc[[6]]
#> SECTION SOF0 -- (offset: 5800, length: 17)
#> .$marker            : 0xFFC0 (65472)
#> .$section           : SOF0
#> .$Precision         : 8
#> .$ImageHeight       : 68
#> .$ImageWidth        : 100
#> .$NumberOfComponents: 3
toc[[2]]$tags
#> EXIF TAGS -- (count: 47)
#> [[1]]  Make                    : Canon              
#> [[2]]  Model                   : Canon EOS 40D      
#> [[3]]  Orientation             : 1                  
#> [[4]]  XResolution             : 72, 1              
#> [[5]]  YResolution             : 72, 1              
#> [[6]]  ResolutionUnit          : 2                  
#> [[7]]  Software                : GIMP 2.4.5         
#> [[8]]  DateTime                : 2008:07:31 10:38:11
#> [[9]]  YCbCrPositioning        : 2                  
#> [[10]] ExifOffset              : 214                
#> [[11]] GPSInfo                 : 978                
#> [[12]] ExposureTime            : 1, 160             
#> [[13]] FNumber                 : 71, 10             
#> [[14]] ExposureProgram         : 1                  
#> [[15]] ISO                     : 100                
#> [[16]] ExifVersion             : <4 byte(s)>        
#> [[17]] DateTimeOriginal        : 2008:05:30 15:56:01
#> [[18]] DateTimeDigitized       : 2008:05:30 15:56:01
#> [[19]] ComponentsConfiguration : <4 byte(s)>        
#> [[20]] ShutterSpeedValue       : 483328, 65536      
#> [[21]] ApertureValue           : 368640, 65536      
#> [[22]] ExposureCompensation    : 0, 1               
#> [[23]] MeteringMode            : 5                  
#> [[24]] Flash                   : 9                  
#> [[25]] FocalLength             : 135, 1             
#> [[26]] UserComment             : <264 byte(s)>      
#> [[27]] SubSecTime              : 00                 
#> [[28]] SubSecTimeOriginal      : 00                 
#> [[29]] SubSecTimeDigitized     : 00                 
#> [[30]] FlashpixVersion         : <4 byte(s)>        
#> [[31]] ColorSpace              : 1                  
#> [[32]] PixelXDimension         : 100                
#> [[33]] PixelYDimension         : 68                 
#> [[34]] InteropOffset           : 948                
#> [[35]] FocalPlaneXResolution   : 3888000, 876       
#> [[36]] FocalPlaneYResolution   : 2592000, 583       
#> [[37]] FocalPlaneResolutionUnit: 2                  
#> [[38]] CustomRendered          : 0                  
#> [[39]] ExposureMode            : 1                  
#> [[40]] WhiteBalance            : 0                  
#> [[41]] SceneCaptureType        : 0                  
#> [[42]] ThumbnailCompression    : 6                  
#> [[43]] ThumbnailXResolution    : 72, 1              
#> [[44]] ThumbnailYResolution    : 72, 1              
#> [[45]] ThumbnailResolutionUnit : 2                  
#> [[46]] ThumbnailOffset         : 1090               
#> [[47]] ThumbnailByteCount      : 1378
toc[[2]]$tags[[2]]
#> TAG -- (offset: 52, length: 12)
#> .$code : 0x0110 (272)
#> .$name : Model
#> .$fmt  : 2 (ascii string)
#> .$count: 14
#> .$value: Canon EOS 40D
#>  [tag data offset: 182, length: 14]
```

## References

This package was created using the helpful information from the
following resources

-   [JPEG File Layout and
    Format](http://vip.sugovica.hu/Sardi/kepnezo/JPEG%20File%20Layout%20and%20Format.htm)
-   [The Metadata in JPEG
    files](https://dev.exiv2.org/projects/exiv2/wiki/The_Metadata_in_JPEG_files)
-   [ExifTool list of EXIF
    tags](https://exiftool.org/TagNames/EXIF.html)
-   [Description of Exif file
    format](https://www.media.mit.edu/pia/Research/deepview/exif.htm)

This package includes sample images from
[ianare/exif-samples](https://github.com/ianare/exif-samples/tree/master/jpg).
Some images originally were from [Wikimedia
Commons](https://commons.wikimedia.org/). Those images are

-   [Positive\_roll\_film.jpg](https://commons.wikimedia.org/wiki/File:Positive_roll_film.jpg)
    by [Ianaré Sévi](https://commons.wikimedia.org/wiki/User:Ianare),
-   [Ducati749.jpg](https://commons.wikimedia.org/wiki/File:Ducati749.jpg)
    by [Monster1000](https://fr.wikipedia.org/wiki/User:Monster1000),
-   [Red-headed\_Rock\_Agama.jpg](https://commons.wikimedia.org/wiki/File:Red-headed_Rock_Agama.jpg)
    by [Chris\_huh](https://commons.wikimedia.org/wiki/User:Chris_huh)
    and
-   [Iguana\_iguana\_male\_head.jpg](https://commons.wikimedia.org/wiki/File:Iguana_iguana_male_head.jpg)
    by [Ianaré Sévi](https://commons.wikimedia.org/wiki/User:Ianare).

Note that these images were scaled down to reduce file size.
