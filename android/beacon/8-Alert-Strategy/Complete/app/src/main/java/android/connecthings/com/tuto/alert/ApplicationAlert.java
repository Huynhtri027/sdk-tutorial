package android.connecthings.com.tuto.alert;

import android.app.Application;
import com.connecthings.adtag.AdtagInitializer;
import com.connecthings.adtag.analytics.AdtagLogsManager;
import com.connecthings.util.adtag.beacon.AdtagBeaconManager;
import com.connecthings.util.adtag.beacon.permission.bluetooth.BluetoothManager;
import com.connecthings.util.connection.Network;
import com.connecthings.util.connection.Url;

/**
 */
public class ApplicationAlert extends Application{

    public void onCreate(){
        super.onCreate();
        AdtagInitializer.initInstance(this).initUrlType(Url.UrlType.__PLATFORM__).initUser("__LOGIN_", "__PASSWORD__").initCompany("__COMPANY__");
        //Initiate the adtagLogManager that manages the way log are sent to the platform
        AdtagLogsManager.initInstance(this, Network.ALL, 200, 1000 * 60 * 2);
        //If youe need more parameter - AdtagLogsManager.initInstance(this, Network.ALL,  50, 1000*60*2);
        //Initiate the beaconManager with the UUID of your beacons company. our beaconManager manage only one beacon Region based on the uuid
        AdtagBeaconManager beaconManager = AdtagBeaconManager.initInstance(this, "__UUID__");
        beaconManager.setEnableBluetoothWhenAppInBackground(BluetoothManager.BLUETOOTH_BACKGROUND_ACTIVATION_STATUS.ENABLE);
        //Register your additional strategy
        beaconManager.addAlertStrategy(new TimeAlertStrategyFirstWay(30000 , 60000));
    }

}
