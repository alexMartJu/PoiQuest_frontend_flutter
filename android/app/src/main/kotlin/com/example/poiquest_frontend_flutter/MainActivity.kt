package com.example.poiquest_frontend_flutter

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    /**
     * Workaround para bug en arcore_flutter_plus: al destruir una sesión AR,
     * el plugin anula internamente su ArSceneView, pero Flutter mantiene
     * registrado el platform view. En el siguiente onPostResume(),
     * PlatformViewsController.onResume() itera todos los platform views
     * y llama resetSurface() → getView() sobre la vista zombie, lo que
     * lanza NullPointerException y mata la app.
     *
     * Al capturar esa excepción aquí, permitimos que la Activity se reanude
     * normalmente y la segunda sesión AR funcione sin crash.
     */
    override fun onPostResume() {
        try {
            super.onPostResume()
        } catch (e: NullPointerException) {
            // Ignorar NPE lanzada por ArCoreView.getView() durante
            // PlatformViewsController.onResume → resetSurface.
        }
    }
}
