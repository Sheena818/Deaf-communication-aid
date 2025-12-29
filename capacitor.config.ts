import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.deafcomm.app',
  appName: 'Deaf Communication Aid',
  webDir: 'dist',
  server: {
    androidScheme: 'https',
    // For development, uncomment the following to enable live reload:
    // url: 'http://YOUR_IP:5173',
    // cleartext: true
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: '#0f172a',
      androidSplashResourceName: 'splash',
      androidScaleType: 'CENTER_CROP',
      showSpinner: false,
      splashFullScreen: true,
      splashImmersive: true
    },
    PushNotifications: {
      presentationOptions: ['badge', 'sound', 'alert']
    },
    Keyboard: {
      resize: 'body',
      resizeOnFullScreen: true
    },
    StatusBar: {
      style: 'dark',
      backgroundColor: '#0f172a'
    },
    LocalNotifications: {
      smallIcon: 'ic_stat_icon',
      iconColor: '#6366f1'
    },
    Camera: {
      // Camera permissions are handled in native config
    },
    Microphone: {
      // Microphone permissions are handled in native config
    },
    SpeechRecognition: {
      // Speech recognition permissions are handled in native config
    },
    TextToSpeech: {
      // Text-to-speech uses system voices
    },
    Haptics: {
      // Haptic feedback for accessibility
    },
    ScreenReader: {
      // Screen reader detection for accessibility
    }
  },
  ios: {
    contentInset: 'automatic',
    preferredContentMode: 'mobile',
    scheme: 'DeafComm',
    backgroundColor: '#0f172a',
    // Accessibility settings
    allowsLinkPreview: true,
    scrollEnabled: true
  },
  android: {
    allowMixedContent: false,
    captureInput: true,
    webContentsDebuggingEnabled: false,
    backgroundColor: '#0f172a',
    // Build configuration
    buildOptions: {
      keystorePath: undefined,
      keystorePassword: undefined,
      keystoreAlias: undefined,
      keystoreAliasPassword: undefined,
      releaseType: 'AAB'
    }
  }
};

export default config;
