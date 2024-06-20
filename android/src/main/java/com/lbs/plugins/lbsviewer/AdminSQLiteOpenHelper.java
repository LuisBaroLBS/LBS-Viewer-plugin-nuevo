package com.lbs.plugins.lbsviewer;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class AdminSQLiteOpenHelper extends SQLiteOpenHelper {
    public AdminSQLiteOpenHelper(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
        super(context, name, factory, version);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE IF NOT EXISTS SEPARADORES (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS RAYADO (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS SUBRAYADO (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS NOTAS (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS FOTOS (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, HOJA TEXT,DATA TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS ESCRIBIR (ID INTEGER PRIMARY KEY AUTOINCREMENT,LIBROID INTEGER, EJERCICIO TEXT,DATA TEXT,ELEMENTO TEXT,ESTADO INTEGER)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
