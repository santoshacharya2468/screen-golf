import 'package:flutter/material.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/stacked_image_header.dart';
import 'input_spacer.dart';

class HotelInfoCard extends StatefulWidget {
  final Shop? shop;
  const HotelInfoCard({Key? key, required this.shop}) : super(key: key);

  @override
  _HotelInfoCardState createState() => _HotelInfoCardState();
}

class _HotelInfoCardState extends State<HotelInfoCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
              height: size.height * 0.25,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: StackedImageHeader(shopInfo: widget.shop!))),
          InputSpacer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputSpacer(
                  child: Text(
                    "${widget.shop?.name}",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                InputSpacer(
                  child: Text(
                    '0.8km',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          InputSpacer(
              child: Row(
            children: [
              Text("Our own massage shop."),
              Icon(Icons.keyboard_arrow_down, color: Colors.black)
            ],
          )),
          InputSpacer(
            child: Row(
              children: [
                Text('Other Random details'),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      Container(
                          color: Colors.red,
                          child: InputSpacer(
                            child: Text(
                              '30%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.white),
                            ),
                          )),
                      Container(
                          color: Colors.white,
                          child: InputSpacer(
                            child: Text('discount right now',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.red)),
                          ))
                    ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
