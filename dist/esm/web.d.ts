import { WebPlugin } from '@capacitor/core';
import type { LbsViewerPlugin } from './definitions';
export declare class LbsViewerWeb extends WebPlugin implements LbsViewerPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    openBook(options: {
        token: string;
        libroId: number;
        directory: string;
    }): Promise<{
        token: string;
        libroId: number;
        directory: string;
    }>;
    show(options: {
        message: string;
    }): Promise<{
        message: string;
    }>;
}
