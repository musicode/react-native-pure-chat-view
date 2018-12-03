
package com.github.musicode;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

public class RNTChatViewModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNTChatViewModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNTChatView";
  }

}