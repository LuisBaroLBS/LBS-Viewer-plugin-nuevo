var capacitorLbsViewer = (function (exports, core) {
    'use strict';

    const LbsViewer = core.registerPlugin('LbsViewer', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.LbsViewerWeb()),
    });

    class LbsViewerWeb extends core.WebPlugin {
        async echo(options) {
            console.log('ECHO in [WEB]: ', options);
            return options;
        }
        async openBook(options) {
            return options;
        }
        async show(options) {
            return options;
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        LbsViewerWeb: LbsViewerWeb
    });

    exports.LbsViewer = LbsViewer;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
