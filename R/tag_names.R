#' Get name for Exif tag code
#'
#' @param code The numeric code for an Exif tag
#' @param fill_na If the description for a code is not
#'   found, NA will be returned by default (FALSE).
#'   To generate a name using hex code, set to TRUE
#'
#' @return A character vector with code names (if available)
#' @export
#'
#' @seealso [get_known_tags()]
#'
#' @examples
#' get_tag_name(0x0112)
#' get_tag_name(41991:41994)
#' get_tag_name(5) # not a valid code
#' get_tag_name(5, fill_na = TRUE)

get_tag_name <- function(code, fill_na = FALSE) {
  names <- merge(data.frame(code=code), tag_names, all.x=TRUE)$name
  if (fill_na) {
    names[is.na(names)] <- vapply(code[is.na(names)], function(x) sprintf("x%04X", x), character(1))
  }
  names
}


#' Get known Exif tags
#'
#' Return a data.frame with known Exif codes and names
#'
#' @return A data.frame
#' @export
#' @seealso [get_tag_name()]
#' @examples
#' get_known_tags()
#'
get_known_tags <- function() {
  data <- tag_names
  data$hex <- fhex(data$code)
  data
}

get_tag_code_from_name <- function(name) {
  merge(data.frame(name=name), tag_names, all.x=TRUE)$code
}


# Just a helper function to import the following list
tdata <- function(...) {
  call <- match.call()
  codes <- call[c(1, seq(2, length(call), by=2))]
  codes[[1]] <- quote(c)
  names <- call[c(1, seq(3, length(call), by=2))]
  names[[1]] <- quote(c)
  data.frame(code = eval.parent(codes), name = eval.parent(names))
}

tag_names <- tdata(
  0x0001, "InteropIndex",
  0x0002, "InteropVersion",
  0x000b, "ProcessingSoftware",
  0x00fe, "SubfileType",
  0x00ff, "OldSubfileType",
  0x0100, "ImageWidth",
  0x0101, "ImageHeight",
  0x0102, "BitsPerSample",
  0x0103, "Compression",
  0x0106, "PhotometricInterpretation",
  0x0107, "Thresholiding",
  0x0108, "CellWidth",
  0x0109, "CellHeight",
  0x010a, "FillOrder",
  0x010d, "DocumentName",
  0x010e, "ImageDescription",
  0x010f, "Make",
  0x0110, "Model",
  0x0111, "StripOffsets",
  0x0112, "Orientation",
  0x0115, "SamplesPerPixel",
  0x0116, "RowsPerStrip",
  0x0117, "StripBytesCounts",
  0x0118, "MinSampleValue",
  0x0119, "MaxSampleValue",
  0x011a, "XResolution",
  0x011b, "YResolution",
  0x011c, "PlanarConfiguration",
  0x011d, "PageName",
  0x011e, "XPosition",
  0x011f, "YPosition",
  0x0120, "FreeOffsets",
  0x0121, "FreeByteCounts",
  0x0122, "GrayResponseUnit",
  0x0123, "GrayResponseCurve",
  0x0128, "ResolutionUnit",
  0x0129, "PageNumber",
  0x012c, "ColorResponseUnit",
  0x012d, "TransferFunction",
  0x0131, "Software",
  0x0132, "DateTime",
  0x013b, "Artist",
  0x013c, "HostComputer",
  0x013d, "Predictor",
  0x013e, "WhitePoint",
  0x013f, "PrimaryChromaticies",
  0x0140, "ColorMap",
  0x0141, "HalftoneHints",
  0x0142, "TileWidth",
  0x0143, "TileHeight",
  0x014c, "Inkset",
  0x0153, "SampleFormat",
  0x0201, "ThumbnailOffset",
  0x0202, "ThumbnailByteCount",
  0x0211, "YCbCrCoefficients",
  0x0212, "YCbCrSubSampling",
  0x0213, "YCbCrPositioning",
  0x0214, "ReferenceBlackWhite",
  0x022f, "StripRowCounts",
  0x02bc, "ApplicationNotes",
  0x1000, "RelatedImageFileFormat",
  0x1001, "RelatedImageWidth",
  0x1002, "RelatedImageHeight",
  0x4746, "Rating",
  0x4749, "RatingPercent",
  0x7031, "VignettingCorrection",
  0x7032, "VignettingCorrParams",
  0x7034, "ChromaticAberrationCorrection",
  0x7035, "ChromaticAberrationCorrParams",
  0x7036, "DistortionCorrection",
  0x7037, "DistortionCorrParams",
  0x74c7, "SonyCropTopLeft",
  0x74c8, "SonyCropSize",
  0x8298, "Copyright",
  0x829a, "ExposureTime",
  0x829d, "FNumber",
  0x830e, "PixelScale",
  0x8769, "ExifOffset",
  0x8822, "ExposureProgram",
  0x8825, "GPSInfo",
  0x8827, "ISO",
  0x8830, "SensitivityType",
  0x8832, "RecommendedExposureIndex",
  0x9000, "ExifVersion",
  0x9003, "DateTimeOriginal",
  0x9004, "DateTimeDigitized",
  0x9010, "OffsetTime",
  0x9011, "OffsetTimeOriginal",
  0x9012, "OffsetTimeDigitized",
  0x9101, "ComponentsConfiguration",
  0x9102, "CompressedBitsPerPixel",
  0x9201, "ShutterSpeedValue",
  0x9202, "ApertureValue",
  0x9203, "BrightnessValue",
  0x9204, "ExposureCompensation",
  0x9205, "MaxApertureValue",
  0x9206, "SubjectDistance",
  0x9207, "MeteringMode",
  0x9208, "LightSource",
  0x9209, "Flash",
  0x920A, "FocalLength",
  0x9214, "SubjectArea",
  0x927C, "MarkerNote",
  0x9286, "UserComment",
  0x9290, "SubSecTime",
  0x9291, "SubSecTimeOriginal",
  0x9292, "SubSecTimeDigitized",
  0x9C9B, "XPTitle",
  0x9C9C, "XPComment",
  0x9C9D, "XPAuthor",
  0x9C9E, "XPKeywords",
  0x9C9F, "XPSubject",
  0xA000, "FlashpixVersion",
  0xA001, "ColorSpace",
  0xA002, "PixelXDimension",
  0xA003, "PixelYDimension",
  0xA004, "RelatedSoundFile",
  0xA005, "InteropOffset",
  0xA20E, "FocalPlaneXResolution",
  0xA20F, "FocalPlaneYResolution",
  0xA210, "FocalPlaneResolutionUnit",
  0xA217, "SensingMethod",
  0xA300, "FileSource",
  0xA301, "SceneType",
  0xA302, "CFAPattern",
  0xA401, "CustomRendered",
  0xA402, "ExposureMode",
  0xA403, "WhiteBalance",
  0xA404, "DigitalZoomRatio",
  0xA405, "FocalLengthIn35mmFilm",
  0xA406, "SceneCaptureType",
  0xA407, "GainControl",
  0xA408, "Contrast",
  0xA409, "Saturation",
  0xA40A, "Sharpness",
  0xA40C, "SubjectDistanceRange",
  0xA420, "ImageUniqueID",
  0xA430, "OwnerName",
  0xA431, "SerialNumber",
  0xA432, "LensSpecification",
  0xA433, "LensMake",
  0xA434, "LensModel",
  0xA435, "LensSerialNumber",
  0xA460, "CompositeImage",
  0xA500, "Gamma",
  0xEA1C, "Padding",
  0xEA1D, "OffsetSchema"
)
