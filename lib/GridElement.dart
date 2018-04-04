import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum GridDemoTileStyle { imageOnly, oneLine, twoLine }

typedef void BannerTapCallback(Photo photo);

const double _kMinFlingVelocity = 800.0;

class Photo {
  Photo({
    this.link,
    this.title,
    this.caption,
  });

  final String link;
  final String title;
  final String caption;
}

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({Key key, this.photo}) : super(key: key);

  final Photo photo;

  @override
  _GridPhotoViewerState createState() => new _GridPhotoViewerState();
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(text),
    );
  }
}

class _GridPhotoViewerState extends State<GridPhotoViewer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
            begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: new ClipRect(
        child: new Transform(
            transform: new Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            child: new Image.network(
              "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}

class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem(
      {Key key,
      @required this.photo,
      @required this.tileStyle,
      @required this.onBannerTap})
      : assert(photo != null),
        assert(tileStyle != null),
        assert(onBannerTap != null),
        super(key: key);

  final Photo photo;
  final GridDemoTileStyle tileStyle;
  final BannerTapCallback
      onBannerTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text(photo.title)),
        body: new SizedBox.expand(
          child: new Hero(
            child: new GridPhotoViewer(photo: photo),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
      onTap: () {
        showPhoto(context);
      },
      child: new Image.network(
        this.photo.link,
        fit: BoxFit.cover,
      ),
    );
    switch (tileStyle) {
      case GridDemoTileStyle.imageOnly:
        return image;

      case GridDemoTileStyle.oneLine:
        return new GridTile(
          header: new GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: new GridTileBar(
              title: new _GridTitleText(photo.title),
              backgroundColor: Colors.black45,
            ),
          ),
          child: image,
        );

      case GridDemoTileStyle.twoLine:
        return new GridTile(
          footer: new GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: new GridTileBar(
              backgroundColor: Colors.black45,
              title: new _GridTitleText(photo.title),
              subtitle: new _GridTitleText(photo.caption),
            ),
          ),
          child: image,
        );
    }
    assert(tileStyle != null);
    return null;
  }
}

class GridListDemo extends StatefulWidget {
  const GridListDemo({Key key}) : super(key: key);

  static const String routeName = '/material/grid-list';

  @override
  GridListDemoState createState() => new GridListDemoState();
}

class GridListDemoState extends State<GridListDemo> {

  GridDemoTileStyle _tileStyle = GridDemoTileStyle.twoLine;

  List<Photo> photos = <Photo>[
    new Photo(
      title: 'Philippines',
      caption: 'Batad rice terraces',
      link: "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
    ),
    new Photo(
      title: 'Italy',
      caption: 'Ceresole Reale',
      link: "https://c1.staticflickr.com/4/3890/15300686592_1dd0c35fb3_c.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3938/15328999679_ac5a97c287_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/6/5558/15251192595_1d9539766c_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/3/2947/15329032467_4fb72f9700_c.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3938/15328999679_ac5a97c287_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
    ),
    new Photo(
      title: 'A place',
      caption: 'Beautiful hills',
      link: "https://c1.staticflickr.com/4/3872/15114707958_03e5c871a8_b.jpg",
    ),
  ];

  void changeTileStyle(GridDemoTileStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new SafeArea(
              top: false,
              bottom: false,
              child: new GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio:
                    (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map((Photo photo) {
                  return new GridDemoPhotoItem(
                      photo: photo,
                      tileStyle: _tileStyle,
                      onBannerTap: (Photo photo) {
                        setState(() {});
                      });
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
