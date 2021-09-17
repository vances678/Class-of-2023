package com.example.classof2023

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.webkit.WebView
import com.google.android.material.bottomnavigation.BottomNavigationView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.navigation.NavController
import androidx.navigation.fragment.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.example.classof2023.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var navController: NavController

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val nav = supportFragmentManager.findFragmentById(R.id.nav_host_fragment_activity_main)?.findNavController()
        if (nav != null) {
            val toolbar: Toolbar = findViewById(R.id.toolbar)
            val white = ContextCompat.getColor(applicationContext, R.color.white)
            toolbar.setTitleTextColor(white)
            setSupportActionBar(toolbar)

            navController = nav
            val appBarConfiguration = AppBarConfiguration(setOf(
                R.id.navigation_home, R.id.navigation_hub,
                R.id.navigation_calendar, R.id.navigation_suggestions))
            setupActionBarWithNavController(navController, appBarConfiguration)

            val navigationView = findViewById<BottomNavigationView>(R.id.nav_view)
            navigationView.setupWithNavController(navController)
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.action_buttons, menu)

        val refresh = menu?.findItem(R.id.action_refresh)
        val back = menu?.findItem(R.id.action_back)
        val next = menu?.findItem(R.id.action_next)
        navController.addOnDestinationChangedListener { _, destination, _ ->
            when(destination.id) {
                R.id.navigation_suggestions -> {
                    refresh?.isVisible = false
                    back?.isVisible = false
                    next?.isVisible = false
                } else -> {
                    refresh?.isVisible = true
                    back?.isVisible = true
                    next?.isVisible = true
                }
            }
        }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        val currentFragment = supportFragmentManager.primaryNavigationFragment?.childFragmentManager?.fragments?.first()
        val tag = currentFragment?.view?.tag.toString()
        val wvtag = Regex("^((?!constraintlayout).)*").find(tag)?.value.plus("webview")
        val webView = currentFragment?.view?.findViewWithTag(wvtag) as WebView

        val id = item.itemId
        if (id == R.id.action_back) {
            webView.goBack()
        } else if (id == R.id.action_next){
            webView.goForward()
        } else if (id == R.id.action_refresh) {
            webView.reload()
        } else if (id == R.id.action_share) {
            val sendIntent: Intent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, webView.url.toString())
                type = "text/plain"
            }
            startActivity(Intent.createChooser(sendIntent, null))
        }
        return super.onOptionsItemSelected(item)
    }


}