import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/prov/image_prov.dart';

class CustomCachedNetworkImage extends StatefulWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.isBoxFit,
  });

  final String? imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final bool isBoxFit;
  @override
  State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage> {
  @override
  Widget build(BuildContext context) {

    return Consumer<ImageProv>(
        builder: (context, imageProv, child) {
        return CachedNetworkImage(
          imageUrl: widget.imagePath.toString(),  // 이미지 URL
          placeholder: (context, url) {
            return Container(
              width: widget.imageWidth ?? null,  // 이미지의 세로 크기
              height: widget.imageHeight ?? null,
            );
          },
          errorWidget: (context, url, error) {
            return Icon(
              null,
              color: Colors.black,
              size: widget.imageWidth,
            );
          },
          fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
          fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
          width: widget.imageWidth ?? null,  // 이미지의 세로 크기
          height: widget.imageHeight ?? null,
          fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
          imageBuilder: (context, imageProvider) {
            return Image(
              image: imageProvider,
              fit: widget.isBoxFit ? BoxFit.cover : null,
            );  // 이미지가 로드되면 표시
          },
        );
      }
    );
  }
}
