package android.connecthings.app.qrNfcSdkDemo;

import android.app.Activity;
import android.connecthings.adtag.analytics.AdtagLogsManager;
import android.connecthings.adtag.analytics.model.AdtagLogContent;
import android.connecthings.adtag.analytics.model.AdtagLogData;
import android.connecthings.adtag.model.sdk.AdtagContent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;


public class ActivityContent extends Activity implements View.OnClickListener{

    public static final String ADTAG_CONTENT="adtag_content";

    AdtagContent content;

    AdtagLogsManager logsManager;

    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        if(savedInstanceState==null || savedInstanceState.isEmpty()){
            Bundle extraBundle = getIntent().getExtras();
            if(extraBundle!=null){
                loadDataOnCreate(extraBundle);
            }
        }else{
            loadDataOnCreate(savedInstanceState);
        }
        setContentView(R.layout.activity_content);
        View v = findViewById(R.id.btn_back);
        v.setOnClickListener(this);
        v.setClickable(true);
        v.setFocusable(true);
        logsManager = AdtagLogsManager.getInstance();
        createContent();
    }

    public void createContent(){
        TextView tv = (TextView) findViewById(R.id.txt_content);
        if(content == null) {
            tv.setText(R.string.txt_content_empty);
        }else if(content.hasInformation()){
            tv.setText(content.getValue("Name","Nom"));
        }else{
            tv.setText(R.string.txt_content_no);
        }
        if(content!=null){
            AdtagLogContent logContent = new AdtagLogContent(content, AdtagLogData.REDIRECT_TYPE.DIRECT, "ActivityHome");
            logsManager.sendLog(logContent);
        }
    }

    public void loadDataOnCreate(Bundle bundle) {
        content = bundle.getParcelable(ADTAG_CONTENT);
    }

    public void onSaveInstanceState(Bundle outState){
        outState.putParcelable(ADTAG_CONTENT, content);
    }

    @Override
    public void onClick(View v) {
        this.finish();
    }
}
