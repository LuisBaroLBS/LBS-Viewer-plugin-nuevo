export interface LbsViewerPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    openBook(options: {
        token: string;
        libroId: number;
        url: string;
    }): Promise<{
        token: string;
        libroId: number;
        url: string;
    }>;
    show(options: {
        message: string;
    }): Promise<{
        message: string;
    }>;
}
