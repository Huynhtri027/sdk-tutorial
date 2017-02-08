package android.connecthings.com.tuto.notification;

import android.app.Application;
import android.app.NotificationManager;
import android.app.PendingIntent;
import com.connecthings.adtag.AdtagInitializer;
import com.connecthings.adtag.analytics.AdtagLogsManager;
import com.connecthings.adtag.model.sdk.BeaconContent;
import com.connecthings.util.Log;
import com.connecthings.util.adtag.beacon.AdtagBeaconManager;
import com.connecthings.util.adtag.beacon.model.BeaconNotification;
import com.connecthings.util.adtag.beacon.strategy.notification.BeaconNotificationStrategySpamMaxFilter;
import com.connecthings.util.adtag.beacon.strategy.notification.BeaconNotificationStrategySpamRegionFilter;
import com.connecthings.util.adtag.beacon.strategy.notification.BeaconNotificationStrategySpamTimeFilter;
import com.connecthings.util.connection.Network;
import com.connecthings.util.connection.Url;
import android.content.Intent;
import android.media.RingtoneManager;
import android.support.v4.app.NotificationCompat;
import android.text.TextUtils;

/**
 */
public class ApplicationNotification extends Application implements BeaconNotification{

    private static final String TAG = "ApplicationNotification";
    private static final int NOTIFICATION_BEACON_ID = 1;
    private NotificationManager mNotificationManager;

    public void onCreate(){
        super.onCreate();
        AdtagInitializer.initInstance(this).initUrlType(Url.UrlType.***PLATFORM***)
                .initUser("**USER**", "**PSW**").initCompany("**COMPANY**");
        //Initiate the adtagLogManager that manages the way log are sent to the platform
        AdtagLogsManager.initInstance(this, Network.ALL, 200, 1000 * 60 * 2);
        //If you need more parameter - AdtagLogsManager.initInstance(this, Network.ALL,  50, 1000*60*2);
        //Initiate the beaconManager with the UUID of your beacons company. our beaconManager manage only one beacon Region based on the uuid
        AdtagBeaconManager beaconManager = AdtagBeaconManager.initInstance(this, "**UUID**");

        beaconManager.registerBeaconNotificationListener(this);
        /**
         * *************    NOTIFICATION STRATEGIES   ***********************
         */
        //Avoid to replace the current notification if the next notification has the same content for the {category, field} value.
        // In this case, if the current beacon notification and the new beacon notification has the same beacon notification title,
        // the current beacon notification is not replaced by a notification associated to the new beacon.
        beaconManager.addNotificationStrategy(new BeaconNotificationStrategySpamRegionFilter("beacon-notification", "title"));
        //Limit the number of notifications in a lapse time : in our case the application won't create more than 2 beacon notifications each hours
        beaconManager.addNotificationStrategy(new BeaconNotificationStrategySpamMaxFilter(2, 60* 1000 * 60));
        //Permit to define :
        // - a time to wait before displaying a first notification after the application goes to background (in our exemple 10 minutes)
        // - a time to wait before displaying a new beacon notification (in our exemples 20 minutes
        beaconManager.addNotificationStrategy(new BeaconNotificationStrategySpamTimeFilter(60 * 1000 * 10, 60 * 1000* 20));
    }

    public int createNotification(BeaconContent beaconContent) {
        Log.d(TAG, "create notification");
        if(TextUtils.isEmpty(beaconContent.getAlertTitle()) || TextUtils.isEmpty(beaconContent.getAlertDescription())){
            return -1;
        }
        //example of notification code
        if(mNotificationManager==null){
            mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        }
        Intent notifyIntent = new Intent(Intent.ACTION_MAIN);
        notifyIntent.setClass(getApplicationContext(), MainActivity.class);

        PendingIntent intent = PendingIntent.getActivity(this, 0,
                notifyIntent,  PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationCompat.Builder mNotificationBuilder = new NotificationCompat.Builder(this);
        mNotificationBuilder.setContentTitle(beaconContent.getNotificationTitle());
        mNotificationBuilder.setContentText(beaconContent.getNotificationDescription());
        mNotificationBuilder.setContentIntent(intent);
        mNotificationBuilder.setSmallIcon(R.mipmap.ic_launcher);
        mNotificationBuilder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION));
        mNotificationBuilder.setAutoCancel(true);
        mNotificationBuilder.setVibrate(new long[]{1000, 1000 ,1000});
        mNotificationManager.notify(NOTIFICATION_BEACON_ID, mNotificationBuilder.build());
        return NOTIFICATION_BEACON_ID;
    }

}
