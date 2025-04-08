import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    this.controller,
    this.page,
  });

  final String text;
  final IconData icon;
  final PageController? controller;
  final int? page;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controller?.jumpToPage(page!);
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color:
                    controller!.page == page
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
              ),
              SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      controller!.page == page
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
