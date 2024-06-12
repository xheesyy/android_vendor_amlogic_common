package com.khadas.ksettings;

import android.content.Context;
import android.content.Intent;
import android.media.tv.TvInputInfo;
import android.media.tv.TvInputManager;
import android.os.SystemProperties;
import android.preference.EditTextPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.preference.SwitchPreference;
import android.util.Log;
import android.widget.Toast;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import android.text.TextUtils;
import android.content.ComponentName;

public class MainActivity extends PreferenceActivity implements Preference.OnPreferenceClickListener {

    private ListPreference USB_PCIE_Preference;
    private ListPreference FAN_Preference;

    private ListPreference POWERKEY_Preference;

    private EditTextPreference FUNCTIONKEY_Preference;

    private SwitchPreference WOL_Preference;
    private SwitchPreference HOTSPOT_Preference;

    private PreferenceScreen HDMI_IN_Preference;
	private SwitchPreference CAM1_IR_CUT_Preference;
    private Preference UPDATER_Preference;
    private Context mContext;

    private static final String USB_PCIE_KEY = "USB_PCIE_KEY";
    private static final String FAN_KEY = "FAN_KEY";
    private static final String POWER_KEY = "POWER_KEY";
    private static final String FUNCTION_KEY = "FUNCTION_KEY";
    private static final String WOL_KEY = "WOL_KEY";
    private static final String HOTSPOT_KEY = "HOTSPOT_KEY";
    private static final String HDMI_IN_KEY = "HDMI_IN_KEY";
	private static final String CAM1_IR_CUT_KEY = "CAM1_IR_CUT_KEY";

    private static final String UPDATER_KEY = "UPDATER_KEY";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.main);
        mContext = this;
		PreferenceScreen preferenceScreen = getPreferenceScreen();
        getActionBar().setHomeButtonEnabled(true);
        getActionBar().setDisplayHomeAsUpEnabled(true);

        USB_PCIE_Preference = (ListPreference) findPreference(USB_PCIE_KEY);
        bindPreferenceSummaryToValue(USB_PCIE_Preference);
        getPreferenceScreen().removePreference(USB_PCIE_Preference);

        FAN_Preference = (ListPreference) findPreference(FAN_KEY);
        bindPreferenceSummaryToValue(FAN_Preference);
		CAM1_IR_CUT_Preference = (SwitchPreference)findPreference(CAM1_IR_CUT_KEY);
		CAM1_IR_CUT_Preference.setOnPreferenceClickListener(this);
        POWERKEY_Preference = (ListPreference) findPreference(POWER_KEY);
        bindPreferenceSummaryToValue(POWERKEY_Preference);

        FUNCTIONKEY_Preference = (EditTextPreference) findPreference(FUNCTION_KEY);
        bindPreferenceSummaryToValue(FUNCTIONKEY_Preference);

        WOL_Preference = (SwitchPreference)findPreference(WOL_KEY);
        //WOL_Preference.setChecked(true);
        WOL_Preference.setOnPreferenceClickListener(this);
        try {
            String ret = ComApi.execCommand(new String[]{"sh", "-c", "cat /sys/class/mcu/wol_enable"});
            if(ret.equals("1")){
                WOL_Preference.setChecked(true);
            }else{
                WOL_Preference.setChecked(false);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        HOTSPOT_Preference = (SwitchPreference)findPreference(HOTSPOT_KEY);
        //HOTSPOT_Preference.setChecked(true);
        HOTSPOT_Preference.setOnPreferenceClickListener(this);
        getPreferenceScreen().removePreference(HOTSPOT_Preference);

        HDMI_IN_Preference = (PreferenceScreen) findPreference(HDMI_IN_KEY);
        HDMI_IN_Preference.setOnPreferenceClickListener(this);
        UPDATER_Preference = (Preference) findPreference(UPDATER_KEY);
        UPDATER_Preference.setOnPreferenceClickListener(this);
        File file = new File("/sys/bus/i2c/drivers/ov08a10/2-0036");
        if (!file.exists()){
			//CAM1_IR_CUT_Preference.setEnabled(false);
			preferenceScreen.removePreference(CAM1_IR_CUT_Preference);
		}

    }

    /**
     * bindPreferenceSummaryToValue 拷贝至as自动生成的preferences的代码，用于绑定显示实时值
     */
    private static Preference.OnPreferenceChangeListener sBindPreferenceSummaryToValueListener = new Preference.OnPreferenceChangeListener() {
        @Override
        public boolean onPreferenceChange(Preference preference, Object value) {
            String stringValue = value.toString();
            String key = preference.getKey();
            if (preference instanceof ListPreference) {
                // For list preferences, look up the correct display value in
                // the preference's 'entries' list.
                ListPreference listPreference = (ListPreference) preference;
                int index = listPreference.findIndexOfValue(stringValue);
                // Set the summary to reflect the new value.
                preference.setSummary(index >= 0 ? listPreference.getEntries()[index] : null);

                if (USB_PCIE_KEY.equals(key)){
                    Log.d("wjh","u===" + index);
                }else if(FAN_KEY.equals(key)){
                    //Log.d("wjh","f===" + index);
                    //set Fan Level
                    switch (index){
                        case 0:
                            try {
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 0 > /sys/class/fan/enable"});
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                        case 1:
                            try {
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/enable"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/mode"});
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                        case 2:
                            try {
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/enable"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 0 > /sys/class/fan/mode"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/level"});
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                        case 3:
                            try {
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/enable"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 0 > /sys/class/fan/mode"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 2 > /sys/class/fan/level"});
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                        case 4:
                            try {
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/fan/enable"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 0 > /sys/class/fan/mode"});
                                ComApi.execCommand(new String[]{"sh", "-c", "echo 3 > /sys/class/fan/level"});
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                    }
                    SystemProperties.set("persist.sys.fan_control", "" + index);

                }else if(POWER_KEY.equals(key)){
                    Log.d("wjh","p===" + index);
                    SystemProperties.set("persist.sys.power.key.action",""+index);
                }

            }  else {
                // For all other preferences, set the summary to the value's
                // simple string representation.
                if (FUNCTION_KEY.equals(key)){
                    if("".equals(stringValue)) {
                        stringValue = SystemProperties.get("persist.sys.func.key.action", "3");
                    }
                    SystemProperties.set("persist.sys.func.key.action", stringValue);
                }
                preference.setSummary(stringValue);
            }
            return true;
        }
    };
    private static void bindPreferenceSummaryToValue(Preference preference) {
        // Set the listener to watch for value changes.
        preference.setOnPreferenceChangeListener(sBindPreferenceSummaryToValueListener);

        // Trigger the listener immediately with the preference's
        // current value.
        sBindPreferenceSummaryToValueListener.onPreferenceChange(preference,
                PreferenceManager.getDefaultSharedPreferences(preference.getContext()).getString(preference.getKey(), ""));
    }


    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {

    }

    private boolean checkServiceInstalled(Context context, String pkgName) {
        if (TextUtils.isEmpty(pkgName)) {
            return false;
        }
        try {
            context.getPackageManager().getPackageInfo(pkgName, 0);
        } catch (Exception x) {
            return false;
        }
        return true;
    } 

    @Override
    public boolean onPreferenceClick(Preference preference) {
        final String key = preference.getKey();
        if (WOL_KEY.equals(key)){
            if (WOL_Preference.isChecked()) {
                //Toast.makeText(this,"true",Toast.LENGTH_SHORT).show();
                try {
                    ComApi.execCommand(new String[]{"sh", "-c", "echo 1 > /sys/class/mcu/wol_enable"});
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }else {
                //Toast.makeText(this,"false",Toast.LENGTH_SHORT).show();
                try {
                    ComApi.execCommand(new String[]{"sh", "-c", "echo 0 > /sys/class/mcu/wol_enable"});
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }else if (HOTSPOT_KEY.equals(key)){
            if (HOTSPOT_Preference.isChecked()) {
                Toast.makeText(this,"true",Toast.LENGTH_SHORT).show();
            }else {
                Toast.makeText(this,"false",Toast.LENGTH_SHORT).show();
            }
        }else if (HDMI_IN_KEY.equals(key)){

//            TvInputManager mTvInputManager = (TvInputManager)mContext.getSystemService(Context.TV_INPUT_SERVICE);
//            List<TvInputInfo> inputList = mTvInputManager.getTvInputList();
//            for (TvInputInfo input : inputList) {
//                DroidLogicTvUtils.setSearchType(mContext, input.getId());
//                Log.d("wjh","===" + input.getId());
//                if(input.getId().contains(".Hdmi2InputService/HW6")) {
//                    Intent intent = new Intent(TvInputManager.ACTION_SETUP_INPUTS);
//                    intent.putExtra("from_tv_source", true);
//                    intent.putExtra(TvInputInfo.EXTRA_INPUT_ID, input.getId());
//                    startActivity(intent);
//                    break;
//                }
//            }
            //HDMI2
            Intent intent = new Intent(TvInputManager.ACTION_SETUP_INPUTS);
            intent.putExtra("from_tv_source", true);
            intent.putExtra(TvInputInfo.EXTRA_INPUT_ID, "com.droidlogic.tvinput/.services.Hdmi2InputService/HW6");
            startActivity(intent);
            //Settings.System.putInt(mContext.getContentResolver(), DroidLogicTvUtils.TV_CURRENT_DEVICE_ID, TvControlManager.AM_AUDIO_HDMI2);

        }else if (CAM1_IR_CUT_KEY.equals(key)){
            if (CAM1_IR_CUT_Preference.isChecked()) {
                su_exec("echo 481 > /sys/class/gpio/export;echo out > sys/class/gpio/gpio481/direction;echo 0 > sys/class/gpio/gpio481/value");
				SystemProperties.set("persist.sys.cam1", "" + 1);
            }else {
                su_exec("echo 481 > /sys/class/gpio/export;echo out > sys/class/gpio/gpio481/direction;echo 1 > sys/class/gpio/gpio481/value");
				SystemProperties.set("persist.sys.cam1", "" + 0);
			}
        } else if (UPDATER_KEY.equals(key)){
            boolean isInstall = checkServiceInstalled(mContext, "com.droidlogic.updater");
            Log.e("KSettings", "isInstall  " + isInstall);
            if (isInstall) {
                try {
                    Intent intent = mContext.getPackageManager().getLaunchIntentForPackage("com.droidlogic.updater");
                    Log.d("KSettings", "intent  " + (intent == null));
                    if (intent != null) {
                        mContext.startActivity(intent);
                    } else {
                        Toast.makeText(this, getString(R.string.wait_updater_startup), Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception exception) {
                }
                return true;
            }
        }
        return true;
    }

	public static String su_exec(String command) {

	    Process process = null;
	    BufferedReader reader = null;
	    InputStreamReader is = null;
	    DataOutputStream os = null;

	    try {
	        process = Runtime.getRuntime().exec("su");
	        is = new InputStreamReader(process.getInputStream());
	        reader = new BufferedReader(is);
	        os = new DataOutputStream(process.getOutputStream());
	        os.writeBytes(command + "\n");
	        os.writeBytes("exit\n");
	        os.flush();
	        int read;
	        char[] buffer = new char[4096];
	        StringBuilder output = new StringBuilder();
	        while ((read = reader.read(buffer)) > 0) {
	            output.append(buffer, 0, read);
	        }
	        process.waitFor();
	        return output.toString();
	    } catch (IOException | InterruptedException e) {
	        throw new RuntimeException(e);
	    } finally {
	        try {
	            if (os != null) {
	                os.close();
	            }

	            if (reader != null) {
	                reader.close();
	            }

	            if (is != null) {
	                is.close();
	            }

	            if (process != null) {
	                process.destroy();
	            }
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
	}
}
