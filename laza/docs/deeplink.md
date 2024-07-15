# deeplink

- To test with an Android emulator, give the adb command an intent where the host name matches the name defined in AndroidManifest.xml:

``` adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "http://dwirandyh.medium.com/passwordResetPage/" com.example.laza ```