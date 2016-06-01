package android.connecthings.com.tuto.permission;

import android.app.Application;
import android.connecthings.adtag.AdtagInitializer;
import android.connecthings.adtag.analytics.AdtagLogsManager;
import android.connecthings.util.adtag.beacon.AdtagBeaconManager;
import android.connecthings.util.connection.Network;
import android.connecthings.util.connection.Url;

/**
 */
public class ApplicationPermission extends Application{

    private static final String UUID = "B0462602-CBF5-4ABB-87DE-B05340DCCBC5";



    public void onCreate(){
        super.onCreate();
        AAdtagInitializer.initInstance(this).initUrlType(Url.UrlType.**PLATFORM**)
                .initUser("**USER**", "**PSW**").initCompany("**COMPANY**");
        //Initiate the adtagLogManager that manages the way log are sent to the platform
        AdtagLogsManager.initInstance(this, Network.ALL, 200, 1000 * 60 * 2);
        //If youe need more parameter - AdtagLogsManager.initInstance(this, Network.ALL,  50, 1000*60*2);
        //Initiate the beaconManager with the UUID of your beacons company. our beaconManager manage only one beacon Region based on the uuid
        AdtagBeaconManager beaconManager = AdtagBeaconManager.initInstance(this, "**UUID**");
    }





}
