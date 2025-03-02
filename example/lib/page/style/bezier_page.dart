import 'package:example/page/more/theme.dart';
import 'package:example/widget/menu_bottom_bar.dart';
import 'package:example/widget/skeleton_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class BezierPage extends StatefulWidget {
  const BezierPage({Key? key}) : super(key: key);

  @override
  State<BezierPage> createState() => _BezierPageState();
}

class _BezierPageState extends State<BezierPage> {
  late EasyRefreshController _controller;
  int _count = 10;
  Axis _scrollDirection = Axis.vertical;
  int _expandedIndex = -1;
  final _BIProperties _headerProperties = _BIProperties(
    name: 'Header',
    alignment: MainAxisAlignment.center,
    infinite: false,
  );
  final _BIProperties _footerProperties = _BIProperties(
    name: 'Footer',
    alignment: MainAxisAlignment.start,
    infinite: true,
  );

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertiesItems = [_headerProperties, _footerProperties];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bezier'),
      ),
      body: EasyRefresh(
        controller: _controller,
        header: BezierHeader(),
        footer: BezierFooter(),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            _count = 10;
          });
          _controller.finishRefresh();
          _controller.resetFooter();
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            _count += 5;
          });
          _controller.finishLoad(_count >= 20
              ? IndicatorResult.noMore
              : IndicatorResult.succeeded);
        },
        child: ListView.builder(
          clipBehavior: Clip.none,
          scrollDirection: _scrollDirection,
          padding: EdgeInsets.zero,
          itemCount: _count,
          itemBuilder: (ctx, index) {
            return SkeletonItem(
              direction: _scrollDirection,
            );
          },
        ),
      ),
      bottomNavigationBar: MenuBottomBar(
        onRefresh: () => _controller.callRefresh(),
        onLoad: () => _controller.callLoad(),
        expandedBody: Column(
          children: [
            const SizedBox(height: 16),
            Obx(() {
              final themeMode = ThemeController.i.themeModel;
              return ListTile(
                title: Text('Theme'.tr),
                trailing: IntrinsicWidth(
                  child: Row(
                    children: [
                      if (themeMode.icon != null) Icon(themeMode.icon),
                      if (themeMode.color != null)
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: themeMode.color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      const SizedBox(width: 16),
                      Text(ThemeController.i.theme.value.tr),
                    ],
                  ),
                ),
                onTap: () => Get.to(() => const ThemePage()),
              );
            }),
            ListTile(
              title: Text('Direction'.tr),
              trailing: IntrinsicWidth(
                child: Row(
                  children: [
                    Radio<Axis>(
                      value: Axis.vertical,
                      groupValue: _scrollDirection,
                      onChanged: (value) {
                        setState(() {
                          _scrollDirection = value!;
                        });
                      },
                    ),
                    Text('Vertical'.tr),
                    Radio<Axis>(
                      value: Axis.horizontal,
                      groupValue: _scrollDirection,
                      onChanged: (value) {
                        setState(() {
                          _scrollDirection = value!;
                        });
                      },
                    ),
                    Text('Horizontal'.tr),
                  ],
                ),
              ),
            ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  if (!isExpanded) {
                    _expandedIndex = panelIndex;
                  } else {
                    _expandedIndex = -1;
                  }
                });
              },
              children: [
                for (int i = 0; i < propertiesItems.length; i++)
                  ExpansionPanel(
                    headerBuilder: (ctx, isExpanded) {
                      return ListTile(
                        title: Text(propertiesItems[i].name),
                        selected: isExpanded,
                      );
                    },
                    body: Builder(
                      builder: (ctx) {
                        final properties = propertiesItems[i];
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Clamping'.tr),
                              trailing: Switch(
                                value: properties.clamping,
                                onChanged: (value) {
                                  setState(() {
                                    properties.clamping = value;
                                    if (value && properties.infinite) {
                                      properties.infinite = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Background'.tr),
                              trailing: Switch(
                                value: properties.background,
                                onChanged: (value) {
                                  setState(() {
                                    properties.background = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Alignment'.tr),
                              trailing: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Radio<MainAxisAlignment>(
                                      value: MainAxisAlignment.center,
                                      groupValue: properties.alignment,
                                      onChanged: (value) {
                                        setState(() {
                                          properties.alignment = value!;
                                        });
                                      },
                                    ),
                                    Text('Center'.tr),
                                    Radio<MainAxisAlignment>(
                                      value: MainAxisAlignment.start,
                                      groupValue: properties.alignment,
                                      onChanged: (value) {
                                        setState(() {
                                          properties.alignment = value!;
                                        });
                                      },
                                    ),
                                    Text('Start'.tr),
                                    Radio<MainAxisAlignment>(
                                      value: MainAxisAlignment.end,
                                      groupValue: properties.alignment,
                                      onChanged: (value) {
                                        setState(() {
                                          properties.alignment = value!;
                                        });
                                      },
                                    ),
                                    Text('End'.tr),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text('Infinite'.tr),
                              trailing: Switch(
                                value: properties.infinite,
                                onChanged: (value) {
                                  setState(() {
                                    properties.infinite = value;
                                    if (value && properties.clamping) {
                                      properties.clamping = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Message'.tr),
                              trailing: Switch(
                                value: properties.message,
                                onChanged: (value) {
                                  setState(() {
                                    properties.message = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Text'.tr),
                              trailing: Switch(
                                value: properties.text,
                                onChanged: (value) {
                                  setState(() {
                                    properties.text = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    isExpanded: _expandedIndex == i,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bezier indicator properties.
class _BIProperties {
  final String name;
  bool clamping = false;
  bool background = false;
  MainAxisAlignment alignment;
  bool message = true;
  bool text = true;
  bool infinite;

  _BIProperties({
    required this.name,
    required this.alignment,
    required this.infinite,
  });
}
