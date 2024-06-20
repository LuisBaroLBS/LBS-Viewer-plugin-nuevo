import { registerPlugin } from '@capacitor/core';
const LbsViewer = registerPlugin('LbsViewer', {
    web: () => import('./web').then(m => new m.LbsViewerWeb()),
});
export * from './definitions';
export { LbsViewer };
//# sourceMappingURL=index.js.map