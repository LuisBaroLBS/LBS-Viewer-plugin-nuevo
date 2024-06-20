package com.moduscreate.plugin;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.ContentValues;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Configuration;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.icu.text.SymbolTable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.sax.Element;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;
import android.view.ActionMode;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TableLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.os.Environment;

import org.apache.commons.io.IOUtils;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebViewImpl;
import org.apache.cordova.engine.SystemWebView;
import org.apache.cordova.engine.SystemWebViewClient;
import org.apache.cordova.engine.SystemWebViewEngine;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.webkit.JavascriptInterface;

import java.io.File;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import lbs.starter.BuildConfig;

import lbs.starter.MainActivity;
import me.echodev.resizer.Resizer;

import com.squareup.picasso.MemoryPolicy;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import static android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION;
import static android.content.Intent.FLAG_GRANT_WRITE_URI_PERMISSION;
import static android.icu.lang.UCharacter.GraphemeClusterBreak.L;


public class NewActivity extends CordovaActivity {
    SystemWebView web1;
    ImageButton FabMain,FabBookmark,FabFavoritos,FabIndice,FabNotas,FabRayar,FabSubrayar,FabFoto,FabNumeroPagina,FabAudioPlayer,FabPanelMaestro;
    ImageButton FabSubrayarAmarillo,FabSubrayarRosa,FabSubrayarAzul;
    ImageButton FabRayarNegro,FabRayarRojo,FabRayarAmarillo,FabRayarVerde,FabRayarRosa,FabRayarAzul,FabRayarColor,FabRayarRosaLigero,FabRayarGrey,FabRayarMarron;
    ImageButton FabBorrar,FabBorrarActivo,FabCloseSubrayar,FabColorSubrayado;
    Button FabTamano;
    ImageButton FabUndo,FabLimpiar,FabCloseRayar;
    ImageButton FabEjercicios;
    TextView txtNumeroPagina;
    ImageButton FabTomarFoto,FabGaleria,FabCloseFoto;
    Boolean isFabOpen=false,FotoActivo=false,RayarActivo=false,SubRayar=false,TapActivo=false,BorrarActivo=false,FavoritosActivo = false;
    LinearLayout PanelSubrayado;
    TableLayout  PanelRayado;
    String  HojaActual,nombrearchivo;
    int libroid,cargando = 0,TotalPaginas = 0;
    String token;
    EditText e2;
    Dialog ThisDialog,ThisDialogGrid;
    Button guardar;
    Button borrar;
    Button btnSeleccionarImagen;
    ImageButton btnBorrarImagen;
    ArrayList<String> f = new ArrayList<String>();
    ArrayList<String> borrargaleria = new ArrayList<String>();
    List<File> fileList = new ArrayList<File>();
    File[] listFile;
    File[] listFileBorrar;
    Integer[] imageIDs = {};
    GridView androidGridView;
    SQLiteDatabase bd;
    String Capitulos;
    int tipofoto;
    boolean banderaScale=true;
    String imagenid;
    String paginaid;
    SeekBar simpleSeekBar;
    int progresvisible=1;
    double division=Math.pow(0.0, 1);
    boolean isLibroMaestro = false;
    boolean isLibroMedicina = false;


    private static final String GOOGLE_PHOTOS_PACKAGE_NAME = "com.google.android.apps.photos";
    private static final int CAMERA_REQUEST = 1888;
    @Override
    protected CordovaWebView makeWebView() {
        //SystemWebView webView =SystemWebView)findViewById(R.id.cordovaWebView);
        String package_name = getApplication().getPackageName();
        SystemWebView webView =web1=(SystemWebView)findViewById(getApplication().getResources().getIdentifier("web1", "id", package_name));
        //eduardo
        webView.setInitialScale(0);
        webView.setVerticalScrollBarEnabled(false);
        webView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        webView.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NORMAL);
        web1.clearCache(true);
        web1.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        //web1.getSettings().setAppCacheEnabled(false);
        webView.getSettings().setUseWideViewPort(true);



        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setDisplayZoomControls(false);
        webView.getSettings().setAllowFileAccessFromFileURLs(true);
        webView.getSettings().setAllowUniversalAccessFromFileURLs(true);
        webView.getSettings().setAllowFileAccess(true);
        webView.getSettings().setAllowContentAccess(true);
        webView.getSettings().setTextZoom(100); // previene que los dispositivos no aumente el tamaño de la letra,
        // si el usuario cambia el tamaño de la fuente desde sistema del celular.
        webView.getSettings().setDomStorageEnabled(true);
        webView.addJavascriptInterface(new WebViewJavaScriptInterface(this,this), "app");
        return new CordovaWebViewImpl(new SystemWebViewEngine(webView));

    }

    @Override
    protected void createViews() {
        appView.getView().requestFocusFromTouch();
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String package_name = getApplication().getPackageName();
        //String package_name = "com.moduscreate.plugin";
        this.requestWindowFeature(1);


        setContentView(getApplication().getResources().getIdentifier("activity_new", "layout", package_name));
        this.HojaActual = "1";
        this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        this.ThisDialog = new Dialog(this);
        this.ThisDialog.requestWindowFeature(1);
        this.ThisDialog.setContentView(getApplication().getResources().getIdentifier("modal", "layout", getApplication().getPackageName()));
        //getActionBar().hide();


        //***** inicializar base de datos
        bd = new AdminSQLiteOpenHelper(getApplicationContext(), "libros", null, 1).getWritableDatabase();
        int resId = getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resId > 0) {
            int result = getResources().getDimensionPixelSize(resId);
        }

        txtNumeroPagina =  (TextView) findViewById(getResources().getIdentifier("txtNumeroPagina", "id", package_name));
        FabNumeroPagina = (ImageButton) findViewById(getResources().getIdentifier("FabNumeroPagina", "id", package_name));
        FabAudioPlayer = (ImageButton) findViewById(getResources().getIdentifier("FabAudioPlayer", "id", package_name));
        
        //web1=(SystemWebView)findViewById(getApplication().getResources().getIdentifier("web1", "id", package_name));
        FabMain = (ImageButton) findViewById(getResources().getIdentifier("FabMain", "id", package_name));
        FabBookmark = (ImageButton) findViewById(getResources().getIdentifier("FabBookmark", "id", package_name));
        FabFavoritos = (ImageButton) findViewById(getResources().getIdentifier("FabFavoritos", "id", package_name));
        FabIndice = (ImageButton) findViewById(getResources().getIdentifier("FabIndice", "id", package_name));
        FabNotas = (ImageButton) findViewById(getResources().getIdentifier("FabNotas", "id", package_name));
        FabFoto = (ImageButton) findViewById(getResources().getIdentifier("FabFoto", "id", package_name));
        FabRayar = (ImageButton) findViewById(getResources().getIdentifier("FabRayar", "id", package_name));
        FabSubrayar = (ImageButton) findViewById(getResources().getIdentifier("FabSubrayar", "id", package_name));


        //Botones Subrayado
        FabBorrar = (ImageButton) findViewById(getResources().getIdentifier("FabBorrar", "id", package_name));
        FabBorrarActivo = (ImageButton) findViewById(getResources().getIdentifier("FabBorrarActivo", "id", package_name));
        FabCloseSubrayar = (ImageButton) findViewById(getResources().getIdentifier("FabCloseSubrayar", "id", package_name));

        //Botones Color Subryado
        FabColorSubrayado=(ImageButton) findViewById(getResources().getIdentifier("FabColorSubrayado", "id", package_name));
        FabSubrayarAmarillo=(ImageButton) findViewById(getResources().getIdentifier("FabSubrayarAmarillo", "id", package_name));
        FabSubrayarRosa=(ImageButton) findViewById(getResources().getIdentifier("FabSubrayarRosa", "id", package_name));
        FabSubrayarAzul=(ImageButton) findViewById(getResources().getIdentifier("FabSubrayarAzul", "id", package_name));

        //Botones Rayar
        FabRayarColor=(ImageButton) findViewById(getResources().getIdentifier("FabRayarColor", "id", package_name));
        FabUndo = (ImageButton) findViewById(getResources().getIdentifier("FabUndo", "id", package_name));
        FabLimpiar = (ImageButton) findViewById(getResources().getIdentifier("FabLimpiar", "id", package_name));
        FabCloseRayar = (ImageButton) findViewById(getResources().getIdentifier("FabCloseRayar", "id", package_name));
        FabTamano = (Button) findViewById(getResources().getIdentifier("FabTamano", "id", package_name));
        simpleSeekBar = (SeekBar) findViewById(getResources().getIdentifier("simpleSeekBar", "id", package_name));

        //Botones Color Rayar
        FabRayarNegro= (ImageButton) findViewById(getResources().getIdentifier("FabRayarNegro", "id", package_name));
        FabRayarRojo= (ImageButton) findViewById(getResources().getIdentifier("FabRayarRojo", "id", package_name));
        FabRayarAmarillo= (ImageButton) findViewById(getResources().getIdentifier("FabRayarAmarillo", "id", package_name));
        FabRayarVerde= (ImageButton) findViewById(getResources().getIdentifier("FabRayarVerde", "id", package_name));
        FabRayarRosa= (ImageButton) findViewById(getResources().getIdentifier("FabRayarRosa", "id", package_name));
        FabRayarAzul= (ImageButton) findViewById(getResources().getIdentifier("FabRayarAzul", "id", package_name));
        FabRayarRosaLigero= (ImageButton) findViewById(getResources().getIdentifier("FabRayarRosaLigero", "id", package_name));
        FabRayarGrey= (ImageButton) findViewById(getResources().getIdentifier("FabRayarGrey", "id", package_name));
        FabRayarMarron= (ImageButton) findViewById(getResources().getIdentifier("FabRayarMarron", "id", package_name));
        

        //Botones Foto
        FabTomarFoto = (ImageButton) findViewById(getResources().getIdentifier("FabTomarFoto", "id", package_name));
        FabGaleria = (ImageButton) findViewById(getResources().getIdentifier("FabGaleria", "id", package_name));
        FabCloseFoto = (ImageButton) findViewById(getResources().getIdentifier("FabCloseFoto", "id", package_name));

        //Botones notas
        this.e2 = (EditText) this.ThisDialog.findViewById(getResources().getIdentifier("e2", "id", getApplication().getPackageName()));
        this.guardar = (Button) this.ThisDialog.findViewById(getResources().getIdentifier("guardar", "id", getApplication().getPackageName()));
        this.borrar = (Button) this.ThisDialog.findViewById(getResources().getIdentifier("borrar", "id", getApplication().getPackageName()));

        //Botones Ejercicios
        FabEjercicios = (ImageButton) findViewById(getResources().getIdentifier("FabEjercicios", "id", package_name));

        Bundle bundle1 = getIntent().getExtras();
        String mostrarbotonejercicio=bundle1.getString("app");
        FabEjercicios.setVisibility(View.GONE);



       



        





      
        /***************Panel Rayar**********************/
      

        

     
        /***********************************************/
       
        /********************Panel color subrayado**********************/
       
        /*************************************************************/
       
        /***Herramientas Subrayar***/
        
        /***************************/
        /***Herramientas Rayar******/
       
        
        /***************************/
        /***Herramientas Foto******/
        

        /***************************/
        // Create a `GestureDetector` that does something special on double-tap.
        final GestureDetector gestureDetector = new GestureDetector(this, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onDoubleTap(MotionEvent event) {
                // TODO: Insert code to run on double-tap here.
                ResetZoom();
                // Consume the double-tap.
                return true;
            }
            @Override
            public boolean onSingleTapConfirmed(MotionEvent event){
                if(BorrarActivo==true)
                    return true;
                if(TapActivo==false) {
                    TapActivo=true;
                    FabMain.setVisibility(View.GONE);
                    FabBookmark.setVisibility(View.GONE);
                    FabFavoritos.setVisibility(View.GONE);
                    FabIndice.setVisibility(View.GONE);
                    FabNotas.setVisibility(View.GONE);
                    FabFoto.setVisibility(View.GONE);
                    FabRayar.setVisibility(View.GONE);
                    FabSubrayar.setVisibility(View.GONE);
                }
                else{
                    TapActivo=false;
                    FabMain.setVisibility(View.VISIBLE);
                    FabBookmark.setVisibility(View.VISIBLE);
                    FabFavoritos.setVisibility(View.VISIBLE);
                    FabIndice.setVisibility(View.VISIBLE);
                    FabNotas.setVisibility(View.VISIBLE);
                    FabFoto.setVisibility(View.VISIBLE);
                    FabRayar.setVisibility(View.VISIBLE);
                    FabSubrayar.setVisibility(View.VISIBLE);
                }
                return true;
            }
        });

      
        

            /*** AQUI NO **/
        loadUrl(launchUrl + "/indexAndroid.html?page=1");
        web1.setWebViewClient(new SystemWebViewClient((SystemWebViewEngine) this.appView.getEngine()) {
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                NewActivity newActivity = NewActivity.this;
                cargando++;
                Log.i("LOG MESSAGE","TOKEN: " + token );
                if (cargando == 2) {
                    System.out.println("cargando------------------------!!!!!!!!!!!!!!!!!!!!");
                    dibujarSeparadores();
                    dibujarRayado();
                    dibujarSubrayado();
                    dibujarNotas();
                    dibujarFotos();
                    cargarCapitulos();
                    cacharTokendesdeNativo(token);

                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    web1.evaluateJavascript("window.localStorage.setItem('USER_INFO','"+ token +"');", null);
                    web1.evaluateJavascript("window.localStorage.setItem('USER_INFO','"+ token +"');", null);
                } else {
                    web1.loadUrl("javascript:localStorage.setItem('USER_INFO','"+ token +"');");
                    web1.loadUrl("javascript:localStorage.setItem('USER_INFO','"+ token +"');");
                }
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    web1.evaluateJavascript("window.localStorage.setItem('USER_INFO','"+ token +"');", null);
                    web1.evaluateJavascript("window.localStorage.setItem('USER_INFO','"+ token +"');", null);
                } else {
                    web1.loadUrl("javascript:localStorage.setItem('USER_INFO','"+ token +"');");
                    web1.loadUrl("javascript:localStorage.setItem('USER_INFO','"+ token +"');");
                }

            }

            /*** hst aca ***/


        });

    }




   
    private void ResetZoom(){
        web1.getSettings().setLoadWithOverviewMode(false);
        web1.getSettings().setLoadWithOverviewMode(true);
        web1.setInitialScale(0);
    }

    
    public ContentValues PutBDNota() {
        ContentValues registro = new ContentValues();
        registro.put("LIBROID", Integer.valueOf(this.libroid));
        registro.put("HOJA", this.HojaActual);
        registro.put("DATA", this.e2.getText().toString());
        return registro;
    }
    


    /****************************/
    /***METODOS PARA TOMAR FOTOGRAFIA***/



    

    


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        int a=Build.VERSION.SDK_INT;
        if(a>19){
            this.finish();
            Intent startIntent= new Intent(this, MainActivity.class);
            startIntent.putExtra("eduardo", "eduardo");
            startIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            this.startActivity(startIntent);
        }

    }
    

 
  

    

    public void ocultarbotoncandado(String accion){
        if(accion.equals("abrir")){
            this.FabAudioPlayer.setVisibility(View.GONE);
            this.FabPanelMaestro.setVisibility(View.GONE);

        }
        else if(accion.equals("cerrar")){
            this.FabAudioPlayer.setVisibility(View.VISIBLE);
            this.FabPanelMaestro.setVisibility(View.VISIBLE);
        }
    }

    

    

    /*
 
       

    }

}