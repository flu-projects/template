import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:wallet/utils/utils.dart';

class Images extends StatelessWidget {
  const Images(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format,
    this.holderImg = 'assets/images/error.webp',
    this.errorImage = 'assets/images/error.webp',
    this.cacheWidth,
    this.cacheHeight,
    this.color,
    this.colorBlendMode,
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat? format;

  ///加载底图
  final String holderImg;

  ///加载失败默认图
  final String errorImage;
  final int? cacheWidth;
  final int? cacheHeight;
  final Color? color;

  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return _setLoadAssetImage(errorImage);
    }

    if (image.startsWith('http')) {
      final Widget _image = Image.asset(
        holderImg,
        height: height,
        width: width,
        fit: fit,
      );
      if (image.endsWith('.svg')) {
        return SvgPicture.network(
          image,
          width: width,
          height: height,
          fit: fit,
          // color: Colours.grey,
          placeholderBuilder: (_) => _image,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (_, __) => _image,
          color: color,
          colorBlendMode: colorBlendMode,
          errorWidget: (_, __, dynamic error) {
            return Container(
              width: width,
              height: height,
              child: _LoadAssetImage(
                errorImage,
                height: height,
                width: width,
                fit: fit,
              ),
            );
          },
          width: width,
          height: height,
          fit: fit,
          cacheManager: ImgCacheMgr(),
        );
      }
    } else {
      return _setLoadAssetImage(image);
    }
  }

  Widget _setLoadAssetImage(String _image) {
    return _LoadAssetImage(
      _image,
      height: height,
      width: width,
      fit: fit,
      format: format,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      color: color,
    );
  }
}

class _LoadAssetImage extends StatelessWidget {
  const _LoadAssetImage(this.image,
      {Key? key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format,
      this.color})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat? format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    switch (_getFormat()) {
      case ImageFormat.png:
      case ImageFormat.jpg:
      case ImageFormat.gif:
      case ImageFormat.webp:
        return Image.asset(
          image,
          height: height,
          width: width,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          fit: fit,
          color: color,
          excludeFromSemantics: true,
        );
      case ImageFormat.svg:
        return SvgPicture.asset(
          image,
          height: height,
          width: width,
          fit: fit!,
          color: color,
          excludeFromSemantics: true,
        );
      default:
        return Image.asset(
          image,
          height: height,
          width: width,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          fit: fit,
          color: color,
          excludeFromSemantics: true,
        );
    }
  }

  ImageFormat _getFormat() {
    if (format == null) {
      int index = image.lastIndexOf('.');
      if (index <= 0) {
        return ImageFormat.png;
      }
      String suffix = image.substring(index);
      switch (suffix.toLowerCase()) {
        case '.png':
          return ImageFormat.png;
        case '.jpg':
          return ImageFormat.jpg;
        case '.gif':
          return ImageFormat.gif;
        case '.webp':
          return ImageFormat.webp;
        case '.svg':
          return ImageFormat.svg;
        default:
          return ImageFormat.png;
      }
    } else {
      return format!;
    }
  }
}

class ImgCacheMgr extends CacheManager {
  static ImgCacheMgr? _instance;

  factory ImgCacheMgr() {
    _instance ??= ImgCacheMgr._();
    return _instance!;
  }

  ImgCacheMgr._() : super(Config('ImgCacheMgr'));

  Future<double> getCacheRomSize() async {
    var path = await getFilePath();
    Directory dir = Directory(path);
    double value = await _getTotalSizeOfFilesInDir(dir);
    return value;
  }

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, 'ImgCacheMgr');
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity>? children = file.listSync();
      double total = 0;
      if (children != null) {
        for (FileSystemEntity child in children) {
          total += await _getTotalSizeOfFilesInDir(child);
        }
      }
      return total;
    }
    return 0;
  }
}
