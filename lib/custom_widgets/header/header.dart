import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/providers/client_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ClientProvider>();
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 200,
      flexibleSpace: FutureBuilder(
          future: provider.getUsername(),
          builder: (context, snapshot) {
            var background = SvgPicture.asset(
              "assets/header_background.svg",
              fit: BoxFit.cover,
            );
            if (snapshot.hasData) {
              return FlexibleSpaceBar(
                background: background,
                title: Text("Hi, ${snapshot.requireData}"),
                titlePadding: const EdgeInsets.only(bottom: 100.0, left: 25.0),
              );
            } else if (snapshot.hasError) {
              return FlexibleSpaceBar(
                centerTitle: true,
                title: Text(snapshot.error.toString()),
              );
            } else {
              return const FlexibleSpaceBar(
                title: Text(
                  "Hi, nice to meet you",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }),
    );
  }
}
