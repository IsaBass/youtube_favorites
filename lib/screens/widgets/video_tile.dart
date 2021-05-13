import 'package:flutter/material.dart';
import 'package:yout_favorites/api/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  const VideoTile({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              video.thumbnail,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${video.title}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        video.channel,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.star_border_outlined,
                  color: Colors.red,
                  size: 32,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
