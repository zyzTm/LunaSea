import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class SonarrSeriesAddDetailsAppbarLinkAction extends StatelessWidget {
    final int tvdbId;

    SonarrSeriesAddDetailsAppbarLinkAction({
        Key key,
        @required this.tvdbId,
    }) : super(key: key);
    @override
    Widget build(BuildContext context) => LSIconButton(
        icon: Icons.link,
        onPressed: () async => tvdbId?.toString()?.lsLinks_OpenTVDB(),
    );
}