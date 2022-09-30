public class MyApplication extends Application {

    private static MyApplication mInstance;

    @Override
    public void onCreate() {
        super.onCreate();

        mInstance = this;


        //app crash report
        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {

            @Override
            public void uncaughtException(Thread thread, Throwable ex) {
                handleUncaughtException(thread, ex);

            }
        });
    }

    public static synchronized MyApplication getInstance() {
        return mInstance;
    }

    public void setConnectivityListener(ConnectivityReceiver.ConnectivityReceiverListener listener) {
        ConnectivityReceiver.connectivityReceiverListener = listener;
    }


    //mail bug report function
    public void handleUncaughtException (Thread thread, Throwable e)
    {
        String stackTrace = Log.getStackTraceString(e);
        String message = e.getMessage();

        Intent intent = new Intent (Intent.ACTION_SEND);
        intent.setType("message/rfc822");
        intent.putExtra (Intent.EXTRA_EMAIL, new String[] {"xpertlab.urvashi@gmail.com"});
        intent.putExtra (Intent.EXTRA_SUBJECT, "AMC Teledoc Doctor - App Crash Report");
        intent.putExtra (Intent.EXTRA_TEXT, stackTrace);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // required when starting from Application
        startActivity(intent);

    }

}