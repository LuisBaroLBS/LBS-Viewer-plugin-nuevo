package com.lbs.plugins.lbsviewer;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.icu.text.SimpleDateFormat;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.util.TypedValue;
import android.view.ActionMode;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.content.res.Configuration;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TableLayout;
import android.widget.TextView;
import android.widget.Toast;


import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;


import com.getcapacitor.CapacitorWebView;
import com.squareup.picasso.MemoryPolicy;
import com.squareup.picasso.Picasso;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;

import static android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION;

import org.apache.commons.io.IOUtils;

import me.echodev.resizer.BuildConfig;
import me.echodev.resizer.Resizer;

public class BookViewer extends AppCompatActivity {
    String libroId, directory, token;
    String HojaActual, nombrearchivo;
    WebView webView;

    ImageButton fabNumeroPagina, fabAudioPlayer, fabBookmark, fabFavoritos, fabIndice, fabNotas, fabRayar, fabSubrayar, fabFoto, fabPanelMaestro;
    ImageButton fabMain;
    ImageButton fabBorrar, fabBorrarActivo, fabColorSubrayado, fabGaleria,fabTomarFoto, fabLimpiar, fabUndo, fabRayarColor, fabCloseRayar, fabCloseFoto, fabCloseSubrayar;
    //Colores EDITADO
    ImageButton FabRayarNegro,FabRayarRojo,FabRayarAmarillo,FabRayarVerde,FabRayarRosa,FabRayarAzul,FabRayarColor,FabRayarRosaLigero,FabRayarGrey,FabRayarMarron;
    ImageButton FabBorrar,FabBorrarActivo,FabCloseSubrayar,FabColorSubrayado;
    ImageButton FabSubrayarAmarillo,FabSubrayarRosa,FabSubrayarAzul;
    ImageButton FabUndo, FabLimpiar, FabCloseRayar;
    TableLayout panelRayado;
    LinearLayout panelSubrayado;
    Button fabTamano;
    TextView txtNumeroPagina;

    SeekBar simpleSeekBar;
    Boolean isFabOpen = false, isLibroMaestro = false, isLibroMedicina = false, banderaScale = false, FotoActivo = false, RayarActivo =false, SubRayar = false;
    Boolean BorrarActivo = false, FavoritosActivo = false;

    int tipofoto;
    String imagenid;
    String paginaid;
    String Capitulos;
    int TotalPaginas, progresvisible = 1;

    ArrayList<String> f = new ArrayList<String>();
    ArrayList<String> borrargaleria = new ArrayList<String>();
    Dialog ThisDialog,ThisDialogGrid;
    GridView androidGridView;

    Button guardar;
    Button borrar;
    Button btnSeleccionarImagen;
    ImageButton btnBorrarImagen;
    double division = Math.pow(0.0, 1);
    SQLiteDatabase bd;
    JavascriptInterfaces javascriptInterfaces = new JavascriptInterfaces(this);
    private static final int CAMERA_REQUEST = 1888;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getExtrasData();
        setContentView(R.layout.activity_book_viewer);
        initWebView(); // Inicializar todo lo relacionado del view
        initObjetos(); // Inicializar todo lo relacionado de botones y objetos de la interfaz
        initJSInterface(); // Inicializar las funciones que seran llamados de javascript
        initOnClickListenersButtons(); // Inicializar los on click listener


        bd = new AdminSQLiteOpenHelper(getApplicationContext(), "libros", null, 1).getWritableDatabase();

        //libroId = "1885";
        String url = directory + "Libro"+ libroId + "/indexAndroidNew.html";
         webView.loadUrl(url);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {

                webView.evaluateJavascript("window.localStorage.setItem('USER_INFO', '"+token+"');", null);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                //Toast.makeText(BookViewer.this, "Page finished loading", Toast.LENGTH_SHORT).show();
                cacharTokendesdeNativo(token);
            }

        });

    }

    /**
     * Get data del libro y usuario(token)
     */
    private void getExtrasData() {
        Bundle bundleData = getIntent().getExtras();
        directory = bundleData.getString("directory");
        token = bundleData.getString("token");
        libroId = bundleData.getString("libroId");
        token = token.substring(4);
    }

    private void initWebView() {
        webView = (CapacitorWebView) findViewById(R.id.webView);

        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setDisplayZoomControls(false);
        webView.getSettings().setAllowFileAccessFromFileURLs(true);
        webView.getSettings().setAllowUniversalAccessFromFileURLs(true);
        webView.getSettings().setAllowFileAccess(true);
        webView.getSettings().setAllowContentAccess(true);
        webView.getSettings().setDatabaseEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);


        webView.getSettings().setTextZoom(100); // previene que los dispositivos no aumente el tamaño de la letra,
    }

    @SuppressLint("CutPasteId")
    private void initObjetos() {
        fabMain = (ImageButton) findViewById(R.id.FabMain);
        fabNumeroPagina = (ImageButton) findViewById(R.id.FabNumeroPagina);
        txtNumeroPagina = (TextView) findViewById(R.id.txtNumeroPagina);
        fabAudioPlayer = (ImageButton) findViewById(R.id.FabAudioPlayer);
        fabBookmark = (ImageButton) findViewById(R.id.FabBookmark);
        fabFavoritos = (ImageButton) findViewById(R.id.FabFavoritos);
        fabIndice = (ImageButton) findViewById(R.id.FabIndice);
        fabNotas = (ImageButton) findViewById(R.id.FabNotas);
        fabRayar = (ImageButton) findViewById(R.id.FabRayar);
        fabSubrayar = (ImageButton) findViewById(R.id.FabSubrayar);
        fabFoto = (ImageButton) findViewById(R.id.FabFoto);

        fabColorSubrayado = (ImageButton) findViewById(R.id.FabColorSubrayado);
        fabGaleria = (ImageButton) findViewById(R.id.FabGaleria);
        fabTomarFoto = (ImageButton) findViewById(R.id.FabTomarFoto);
        fabLimpiar = (ImageButton) findViewById(R.id.FabLimpiar);
        fabUndo = (ImageButton) findViewById(R.id.FabUndo);
        fabRayarColor = (ImageButton) findViewById(R.id.FabRayarColor);
        fabTamano = (Button) findViewById(R.id.FabTamano);
        fabPanelMaestro = (ImageButton) findViewById(R.id.FabPanelMaestro);

        //Botones Subrayado
        fabBorrar = (ImageButton) findViewById(R.id.FabBorrar);
        fabCloseSubrayar = (ImageButton) findViewById(R.id.FabCloseSubrayar);
        fabBorrarActivo = (ImageButton) findViewById(R.id.FabBorrarActivo);
        panelSubrayado = (LinearLayout) findViewById(R.id.PanelSubrayado);
        FabBorrar = (ImageButton) findViewById(R.id.FabBorrar);
        FabBorrarActivo = (ImageButton) findViewById(R.id.FabBorrarActivo);
        FabCloseSubrayar = (ImageButton) findViewById(R.id.FabCloseSubrayar);
        FabColorSubrayado = (ImageButton) findViewById(R.id.FabColorSubrayado);
        FabSubrayarAmarillo= (ImageButton) findViewById(R.id.FabSubrayarAmarillo);
        FabSubrayarRosa=(ImageButton) findViewById(R.id.FabSubrayarRosa);
        FabSubrayarAzul=(ImageButton) findViewById(R.id.FabSubrayarAzul);
        FabSubrayarAmarillo=(ImageButton) findViewById(R.id.FabSubrayarAmarillo);
        //Botones Rayar
        fabCloseRayar = (ImageButton) findViewById(R.id.FabCloseRayar);
        fabCloseFoto = (ImageButton) findViewById(R.id.FabCloseFoto);
        FabCloseRayar = (ImageButton) findViewById(R.id.FabCloseRayar);
        //Colores
        FabRayarColor = (ImageButton) findViewById(R.id.FabRayarColor);
        FabRayarNegro = (ImageButton) findViewById(R.id.FabRayarNegro);
        FabRayarRojo = (ImageButton) findViewById(R.id.FabRayarRojo);
        FabRayarAmarillo = (ImageButton) findViewById(R.id.FabRayarAmarillo);
        FabRayarVerde = (ImageButton) findViewById(R.id.FabRayarVerde);
        FabRayarRosa = (ImageButton) findViewById(R.id.FabRayarRosa);
        FabRayarAzul = (ImageButton) findViewById(R.id.FabRayarAzul);
        FabRayarRosaLigero = (ImageButton) findViewById(R.id.FabRayarRosaLigero);
        FabRayarGrey = (ImageButton) findViewById(R.id.FabRayarGrey);
        FabRayarMarron = (ImageButton) findViewById(R.id.FabRayarMarron);

        //Botones Color Rayar
        panelRayado = (TableLayout) findViewById(R.id.PanelRayado);

        simpleSeekBar = (SeekBar) findViewById(R.id.simpleSeekBar);

    }

    private void initJSInterface() {
        webView.addJavascriptInterface(javascriptInterfaces, "app");
    }

    public void initOnClickListenersButtons() {
        // Fab open menu
        fabMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!isLibroMaestro) {
                    if(!isFabOpen)
                        showFabMenu();
                    else
                        CloseFabMenu();
                } else {
                    webView.evaluateJavascript("Visor.toastHandler('show', 'Este libro es de solo lectura.', 400); setTimeout(function(){ Visor.toastHandler('hide',' ', 400); }, 3000);", null);
                }
            }
        });

        //Btn numero de paginas - indice
        txtNumeroPagina.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.evaluateJavascript("Visor.mostrarIndicePaginas();", null);
                esconderBotonesDesdeComponentesFuncNativa(true);
                // Log.i("Click", v.toString());
            }
        });
        // Audio player
        fabAudioPlayer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.evaluateJavascript("document.getElementById('playerMusic')._showModal()", null);
                 esconderBotonesDesdeComponentesFuncNativa(true);
            }

        });
        // panel maestro ( secuencias )
        fabPanelMaestro.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.evaluateJavascript("Visor.openFooter()", null);
                panelMaestroEsconderFabs();
            }
        });
        // Favoritos
        fabBookmark.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(FotoActivo) fabCloseFoto .callOnClick();
                if(SubRayar) fabCloseSubrayar.callOnClick();

                String funcionNombre = "Visor.dibujarSeparador(" + HojaActual + ")";
                webView.evaluateJavascript(funcionNombre, null);
                CloseFabMenu();
            }
        });

        fabFavoritos.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(FotoActivo)  fabCloseFoto.callOnClick();
                if(SubRayar)    fabCloseSubrayar.callOnClick();

                ResetZoom();
                webView.evaluateJavascript("Visor.mostrarNotasYFavoritosList();", null);
                esconderBotonesDesdeComponentesFuncNativa(true);
            }
        });

        fabIndice.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)  {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(FotoActivo)  fabCloseFoto.callOnClick();
                if(SubRayar)    fabCloseSubrayar.callOnClick();

                webView.evaluateJavascript("Visor.mostrarIndiceTitulos();", null);
                esconderBotonesDesdeComponentesFuncNativa(true);
            }
        });

        fabNotas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(FotoActivo)  fabCloseFoto.callOnClick();
                if(SubRayar)    fabCloseSubrayar.callOnClick();

                String js = "Visor.mostrarNotaV2()";
                webView.evaluateJavascript(js, null);
                //Toast.makeText(NewActivity.this, "Presiona donde quieres poner la nota.", Toast.LENGTH_SHORT).show();
            }
        });


        /** RAYADO ***/
        fabRayar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(SubRayar) fabCloseSubrayar.callOnClick();
                if(FotoActivo)fabCloseFoto.callOnClick();

                if(!RayarActivo) {
                    int inicio;
                    int fin;
                    RayarActivo = true;
                    CloseFabMenu();

                    simpleSeekBar.setProgress(10);

                    fabRayarColor.setBackgroundResource(R.drawable.fabbuttontransparent);
                    //            web1.loadUrl("javascript:" + "Visor.handleColorRayado('black')");

                    fabUndo.setVisibility(View.VISIBLE);
                    fabLimpiar.setVisibility(View.VISIBLE);
                    fabCloseRayar.setVisibility(View.VISIBLE);
                    fabRayarColor.setVisibility(View.VISIBLE);
                    fabTamano.setVisibility(View.VISIBLE);
                    fabRayar.setImageResource(R.drawable.pencil_box);
                    webView.evaluateJavascript("(function() { document.getElementById('idrviewer').style['touch-action']  = 'none'})()", null);

                    int PaginaActual = Integer.parseInt(HojaActual);
                    if (PaginaActual < 1 || PaginaActual >= TotalPaginas) {
                        inicio = PaginaActual - 1;
                        fin = PaginaActual;
                    } else {
                        inicio = PaginaActual == 1 ? PaginaActual : PaginaActual - 1;
                        fin = PaginaActual + 1;
                    }

                    // SQLiteDatabase bd = new AdminSQLiteOpenHelper(getApplicationContext(), "libros", null, 1).getWritableDatabase();
                    for (int i = inicio; i <= fin; i++) {
                        Cursor fila = bd.rawQuery("SELECT DATA FROM RAYADO WHERE HOJA='" + i + "' and LIBROID=" + libroId, null);
                        if (fila.moveToFirst()) {
                            webView.evaluateJavascript( ("Visor.ActivarRayado('" + fila.getString(0) + "'," + i + ")"), null);

                        } else {
                            webView.evaluateJavascript(("Visor.dibujarRayado(" + i + ",null)"), null);
                        }
                        fila.close();
                    }
                    webView.evaluateJavascript( "(Visor.handleTamanoLienzo('1.0'))", null);
                    // bd.close();
                } else {
                    RayarActivo=false;
                    fabUndo.setVisibility(View.GONE);
                    fabLimpiar.setVisibility(View.GONE);
                    fabCloseRayar.setVisibility(View.GONE);
                    fabRayarColor.setVisibility(View.GONE);
                    fabTamano.setVisibility(View.GONE);
                    simpleSeekBar.setVisibility(View.GONE);
                    fabRayar.setImageResource(R.drawable.pencil_box_outline);
                    webView.evaluateJavascript("Visor.DesactivarRayado();", null);
                }
            }
        });

        // Panel rayar
        fabRayarColor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                panelRayado.setVisibility(panelRayado.getVisibility() == View.GONE ? View.VISIBLE : View.GONE);
            }
        });

        simpleSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progressChangedValue = 0;
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                progressChangedValue = progress;
                division = (double) progressChangedValue / 10;
                if(progressChangedValue <= 5) {
                    fabTamano.setText("" + 0.5);
                    division = 0.5;
                }
                else{
                    fabTamano.setText("" + division);
                }
            }

            public void onStartTrackingTouch(SeekBar seekBar) {
                // TODO Auto-generated method stub
            }

            public void onStopTrackingTouch(SeekBar seekBar) {
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ division +"')", null);
                fabRayarColor.setVisibility(View.VISIBLE);
                fabUndo.setVisibility(View.VISIBLE);
                fabCloseRayar.setVisibility(View.VISIBLE);
                fabLimpiar.setVisibility(View.VISIBLE);
                simpleSeekBar.setVisibility(View.GONE);
                progresvisible = 1;
            }
        });

        fabTamano.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(progresvisible == 1) {
                    fabRayarColor.setVisibility(View.GONE);
                    fabUndo.setVisibility(View.GONE);
                    fabCloseRayar.setVisibility(View.GONE);
                    fabLimpiar.setVisibility(View.GONE);
                    panelRayado.setVisibility(View.GONE);
                    simpleSeekBar.setVisibility(View.VISIBLE);
                    progresvisible = 0;
                }
                else if(progresvisible == 0) {
                    fabRayarColor.setVisibility(View.VISIBLE);
                    fabUndo.setVisibility(View.VISIBLE);
                    fabCloseRayar.setVisibility(View.VISIBLE);
                    fabLimpiar.setVisibility(View.VISIBLE);
                    simpleSeekBar.setVisibility(View.GONE);
                    progresvisible = 1;
                }
            }
        });

        FabRayarNegro.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabRayarColor.setBackgroundResource(R.drawable.fabbuttonblack);
                webView.evaluateJavascript("Visor.handleColorRayado('black')", null);
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });

        FabRayarRojo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonred);
                webView.evaluateJavascript(  "Visor.handleColorRayado('red')", null);
                webView.evaluateJavascript( "Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarAmarillo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonamarillo);
                webView.evaluateJavascript("Visor.handleColorRayado('yellow')", null);
                webView.evaluateJavascript("javascript:" + "Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarVerde.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttongreen);
                webView.evaluateJavascript( "Visor.handleColorRayado('green')", null);
                webView.evaluateJavascript( "Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarRosa.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonpurple);
                webView.evaluateJavascript("Visor.handleColorRayado('purple')", null);
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarAzul.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonazul);
                webView.evaluateJavascript( "Visor.handleColorRayado('blue')", null);
                webView.evaluateJavascript( "Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarRosaLigero.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonpinkmagenta);
                webView.evaluateJavascript("Visor.handleColorRayado('magenta')", null);
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarGrey.setOnClickListener(new View.OnClickListener() {
            @Override
            // color cafe
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonbrown);
                webView.evaluateJavascript("Visor.handleColorRayado('brown')", null);
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });
        FabRayarMarron.setOnClickListener(new View.OnClickListener() {
            @Override
            //color naranja
            public void onClick(View v) {
                FabRayarColor.setBackgroundResource(R.drawable.fabbuttonmarron);
                webView.evaluateJavascript( "Visor.handleColorRayado('orange')", null);
                webView.evaluateJavascript("Visor.handleTamanoLienzo('"+ fabTamano.getText().toString() +"')", null);
                panelRayado.setVisibility(View.GONE);
            }
        });

/*
        FabUndo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String js = "Visor.handleUndo()";
                webView.evaluateJavascript(js, null);
            }
        });
        FabLimpiar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String js = "Visor.handleClear()";
                webView.evaluateJavascript(js, null);
            }
        });*/


        // Subrayar
        fabSubrayar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(FotoActivo) fabCloseFoto.callOnClick();

                if(!SubRayar) {
                    int inicio;
                    int fin;
                    SubRayar=true;
                    CloseFabMenu();
                    fabBorrar.setVisibility(View.VISIBLE);
                    fabCloseSubrayar.setVisibility(View.VISIBLE);
                    fabColorSubrayado.setVisibility(View.VISIBLE);
                    //FabSubrayar.setImageResource(getResources().getIdentifier("format_strikethrough_variant", "drawable", getPackageName()));
                    fabColorSubrayado.setBackgroundResource(R.drawable.fabbuttontransparent);
                    webView.evaluateJavascript("Visor.handleColorSubRayado('rgba(255, 255, 0, 0.25)')", null);
                    webView.evaluateJavascript("(function() { document.ontouchmove = function(e){ e.preventDefault(); }})()", null);
                    int PaginaActual = Integer.parseInt(HojaActual);
                    if (PaginaActual < 1 || PaginaActual >= TotalPaginas) {
                        inicio = PaginaActual - 1;
                        fin = PaginaActual;
                    } else {
                        inicio = PaginaActual == 1 ? PaginaActual : PaginaActual - 1;
                        fin = PaginaActual + 1;
                    }
                    for (int i = inicio; i <= fin; i++) {
                        webView.evaluateJavascript(("Visor.ActivarSubrayado(" + i + ")"), null);
                    }
                }
                else {
                    SubRayar = false;
                    fabBorrar.setVisibility(View.GONE);
                    fabCloseSubrayar.setVisibility(View.GONE);
                    fabColorSubrayado.setVisibility(View.GONE);
                    fabSubrayar.setImageResource(R.drawable.format_underline);
                    webView.evaluateJavascript("Visor.DesactivarSubrayado()", null);
                    webView.evaluateJavascript("(function() { document.ontouchmove = function(e){  }})()", null);
                }
            }
        });

        fabColorSubrayado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(panelSubrayado.getVisibility() == View.GONE)
                    panelSubrayado.setVisibility(View.VISIBLE);
                else
                    panelSubrayado.setVisibility(View.GONE);
            }
        });
        FabSubrayarAmarillo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabColorSubrayado.setBackgroundResource(R.drawable.fabbuttonamarillo);
                webView.evaluateJavascript("Visor.handleColorSubRayado('rgba(255, 255, 0, 0.25)')", null);
                panelSubrayado.setVisibility(View.GONE);
            }
        });
        FabSubrayarAzul.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabColorSubrayado.setBackgroundResource(R.drawable.fabbuttonazulcyan);
                webView.loadUrl("javascript:" + "Visor.handleColorSubRayado('rgba(39, 255, 240, 0.25)')");
                panelSubrayado.setVisibility(View.GONE);
            }
        });
        FabSubrayarRosa.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabColorSubrayado.setBackgroundResource(R.drawable.fabbuttonpinkligth);
                webView.evaluateJavascript("Visor.handleColorSubRayado('rgba(255, 39, 123, 0.25)')", null);
                panelSubrayado.setVisibility(View.GONE);
            }
        });

        FabBorrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!BorrarActivo) {
                    BorrarActivo = true;
                    FabBorrarActivo.setVisibility(View.VISIBLE);
                    FabBorrar.setVisibility(View.GONE);
                }
                String js = "document.getElementById('BtnBorrarSubrayado').click()";
                webView.loadUrl("javascript:" + js);
            }
        });
        FabBorrarActivo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(BorrarActivo==true)
                {
                    BorrarActivo=false;
                    FabBorrarActivo.setVisibility(View.GONE);
                    FabBorrar.setVisibility(View.VISIBLE);
                }

                String js = "document.getElementById('BtnBorrarSubrayado').click()";
                webView.evaluateJavascript(js, null);
            }
        });
        FabCloseSubrayar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BorrarActivo=false;
                FabBorrarActivo.setVisibility(View.GONE);
                FabBorrar.setVisibility(View.VISIBLE);
                panelSubrayado.setVisibility(View.GONE);
                fabSubrayar.callOnClick();
            }
        });


        // FOTO
        fabFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(RayarActivo) fabCloseRayar.callOnClick();
                if(SubRayar) FabCloseSubrayar.callOnClick();


                if(!FotoActivo) {
                    FotoActivo=true;
                    CloseFabMenu();
                    fabTomarFoto.setVisibility(View.VISIBLE);
                    fabGaleria.setVisibility(View.VISIBLE);
                    fabCloseFoto.setVisibility(View.VISIBLE);
                    fabRayar.setImageResource(R.drawable.pencil_box);
                }
                else {
                    FotoActivo=false;
                    fabTomarFoto.setVisibility(View.GONE);
                    fabGaleria.setVisibility(View.GONE);
                    fabCloseFoto.setVisibility(View.GONE);
                    fabRayar.setImageResource(R.drawable.pencil_box_outline);
                }
            }
        });
        fabTomarFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checarpermisocamara(null,null,1);
            }
        });
        fabGaleria.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Galeria();
            }
        });

        fabCloseFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabFoto.callOnClick();
            }
        });

        // misc
        fabCloseRayar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabRayar.callOnClick();
                panelRayado.setVisibility(View.GONE);
                fabCloseRayar.setVisibility(View.GONE);
            }
        });

        fabCloseFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fabFoto.callOnClick();
            }
        });

        fabCloseSubrayar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BorrarActivo=false;
                fabBorrarActivo.setVisibility(View.GONE);
                fabBorrar.setVisibility(View.VISIBLE);
                panelSubrayado.setVisibility(View.GONE);
                fabSubrayar.callOnClick();
            }
        });

    }

    private void showFabMenu() {
        isFabOpen = true;

        //float density = getResources().getDisplayMetrics().density;
        float density = Math.round(getResources().getDisplayMetrics().density);
        int inicio = calculateStartPosition(density);

        View[] fabs = { fabBookmark, fabFavoritos, fabIndice, fabNotas, fabRayar, fabSubrayar, fabFoto  };

        for (int i = 0; i < fabs.length; i++) {
            View fab = fabs[i];
            fab.setVisibility(View.VISIBLE);
            fab.animate()
                    .translationY(inicio * (i + 1))
                    .rotation(0f);
        }

        fabNumeroPagina.animate().translationY(inicio * 7);
        txtNumeroPagina.animate().translationY(inicio * 7);
    }

    private int calculateStartPosition(float density) {
        int inicio = -120;
        int screenSize = getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK;

        switch (screenSize) {
            case Configuration.SCREENLAYOUT_SIZE_XLARGE:
                Log.i("Screen Size: ", "XLARGE");
                BotonesHerramientas(180,250, 320,390);
                if (density == 1.5f || density == 1.0f) {
                    inicio = -90;
                } else if (density == 2.0f) {
                    inicio = -130;
                } else if (density == 3.0f) {
                    inicio = -200;
                } else if (density == 4.0f) {
                    inicio = -260;
                }
                break;

            case Configuration.SCREENLAYOUT_SIZE_LARGE:
                Log.i("Screen Size: ", "LARGE");
                BotonesHerramientas(180,250,320,390);
                if (density == 1.5f || density == 1.0f) {
                    inicio = -80;
                } else if (density == 2.0f) {
                    inicio = -120;
                } else if (density == 3.0f) {
                    inicio = -190;
                } else if (density == 4.0f) {
                    inicio = -250;
                }
                break;

            case Configuration.SCREENLAYOUT_SIZE_NORMAL:
                Log.i("Screen Size: ", "NORMAL");
                Log.i("Screen Size: ", String.valueOf(density));

                if (density == 1.5f || density == 1.0f) {
                    BotonesHerramientas(160,210,260,310);
                    inicio = -70;
                } else if (density == 2.0f ) {
                    BotonesHerramientas(170,230,290,350);
                    inicio = -110;
                } else if (density == 3.0f ) {
                    BotonesHerramientas(170,230,290,350);
                    inicio = -180;
                } else if (density == 4.0f) {
                    BotonesHerramientas(170,230,290,350);
                    inicio = -240;
                }
                break;
        }

        return inicio;
    }


    public void BotonesHerramientas(int espacio, int espacio1, int espacio3, int espacio4) {
        int sizeInDP = espacio + 100;
        int sizeInDP1 = espacio1 + 100;
        int sizeInDP3 = espacio3 + 100;
        int sizeInDP4 = espacio4 + 100;
        int marginInDp = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, sizeInDP, getResources().getDisplayMetrics());
        int marginInDp1 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, sizeInDP1, getResources().getDisplayMetrics());
        int marginInDp2 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, sizeInDP3, getResources().getDisplayMetrics());
        int marginInDp3 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, sizeInDP4, getResources().getDisplayMetrics());

        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) fabBorrar.getLayoutParams();
        params.bottomMargin = marginInDp;
        RelativeLayout.LayoutParams params1 = (RelativeLayout.LayoutParams) fabColorSubrayado.getLayoutParams();
        params1.bottomMargin = marginInDp1;
        RelativeLayout.LayoutParams params2 = (RelativeLayout.LayoutParams) fabGaleria.getLayoutParams();
        params2.bottomMargin = marginInDp;
        RelativeLayout.LayoutParams params3 = (RelativeLayout.LayoutParams) fabTomarFoto.getLayoutParams();
        params3.bottomMargin = marginInDp1;

        RelativeLayout.LayoutParams params4 = (RelativeLayout.LayoutParams) fabLimpiar.getLayoutParams();
        params4.bottomMargin = marginInDp;

        RelativeLayout.LayoutParams params5 = (RelativeLayout.LayoutParams) fabUndo.getLayoutParams();
        params5.bottomMargin = marginInDp1;

        RelativeLayout.LayoutParams params6 = (RelativeLayout.LayoutParams) fabRayarColor.getLayoutParams();
        params6.bottomMargin = marginInDp2;

        RelativeLayout.LayoutParams params7 = (RelativeLayout.LayoutParams) fabTamano.getLayoutParams();
        params7.bottomMargin = marginInDp3;
    }

    public void CloseFabMenu() {
        isFabOpen = false;

        View[] fabs = { fabBookmark, fabFavoritos, fabIndice, fabNotas, fabRayar, fabSubrayar, fabFoto};
        fabMain.animate().rotation(0f);
        fabNumeroPagina.animate()
                .translationY(5f);
        txtNumeroPagina.animate()
                .translationY(5f);

        for (View fab : fabs) {
            fab.animate()
                    .translationY(0f)
                    .rotation(90f);
        }

    }

    public void esconderBotonesDesdeComponentesFuncNativa(boolean estado) {
        CloseFabMenu();
        if (estado) {
            hideButtonsWithAnimation();
        } else {
            showButtonsWithAnimation();
        }
    }

    /** BLOQUE ESCONDER BOTONES **/
    private void hideButtonsWithAnimation() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                animateButtonScale(0f);
                Handler handler = new Handler();
                int delay = 200; // 2 seconds
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        setButtonsVisibility(View.INVISIBLE);
                    }
                }, delay);
            }
        });
    }

    private void showButtonsWithAnimation() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                setButtonsVisibility(View.VISIBLE);
                animateButtonScale(1f);
                if (isLibroMedicina) {
                    fabAudioPlayer.setVisibility(View.VISIBLE);
                    fabAudioPlayer.animate().scaleX(1f).scaleY(1f);
                }
            }
        });
    }

    private void animateButtonScale(float scale) {
        View fabs[] = { fabMain,fabNumeroPagina, txtNumeroPagina, fabBookmark, fabFavoritos, fabIndice, fabNotas, fabRayar, fabSubrayar, fabFoto };
        for (View fab : fabs) {
            fab.animate().scaleX(scale).scaleY(scale);
        }
    }

    private void setButtonsVisibility(int visibility) {
        View fabs[] = {fabMain,fabNumeroPagina, txtNumeroPagina, fabBookmark, fabFavoritos, fabIndice, fabNotas, fabRayar, fabSubrayar, fabFoto };

        for (View fab : fabs) {
            fab.setVisibility(visibility);
        }
    }

    private void panelMaestroEsconderFabs() {
        if(banderaScale) {
            showFabMenu();
            fabPanelMaestro.animate().rotation(180f);
            banderaScale = false;
        } else {
            CloseFabMenu();
            fabPanelMaestro.animate().rotation(0f);
            banderaScale=true;
        }

    }

    public void audioPlayerEsconderFabs(boolean estado) {
        esconderBotonesDesdeComponentesFuncNativa(estado);
    }

    public void mostrarBotonAudioLibro() {
        fabPanelMaestro.setVisibility(View.GONE);
        fabAudioPlayer.setVisibility(View.VISIBLE);
    }

    public void esconder(){
        fabMain.setVisibility(View.VISIBLE);
        fabNumeroPagina.setVisibility(View.VISIBLE);
        txtNumeroPagina.setVisibility(View.VISIBLE);
        this.fabAudioPlayer.setVisibility(View.VISIBLE);
        this.fabPanelMaestro.setVisibility(View.VISIBLE);
    }

        /*** TERMINA BLOQUE ESCONDER BOTONES ***/

    public void cargarCapitulos(){
        String js = "Visor.handleIndice();";
        webView.evaluateJavascript(js, null);
    }

    public void cacharTokendesdeNativo(String token ){
        String js = "Visor.cacharTokendesdeNativo('"+token+"')";
        webView.evaluateJavascript(js, null);
    }

    public void mostrarBotonPanelMaestro() {
        fabPanelMaestro.setVisibility(View.VISIBLE);

    }
    public void dibujarRayado() {
        Cursor fila = bd.rawQuery("SELECT DATA,HOJA FROM RAYADO WHERE LIBROID=" + this.libroId, null);
        while (fila.moveToNext()) {
            String data = fila.getString(0);
            String hoja = fila.getString(1);
            Log.i("Dibuajr", "DATA: " + data + "Hoja: "+ hoja);
            webView.evaluateJavascript( ("Visor.dibujarRayado(" + hoja + ",'" + data + "');"), null);
            webView.evaluateJavascript("(function() { document.getElementById('signatureCanvas" + hoja + "').style['touch-action']=null;})()", null);
        }
        fila.close();
    }

    public void dibujarSubrayado() {
        Cursor fila = bd.rawQuery("SELECT DATA,HOJA FROM SUBRAYADO WHERE LIBROID=" + libroId, null);
        while (fila.moveToNext()) {
            String data = fila.getString(0);
            String hoja = fila.getString(1);
            if (!data.equals("[]")) {
                webView.evaluateJavascript("Visor.dibujarMarcatexto(" + hoja + ",'" + data + "')", null);
            }
        }
        fila.close();
    }

    public void dibujarFotos() {
        Cursor fila = bd.rawQuery("SELECT HOJA FROM FOTOS WHERE LIBROID=" + libroId, null);
        while (fila.moveToNext()) {
            webView.evaluateJavascript( "Visor.dibujarFoto(" + fila.getString(0) + ");", null);
        }
        fila.close();
    }

    private void ResetZoom(){
        webView.getSettings().setLoadWithOverviewMode(false);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.setInitialScale(0);
    }

    public void abrirlink(String url) {
        Uri webpage = Uri.parse(url);
        Intent intent = new Intent(Intent.ACTION_VIEW, webpage);
        startActivity(intent);
    }

    public void deshabilitarBotonesNativosPlugin(boolean estado) {
        isLibroMaestro = estado;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void tomarFoto(@Nullable String id, @Nullable String pid, int tipo) {
        // 1 = imagen tomada fuera  del libro 0=imagen tomada dentro del libro javascript
        nombrearchivo = getCurrentTimeStamp();
        if(tipo == 1){
            imagenid = "imagen_" + HojaActual + "_" + nombrearchivo;
        }
        else{
            imagenid = id;
        }
        File mydir;
        File foto;

        if(tipo == 1){
            mydir = new File(getExternalFilesDir(null),"fotolibro"+libroId+"/"+HojaActual);
            if (!mydir.exists()) mydir.mkdirs();
            foto = new File(getExternalFilesDir(null), "fotolibro"+libroId+"/"+HojaActual+"/"+imagenid+".png");
        }
        else {
            mydir = new File(getExternalFilesDir(null),"fotolibro"+libroId+"/"+paginaid);
            if (!mydir.exists()) mydir.mkdirs();
            foto = new File(getExternalFilesDir(null), "fotolibro"+libroId+"/"+paginaid+"/"+imagenid+".png");
        }

        try {
            Intent abrircamara = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

            abrircamara.putExtra(MediaStore.EXTRA_OUTPUT, FileProvider.getUriForFile(BookViewer.this,   "lbs.starter.provider", foto));

            startActivityForResult(abrircamara, CAMERA_REQUEST);
        } catch (Exception e) {
            Log.i("Error",e.toString() );
        }
        //  File foto = new File(getExternalFilesDir(null), "fotolibro"+libroid+"/"+HojaActual+"/"+getCurrentTimeStamp()+".jpg");



    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CAMERA_REQUEST && resultCode == Activity.RESULT_OK) {
            //1=imagen tomada fuera  del libro 0 = imagen tomada dentro del libro javascript
            if (tipofoto == 1) {
                File foto = new File(getExternalFilesDir(null), "fotolibro" + libroId + "/" + BookViewer.this.HojaActual + "/" + imagenid + ".png");
                File newfile = new File( BookViewer.this.getFilesDir() + "/books2020/" + "Libro" + libroId + "/" + BookViewer.this.HojaActual + "/img");

                copyFile(foto, newfile, imagenid);
                comprimirimage(newfile, imagenid, data, HojaActual);

                Cursor fila = bd.rawQuery("SELECT * FROM FOTOS WHERE HOJA='" + BookViewer.this.HojaActual + "' and LIBROID=" + BookViewer.this.libroId, null);
                bd.insert("FOTOS", null, BookViewer.this.PutBDFoto());
                String js = "Visor.dibujarFoto(" + BookViewer.this.HojaActual + ")";
                BookViewer.this.webView.loadUrl("javascript:" + js );
                //String js = "Visor.dibujarNota(" + NewActivity.this.HojaActual + ")";
                //  bd.close();
                fila.close();
            } else {
                File foto = new File(getExternalFilesDir(null), "fotolibro" + libroId + "/" + paginaid + "/" + imagenid + ".png");
                File newfile = new File(BookViewer.this.getFilesDir() + "/books2020/" + "Libro" + libroId + "/" + paginaid);

                copyFile(foto, newfile, imagenid);
                comprimirimage(newfile, imagenid, data, paginaid);

                String js = "Visor.mostrarFoto(" + "'" + imagenid + "'" + "," + "'" + paginaid + "'" + ");";
                BookViewer.this.webView.evaluateJavascript( js, null );
            }
        }
    }

    public void borrarFotoAdentroLibro(String id,String pid) {
        tipofoto=1;
        imagenid=id;
        paginaid=pid;
        File mydir = new File(getFilesDir(),"books2020/Libro"+libroId+"/"+paginaid+"/"+id+".png");
        File fotolibrodir = new File(getFilesDir(), "fotolibro"+libroId+"/"+paginaid+"/"+imagenid+".png");
        String filePath = fotolibrodir.getAbsolutePath();
        // Reemplaza la parte "/data/user/0" por "/data"
        String newFilePath = filePath.replaceFirst("/data/user/0", "/storage/emulated/0/Android/data");
        File ftlbrodir = new File(newFilePath);
        ftlbrodir.delete();
        mydir.delete();

        String js = "Visor.LimpiarFoto("+"'"+id+"'"+ ")";
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                BookViewer.this.webView.evaluateJavascript(js, null);
            }
        });


    }

    public void copyFile(File src, File dst,String nombre)  {
        InputStream in = null;
        OutputStream out = null;
        try {
            if (!dst.getAbsoluteFile().exists()) {
                dst.mkdirs();
            }
            in = new FileInputStream(src);
            out = new FileOutputStream(dst+"/"+nombre+".png");
            IOUtils.copy(in, out);
        } catch (Exception ioe) {
            //  Log.e(LOGTAG, "IOException occurred.", ioe);
        } finally {
            IOUtils.closeQuietly(out);
            IOUtils.closeQuietly(in);
        }
    }

    public void comprimirimage(File dst, String nombre,  Intent data1,String hoja)  {
        File f = new File(dst+"/"+ nombre+".png");
        try {
            File resizedImage = new Resizer(this)
                    .setTargetLength(600)
                    .setQuality(40)
                    .setOutputFormat("PNG")
                    .setOutputFilename(nombre)
                    .setOutputDirPath(dst.getAbsolutePath())
                    .setSourceImage(f)
                    .getResizedFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public  void Galeria() {
        getFromSdcard();
        borrargaleria.clear();
        ThisDialogGrid=new Dialog(BookViewer.this);
        ThisDialogGrid.requestWindowFeature(1);
        ThisDialogGrid.setContentView(R.layout.modalgrid);
        ThisDialogGrid.show();
        //Botones galeria
        this.btnBorrarImagen = (ImageButton) this.ThisDialogGrid.findViewById(R.id.btnBorrarImagen);
        this.btnBorrarImagen.setVisibility(View.VISIBLE);

        androidGridView = (GridView) ThisDialogGrid.findViewById(getResources().getIdentifier("gridview_android_example", "id", getPackageName()));
        androidGridView.setAdapter(new ImageAdapterGridView(this));
        androidGridView.setChoiceMode(GridView.CHOICE_MODE_MULTIPLE_MODAL);
        androidGridView.setMultiChoiceModeListener(new MultiChoiceModeListener());

        //cambio para git hub
        androidGridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
                String rutaimagen = new ImageAdapterGridView(BookViewer.this).getItem(position);
                Uri data = Build.VERSION.SDK_INT >= 24 ? Uri.parse(rutaimagen) : Uri.fromFile(new File(rutaimagen));
                Intent intent = new Intent(BookViewer.this, VisorImagen.class);
                intent.putExtra("img", rutaimagen);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK| FLAG_GRANT_READ_URI_PERMISSION);
                startActivity(intent);
            }
        });

        btnBorrarImagen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (borrargaleria.isEmpty()) {
                    Log.d("GalleryDeletion", "La lista borrargaleria está vacía. No se realizará ninguna acción.");
                    return;
                }

                SQLiteDatabase bd = new AdminSQLiteOpenHelper(getApplicationContext(), "libros", null, 1).getWritableDatabase();


                for (int i = 0; i < borrargaleria.size(); i++){
                    File filenew= new File(borrargaleria.get(i));
                    filenew.delete();
                }
                File file= new File(getFilesDir(),"books2020/Libro"+libroId+"/"+HojaActual+"/img");
                if(file.listFiles().length<1){
                    bd.delete("FOTOS", "HOJA='" + HojaActual + "'", null);
                    String js = "Visor.EliminarEtiquetaFoto(" + HojaActual + ")";
                    webView.evaluateJavascript(js, null);
                }
                ThisDialogGrid.onBackPressed();
                btnBorrarImagen.setVisibility(View.GONE);
            }
        });

    }

    public class ImageAdapterGridView extends BaseAdapter {
        private Context mContext;
        public ImageAdapterGridView(Context c) {
            mContext = c;
        }

        public int getCount() {
            // return imageIDs.length;
            return f.size();
        }

        @Override public String getItem(int position){
            return f.get(position);
        }

        public long getItemId(int position) {
            return 0;
        }

        public View getView(int position, View convertView, ViewGroup parent) {
            ImageView mImageView;
            if (convertView == null) {
                mImageView = new ImageView(mContext);
                mImageView.setLayoutParams(new GridView.LayoutParams(200, 230));
                mImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
                //  mImageView.setPadding(0, 5, 0, 5);
                Picasso.get().load("file://"+f.get(position)).fit().memoryPolicy(MemoryPolicy.NO_CACHE).centerCrop().into(mImageView);
            } else {
                mImageView = (ImageView) convertView;
            }
            return mImageView;
        }
    }

    public class MultiChoiceModeListener implements GridView.MultiChoiceModeListener {
        public boolean onCreateActionMode(ActionMode mode, Menu menu) {
            mode.setTitle("Selección de imagenes");
            return true;
        }

        public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
            return true;
        }

        public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
            return true;
        }

        public void onDestroyActionMode(ActionMode mode) {
            btnBorrarImagen.setVisibility(View.GONE);
        }

        public void onItemCheckedStateChanged(ActionMode mode, int position, long id, boolean checked) {
            String rutaimagen= new ImageAdapterGridView(BookViewer.this).getItem(position);
            ImageView img =(ImageView)androidGridView.getChildAt(position);
            if(checked){
                borrargaleria.add(rutaimagen);
                img.setAlpha(0.8f);
                btnBorrarImagen.setVisibility(View.VISIBLE);
            }
            else{
                borrargaleria.remove(rutaimagen);
                img.setAlpha(1.0f);
            }
        }
    }

    public void getFromSdcard() {
        File file= new File(getFilesDir(),"books2020/Libro"+ libroId +"/" + HojaActual + "/img");
        if (file.isDirectory()) {
            f.clear();
            File[] listFile = file.listFiles();
            if (listFile != null) {
                for (int i = 0; i < listFile.length; i++) {
                    f.add(listFile[i].getAbsolutePath());
                }
            }
        }
        else { f.clear(); }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public ContentValues PutBDFoto() {
        ContentValues registro = new ContentValues();
        registro.put("LIBROID", Integer.valueOf(this.libroId));
        registro.put("HOJA", this.HojaActual);
        registro.put("DATA", getCurrentTimeStamp()+".png");
        return registro;
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    public static String getCurrentTimeStamp() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
        Date now = new Date();
        String strDate = null;
        strDate = sdf.format(now);
        return strDate;
    }

    /** PERMISOS ANDROID ***/
    @SuppressLint("NewApi")
    public void checarpermisocamara(@Nullable String id, @Nullable String pid, int tipo){
        tipofoto = tipo;
        imagenid = id;
        paginaid = pid;
        int permiso = ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA);
        if(permiso != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(BookViewer.this, new String[]{ Manifest.permission.CAMERA }, 225); {
            };
        } else {
            tomarFoto(id,pid,tipo);
        }
    }

    @SuppressLint("NewApi")
    @Override
  /*  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(requestCode==225 && grantResults[0]==0 )
            tomarFoto(imagenid,paginaid,tipofoto);
    }*/
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 225) {
            boolean allPermissionsGranted = true;
            for (int result : grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    allPermissionsGranted = false;
                    break;
                }
            }
            if (allPermissionsGranted) {
                tomarFoto(imagenid, paginaid, tipofoto);
            } else {
                // Aquí puedes manejar el caso en que no se otorgaron todos los permisos
                // Por ejemplo, mostrar un mensaje al usuario o tomar una acción alternativa
            }
        }
    }



}