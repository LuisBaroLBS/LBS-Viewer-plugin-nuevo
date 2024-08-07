package com.lbs.plugins.lbsviewer;

import android.content.ContentValues;
import android.database.Cursor;
import android.webkit.JavascriptInterface;
import android.widget.Toast;
import android.content.Context;
import android.os.Handler;

public class JavascriptInterfaces {

    private BookViewer mContex;

    public JavascriptInterfaces(BookViewer context) {
        mContex = context;
    }

    @JavascriptInterface
    public void makeToast(String message, boolean lengthLong){
        Toast.makeText(mContex, message, (lengthLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT)).show();
    }

    @JavascriptInterface
    public void showToast(String message) {
        Toast.makeText(mContex, message, Toast.LENGTH_SHORT).show();
    }

    // @JavascriptInterface
    // public void esconderBotonesDesdeComponentes(Boolean accion) {
    //     mContex.esconderBotonesDesdeComponentesFuncNativa(accion);
    // }

    @JavascriptInterface
    public void CambioHoja(String Hoja) {
        mContex.HojaActual = Hoja;
        mContex.txtNumeroPagina.setText(Hoja);
    }

    @JavascriptInterface
    public void TotalHojas(int paramInt) {
        mContex.TotalPaginas = paramInt;
    }

    /** RAYADO ***/
    @JavascriptInterface
    public void GuardarRayado(String Hoja, String Data) {
        mContex.runOnUiThread(new Runnable() {
            public void run(){
        ContentValues registro;
            if (mContex.bd.rawQuery("SELECT DATA FROM RAYADO WHERE HOJA='" + Hoja + "' and LIBROID=" + mContex.libroId, null).moveToFirst()) {
                registro = new ContentValues();
                registro.put("DATA", Data);
                mContex.bd.update("RAYADO", registro, "HOJA='" + Hoja + "' AND LIBROID=" + mContex.libroId, null);
            } else {
                registro = new ContentValues();
                registro.put("LIBROID", Integer.valueOf(mContex.libroId));
                registro.put("HOJA", Hoja);
                registro.put("DATA", Data);
                mContex.bd.insert("RAYADO", null, registro);
            }
        }
        });
    }

    /** SUBRAYADO **/
    @JavascriptInterface
    public void GuardarSubrayado(String Hoja, String Data) {
        ContentValues registro;
        Cursor fila = mContex.bd.rawQuery("SELECT DATA FROM SUBRAYADO WHERE HOJA='" + Hoja + "' and LIBROID=" + mContex.libroId, null);
        if (fila.moveToFirst()) {
            registro = new ContentValues();
            registro.put("DATA", Data);
            mContex.bd.update("SUBRAYADO", registro, "HOJA='" + Hoja + "' AND LIBROID=" + mContex.libroId, null);
        } else {
            registro = new ContentValues();
            registro.put("LIBROID", Integer.valueOf(mContex.libroId));
            registro.put("HOJA", Hoja);
            registro.put("DATA", Data);
            mContex.bd.insert("SUBRAYADO", null, registro);
        }
        fila.close();
    }

    @JavascriptInterface
    public void InsertarEscribir (String ejercicio, String datos, String id) {
        ContentValues registro;
        Cursor fila = mContex.bd.rawQuery("SELECT DATA FROM ESCRIBIR WHERE LIBROID=" + mContex.libroId + " and EJERCICIO='" + ejercicio + "' and ELEMENTO='" + id+ "'" , null);

        if (fila.moveToFirst()) {
            registro = new ContentValues();
            registro.put("DATA", datos);
            mContex.bd.update("ESCRIBIR", registro, "LIBROID=" + mContex.libroId + " and EJERCICIO='" + ejercicio + "' and ELEMENTO='" + id+ "'", null);
        } else {
            registro = new ContentValues();
            registro.put("LIBROID", Integer.valueOf(mContex.libroId));
            registro.put("EJERCICIO", ejercicio);
            registro.put("DATA", datos);
            registro.put("ELEMENTO", id);
            registro.put("ESTADO", 2);
            mContex.bd.insert("ESCRIBIR", null, registro);
        }
        fila.close();
    }

    @JavascriptInterface
    public void calificarEjercicios(int estado, String ejercicio, String id)  {
        ContentValues registro;
        Cursor fila = mContex.bd.rawQuery("SELECT DATA FROM ESCRIBIR WHERE LIBROID=" + mContex.libroId + " and EJERCICIO='" + ejercicio + "' and ELEMENTO='" + id+ "'" , null);

        if (fila.moveToFirst()) {
            registro = new ContentValues();
            registro.put("ESTADO", estado);
            mContex.bd.update("ESCRIBIR", registro, "LIBROID=" + mContex.libroId + " and EJERCICIO='" + ejercicio + "' and ELEMENTO='" + id+ "'", null);
        } else {
            registro = new ContentValues();
            registro.put("LIBROID", Integer.valueOf(mContex.libroId));
            registro.put("EJERCICIO", ejercicio);
            registro.put("ELEMENTO", id);
            registro.put("ESTADO", estado);
            mContex.bd.insert("ESCRIBIR", null, registro);
        }
        fila.close();
    }

    @JavascriptInterface
    public void dibujarEjercicios(String ejercicio) {

        Cursor fila = mContex.bd.rawQuery("SELECT DATA,ELEMENTO,ESTADO FROM ESCRIBIR WHERE LIBROID=" + mContex.libroId  + " and EJERCICIO='" + ejercicio + "'"  , null);
        while (fila.moveToNext()) {

            final  String data = fila.getString(0);
            final String Elemento = fila.getString(1);
            String Estado = fila.getString(2);

            if (!(Estado.equals("2")))
            {
                mContex.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mContex.webView.evaluateJavascript("(function() { document.getElementById('"+ Elemento+ "').disabled=true;})()", null);
                    }
                });


                if(Estado.equals("1"))
                {
                    mContex.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mContex.webView.evaluateJavascript("(function() { document.getElementById('bien_"+ Elemento+ "').style.color='green';})()", null);
                        }
                    });
                }
                else if(Estado.equals("0"))
                {
                    mContex.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mContex.webView.evaluateJavascript("(function() { document.getElementById('mal_"+ Elemento+ "').style.color='orange';})()", null);
                        }
                    });
                }
            }
        }
        fila.close();
    }

    @JavascriptInterface
    public void ShowIndice(String jsonString)  {
        mContex.Capitulos = jsonString;
    }

    @JavascriptInterface
    public void ActivarTap() {
        mContex.FavoritosActivo = Boolean.valueOf(false);
    }

    @JavascriptInterface
    public void TomarFoto(String img, String paginaid) {
        mContex.checarpermisocamara(img, paginaid, 0);
    }

    @JavascriptInterface
    public void EliminarFoto(String img, String paginaid) {
        mContex.borrarFotoAdentroLibro(img, paginaid);
    }

    @JavascriptInterface
    public void mostrarBotonPanelMaestro() {
        mContex.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mContex.mostrarBotonPanelMaestro();
            }
        });
    }

    @JavascriptInterface
    public void abrirLink(String url) {
        mContex.abrirlink(url);
    }

    @JavascriptInterface
    public void mostrarFabsAudioPlayerCerrar(boolean estado) {
        mContex.esconderBotonesDesdeComponentesFuncNativa(estado);
    }

    @JavascriptInterface
    public void mostrarBotonAudioLibro() {
        mContex.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mContex.mostrarBotonAudioLibro();
            }
        });
    }

    @JavascriptInterface
    public void esconderBotonesDesdeComponentes(boolean estado) {
        mContex.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mContex.esconderBotonesDesdeComponentesFuncNativa(estado);
            }
        });
    }

    @JavascriptInterface
    public void deshabilitarBotonesNativos(boolean estado) {
        mContex.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mContex.deshabilitarBotonesNativosPlugin(estado);
            }
        });
    }

    @JavascriptInterface
    public void mostrarBotonAudioLibroBoolean(boolean esLibroMedicina) {
        mContex.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mContex.isLibroMedicina = true;
            }
        });
    }

    @JavascriptInterface
    public void domDidLoad() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                mContex.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mContex.dibujarRayado();
                        mContex.dibujarRayado();
                        mContex.dibujarSubrayado();
                        mContex.dibujarFotos();
                        mContex.cargarCapitulos();
                    }
                });
            }
        }, 1000); // El número representa el retraso en milisegundos (1000 ms = 1 segundo)
    }

}
