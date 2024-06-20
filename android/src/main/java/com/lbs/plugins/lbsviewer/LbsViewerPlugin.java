package com.lbs.plugins.lbsviewer;

import android.content.Intent;
import android.util.Log;

import com.getcapacitor.CapacitorWebView;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "LbsViewer")
public class LbsViewerPlugin extends Plugin {



    private LbsViewer implementation = new LbsViewer();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void openBook(PluginCall call) {
        String directory = call.getString("url");
        String token = call.getString("token");
        Integer libroId = call.getInt("libroId");

       Intent intent = new Intent(getContext(),  BookViewer.class);

        intent.putExtra("directory", directory);
        intent.putExtra("libroId", libroId.toString());
        intent.putExtra("token", token);

        this.getActivity().startActivity(intent);


        JSObject resolvedData = new JSObject();
        resolvedData.put("Resolved",  "Ok");
        call.resolve(resolvedData);
    }
}
