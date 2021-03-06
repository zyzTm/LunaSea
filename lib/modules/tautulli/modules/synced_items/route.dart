import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliSyncedItemsRouter {
    static const String ROUTE_NAME = '/tautulli/synceditems/list';

    static Future<void> navigateTo(BuildContext context) async => LunaRouter.router.navigateTo(
        context,
        route(),
    );

    static String route() => ROUTE_NAME;

    static void defineRoutes(FluroRouter router) {
        router.define(
            ROUTE_NAME,
            handler: Handler(handlerFunc: (context, params) => _TautulliSyncedItemsRoute()),
            transitionType: LunaRouter.transitionType,
        );
    }

    TautulliSyncedItemsRouter._();
}

class _TautulliSyncedItemsRoute extends StatefulWidget {
    @override
    State<_TautulliSyncedItemsRoute> createState() => _State();
}

class _State extends State<_TautulliSyncedItemsRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

    @override
    void initState() {
        super.initState();
        SchedulerBinding.instance.addPostFrameCallback((_) => _refresh()); 
    }

    Future<void> _refresh() async {
        context.read<TautulliState>().resetSyncedItems();
        await context.read<TautulliState>().syncedItems;
    }

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );
    
    Widget get _appBar => LunaAppBar(
        context: context,
        title: 'Synced Items',
        popUntil: '/tautulli',
    );

    Widget get _body => LSRefreshIndicator(
        refreshKey: _refreshKey,
        onRefresh: _refresh,
        child: Selector<TautulliState, Future<List<TautulliSyncedItem>>>(
            selector: (_, state) => state.syncedItems,
            builder: (context, synced, _) => FutureBuilder(
                future: synced,
                builder: (context, AsyncSnapshot<List<TautulliSyncedItem>> snapshot) {
                    if(snapshot.hasError) {
                        if(snapshot.connectionState != ConnectionState.waiting) {
                            LunaLogger.error(
                                '_TautulliSyncedItemsRoute',
                                '_body',
                                'Unable to fetch Tautulli synced items',
                                snapshot.error,
                                null,
                                uploadToSentry: !(snapshot.error is DioError),
                            );
                        }
                        return LSErrorMessage(onTapHandler: () async => _refreshKey.currentState.show());
                    }
                    if(snapshot.hasData) return snapshot.data.length == 0
                        ? _noSyncedItems()
                        : _syncedItems(snapshot.data);
                    return LSLoader();
                },
            ),
        ),
    );

    Widget _syncedItems(List<TautulliSyncedItem> syncedItems) => LSListViewBuilder(
        itemCount: syncedItems.length,
        itemBuilder: (context, index) => TautulliSyncedItemTile(syncedItem: syncedItems[index]),
    );

    Widget _noSyncedItems() => LSGenericMessage(
        text: 'No Synced Items Found',
        showButton: true,
        buttonText: 'Refresh',
        onTapHandler: () async => _refreshKey.currentState.show(),
    );
}
