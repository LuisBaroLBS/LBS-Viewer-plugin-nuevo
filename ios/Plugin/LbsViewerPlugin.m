#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.

CAP_PLUGIN(LbsViewerPlugin, "LbsViewer",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openBook,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(FabsHandler,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(CambioHoja,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(GuardarRayado,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(domDidLoad,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(TotalHojas,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(GuardarSubrayado,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(mostrarBotonPanelMaestro,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(TomarFoto,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(EliminarFoto,CAPPluginReturnPromise);
           
)
