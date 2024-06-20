import { WebPlugin } from '@capacitor/core';
export class LbsViewerWeb extends WebPlugin {
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
//# sourceMappingURL=web.js.map