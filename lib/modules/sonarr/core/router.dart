import 'package:fluro/fluro.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrRouter {
    SonarrRouter._();

    static void initialize(FluroRouter router) {
        SonarrHomeRouter.defineRoutes(router);
        // Series
        SonarrSeriesAddRouter.defineRoutes(router);
        SonarrSeriesAddDetailsRouter.defineRoutes(router);
        SonarrSeriesEditRouter.defineRoutes(router);
        SonarrSeriesDetailsRouter.defineRoutes(router);
        SonarrSeriesSeasonDetailsRouter.defineRoutes(router);
        // Other
        SonarrQueueRouter.defineRoutes(router);
        SonarrReleasesRouter.defineRoutes(router);
        SonarrTagsRouter.defineRoutes(router);
    }
}
