import { WebPlugin } from '@capacitor/core';

import type { LbsViewerPlugin } from './definitions';

export class LbsViewerWeb extends WebPlugin implements LbsViewerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO in [WEB]: ', options);
    return options;
  }

  async openBook(options: { token: string, libroId: number, directory: string}): Promise<{  token: string, libroId: number, directory: string }> {
    return options;
  }

  async show(options: { message: string }): Promise<{ message: string }> {
    return options;
  }
}
