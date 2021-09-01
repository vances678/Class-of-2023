package com.example.classof2023.ui.home

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.core.view.children
import androidx.core.view.get
import androidx.fragment.app.Fragment
import com.example.classof2023.R

private var savedView: View? = null

class HomeFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        var shouldReload = false
        if (container?.childCount == 1) {
            if (container.children.first() == savedView) {
                container.removeAllViews()
                shouldReload = true
            }
        }
        return if (savedView == null || shouldReload) { inflater.inflate(R.layout.fragment_home, container, false) } else { savedView }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        savedView = view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val webView: WebView? = getView()?.findViewById(R.id.homewebview)
        webView?.webViewClient = WebViewClient()
        webView?.settings?.javaScriptEnabled = true
        if (webView?.url == null) {
            webView?.loadUrl("https://sites.google.com/hotchkiss.org/hotchkissclassof2023/home")
        }
    }
}