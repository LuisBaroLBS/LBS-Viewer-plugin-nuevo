import { registerPlugin } from '@capacitor/core';

import type { LbsViewerPlugin } from './definitions';

const LbsViewer = registerPlugin<LbsViewerPlugin>('LbsViewer', {
  web: () => import('./web').then(m => new m.LbsViewerWeb()),
});

export * from './definitions';
export { LbsViewer };
