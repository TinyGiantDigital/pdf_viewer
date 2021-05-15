import 'dart:io';
import 'dart:ui';
import 'package:advance_pdf_viewer/src/zoomable_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

/// A class to represent PDF page
/// [imgPath], path of the image (pdf page)
/// [num], page number
/// [onZoomChanged], function called when zoom is changed
/// [zoomSteps], number of zoom steps on double tap
/// [minScale] minimum zoom scale
/// [maxScale] maximum zoom scale
/// [panLimit] limit for pan
class PDFPage extends StatefulWidget {
  final String imgPath;
  final int num;
  final Function(double) onZoomChanged;
  final int zoomSteps;
  final double minScale;
  final double maxScale;
  final double panLimit;
  PDFPage(
    this.imgPath,
    this.num, {
    this.onZoomChanged,
    this.zoomSteps = 3,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.panLimit = 1.0,
  });

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  ImageProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repaint();
  }

  @override
  void didUpdateWidget(PDFPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath) {
      _repaint();
    }
  }

  _repaint() {
    provider = FileImage(File(widget.imgPath));
    final resolver = provider.resolve(createLocalImageConfiguration(context));
    resolver.addListener(ImageStreamListener((imgInfo, alreadyPainted) {
      if (!alreadyPainted) setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAFAFA),
      decoration: null,
      child: ZoomableWidget(
        onZoomChanged: widget.onZoomChanged,
        zoomSteps: widget.zoomSteps ?? 3,
        minScale: widget.minScale ?? 1.0,
        panLimit: widget.panLimit ?? 1.0,
        maxScale: widget.maxScale ?? 5.0,
        child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 16,
                offset: Offset(0,6)
              )]
            ),
            child: Image(image: provider),
          )
      ));
  }
}
