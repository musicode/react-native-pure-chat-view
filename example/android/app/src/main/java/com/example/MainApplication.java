package com.example;

import android.app.Application;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.facebook.react.ReactApplication;
import com.github.musicode.chatview.RNTChatViewImageLoader;
import com.github.musicode.chatview.RNTChatViewManager;
import com.github.musicode.chatview.RNTChatViewPackage;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Arrays;
import java.util.List;

public class MainApplication extends Application implements ReactApplication {

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
              new MainReactPackage(),
              new RNTChatViewPackage()
      );
    }

    @Override
    protected String getJSMainModuleName() {
      return "index";
    }
  };

  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SoLoader.init(this, /* native exopackage */ false);

    RNTChatViewManager.imageLoader = new RNTChatViewImageLoader() {
      @Override
      public void loadImage(ImageView imageView, String url) {

        Glide
                .with(imageView.getContext())
                .load(url)
                .into(imageView);
      }
    };

  }
}
