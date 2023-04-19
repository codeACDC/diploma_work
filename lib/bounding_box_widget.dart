import 'package:diploma_work/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoundingBoxWidget extends StatefulWidget {
  List<dynamic>? prediction;

  BoundingBoxWidget({Key? key, this.prediction}) : super(key: key);

  @override
  State<BoundingBoxWidget> createState() => _BoundingBoxWidgetState();
}

class _BoundingBoxWidgetState extends State<BoundingBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.prediction != null
        ? Stack(
            children: [
              ...widget.prediction!.map((e) => Builder(builder: (context) {
                    // print(e[PredictionConsts.rect][BoundingBoxConst.w].runtimeType);
                    // print(e[PredictionConsts.rect][BoundingBoxConst.x].runtimeType);

                    return Stack(children: [
                      Positioned(
                          width: (e[PredictionConsts.rect][BoundingBoxConst.w]
                                  as double)
                              .sw,
                          height: (e[PredictionConsts.rect][BoundingBoxConst.h]
                                  as double)
                              .sh,
                          top: (e[PredictionConsts.rect][BoundingBoxConst.y]
                                  as double)
                              .sh,
                          left: (e[PredictionConsts.rect][BoundingBoxConst.x]
                                  as double)
                              .sw,
                          child: Container(
                            width: (e[PredictionConsts.rect][BoundingBoxConst.w]
                                    as double)
                                .sw,
                            height: (e[PredictionConsts.rect]
                                    [BoundingBoxConst.h] as double)
                                .sh,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.deepOrange, width: 2)),
                          )),
                      Positioned(
                          top: (e[PredictionConsts.rect][BoundingBoxConst.y]
                                  as double)
                              .sh,
                          left: (e[PredictionConsts.rect][BoundingBoxConst.x]
                                  as double)
                              .sw,
                          child: Text(
                            '${e[PredictionConsts.detectedClass]} ${(e[PredictionConsts.confidence] * 100).toString().substring(0, 5)}%',
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.white,backgroundColor: Colors.deepOrange),
                          )),
                    ]);
                  }))
            ],
          )
        : const SizedBox();
  }
}
